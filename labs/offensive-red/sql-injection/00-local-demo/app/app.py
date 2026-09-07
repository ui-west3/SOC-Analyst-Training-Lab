import json
import os
import random
import sqlite3
from datetime import datetime, timezone
from pathlib import Path

from flask import Flask, redirect, render_template, request, session, url_for

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "local-sqli-training-secret")

BASE_DIR = Path(__file__).resolve().parent
ARTIFACTS_DIR = BASE_DIR / "artifacts"
ARTIFACTS_DIR.mkdir(exist_ok=True)
DB_PATH = ARTIFACTS_DIR / "training.db"
EVENTS_PATH = ARTIFACTS_DIR / "events.log"


def now_utc() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def db_conn() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db() -> None:
    random.seed(42)
    with db_conn() as conn:
        conn.executescript(
            """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL,
                role TEXT NOT NULL
            );
            CREATE TABLE IF NOT EXISTS products (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                category TEXT NOT NULL,
                price INTEGER NOT NULL
            );
            CREATE TABLE IF NOT EXISTS incidents (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                severity TEXT NOT NULL,
                owner TEXT NOT NULL,
                status TEXT NOT NULL
            );
            """
        )

        if conn.execute("SELECT COUNT(*) FROM users").fetchone()[0] == 0:
            users = [
                ("admin", "AdminPass123", "admin"),
                ("analyst", "blue-team", "analyst"),
                ("guest", "guest", "viewer"),
            ]
            roles = ["analyst", "viewer", "intern"]
            for idx in range(1, 61):
                users.append((f"user{idx:02d}", f"pass{idx:02d}", random.choice(roles)))
            conn.executemany("INSERT INTO users (username, password, role) VALUES (?, ?, ?)", users)

        if conn.execute("SELECT COUNT(*) FROM products").fetchone()[0] == 0:
            catalog = [
                ("Firewall Appliance", "hardware"),
                ("EDR Agent License", "software"),
                ("Threat Intel Feed", "subscription"),
                ("SIEM Storage Add-on", "cloud"),
                ("SOC Analyst Course", "training"),
                ("Phishing Drill Kit", "training"),
                ("Endpoint Scanner", "software"),
                ("Log Retention Pack", "cloud"),
            ]
            rows = []
            for idx in range(1, 81):
                base_name, category = random.choice(catalog)
                rows.append((f"{base_name} #{idx:02d}", category, random.randint(19, 1499)))
            conn.executemany("INSERT INTO products (name, category, price) VALUES (?, ?, ?)", rows)

        if conn.execute("SELECT COUNT(*) FROM incidents").fetchone()[0] == 0:
            severities = ["low", "medium", "high", "critical"]
            statuses = ["new", "triage", "investigating", "resolved"]
            titles = [
                "Suspicious login burst",
                "Endpoint malware alert",
                "WAF anomaly trigger",
                "Credential stuffing signal",
                "Privilege escalation attempt",
            ]
            rows = []
            for idx in range(1, 41):
                rows.append(
                    (
                        f"{random.choice(titles)} #{idx:02d}",
                        random.choice(severities),
                        f"user{random.randint(1, 30):02d}",
                        random.choice(statuses),
                    )
                )
            conn.executemany(
                "INSERT INTO incidents (title, severity, owner, status) VALUES (?, ?, ?, ?)", rows
            )


def detect_signals(payload: str) -> list[str]:
    patterns = [
        ("' OR ", "classic OR injection pattern"),
        ("\" OR ", "double-quote OR pattern"),
        ("--", "inline SQL comment marker"),
        ("/*", "block comment marker"),
        (" UNION ", "union probing pattern"),
        (" SLEEP(", "time-based probe"),
        (" BENCHMARK(", "resource delay probe"),
        (";DROP", "statement chaining"),
    ]
    up = payload.upper()
    return [message for needle, message in patterns if needle in up]


def log_event(event_type: str, details: dict) -> None:
    line = {"ts_utc": now_utc(), "event_type": event_type, "details": details}
    with EVENTS_PATH.open("a", encoding="utf-8") as fh:
        fh.write(json.dumps(line, ensure_ascii=True) + "\n")


def get_recent_events(limit: int = 80) -> list[dict]:
    if not EVENTS_PATH.exists():
        return []
    rows = EVENTS_PATH.read_text(encoding="utf-8").splitlines()[-limit:]
    parsed = []
    for row in rows:
        try:
            parsed.append(json.loads(row))
        except json.JSONDecodeError:
            continue
    parsed.reverse()
    return parsed


def clear_events() -> None:
    EVENTS_PATH.write_text("", encoding="utf-8")


