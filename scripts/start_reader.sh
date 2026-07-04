#!/bin/zsh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${1:-8000}"
URL="http://127.0.0.1:${PORT}/"
PID_FILE="${ROOT}/data/build/server.pid"
LOG_FILE="${ROOT}/data/build/server.log"

mkdir -p "${ROOT}/data/build"

is_running() {
  /usr/bin/python3 - "$URL" <<'PY'
import sys
from urllib.request import urlopen

try:
    with urlopen(sys.argv[1], timeout=1) as response:
        raise SystemExit(0 if response.status == 200 else 1)
except Exception:
    raise SystemExit(1)
PY
}

if ! is_running; then
  cd "$ROOT"
  /usr/bin/nohup /usr/bin/python3 scripts/server.py "$PORT" > "$LOG_FILE" 2>&1 &
  echo $! > "$PID_FILE"
  sleep 1
fi

/usr/bin/open "$URL"

