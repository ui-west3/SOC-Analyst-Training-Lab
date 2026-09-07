# Lab 01 — Baseline: formats and wordlist

**Status:** ready to record  
**Scope:** local synthetic hashes + wordlist workflow

## 1) Scenario

Show how John handles a local hash file, run a small wordlist attack, and print cracked entries with `--show`.

## 2) Scope & authorization

- Use only data created by `scripts/generate-lab-data.sh`.
- No real organizational `passwd`/`shadow` data in this repo.

## 3) Reproduction (Red)

### Generate local input

```bash
cd labs/offensive-red/john-the-ripper/01-baseline-formats
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh
```

### Verify generated files

```bash
ls -la input
```

Expected:

- `input/hashes-raw-sha256.txt`
- `input/wordlist-demo.txt`

### Run John with explicit format

```bash
john --format=Raw-SHA256 --wordlist=input/wordlist-demo.txt input/hashes-raw-sha256.txt
```

### Show cracked entries

```bash
john --show --format=Raw-SHA256 input/hashes-raw-sha256.txt
```

## 4) Remediation (Blue)

- Enforce strong passphrases and remove weak defaults.
- Store passwords with slow KDFs (Argon2id/bcrypt) rather than fast raw SHA formats.
- Monitor and restrict paths that enable hash collection/export.

## 5) Verification

- `john --show` returns at least one known password from the local dataset.
- Re-run with a wordlist that excludes the known password and confirm no crack.

## 6) Artifacts

- `input/hashes-raw-sha256.txt` — synthetic local hashes
- `input/wordlist-demo.txt` — demo candidate list
- Terminal output from `john --show` (screenshot or transcript)

## 7) Defensive takeaway

Cracking tools are the end of the chain. The real defensive win is preventing hash theft and using storage algorithms that make offline cracking expensive.

## 8) MITRE ATT&CK (example)

| Tactic | Technique | Note |
| ------ | --------- | ---- |
| Credential Access | T1110.002 — Password Cracking | Offline wordlist attack against leaked hashes |
