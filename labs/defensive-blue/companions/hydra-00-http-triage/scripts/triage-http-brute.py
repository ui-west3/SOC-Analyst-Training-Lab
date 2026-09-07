#!/usr/bin/env python3
"""
SOC triage helper for Hydra Lab 00 HTTP login events.

Lab-only. Default source is 127.0.0.1:8765. Do not point this at the internet.
"""
from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.request
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

DEFAULT_API = "http://127.0.0.1:8765/api/logs"
FAIL_THRESHOLD = 5


def parse_ts(value: str) -> datetime | None:
    raw = (value or "").strip()
    if not raw:
        return None
    if raw.endswith("Z"):
        raw = raw[:-1] + "+00:00"
    try:
        return datetime.fromisoformat(raw)
    except ValueError:
        return None


def load_payload(source: str) -> dict[str, Any]:
    if source.startswith("http://127.0.0.1") or source.startswith("http://localhost"):
        req = urllib.request.Request(source, headers={"Accept": "application/json"})
        with urllib.request.urlopen(req, timeout=5) as resp:
            return json.loads(resp.read().decode("utf-8"))
    path = Path(source)
    with path.open(encoding="utf-8") as fh:
        return json.load(fh)


def summarize(events: list[dict[str, Any]]) -> dict[str, Any]:
    details = Counter(str(e.get("detail") or "unknown") for e in events)
    ips = Counter(str(e.get("ip") or "unknown") for e in events)
    users = Counter(str(e.get("user") or "") for e in events)
    fails = [e for e in events if not e.get("success")]
    successes = [e for e in events if e.get("success")]
    stamps = [parse_ts(str(e.get("ts") or "")) for e in events]
    stamps = [t for t in stamps if t is not None]
    first_ts = min(stamps) if stamps else None
    last_ts = max(stamps) if stamps else None
    span_sec = (last_ts - first_ts).total_seconds() if first_ts and last_ts else 0.0
    fail_rate = (len(fails) / span_sec) if span_sec > 0 else float(len(fails))

    success_after_fail = False
    seen_fail = False
    for event in events:
        if not event.get("success"):
            seen_fail = True
        elif seen_fail:
            success_after_fail = True
            break

    return {
        "total": len(events),
        "fails": len(fails),
        "successes": len(successes),
        "details": details,
        "ips": ips,
        "users": users,
        "first_ts": first_ts,
        "last_ts": last_ts,
        "span_sec": span_sec,
        "fail_rate": fail_rate,
        "success_after_fail": success_after_fail,
        "control_fired": any(
            d in details for d in ("rate_limited", "lockout_triggered", "blocked_lockout")
        ),
    }


def verdict(stats: dict[str, Any]) -> tuple[str, str]:
    if stats["success_after_fail"] and stats["fails"] >= FAIL_THRESHOLD:
        return (
            "True Positive — escalate",
            "Burst of failures then a successful login. Treat as possible account compromise.",
        )
    if stats["fails"] >= FAIL_THRESHOLD and len(stats["ips"]) <= 2 and stats["span_sec"] <= 180:
        return (
            "True Positive",
            "High-volume failed authentication from one or two sources in a short window.",
        )
    if stats["fails"] >= FAIL_THRESHOLD:
        return (
            "Suspicious",
            "Failure volume is high, but source/time pattern needs a second look.",
        )
    return (
        "Needs more data",
        "Below the lab threshold. Keep watching or pull a wider time range.",
    )


