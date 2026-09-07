# Ticket — HTTP brute-force triage

**Lab:** Blue companion / Hydra 00  
**Analyst:** MiroslavSec  
**Date:** 30 August 2026  
**Status:** closed (lab)

## Alert

Multiple failed HTTP logins against the local training form in a few seconds, single source IP.

## Evidence

- 17 events from `127.0.0.1` against user `labuser`
- Window: `2026-08-30 18:01:02 UTC` → `18:01:23 UTC` (21s)
- 14× `bad_password`, then `lockout_triggered`, then `blocked_lockout`
- 0 successful logins in this window

## Timeline

1. 18:01:02 — fail burst starts (defenses off / still guessing)
2. 18:01:09 — still `bad_password` only; volume is machine-like
3. 18:01:21 — lockout fires
4. 18:01:22–23 — same IP is blocked

## Verdict

**True Positive** — T1110 brute force. One IP, one username, high fail rate, no human typing cadence. Not a single typo.

## Action

- Confirmed lockout stopped further guesses
- No success-after-fail → no password reset in this lab case
- Watch the same IP on SSH/FTP if those labs are up
- Close: monitor repeat bursts from `127.0.0.1` on this form

## Notes

Script draft matched the human verdict. Script does not close the ticket by itself.
