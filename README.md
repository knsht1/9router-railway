# 9Router — Self-Hosted AI Gateway & LLM Router

Deploy 9Router, the open-source gateway that connects Claude Code, Codex, Cursor, and any OpenAI-compatible tool to 40+ AI providers through a single unified endpoint, on Railway with one click.

## Deploy on Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

## Features

- **Unified endpoint** — Point every AI coding tool and app at one URL instead of juggling separate API keys and base URLs per provider.
- **Multi-provider routing** — Connect OpenAI, Anthropic, Gemini, and dozens of other providers, then switch between them without touching client config.
- **RTK Token Saver** — Losslessly compresses git diffs, grep output, and file trees before they hit the LLM, cutting input token usage 20-40% per request.
- **Smart fallback** — Automatically falls back from subscription to cheap to free providers when a request fails or hits a rate limit.
- **Dashboard-managed API keys** — Create and revoke scoped API keys from a web dashboard instead of editing config files.
- **Pinned, stable image** — Runs `decolua/9router:0.5.45`, a specific verified release rather than a floating `latest` tag that could change behavior under you between deploys.

## How to Use

1. Click the Deploy on Railway button above.
2. Railway provisions the 9Router container with a persistent volume for its SQLite database and settings.
3. Wait for the healthcheck to pass, then open your Railway domain.
4. Log in using the `INITIAL_PASSWORD` value from your Railway variables, then **immediately set a real password from the dashboard's account settings** (the initial password is only a bootstrap credential).
5. Add your AI provider API keys under Providers, then create a 9Router API key under Keys.
6. Point Claude Code, Cursor, Codex, or any OpenAI-compatible client at your Railway domain plus `/v1` as the base URL, using your new 9Router API key.

## Notes

- **Security-critical default:** if `INITIAL_PASSWORD` is ever unset, 9Router falls back to a hardcoded password (`123456`), confirmed directly in its source. This template always sets it to an auto-generated value, but never redeploy with this variable removed.
- **Data persistence** — All 9Router data (settings, API keys, usage history) lives in a SQLite database on the Railway volume mounted at `/app/data`. As long as that volume exists, your configuration survives redeploys.
- **Headroom is optional and not included** — 9Router's official docs describe an optional "Headroom" sidecar for extra token compression. It's explicitly optional per the project's own Docker documentation, not required for 9Router to function, so this template doesn't provision it. Add it separately later if you want it.
- **Port** — 9Router listens on port 20128 internally. Railway exposes it via HTTPS automatically.

## Self-Hosting on Other Platforms

Clone the repository:
```bash
git clone https://github.com/decolua/9router
```

For Docker:
```bash
docker run -d \
  -p 20128:20128 \
  -v "$HOME/.9router:/app/data" \
  -e DATA_DIR=/app/data \
  -e INITIAL_PASSWORD=your-secure-password \
  -e JWT_SECRET=your-random-secret \
  --name 9router \
  decolua/9router:0.5.45
```

## License

9Router is open-source software, free to self-host with no user limits.

## Support

- **GitHub** — https://github.com/decolua/9router
- **Docs** — https://github.com/decolua/9router/tree/main/docs
- **Issues** — https://github.com/decolua/9router/issues
