# Setup — agents-LocalReady

Step-by-step to run your own HeliQuant engine and connect the dApp to it.

## 0 · Prerequisites
- **Docker** (recommended) — or Python 3.12 + git for the no-Docker path.
- **ngrok** (free) — https://ngrok.com → sign up → `ngrok config add-authtoken <token>`.
- A few **free Groq API keys** — https://console.groq.com (ten is ideal; the desks rotate to dodge limits).

## 1 · Get the engine running
```bash
git clone https://github.com/HeliQuant/agents-LocalReady
cd agents-LocalReady
cp .env.example .env
```
Edit `.env` and set **`HQ_SETUP_TOKEN`** to a long random string (it gates who may register credentials to
your engine). Then:
```bash
docker compose up -d          # first run builds the image (a few minutes)
curl http://localhost:8000/health     # → ok
```

## 2 · Expose it with a tunnel
```bash
ngrok http 8000
```
Copy the `https://…ngrok-free.app` URL.

## 3 · Register on the dApp (no custody)
Open the HeliQuant dApp → **Register your engine** (`/onboarding`):
1. Paste your **ngrok URL** + your **`HQ_SETUP_TOKEN`**.
2. Paste your **10 Groq keys** + any execution keys (Bitget) / optional desk APIs.
3. Hit **Register** — the keys POST straight to your engine, land in its local SQLite, and the whole
   dashboard switches to **your** firm.

Done — your firm runs autonomously. Next time, use **"Already set up → connect"** to reconnect.

## No-Docker path
```bash
# Windows
./run.ps1
# macOS / Linux
chmod +x run.sh && ./run.sh
```

## Troubleshooting
- **`/register` returns 503** — `HQ_SETUP_TOKEN` isn't set in `.env`. Set it + restart.
- **dApp says "engine unreachable"** — is the tunnel up? Test `curl <ngrok-url>/health`.
- **Firm abstains / 0 trades** — correct + disciplined when no validated edge fires. Not a bug.
- **Update the firm** — `docker compose build --no-cache && docker compose up -d` re-pulls the latest `agents`.
- **Data persists** in the `hq_data` volume (your `credentials.db` + state). `docker compose down -v` wipes it.
