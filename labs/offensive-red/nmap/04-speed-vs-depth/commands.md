# Nmap 04 - Speed vs Depth Commands

## Core comparison

```bash
nmap -p 22,80,443 <target>
nmap -p- <target>
```

## Safer / controlled full-range

```bash
nmap -p- -T2 --max-retries 2 <target>
```

## Artifact output

```bash
nmap -p 22,80,443 -oN targeted-ports.txt <target>
nmap -p- -oN full-ports.txt <target>
```

## Common pitfalls

- Full-range scans take longer and create more noise.
- Aggressive timing can miss unstable services.
- Compare targeted vs full scans to catch drift.
