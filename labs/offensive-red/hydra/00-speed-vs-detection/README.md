# Hydra 00 — Speed vs detection (local training target)

**Video:** [Lab 00 — Hydra vs rate limiting (custom range)](https://youtu.be/H16hmZXzrYA)

**Author / maintainer:** Miroslav Ustimenko · **Last reviewed:** 2026 · Part of [SOC Analyst Training Lab](../../../../README.md).

Intro lab: **HTTP login** + **live attempt log** + **defense toggles** on one page. Use it to show how brute-force **noise** changes when rate limit / lockout / delay are enabled.

**Do not expose this app to the internet.** Bind stays on `127.0.0.1` by default.

## 1) Scenario

Demonstrate credential stuffing / brute-force **throughput** vs **visibility**: many failed logins appear in the built-in log; toggling defenses changes how quickly an attacker succeeds and how “loud” the attempt pattern is.

## 2) Scope & authorization

- Run only on **your machine** or an **isolated lab VM**.
- You must **own** the target or have **written authorization** (course/lab/employer). No third-party sites.

## 3) Reproduction (Red)

### Start the lab app

```bash
cd labs/offensive-red/hydra/00-speed-vs-detection
chmod +x start-lab.sh
./start-lab.sh
```

Open `http://127.0.0.1:8765/` — left: login form; right: live log + Blue toggles.

Default demo credentials (override with env if needed):

- `LAB_USER` — default `labuser`
- `LAB_PASS` — default `labpass`

### Hydra (example)

Response body is `**LOGIN_OK**` on success and `**LOGIN_FAIL**` on any failure (Hydra `F=` matches the failure marker).

**Wordlists**

- `**words-demo.txt`** — ~70 lines; real password is **last**. Use this to **stress** rate limit / lockout (attack does not end in 3 guesses).
- `**words-quick.txt`** — 3 lines; finishes almost instantly (good only for “defenses OFF” smoke test).

```bash
hydra -l labuser -P words-demo.txt -s 8765 -t 4 127.0.0.1 http-post-form "/login:username=^USER^&password=^PASS^:F=LOGIN_FAIL"
```

- With **rate limit ON**, server default is **2** successful `POST /login` per **10s** per IP (then `rate_limited`). Lower `-t` (e.g. `-t 1`) if you want a slower, more readable log; higher `-t` produces more `rate_limited` noise.
- With **lockout ON**, IP is blocked after **3** failed logins for **60s** (defaults).

## 4) Remediation (Blue)

- Enable **Rate limit** — caps burst attempts per IP per time window.
- Enable **Lockout** — blocks an IP after repeated failures.
- Add **Response delay** — slows automated guessing (and your video timeline).

In production you would also use: MFA, CAPTCHA/WAF, centralized auth, alerting on auth spikes, account lockout policies.

## 5) Verification

- With defenses **off**, log shows rapid `bad_password` lines from your IP.
- Turn **rate limit** on — expect `rate_limited` entries and fewer attempts per second.
- Turn **lockout** on — after N failures, expect `blocked_lockout` / `lockout_triggered`.

## 6) Artifacts

- `app.py` — Flask training server.
- `templates/index.html` — split UI (login + log + toggles).
- `words-demo.txt` — longer demo list (password at end) to exercise defenses.
- `words-quick.txt` — 3-line list for a very fast run.

## 7) Defensive takeaway

- Brute force is often **detectable** as high-volume **failed authentication** from one source.
- **Rate limiting + lockout + delay** change both attacker success rate and log pattern.
- Treat this lab as **evidence of understanding**, not “bypass homework”.
- Ticket-style close-out (script + sample events) lives in the Blue companion: [hydra-00-http-triage](../../../defensive-blue/companions/hydra-00-http-triage/) — repo only, not a second video.

## 8) MITRE ATT&CK mapping


| Tactic            | ID    | Why                                   | Detection idea                         | Mitigation                    |
| ----------------- | ----- | ------------------------------------- | -------------------------------------- | ----------------------------- |
| Credential Access | T1110 | Password guessing against a web login | Spike in failed logins, same source IP | Rate limit, lockout, MFA, WAF |


## Env reference


| Variable   | Default     | Meaning           |
| ---------- | ----------- | ----------------- |
| `LAB_HOST` | `127.0.0.1` | Bind address      |
| `LAB_PORT` | `8765`      | Port              |
| `LAB_USER` | `labuser`   | Expected username |
| `LAB_PASS` | `labpass`   | Expected password |


