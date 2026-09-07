# Hydra cheat sheet (track level)

Per-lab targets, wordlists, and full command blocks live in each folder. Use this page as a **route map**.


| Lab                                               | Module / service               | Local target (default)            | Commands file                                          |
| ------------------------------------------------- | ------------------------------ | --------------------------------- | ------------------------------------------------------ |
| [01 SSH](./01-ssh/)                               | `ssh`                          | `127.0.0.1:2222`                  | [01-ssh/commands.md](./01-ssh/commands.md)             |
| [02 HTTP form](./02-http-form/)                   | `http-post-form`               | `http://127.0.0.1:8080/login.php` | [02-http-form/commands.md](./02-http-form/commands.md) |
| [03 FTP](./03-ftp/)                               | `ftp`                          | `ftp://127.0.0.1:2121`            | [03-ftp/commands.md](./03-ftp/commands.md)             |
| [00 Speed vs detection](./00-speed-vs-detection/) | *(Flask app, not Hydra flags)* | `127.0.0.1:5000`                  | see folder `README.md`                                 |


## Universal reminders


| Topic         | Note                                                                         |
| ------------- | ---------------------------------------------------------------------------- |
| Authorization | Only lab hosts you own or are explicitly allowed to test.                    |
| Artifacts     | Each lab has `artifacts/` for Hydra `-o` output (gitignored patterns apply). |
| Threads       | Lower `-t` and add wait (`-W`) for cleaner logs and calmer demos.            |
