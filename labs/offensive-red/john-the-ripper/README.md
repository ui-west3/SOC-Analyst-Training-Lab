# John the Ripper

**Offline password / hash recovery** with **John** (and optional **jumbo** features). Same boundary as [Hashcat](../hashcat/): **only material you are authorized to test** — typically hashes you mint locally for training.

Series language: **English** docs; video voiceover optional — command callouts can be text in post.

## Position vs Hashcat

- **John:** quick format auto-detection, flexible rules, CPU-first workflows, many legacy hash types.  
- **Hashcat:** GPU scale, explicit modes, throughput benchmarking.

Both belong **after Hydra** in the learning path: online brute force → **offline** guessing on leaked digests.

## Track rules

- **Authorized hashes only** (self-generated, CTF rules, or lab VMs you own).  
- Do not commit real cracked secrets or production `passwd`/`shadow` snippets.  
- One lab = one **John skill** (formats, wordlist run, `--show`, single rule file).

## Sections (skeleton)


| #   | Folder                                        | Description                                                  | Video      |
| --- | --------------------------------------------- | ------------------------------------------------------------ | ---------- |
| 01  | [01-baseline-formats](./01-baseline-formats/) | Local synthetic hashes, format handling, basic wordlist + `--show` | 🎬 Ready to record |
| 02  | [02-incremental-and-rules](./02-incremental-and-rules/) | Wordlist rules plus incremental mode on synthetic hashes | 🎬 Ready to record |


## Quick links

- [Back to Red Team labs](../README.md)
- [Command index](./commands.md)
- [Main video index](../../../README.md#-video-index)

## Quick start (Lab 01)

```bash
cd labs/offensive-red/john-the-ripper/01-baseline-formats
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh
john --format=Raw-SHA256 --wordlist=input/wordlist-demo.txt input/hashes-raw-sha256.txt
```

## Quick start (Lab 02)

```bash
cd labs/offensive-red/john-the-ripper/02-incremental-and-rules
chmod +x scripts/generate-lab-data.sh
./scripts/generate-lab-data.sh
john --format=Raw-SHA256 --wordlist=input/base-words.txt --rules input/hashes-john-l02.txt
john --format=Raw-SHA256 --incremental=Digits input/hashes-john-l02.txt --max-length=4
```