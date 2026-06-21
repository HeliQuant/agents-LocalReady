# agents-LocalReady 🦅 — run your own HeliQuant engine

Your **own** instance of the [HeliQuant](https://github.com/HeliQuant) autonomous trading firm — running on
**your machine**, with **your keys**, **no custody**. The shared HeliQuant dApp connects to it over a tunnel;
your credentials live only in this engine's local SQLite and never touch anyone else's server.

```
download → docker compose up → ngrok → "Register your engine" on the dApp → your firm is live
```

## Quickstart (Docker — recommended)
```bash
git clone https://github.com/HeliQuant/agents-LocalReady
cd agents-LocalReady
cp .env.example .env          # set HQ_SETUP_TOKEN to a long random string
docker compose up -d          # builds + runs the firm on http://localhost:8000
```
Then expose it and onboard:
```bash
ngrok http 8000               # copy the https URL it prints
```
Open the HeliQuant dApp → **Register your engine** → paste your ngrok URL + `HQ_SETUP_TOKEN` + your keys
(10 free Groq keys, optional Bitget / wallet) → **Register**. The dApp now reads **your** firm.

## No Docker?
- **Windows:** `./run.ps1`
- **macOS / Linux:** `chmod +x run.sh && ./run.sh`

Both clone the firm, make a venv, install it, and run it on port 8000 — with the same self-driving loop.

## What it does
- Runs the firm's FastAPI service (`app.py`) + a built-in **self-pinger**, so the floor and the org cycle
  advance **24/7** with no external uptime monitor.
- Persists your credentials + state in a local SQLite (Docker volume `hq_data`).
- Exposes the same read endpoints the dApp uses (`/campaign`, `/agents`, `/trades`, …) over your tunnel.

See [`SETUP.md`](SETUP.md) for the full walkthrough + troubleshooting.

> **No custody.** Your keys are POSTed from the onboarding form straight to this engine's `/register`
> (gated by `HQ_SETUP_TOKEN`) and stored in `data/credentials.db` on your machine. They never reach a
> shared server.
