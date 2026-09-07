# Hydra 01 SSH - Commands

## Target validation

```bash
nc -zv 127.0.0.1 2222
ssh -p 2222 labuser@127.0.0.1
```

## Hydra quick run

```bash
hydra -l labuser -P words-quick.txt -s 2222 -t 4 -V ssh://127.0.0.1
```

## Hydra demo run (longer list)

```bash
hydra -l labuser -P words-demo.txt -s 2222 -t 4 -V ssh://127.0.0.1
```

## Controlled run for cleaner logs

```bash
hydra -l labuser -P words-demo.txt -s 2222 -t 1 -W 2 -V ssh://127.0.0.1
```

## Save output artifact

```bash
hydra -l labuser -P words-demo.txt -s 2222 -t 1 -V -o artifacts/hydra-ssh.txt ssh://127.0.0.1
```

## Optional: show SSH auth lines (host with Fail2Ban)

```bash
sudo journalctl -u ssh -n 100 --no-pager
sudo fail2ban-client status sshd
```

