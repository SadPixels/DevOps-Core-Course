import os
from datetime import datetime
from pathlib import Path
from threading import Lock
from zoneinfo import ZoneInfo

from flask import Flask

app = Flask(__name__)

VISITS_FILE = Path(os.getenv("VISITS_FILE", "/home/appuser/visits"))
VISITS_LOCK = Lock()


def get_moscow_time() -> str:
    """Return the current time in Moscow in a stable display format."""
    return datetime.now(ZoneInfo("Europe/Moscow")).strftime("%Y-%m-%d %H:%M:%S")


def read_visits() -> int:
    """Read the current visit counter value from the visits file."""
    try:
        return int(VISITS_FILE.read_text(encoding="utf-8").strip() or "0")
    except FileNotFoundError:
        return 0
    except ValueError:
        return 0


def write_visits(value: int) -> None:
    """Write the current visit counter value to the visits file."""
    VISITS_FILE.parent.mkdir(parents=True, exist_ok=True)
    VISITS_FILE.write_text(f"{value}\n", encoding="utf-8")


def increment_visits() -> int:
    """Increase the visit counter and persist it in the visits file."""
    with VISITS_LOCK:
        visits = read_visits() + 1
        write_visits(visits)
        return visits


@app.route("/")
def index():
    visits = increment_visits()
    moscow_time = get_moscow_time()
    return f"""
    <html>
        <head>
            <title>Moscow Time</title>
        </head>
        <body>
            <h1>Current time in Moscow</h1>
            <p>{moscow_time}</p>
            <p>Refresh the page to update the time.</p>
            <p>Total visits: {visits}</p>
            <p><a href="/visits">View recorded visits</a></p>
        </body>
    </html>
    """


@app.route("/healthz")
def healthz():
    return "ok\n", 200


@app.route("/visits")
def visits():
    return f"""
    <html>
        <head>
            <title>Moscow Time Visits</title>
        </head>
        <body>
            <h1>Recorded visits</h1>
            <p>{read_visits()}</p>
        </body>
    </html>
    """


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8080)
