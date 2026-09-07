#!/usr/bin/env python3
"""
Fetch latest videos from YouTube channel RSS and merge into docs/data/videos.json.

Preserves per-video ``track`` (linux | nmap | hydra | sqli | blue | hashcat | john) when updating so
GitHub Pages filters keep working. New videos get ``track`` from the previous file
or from title heuristics.

Requires: CHANNEL_ID env var (e.g. from repo Variables). YouTube Studio → Settings → Advanced.
"""
from __future__ import annotations

import json
import os
import re
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path

RSS_URL = "https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}"
MAX_VIDEOS = 50
OUTPUT_PATH = Path(__file__).resolve().parent.parent / "docs" / "data" / "videos.json"
NS = {"atom": "http://www.w3.org/2005/Atom", "yt": "http://www.youtube.com/xml/schemas/2015"}


def load_existing() -> list[dict]:
    if not OUTPUT_PATH.is_file():
        return []
    try:
        data = json.loads(OUTPUT_PATH.read_text(encoding="utf-8"))
        return data if isinstance(data, list) else []
    except (json.JSONDecodeError, OSError):
        return []


def infer_track(title: str) -> str:
    """Best-effort track from English video titles (MiroslavSec lab naming)."""
    t = title.lower()
    if "nmap" in t:
        return "nmap"
    if "hashcat" in t:
        return "hashcat"
    if "john the ripper" in t or ("john" in t and "ripper" in t) or re.search(r"\bjtr\b", t):
        return "john"
    if "hydra" in t:
        return "hydra"
    if "sqli" in t or "sql injection" in t or "sql-injection" in t:
        return "sqli"
    if "wireshark" in t or "pcap" in t or "blue team" in t or "defensive" in t or "soc analyst labs" in t:
        return "blue"
    # Linux hardening labs use "Lab 0N:" without tool name in some titles
    if re.search(r"lab\s*0[1-6]\s*:", t) or "ufw" in t or "fail2ban" in t or "ssh keys" in t or "banner" in t:
        return "linux"
    if "linux" in t or "firewall" in t or "hardening" in t:
        return "linux"
    return "linux"


def merge_tracks(rss_videos: list[dict], existing: list[dict]) -> list[dict]:
    by_id = {str(v.get("id")): v for v in existing if isinstance(v, dict) and v.get("id")}
    out: list[dict] = []
    for v in rss_videos:
        vid = v["id"]
        title = v["title"]
        prev = by_id.get(vid, {})
        track = prev.get("track")
        if not track or not isinstance(track, str):
            track = infer_track(title)
        out.append({"id": vid, "title": title, "track": track})
    return out


def fetch_rss(channel_id: str) -> list[dict]:
    url = RSS_URL.format(channel_id=channel_id)
    req = urllib.request.Request(url, headers={"User-Agent": "MiroslavSec-Site-Updater/1.1"})
    with urllib.request.urlopen(req, timeout=20) as resp:
        tree = ET.parse(resp)
    root = tree.getroot()

    videos: list[dict] = []
    for entry in root.findall("atom:entry", NS)[:MAX_VIDEOS]:
        video_id = None
        vid_el = entry.find("yt:videoId", NS)
        if vid_el is not None and vid_el.text:
            video_id = vid_el.text.strip()
        if not video_id:
            id_el = entry.find("atom:id", NS)
            if id_el is not None and id_el.text and "video:" in id_el.text:
                video_id = id_el.text.strip().split(":")[-1]
        title_el = entry.find("atom:title", NS)
        title = title_el.text.strip() if title_el is not None and title_el.text else "Video"
        if video_id:
            videos.append({"id": video_id, "title": title})
    return videos


def main() -> None:
    channel_id = os.environ.get("YOUTUBE_CHANNEL_ID", "").strip()
    if not channel_id:
        print("YOUTUBE_CHANNEL_ID not set. Skipping update. Set it in repo Variables or workflow.")
        return

    rss_videos = fetch_rss(channel_id)
    if not rss_videos:
        print("RSS returned no videos; leaving videos.json unchanged.")
        return

    existing = load_existing()
    merged = merge_tracks(rss_videos, existing)

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(json.dumps(merged, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Wrote {len(merged)} videos to {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
