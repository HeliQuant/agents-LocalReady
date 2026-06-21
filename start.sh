#!/usr/bin/env bash
# agents-LocalReady entrypoint — run the firm + drive its cycle locally (no external pinger needed).
set -e
cd /opt/firm
# self-pinger: hit /run-cycle every 4 min so the floor + org keep advancing 24/7
( while true; do sleep 240; curl -fsS http://127.0.0.1:8000/run-cycle >/dev/null 2>&1 || true; done ) &
exec python -m uvicorn app:app --host 0.0.0.0 --port 8000
