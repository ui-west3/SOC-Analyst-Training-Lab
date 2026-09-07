# Companion — Hydra 00 HTTP brute-force triage

**Status:** repo-only (no Blue video — Hydra 00 already covers live log + lockout)  
**Lens:** SOC ticket close-out, not a second attack-tool demo  
**Red pair:** [Hydra Lab 00 — speed vs detection](../../../offensive-red/hydra/00-speed-vs-detection/)  
**Blue video track:** [Lab 01 Wireshark](../../01-wireshark-sqli-pcap/), not this folder

Take the same HTTP login noise Hydra already generated and close it like a T1 ticket: timeline, verdict, action.

## 1) Scenario

A local training form is hit with a burst of failed logins from one IP. Decide whether this is brute-force, whether any login succeeded after the noise, and whether lockout / rate limit changed the pattern.

## 2) Scope & authorization

- **In scope:** `127.0.0.1:8765` Hydra 00 lab, or the saved JSON in `artifacts/`.
- **Out of scope:** any host you do not own. The triage script refuses non-localhost URLs.

## 3) Evidence source (analyst view)

Start the red target only if you need a live panel:

```bash
cd labs/offensive-red/hydra/00-speed-vs-detection
./start-lab.sh
```

Open `http://127.0.0.1:8765/` — right side is the log. Generate traffic with defenses **off**, then again with **lockout** on (see Hydra 00 README). This folder is a ticket companion, not a Blue video.

Pull events without leaving the analyst workflow:

```bash
cd labs/defensive-blue/companions/hydra-00-http-triage
python3 scripts/triage-http-brute.py \
  --save artifacts/events.json \
  --write-ticket artifacts/ticket-draft.md
```

If the lab is not running, use the committed sample:

```bash
python3 scripts/triage-http-brute.py \
  --from artifacts/events-sample.json \
  --write-ticket artifacts/ticket-draft.md
```

## 4) Remediation (Blue)

On the Hydra 00 panel (or via its settings API):

- enable **Rate limit**
- enable **Lockout**
- re-run a short burst and confirm `rate_limited` / `lockout_triggered` / `blocked_lockout`

In production this maps to WAF / IdP lockout / MFA — the lab only proves the pattern.

## 5) Verification

- Script reports **True Positive** on the sample (12+ failures, one IP, short window).
- After lockout, new lines are `blocked_lockout` (or `rate_limited` if that toggle is on).
- Draft ticket exists and a human reviews the verdict before “close”.

## 6) Artifacts

- `scripts/triage-http-brute.py` — localhost API or JSON file → console summary + optional ticket
- `artifacts/events-sample.json` — committed demo events
- `artifacts/ticket.md` — human close-out example
- `commands.md` — curl / jq equivalents

## 7) Defensive takeaway

- Brute-force is a **volume + source + time** story, not a single failed password.
- A success after a fail burst is more urgent than the burst itself.
- Lockout is a response control. Write that it fired; do not stop at “we enabled it”.

## 8) MITRE ATT&CK mapping

| ATT&CK Tactic | Technique ID | Why it matches this lab | Detection idea | Mitigation |
|---|---|---|---|---|
| Credential Access | T1110 | Repeated password guesses against one HTTP login | Spike of failed logins, one IP, short window | Rate limit, lockout, MFA, alert on success-after-fail |
