# Lab 04: SSH Agent Forwarding 🔑➡️🌐

### 🎯 Objective
Learn how to access multiple remote servers securely without copying your private keys to intermediate hosts (Jump Servers).

### 🛠 Security Problem
Copying your private SSH key to a remote server is a major security risk. If that server is compromised, an attacker can steal your identity and access all other systems.

### ✅ The Solution: SSH Agent Forwarding
SSH Agent Forwarding allows you to use your local SSH keys on remote servers as if they were stored there, but they never actually leave your local machine.

### 🚀 Implementation Steps:
1. **Start the SSH Agent locally**: `eval $(ssh-agent -s)`
2. **Add your key**: `ssh-add ~/.ssh/id_ed25519`
3. **Connect with Forwarding**: `ssh -A user@server_a`
4. **Jump to the next one**: From Server A, run `ssh user@server_b` without any passwords!

---
**Status:** ✅ Completed — demo in video: [Lab 04: SSH Agent Forwarding](https://youtu.be/NOCivaFgoXc)
    