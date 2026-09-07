# Lab 02 — Rules and mask attacks (local hashes)

**Status:** published  
**Video:** [Hashcat Lab 02 — Rules & Mask Attack](https://youtu.be/CZ6vZzXUn9k)  
**Focus:** move from plain wordlist to rule-based and mask-based candidate generation

## 1) Scenario

In Lab 01 you cracked only direct wordlist entries. In Lab 02 you show two common upgrades:

- **rules** (mutate dictionary words),
- **mask** (bruteforce constrained pattern).

All data stays synthetic and local.

## 2) Scope & authorization

- Use only hashes created by `scripts/generate-lab-data.sh`.
- Do not use any production or third-party leaked material.

## 3) Reproduction (Red)

### Generate local lab input

```bash
cd labs/offensive-red/hashcat/02-rules-and-mask
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh
```

### Run dictionary + rule attack

```bash
hashcat -m 1400 -a 0 input/hashes-rules-mask.txt input/base-words.txt -r input/demo.rule -o artifacts/cracked-rules.txt
cat artifacts/cracked-rules.txt
```

### Run mask attack (example pattern)

```bash
hashcat -m 1400 -a 3 input/hashes-rules-mask.txt '?l?l?l?l?d?d?d?d' -o artifacts/cracked-mask.txt
cat artifacts/cracked-mask.txt
```

## 4) Remediation (Blue)

- Block predictable transformations (`Summer2026`, `Password1!`, season+year).
- Use long passphrases and ban weak construction patterns.
- Store credentials with slow KDFs and unique salts.
- Treat hash leak as incident: force reset and revoke sessions quickly.

## 5) Verification

- Rule attack recovers at least one value not present in plain form in base wordlist.
- Mask attack recovers a pattern-based password (if generated hash matches mask charset).
- Outputs are saved in `artifacts/`.

## 6) Artifacts

- `input/hashes-rules-mask.txt`
- `input/base-words.txt`
- `input/demo.rule`
- `artifacts/cracked-rules.txt`
- `artifacts/cracked-mask.txt`

## 7) Defensive takeaway

Attackers rarely stop at plain dictionaries. They combine rules and masks to target human password habits. Policy and KDF choice must assume these optimizations.

## 8) MITRE ATT&CK (example)

| Tactic | Technique | Note |
| ------ | --------- | ---- |
| Credential Access | T1110.002 — Password Cracking | Offline cracking with rule/mask optimization |
