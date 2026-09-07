# Nmap 05 - Output and Reporting Commands

## Core output formats

```bash
nmap -oN scan.txt <target>
nmap -oA baseline <target>
```

## Recommended baseline workflow

```bash
STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p "reports/$STAMP"
nmap -oA "reports/$STAMP/baseline" <target>
```

## Common pitfalls

- Keep report folders timestamped for diff-friendly history.
- Avoid mixing targets in one baseline file.
- Include command context in notes when sharing artifacts.