def fmt_ts(value: datetime | None) -> str:
    if value is None:
        return "n/a"
    if value.tzinfo is None:
        value = value.replace(tzinfo=timezone.utc)
    return value.astimezone(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")


def render_report(stats: dict[str, Any], source: str) -> str:
    label, reason = verdict(stats)
    top_ip = stats["ips"].most_common(1)[0][0] if stats["ips"] else "n/a"
    top_user = next((u for u, _n in stats["users"].most_common() if u), "n/a")
    detail_lines = "\n".join(
        f"- `{name}`: {count}" for name, count in stats["details"].most_common()
    ) or "- none"
    return f"""# Ticket — HTTP brute-force triage

**Source:** `{source}`  
**Status:** draft from `triage-http-brute.py` (review before close)

## Alert
Burst of failed HTTP logins against the local training form.

## Evidence
- Events: {stats['total']}
- Failures: {stats['fails']}
- Successes: {stats['successes']}
- Window: {fmt_ts(stats['first_ts'])} → {fmt_ts(stats['last_ts'])} ({int(stats['span_sec'])}s)
- Fail rate: {stats['fail_rate']:.2f}/s
- Top source IP: `{top_ip}`
- Top username: `{top_user}`
- Control fired (rate limit / lockout): {'yes' if stats['control_fired'] else 'no'}

### Event details
{detail_lines}

## Verdict
**{label}**

{reason}

## MITRE
- Credential Access — T1110 Brute Force

## Action
- If TP: enable lockout + rate limit, re-check for success after the burst, watch the same IP on SSH/FTP.
- If success-after-fail: reset/lock the account in a real environment and escalate.
- Close notes: monitor repeat bursts from `{top_ip}`.
"""


def print_console(stats: dict[str, Any]) -> None:
    label, reason = verdict(stats)
    print("=== SOC triage: HTTP login events ===")
    print(f"events     {stats['total']}")
    print(f"fails      {stats['fails']}")
    print(f"success    {stats['successes']}")
    print(f"window     {fmt_ts(stats['first_ts'])} -> {fmt_ts(stats['last_ts'])}")
    print(f"span       {int(stats['span_sec'])}s")
    print(f"fail/s     {stats['fail_rate']:.2f}")
    print(f"IPs        {', '.join(f'{ip}({n})' for ip, n in stats['ips'].most_common()) or 'none'}")
    users = ", ".join(f"{user or '(empty)'}({n})" for user, n in stats["users"].most_common())
    print(f"users      {users or 'none'}")
    print(f"details    {', '.join(f'{k}={v}' for k, v in stats['details'].most_common()) or 'none'}")
    print(f"control    {'fired' if stats['control_fired'] else 'not seen'}")
    print(f"verdict    {label}")
    print(f"why        {reason}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Triage Hydra 00 HTTP login events (lab only).")
    parser.add_argument(
        "--from",
        dest="source",
        default=DEFAULT_API,
        help=f"127.0.0.1 API URL or local JSON file (default: {DEFAULT_API})",
    )
    parser.add_argument(
        "--save",
        metavar="PATH",
        help="Write the raw events JSON to this path",
    )
    parser.add_argument(
        "--write-ticket",
        metavar="PATH",
        help="Write a draft ticket markdown file",
    )
    args = parser.parse_args()

    source = args.source
    if source.startswith("http://") and not (
        source.startswith("http://127.0.0.1") or source.startswith("http://localhost")
    ):
        print("Refusing non-localhost URL. Lab only.", file=sys.stderr)
        return 2

    try:
        payload = load_payload(source)
    except urllib.error.URLError as exc:
        print(f"Cannot reach lab API: {exc}", file=sys.stderr)
        print("Start Hydra 00 or pass --from artifacts/events-sample.json", file=sys.stderr)
        return 1
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Cannot read events: {exc}", file=sys.stderr)
        return 1

    events = list(payload.get("events") or [])
    if not events:
        print("No events yet. Generate traffic on Hydra 00 first.", file=sys.stderr)
        return 1

    if args.save:
        save_path = Path(args.save)
        save_path.parent.mkdir(parents=True, exist_ok=True)
        save_path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
        print(f"saved raw events -> {save_path}")

    stats = summarize(events)
    print_console(stats)

    if args.write_ticket:
        ticket_path = Path(args.write_ticket)
        ticket_path.parent.mkdir(parents=True, exist_ok=True)
        ticket_path.write_text(render_report(stats, source), encoding="utf-8")
        print(f"draft ticket   -> {ticket_path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
