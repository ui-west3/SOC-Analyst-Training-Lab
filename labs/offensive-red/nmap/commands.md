# Nmap Cheat Sheet (Track Level)

Core commands used across this Nmap series.

| Command | Purpose |
|:--------|:--------|
| `nmap -sn -PS22,80,443 <target>` | Host discovery (TCP SYN ping) |
| `nmap -sS -Pn <target>` | SYN scan baseline |
| `nmap -sV <target>` | Service and version detection |
| `nmap -p 22,80,443 <target>` | Targeted port scan |
| `nmap -p- <target>` | Full TCP port scan |
| `nmap -oN report.txt <target>` | Normal output to file |
| `nmap -oA baseline <target>` | Save normal/xml/grepable outputs |
| `nmap --script safe <target>` | Safe NSE script category |
