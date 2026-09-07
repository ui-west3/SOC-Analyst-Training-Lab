# Hydra 03 - FTP brute-force (local lab)

**Status:** Published  
**Video:** [Hydra Lab 03 FINAL - FTP Brute-Force (Local Docker)](https://youtu.be/UAhLfay0G-w)  
**Scope:** Local Docker target on `127.0.0.1:2121` only (FTP; passive ports 30000–30009)

## 1) Scenario

Run Hydra against a **standalone FTP** service in Docker. Practice **active vs passive** FTP behavior in a container: the image advertises `127.0.0.1` for PASV so clients on the same host can complete data connections during the lab.

## 2) Scope & authorization

- Use only your own machine or lab VM.
- Do not aim Hydra at external FTP servers.
- FTP sends credentials in cleartext — acceptable only in this **isolated lab**.

## 3) Reproduction (Red)

### Start target

```bash
cd labs/offensive-red/hydra/03-ftp
chmod +x start-lab.sh stop-lab.sh
./start-lab.sh
```

Target defaults:

- Host: `127.0.0.1`
- Port: `2121` (mapped to port 21 in the container)
- User: `labuser`
- Password: `labpass`
- Passive range (host): `30000–30009` (must match compose for data channel)

### Run Hydra

Quick smoke test:

```bash
hydra -l labuser -P words-quick.txt -s 2121 ftp://127.0.0.1
```

Longer demo:

```bash
hydra -l labuser -P words-demo.txt -s 2121 -t 1 -W 2 -V -o artifacts/hydra-ftp.txt ftp://127.0.0.1
```

### If passive mode misbehaves

From the **same host** as Docker, `PUBLICHOST=127.0.0.1` and published passive ports usually suffice. If you change networks or run from another VM, update `PUBLICHOST` and passive port publishing to match how the client reaches the server.

## 4) Remediation (Blue)

- **Disable FTP** where possible; prefer **SFTP** (SSH subsystem) or **FTPS** with TLS.
- If FTP must exist: **IP allowlists**, **VPN-only** access, strong passwords, **no anonymous** login.
- Log and alert on **repeated failed logins**; consider **Fail2Ban** (or equivalent) on the FTP daemon or fronting firewall.
- Monitor **unexpected cleartext** services on the perimeter.

## 5) Verification

- Confirm Hydra finds `labpass` only when the account exists and the service is reachable.
- Watch container logs during the run and correlate with Hydra attempts.
- After hardening (disabled FTP or restricted source), confirm brute-force no longer reaches the daemon from untrusted networks.

## 6) Artifacts

- `commands.md` — command reference
- `words-quick.txt`, `words-demo.txt` — wordlists
- `artifacts/hydra-ftp.txt` — optional saved Hydra output

## 7) Defensive takeaway

- FTP is **noisy and weak by design** (cleartext credentials; broad attack surface).
- Container FTP still needs correct **PASV** settings for real clients; attackers abuse the same paths defenders monitor.
- Removing or replacing FTP removes an entire class of **T1110** noise.

## 8) MITRE ATT&CK mapping


| ATT&CK Tactic     | Technique ID | Why it matches this lab        | Detection idea                     | Mitigation                                |
| ----------------- | ------------ | ------------------------------ | ---------------------------------- | ----------------------------------------- |
| Credential Access | T1110.001    | Password guessing against FTP  | Failed FTP auth bursts; cleartext  | Disable FTP, use SFTP/FTPS, IP restrict   |

