# Blue Lab 01 — Wireshark / tshark commands

Lab-only. Default target is `127.0.0.1:8088` (SQLi 00).

# Silent recording (no mic / no face)

One scene. Captions in edit.

1. Terminal: `cd labs/offensive-red/sql-injection/00-local-demo && ./start-lab.sh`
2. OBS: Split (F3) — Wireshark + browser. **F9** record.
3. Capture on `lo`, filter `tcp.port == 8088`.
4. Browser: normal search → suspicious search from the demo cheat sheet → `/monitoring`.
5. Stop capture, Follow HTTP Stream on the second request. **F10** stop. Remux mkv → mp4.

Do not open Hydra. Do not teach injection syntax on camera.

## Capture

```bash
# Wireshark GUI: capture interface lo, display filter below, File → Save As artifacts/sqli-local.pcapng

sudo tshark -i lo -f "tcp port 8088" -w artifacts/sqli-local.pcapng
```

## Display filters (Wireshark)

```
tcp.port == 8088
http
http && tcp.port == 8088
http.request
http.request.method == "GET" || http.request.method == "POST"
http.request.uri contains "search"
```

## Follow stream / list HTTP

In Wireshark: right-click a packet → Follow → HTTP Stream.

```bash
tshark -r artifacts/sqli-local.pcapng -Y "http.request && tcp.port == 8088" -T fields -e frame.time -e ip.src -e http.request.method -e http.request.uri
```

## Correlate with the app board

Keep the browser on `http://127.0.0.1:8088/monitoring`. Same two events, same order as the pcap. That is the ticket close-out.