@app.route("/", methods=["GET", "POST"])
def index():
    mode = request.values.get("mode", "vulnerable")
    action = request.values.get("action", "search")
    query = request.values.get("query", "")
    username = request.values.get("username", "")
    password = request.values.get("password", "")

    rows = []
    info = ""
    warning = ""

    if request.method == "POST":
        ip = request.remote_addr or "unknown"
        if action == "search":
            if mode == "vulnerable":
                sql = f"SELECT id, name, category, price FROM products WHERE name LIKE '%{query}%'"
                try:
                    with db_conn() as conn:
                        rows = conn.execute(sql).fetchall()
                    info = "Vulnerable mode: raw SQL string executed."
                    log_event(
                        "search_vulnerable",
                        {"ip": ip, "sql": sql, "query": query, "rows": len(rows)},
                    )
                except sqlite3.Error as exc:
                    warning = f"SQLite error: {exc}"
                    log_event(
                        "search_vulnerable_error",
                        {"ip": ip, "sql": sql, "query": query, "error": str(exc)},
                    )
            else:
                sql = "SELECT id, name, category, price FROM products WHERE name LIKE ?"
                with db_conn() as conn:
                    rows = conn.execute(sql, (f"%{query}%",)).fetchall()
                info = "Safe mode: parameterized query executed."
                log_event("search_safe", {"ip": ip, "sql": sql, "query": query, "rows": len(rows)})

            signals = detect_signals(query)
            if signals:
                log_event(
                    "sqli_signal",
                    {"ip": ip, "action": action, "payload": query, "signals": signals},
                )

        elif action == "login":
            if mode == "vulnerable":
                sql = (
                    "SELECT id, username, role FROM users "
                    f"WHERE username = '{username}' AND password = '{password}'"
                )
                try:
                    with db_conn() as conn:
                        row = conn.execute(sql).fetchone()
                    if row:
                        session["user"] = {"id": row["id"], "username": row["username"], "role": row["role"]}
                        info = f"Login success (vulnerable): {row['username']} ({row['role']})"
                    else:
                        warning = "Login failed."
                    log_event(
                        "login_vulnerable",
                        {"ip": ip, "sql": sql, "username": username, "success": bool(row)},
                    )
                except sqlite3.Error as exc:
                    warning = f"SQLite error: {exc}"
                    log_event("login_vulnerable_error", {"ip": ip, "sql": sql, "error": str(exc)})
            else:
                sql = "SELECT id, username, role FROM users WHERE username = ? AND password = ?"
                with db_conn() as conn:
                    row = conn.execute(sql, (username, password)).fetchone()
                if row:
                    session["user"] = {"id": row["id"], "username": row["username"], "role": row["role"]}
                    info = f"Login success (safe): {row['username']} ({row['role']})"
                else:
                    warning = "Login failed."
                log_event("login_safe", {"ip": ip, "sql": sql, "username": username, "success": bool(row)})

            signals = detect_signals(f"{username} {password}")
            if signals:
                log_event(
                    "sqli_signal",
                    {
                        "ip": ip,
                        "action": action,
                        "payload": f"user={username} pass={password}",
                        "signals": signals,
                    },
                )

        elif action == "logout":
            previous_user = session.get("user", {}).get("username", "unknown")
            session.pop("user", None)
            info = "Logged out."
            log_event("logout", {"ip": ip, "username": previous_user})

    return render_template(
        "index.html",
        mode=mode,
        action=action,
        query=query,
        username=username,
        rows=rows,
        info=info,
        warning=warning,
        current_user=session.get("user"),
    )


@app.route("/admin")
def admin():
    current_user = session.get("user")
    if not current_user or current_user.get("role") != "admin":
        log_event("role_access_denied", {"path": "/admin", "user": current_user})
        return redirect(url_for("index"))

    with db_conn() as conn:
        users_count = conn.execute("SELECT COUNT(*) FROM users").fetchone()[0]
        products_count = conn.execute("SELECT COUNT(*) FROM products").fetchone()[0]
        incidents = conn.execute(
            "SELECT id, title, severity, owner, status FROM incidents ORDER BY id DESC LIMIT 12"
        ).fetchall()

    return render_template(
        "admin.html",
        current_user=current_user,
        users_count=users_count,
        products_count=products_count,
        incidents=incidents,
    )


@app.route("/monitoring")
def monitoring():
    events = get_recent_events()
    summary = {
        "total": len(events),
        "signal_hits": sum(1 for e in events if e.get("event_type") == "sqli_signal"),
        "vulnerable_actions": sum(1 for e in events if "vulnerable" in e.get("event_type", "")),
        "safe_actions": sum(1 for e in events if "safe" in e.get("event_type", "")),
    }
    return render_template("monitoring.html", events=events, summary=summary)


@app.route("/monitoring/clear", methods=["POST"])
def monitoring_clear():
    clear_events()
    return redirect(url_for("monitoring"))


@app.route("/health")
def health():
    return {"status": "ok", "service": "sqli-local-demo"}


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8088")))
