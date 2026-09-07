# Hashcat — command index (lab track)

Use this file as a quick route map. Lab 01 below is ready-to-run with local generated material.

## Lab 01 quick path (`01-baseline-local-hashes`)

```bash
cd labs/offensive-red/hashcat/01-baseline-local-hashes
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh

hashcat -m 1400 -a 0 input/hashes-sha256.txt input/wordlist-demo.txt -o artifacts/cracked-sha256.txt
cat artifacts/cracked-sha256.txt
```

## Lab 02 quick path (`02-rules-and-mask`)

```bash
cd labs/offensive-red/hashcat/02-rules-and-mask
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh

# Wordlist + rule mutation
hashcat -m 1400 -a 0 input/hashes-rules-mask.txt input/base-words.txt -r input/demo.rule -o artifacts/cracked-rules.txt

# Mask pattern: 4 lower letters + 4 digits
hashcat -m 1400 -a 3 input/hashes-rules-mask.txt '?l?l?l?l?d?d?d?d' -o artifacts/cracked-mask.txt
```

## Common patterns (lab-safe)

```bash
# Benchmark only (no target material)
hashcat -b

# Example hash type lookup
hashcat --example-hashes | grep -i -n "sha256"
```

## Key flags

- `-m` — hash mode (see `hashcat --help` / example hashes).
- `-a` — attack mode (0 straight, 1 combinator, …).
- `-o` — output cracked results to file.
- `--show` — show cracked hashes from potfile for current target set.
- `--force` — use only when OpenCL setup is unstable; document **why**.

## Safety

Never paste real organizational hashes into the public repo. Keep `artifacts/` to **local** copies only (see `.gitignore` at track level if added later).
