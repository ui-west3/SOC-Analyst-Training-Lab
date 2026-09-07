# Nmap 03: Service Detection

## Objective

Identify running services and versions for exposure analysis.

## Core Command

```bash
nmap -sV <target>
```

## Quick Start Script

```bash
chmod +x nmap-service-detection.sh
./nmap-service-detection.sh <target>
```

## Defensive Note

- Patch outdated services.
- Disable unused daemons.
- Limit network exposure to required services only.

## Files

| File | Purpose |
|:-----|:--------|
| [nmap-service-detection.sh](./nmap-service-detection.sh) | Automation script for service/version scan |
| [commands.md](./commands.md) | Quick command cheat sheet for recording/practice |

