# Nmap 06 - Safe NSE Commands

## Core

```bash
nmap --script safe <target>
```

## Service-focused variant

```bash
nmap -sV --script safe <target>
```

## Artifact output

```bash
nmap --script safe -oN safe-nse.txt <target>
```

## Common pitfalls

- "safe" scripts are safer, not silent; still generate traffic.
- Validate authorization scope before script runs.
- Review script names in output before acting on findings.

