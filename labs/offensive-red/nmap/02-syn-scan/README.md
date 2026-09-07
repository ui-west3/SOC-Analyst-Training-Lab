# Nmap 02: SYN Scan Basics

## Objective

Run a baseline SYN scan and understand exposed ports.

## Core Command

```bash
nmap -sS -Pn <target>
```

## Quick Start Script

```bash
chmod +x nmap-syn-scan.sh
./nmap-syn-scan.sh <target>
```

## Defensive Note

- Validate open ports against expected services.
- Close unnecessary ports with firewall policy.
- Monitor repeated scan patterns in logs.

## Files

| File | Purpose |
|:-----|:--------|
| [nmap-syn-scan.sh](./nmap-syn-scan.sh) | Automation script for baseline SYN scan |
| [commands.md](./commands.md) | Quick command cheat sheet for recording/practice |
