#!/usr/bin/env python3
"""
Lab 00 — Local training target for Hydra (HTTP form).
Binds to 127.0.0.1 only. Use only in isolated lab / your own machine.

SOC Analyst Training Lab — Miroslav Ustimenko (2026).
"""
from __future__ import annotations

import os
import time
from collections import defaultdict, deque
from datetime import datetime, timezone
from typing import Any

from flask import Flask, jsonify, render_template, request

app = Flask(__name__)
app.config["JSON_SORT_KEYS"] = False

# --- demo credentials (override for your recording session) ---
LAB_USER = os.environ.get("LAB_USER", "labuser")
LAB_PASS = os.environ.get("LAB_PASS", "labpass")

# --- in-memory state (lab only) ---
MAX_EVENTS = 300
events: list[dict[str, Any]] = []

# Defaults tuned for local demos: with Hydra -t4, loose limits feel "instant".
settings: dict[str, Any] = {
    "rate_limit": False,
    "rate_limit_max": 2,  # max POST /login per sliding window per IP (strict)
    "rate_window_sec": 10,
    "lockout": False,
    "lockout_after_fails": 3,  # failed logins before temporary IP block
    "lockout_sec": 60,
    "delay_ms": 0,
}

# IP -> deque of timestamps (for rate limit)
request_times: dict[str, deque[float]] = defaultdict(lambda: deque())
# IP -> failed count since last success (or start)
fail_counts: dict[str, int] = defaultdict(int)
# IP -> unix time until lockout lifts
lockout_until: dict[str, float] = defaultdict(float)


def utc_now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def log_event(
    ip: str,
    user: str,
    success: bool,
    detail: str,
) -> None:
    row = {
        "ts": utc_now_iso(),
        "ip": ip,
        "user": user,
        "success": success,
        "detail": detail,
    }
    events.append(row)
    if len(events) > MAX_EVENTS:
        del events[: len(events) - MAX_EVENTS]


def client_ip() -> str:
    # Trust only for local lab; behind real proxy you'd use X-Forwarded-For carefully
    return request.remote_addr or "0.0.0.0"


def apply_delay() -> None:
    d = int(settings.get("delay_ms") or 0)
    if d > 0:
        time.sleep(min(d, 2000) / 1000.0)


def is_rate_limited(ip: str) -> bool:
    if not settings.get("rate_limit"):
        return False
    window = float(settings.get("rate_window_sec") or 10)
    max_req = int(settings.get("rate_limit_max") or 8)
    now = time.time()
    dq = request_times[ip]
    while dq and now - dq[0] > window:
        dq.popleft()
    if len(dq) >= max_req:
        return True
    dq.append(now)
    return False


def is_locked_out(ip: str) -> bool:
    until = lockout_until.get(ip, 0.0)
    return time.time() < until


def lockout_ip(ip: str) -> None:
    sec = int(settings.get("lockout_sec") or 30)
    lockout_until[ip] = time.time() + max(1, min(sec, 3600))


@app.route("/")
def index():
    return render_template("index.html", lab_user=LAB_USER)


@app.route("/login", methods=["POST"])
def login():
    ip = client_ip()
    apply_delay()

    if is_locked_out(ip):
        log_event(ip, request.form.get("username", ""), False, "blocked_lockout")
        return ("LOGIN_FAIL", 200)

    if is_rate_limited(ip):
        log_event(ip, request.form.get("username", ""), False, "rate_limited")
        # Same failure marker for Hydra (F=LOGIN_FAIL); status 429 is still visible in server log
        return ("LOGIN_FAIL", 429)

    username = request.form.get("username", "").strip()
    password = request.form.get("password", "")

    ok = username == LAB_USER and password == LAB_PASS
    if ok:
        fail_counts[ip] = 0
        log_event(ip, username, True, "ok")
        return ("LOGIN_OK", 200)

    fail_counts[ip] += 1
    log_event(ip, username, False, "bad_password")

    if settings.get("lockout") and fail_counts[ip] >= int(
        settings.get("lockout_after_fails") or 5
    ):
        lockout_ip(ip)
        log_event(ip, username, False, "lockout_triggered")

    return ("LOGIN_FAIL", 200)


@app.route("/api/logs", methods=["GET"])
def api_logs():
    return jsonify({"events": events[-200:], "settings": settings})


@app.route("/api/settings", methods=["GET", "POST"])
def api_settings():
    global settings
    if request.method == "GET":
        return jsonify(settings)

    data = request.get_json(silent=True) or {}
    for key in ("rate_limit", "lockout"):
        if key in data:
            settings[key] = bool(data[key])
    if "delay_ms" in data:
        settings["delay_ms"] = max(0, min(int(data["delay_ms"]), 2000))
    if "rate_limit_max" in data:
        settings["rate_limit_max"] = max(1, min(int(data["rate_limit_max"]), 200))
    if "rate_window_sec" in data:
        settings["rate_window_sec"] = max(1, min(int(data["rate_window_sec"]), 300))
    if "lockout_after_fails" in data:
        settings["lockout_after_fails"] = max(1, min(int(data["lockout_after_fails"]), 50))
    if "lockout_sec" in data:
        settings["lockout_sec"] = max(1, min(int(data["lockout_sec"]), 3600))

    return jsonify({"ok": True, "settings": settings})


@app.route("/health")
def health():
    return jsonify({"status": "ok", "lab": "hydra-00"})


if __name__ == "__main__":
    host = os.environ.get("LAB_HOST", "127.0.0.1")
    port = int(os.environ.get("LAB_PORT", "8765"))
    print(f"[*] Lab user (demo): {LAB_USER}")
    print(f"[*] Bind: http://{host}:{port}/  (lab only)")
    app.run(host=host, port=port, debug=False, threaded=True)
