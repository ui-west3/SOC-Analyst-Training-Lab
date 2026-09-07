# Lab 02 — Incremental and wordlist rules

**Status:** ready to record  
**Focus:** John rules + incremental mode on synthetic hashes

## 1) Scenario

After baseline wordlist attacks, demonstrate how John improves coverage using:

- **wordlist rules** (`--rules`),
- **incremental mode** for constrained brute-force attempts.

## 2) Scope & authorization

- Only local synthetic hashes from `scripts/generate-lab-data.sh`.
- No production secrets, no real `shadow` data.

## 3) Reproduction (Red)

### Generate local lab input

```bash
cd labs/offensive-red/john-the-ripper/02-incremental-and-rules
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh
```

### Run wordlist + rules

```bash
john --format=Raw-SHA256 --wordlist=input/base-words.txt --rules input/hashes-john-l02.txt
john --show --format=Raw-SHA256 input/hashes-john-l02.txt
```

### Run incremental mode (short demo window)

```bash
john --format=Raw-SHA256 --incremental=Digits input/hashes-john-l02.txt --max-length=4
john --show --format=Raw-SHA256 input/hashes-john-l02.txt
```

## 4) Remediation (Blue)

- Password policy must block common transformations and numeric suffix habits.
- Use modern password hashing (Argon2id/bcrypt) with per-user salt.
- Detect and prevent bulk credential database export.

## 5) Verification

- `--rules` run cracks at least one transformed value from base words.
- Incremental mode demonstrates brute-force candidate generation.
- `john --show` confirms recovered entries.

## 6) Artifacts

- `input/hashes-john-l02.txt`
- `input/base-words.txt`
- terminal output from `john --show`

## 7) Defensive takeaway

Rule engines and incremental guesses quickly expand search space. Defenders must assume attackers automate these optimizations by default.

## 8) MITRE ATT&CK (example)

| Tactic | Technique | Note |
| ------ | --------- | ---- |
| Credential Access | T1110.002 — Password Cracking | Offline cracking with rule/incremental candidate expansion |
