# John the Ripper — command index (lab track)

## Lab 01 quick path (`01-baseline-formats`)

```bash
cd labs/offensive-red/john-the-ripper/01-baseline-formats
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh

john --format=Raw-SHA256 --wordlist=input/wordlist-demo.txt input/hashes-raw-sha256.txt
john --show --format=Raw-SHA256 input/hashes-raw-sha256.txt
```

## Lab 02 quick path (`02-incremental-and-rules`)

```bash
cd labs/offensive-red/john-the-ripper/02-incremental-and-rules
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh

# Wordlist + rules
john --format=Raw-SHA256 --wordlist=input/base-words.txt --rules input/hashes-john-l02.txt
john --show --format=Raw-SHA256 input/hashes-john-l02.txt

# Incremental demo (digits only, short length)
john --format=Raw-SHA256 --incremental=Digits input/hashes-john-l02.txt --max-length=4
john --show --format=Raw-SHA256 input/hashes-john-l02.txt
```

## Common patterns (lab-safe)

```bash
# List supported formats (jumbo builds show more)
john --list=formats | head

# Generic wordlist run
john --wordlist=wordlist.txt hashes.txt

# Show cracked entries
john --show hashes.txt
```

## `unshadow` (Linux lab context)

When your **own** disposable VM allows it:

```bash
unshadow /etc/passwd /etc/shadow > local_combined.txt
# Then run john against local_combined.txt in an isolated snapshot only.
```

Never ship real `shadow` content in this repository.

## Safety

Treat `artifacts/` as **local-only**. Add specific `.gitignore` rules under each lab when you introduce files.
