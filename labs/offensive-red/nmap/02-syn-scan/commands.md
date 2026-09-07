# Nmap 02 - SYN Scan Commands

## Core

```bash
nmap -sS -Pn <target>
```

## Safer / slower

```bash
nmap -sS -Pn -T2 --max-retries 2 <target>
```

## Artifact output

```bash
nmap -sS -Pn -oN syn-scan.txt <target>
```

## Common pitfalls

- `-Pn` skips host discovery; use only when needed.
- SYN scan may require elevated privileges for expected behavior.
- Keep scans in authorized scope only.

