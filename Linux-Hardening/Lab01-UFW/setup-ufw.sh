#!/bin/bash

# --- CONFIGURATION ---
MY_SSH_PORT="2222"

echo "🛡️ Starting Lab01: UFW Hardening for port $MY_SSH_PORT"

# 1. Reset and Set Default Policies
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 2. Security Rules (Anti-Brute Force for Custom SSH)
sudo ufw limit $MY_SSH_PORT/tcp comment 'Secure SSH Access'

# 3. Allow Web Services
sudo ufw allow http
sudo ufw allow https

# 4. Monitoring & Activation
sudo ufw logging on
sudo ufw --force enable

# 5. Final Status
echo "✅ UFW Setup Complete. Current Status:"
sudo ufw status verbose
