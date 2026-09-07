# Nmap 06: Safe NSE Intro

**Video:** [Lab 06 — Safe NSE](https://youtu.be/wZI1miGav1w?si=kNtczLp2BnUpQLrL)

## Objective

Use safe NSE scripts for controlled enumeration.

## Core Command

```bash
nmap --script safe <target>
```

## Quick Start Script

```bash
chmod +x nmap-safe-nse.sh
./nmap-safe-nse.sh <target>
```

## Defensive Note

- Run scripts only inside authorized scope.
- Review script output for exposed services and weak configs.
- Document findings and remediation tasks.

## Files

| File | Purpose |
|:-----|:--------|
| [nmap-safe-nse.sh](./nmap-safe-nse.sh) | Automation script for safe NSE run |
| [commands.md](./commands.md) | Quick command cheat sheet for recording/practice |
