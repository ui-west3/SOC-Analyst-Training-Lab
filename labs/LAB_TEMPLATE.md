# LAB_TEMPLATE.md

Use this template for all new labs to keep structure consistent and recruiter-friendly.

## 1) Scenario
Describe the problem and goal in 2-4 lines.

## 2) Scope & Authorization
- Target environment (lab VM, THM room, local network)
- Authorization statement (approved lab only)

## 3) Reproduction (Red)
Show how the issue is observed. Include exact commands.

```bash
# command(s) used to reproduce
```

## 4) Remediation (Blue)
Describe defensive fix/hardening steps.

```bash
# remediation command(s) or config snippets
```

## 5) Verification
Re-run checks to prove the change is effective.

```bash
# verification command(s)
```

## 6) Artifacts
- Script(s):
- Output/report file(s):
- Screenshot(s):

## 7) Defensive Takeaway
1-3 bullets on what SOC/Blue team should monitor or enforce.

## 8) MITRE ATT&CK Mapping
Map this lab to 1-3 ATT&CK techniques with clear reasoning.

| ATT&CK Tactic | Technique ID | Why it matches this lab | Detection idea | Mitigation |
|:-------------|:-------------|:-------------------------|:---------------|:-----------|
| Example: Discovery | T1046 | Service scanning activity is performed during recon | Detect unusual scan patterns in firewall/IDS logs | Restrict exposure, segment network, monitor scan bursts |

Notes:
- Prefer quality over quantity (1-3 relevant techniques only).
- Keep mappings evidence-based from your actual lab steps.
