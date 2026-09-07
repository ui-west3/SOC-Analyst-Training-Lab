# Nmap 03 - Service Detection Commands

## Core

```bash
nmap -sV <target>
```

## Safer / focused

```bash
nmap -sV -p 22,80,443 <target>
```

## Artifact output

```bash
nmap -sV -oN service-detection.txt <target>
```

## Common pitfalls

- Version probes can be noisy; keep scan range intentional.
- Service banners may be incomplete behind reverse proxies.
- Validate findings against expected service inventory.
