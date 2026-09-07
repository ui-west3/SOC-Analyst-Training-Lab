# Cheat sheet — Lab 01 (Host Discovery)


| Command                                    | Purpose                                      |
| ------------------------------------------ | -------------------------------------------- |
| `sudo nmap -sn -PS22,80,443 10.10.10.0/24` | TCP SYN ping on SSH + HTTP/S; no port scan   |
| `sudo nmap -sn -PE 10.10.10.0/24`          | ICMP echo discovery (compare vs `-PS`)       |
| `sudo ./nmap-discovery.sh 10.10.10.0/24`   | Script: same as first row + `live-hosts.txt` |
| `cat live-hosts.txt`                       | Show saved live IPs for next stage           |


## Flags


| Flag         | Meaning                                        |
| ------------ | ---------------------------------------------- |
| `-sn`        | Ping scan only — **no** port scan              |
| `-PS<ports>` | TCP SYN ping on listed ports                   |
| `-PE`        | ICMP Echo Request (ping)                       |
| `-oG -`      | Grepable output to stdout (used inside script) |


## Purple one-liner

**Red:** find live hosts quickly. **Blue:** discovery still creates noise — segment, filter ICMP, watch for sweep patterns before full port scans.