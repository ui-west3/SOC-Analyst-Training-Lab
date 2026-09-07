# Lab 01 — Host Discovery (stealth & efficiency)

**Series:** Nmap — Lab 01  
**Mindset:** Purple — map targets first; don’t blind full-port sweep everything.

## Objective

Find **live hosts** before port scanning. Host discovery is usually **faster and quieter** than a full port scan: `-sn` skips port enumeration and focuses on “who answers.”

## Red phase — TCP SYN ping (main demo)

Probe common service ports so a host must **respond** even if it tries to stay quiet.

```bash
sudo nmap -sn -PS22,80,443 10.10.10.0/24
```

| Flag | Meaning |
|:-----|:--------|
| `-sn` | No port scan — discovery only |
| `-PS22,80,443` | TCP SYN ping on SSH + web ports |

**Why these ports:** many hosts run SSH and/or HTTP(S); a SYN to an open or closed port still elicits a TCP response, confirming the host is reachable.

### Automation (same workflow)

From this directory:

```bash
chmod +x nmap-discovery.sh
sudo ./nmap-discovery.sh 10.10.10.0/24
cat live-hosts.txt
```

`live-hosts.txt` is a **clean target list** for the next lab (SYN scan).

## Comparison — ICMP vs TCP discovery

```bash
sudo nmap -sn -PE <TARGET_OR_RANGE>
```

| Method | Notes |
|:-------|:------|
| **ICMP echo (`-PE`)** | Classic “ping”; often **blocked** by firewalls or dropped at the border. |
| **TCP SYN ping (`-PS…`)** | Often **more reliable** in hardened networks where ICMP is filtered but TCP services still respond. |

**Teaching moment:** show the same host found with one method and **not** the other — that’s normal and shows why mappers use multiple discovery techniques.

## Blue phase — defensive takeaway

- **Visibility:** even **no-port** discovery creates **network noise**; IDS/IPS may flag mass probes or sweep patterns.
- **Firewall / segmentation:** restrict who can ping or reach management segments; a server shouldn’t need to answer ICMP from untrusted subnets.
- **Monitoring:** rapid, repeated probes often **precede** heavier port scanning — useful as an early signal for SOC.

## Next lab

**Lab 02 — SYN scan basics** (`-sS -Pn`): same repo, folder `02-syn-scan/`.

## Files

| File | Purpose |
|:-----|:--------|
| [nmap-discovery.sh](./nmap-discovery.sh) | Run TCP SYN discovery + write `live-hosts.txt` |
| [commands.md](./commands.md) | On-screen command cheat sheet |

## Source

Portfolio: [SOC-Analyst-Training-Lab](https://github.com/ui-west3/SOC-Analyst-Training-Lab) — `labs/offensive-red/nmap/01-discovery/`.
