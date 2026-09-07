# Lab 01 — Baseline: local hashes only

**Status:** published  
**Video:** [Hashcat Lab 01 — Offline Hash Cracking Basics](https://youtu.be/uwtM6-ZVCSg)  
**Scope:** self-generated SHA-256 hashes + tiny local wordlist

## 1) Scenario

Demonstrate a **repeatable offline workflow**: generate hashes from known local training passwords, run Hashcat in straight wordlist mode, recover at least one password, and map the result to blue-team controls.

## 2) Scope & authorization

- **In scope:** hashes produced by `scripts/generate-lab-data.sh` (local-only).
- **Out of scope:** production hashes, third-party leaks, or any non-authorized data.

## 3) Reproduction (Red)

### Generate local lab input

```bash
cd labs/offensive-red/hashcat/01-baseline-local-hashes
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh
```

### Verify input files

```bash
ls -la input
```

Expected:

- `input/hashes-sha256.txt`
- `input/wordlist-demo.txt`

### Run Hashcat (straight wordlist)

```bash
hashcat -m 1400 -a 0 input/hashes-sha256.txt input/wordlist-demo.txt -o artifacts/cracked-sha256.txt
```

### Show cracked output

```bash
cat artifacts/cracked-sha256.txt
```

### Optional: clean session lock/checkpoint

```bash
hashcat --session hc01 --restore-disable -m 1400 -a 0 input/hashes-sha256.txt input/wordlist-demo.txt -o artifacts/cracked-sha256.txt
```

## 4) Remediation (Blue)

- Enforce long passphrases and deny weak patterns.
- Store passwords with slow KDFs (**Argon2id**, **bcrypt**, **scrypt**) instead of fast SHA families.
- Protect hash sources (database dumps, backups, directory replication paths).
- Assume offline cracking after a hash leak and trigger forced reset + incident response.

## 5) Verification

- Hashcat reports recovered entries in `artifacts/cracked-sha256.txt`.
- At least one known training password is recovered from the demo wordlist.
- If you remove the correct word from the wordlist and re-run, recovery fails.

## 6) Artifacts

- `input/hashes-sha256.txt` — local generated training hashes
- `input/wordlist-demo.txt` — local demo wordlist
- `artifacts/cracked-sha256.txt` — recovered pairs (`hash:password`)

## 7) Defensive takeaway

Offline cracking is fast and quiet once hashes are stolen. Detection focus shifts to:

1. preventing hash export/theft,
2. using slow KDFs,
3. forcing password reset quickly after suspected compromise.

## 8) MITRE ATT&CK (example)

| Tactic | Technique | Note |
| ------ | --------- | ---- |
| Credential Access | T1110.002 — Password Cracking | Offline guessing against leaked hashes |
