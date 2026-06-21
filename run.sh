#!/usr/bin/env bash
# agents-LocalReady — run your local HeliQuant engine on macOS/Linux (no Docker).
set -e

[ -d firm ] || { echo "cloning firm..."; git clone --depth 1 https://github.com/HeliQuant/agents.git firm; }
cd firm
[ -d .venv ] || python3 -m venv .venv
./.venv/bin/pip install --upgrade pip >/dev/null
./.venv/bin/pip install -r requirements.txt "uvicorn[standard]"

# load ../.env so the firm sees HQ_SETUP_TOKEN etc.
set -a; [ -f ../.env ] && . ../.env; set +a

# self-pinger: drive the cycle locally every 4 min
( while true; do sleep 240; curl -fsS http://127.0.0.1:8000/run-cycle >/dev/null 2>&1 || true; done ) &

echo "engine on http://localhost:8000 — in another terminal run:  ngrok http 8000"
exec ./.venv/bin/python -m uvicorn app:app --host 0.0.0.0 --port 8000
