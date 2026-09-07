# Nmap 05: Output and Reporting

## Objective

Save scan artifacts for comparison, reporting, and future audits.

## Core Commands

```bash
nmap -oN scan.txt <target>
nmap -oA baseline <target>
```

## Quick Start Script

```bash
chmod +x nmap-output-reporting.sh
./nmap-output-reporting.sh <target>
```

## Defensive Note

- Keep baseline snapshots by date.
- Compare old and new reports to detect drift.
- Track changes as part of regular security reviews.

## Files

| File | Purpose |
|:-----|:--------|
| [nmap-output-reporting.sh](./nmap-output-reporting.sh) | Automation script for report generation |
| [commands.md](./commands.md) | Quick command cheat sheet for recording/practice |
