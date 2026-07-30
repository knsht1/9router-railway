## Template Titles

**Railway Title:** `9Router` (plain name only, this field controls the URL slug)
**Railway Description:** `9Router [Jul '26] (Self-Hosted AI Gateway & LLM Router) Self Host`
**Spreadsheet Title:** `9Router (Open-Source AI Gateway, Multi-Provider LLM Router & Token Saver)`
**GitHub Description:** `9Router: self-hosted AI gateway that routes Claude Code, Cursor, Codex, and OpenAI-compatible tools across 40+ LLM providers. Deploy on Railway with one click.`

---

![9Router dashboard showing connected AI providers and usage stats](https://res.cloudinary.com/dt8h4kuxe/image/upload/v1746791300/9router-banner.png "Hosting 9Router on Railway")

# Deploy and Host Self-Hosted 9Router (Open-Source AI Gateway & LLM Router) on Railway

9Router is the open-source gateway that puts every AI provider behind one endpoint. Point Claude Code, Cursor, Codex, Gemini CLI, or any OpenAI-compatible tool at your 9Router URL, and it routes requests across 40+ providers with automatic fallback and built-in token compression, no per-tool reconfiguration when you switch providers.

## About Hosting 9Router Open-Source Software on Railway (Self-Hosted 9Router Template)

Self-hosting 9Router means your provider API keys, routing rules, and usage history stay on infrastructure you control, not a third party's proxy servers. Railway provisions a persistent volume for 9Router's SQLite database, automatic HTTPS, and zero-config networking, so the gateway takes one click while you keep full control of every credential flowing through it.

## Why Deploy 9Router, the OpenRouter Alternative on Railway (Railway Free Trial)

OpenRouter charges a 5.5% markup on every token routed through it, on top of whatever the provider already charges. Portkey's managed gateway starts at $49/month before any API costs. 9Router is free, open-source software: self-hosting it means you pay provider rates directly, no markup, no platform fee, ever. Railway's $5 free trial covers your first month of hosting it.

### Railway vs Other Hosting Providers and VPS for 9Router Self Hosting

| Provider          | What You Get with Railway           | What You Get with the Other Provider     |
| ----------------- | ------------------------------------ | ----------------------------------------- |
| **DigitalOcean**  | Auto HTTPS, persistent volumes, zero server maintenance | Raw droplets you patch, secure, and back up yourself |
| **AWS**           | Simple usage-based billing, no IAM maze | EC2 setup, security groups, surprise egress fees |
| **Hetzner**       | One-click deploy, automatic domain, instant rollback | Cheap hardware but you own the OS, backups, and TLS |

## Common Use Cases for Hosted 9Router

- **Developers using multiple AI coding tools**: Run Claude Code, Cursor, and Codex against the same provider pool through one gateway instead of separate keys per tool.
- **Cost-conscious teams**: Cut input token spend 20-40% via built-in diff and file-tree compression, on top of avoiding OpenRouter's markup entirely.
- **Reliability-focused workflows**: Configure automatic 3-tier fallback (subscription to cheap to free) so one provider outage doesn't stop your coding session.
- **Agencies managing client AI usage**: Issue scoped API keys per client from one dashboard, with centralized usage tracking across all of them.
- **Privacy-conscious teams**: Keep provider credentials and routing logic off a third-party's servers, since every request passes through infrastructure you control.

![9Router provider connection screen showing multiple AI providers configured](https://res.cloudinary.com/dt8h4kuxe/image/upload/v1746791301/9router-features.png "9Router multi-provider configuration")

## Dependencies for 9Router Docker Hosted on Railway

9Router needs a persistent volume for its own SQLite database, storing settings, API keys, and usage history. No external database service is required.

### Deployment Dependencies for Managed 9Router Service (AI Gateway)

This template provisions a persistent Railway volume mounted at `/app/data`, wired to the container automatically. No Postgres, no Redis. An optional "Headroom" compression sidecar exists in 9Router's docs but isn't provisioned here.

### Implementation Details for 9Router (Using 9Router Official Docker Image)

The template deploys `decolua/9router:0.5.45`, a specific verified release tag matching the image's actual `latest` digest at build time, not a floating tag. `INITIAL_PASSWORD` and `JWT_SECRET` are both auto-generated per deploy, critical since 9Router's source falls back to a hardcoded `123456` password if `INITIAL_PASSWORD` is left unset, confirmed by reading the actual auth code.

## Environment Variables Reference for 9Router on Railway

| Variable | Description | Value |
|----------|-------------|-------|
| `INITIAL_PASSWORD` | Bootstrap login password for the dashboard. Auto-generated per deploy. Change it from account settings immediately after first login. | `${{secret(24)}}` |
| `JWT_SECRET` | Signs dashboard session tokens. Auto-generated per deploy so sessions stay valid across redeploys instead of regenerating and logging everyone out. | `${{secret(32)}}` |
| `API_KEY_SECRET` | Secret used internally to derive and validate issued API keys. | `${{secret(32)}}` |
| `MACHINE_ID_SALT` | Salt used for internal instance identification. | `${{secret(16)}}` |
| `DATA_DIR` | Directory where the SQLite database and settings are stored. Matches the Railway volume mount path. | `/app/data` |
| `PORT` | Port Railway routes external traffic to. Must be set explicitly, a Dockerfile default alone isn't reliably enough for Railway's edge to route correctly. | `20128` |
| `HOSTNAME` | Binds the Next.js server to all network interfaces so Railway's edge can reach it. | `0.0.0.0` |
| `BASE_URL` | Public URL of your instance, used for internal callback and sync jobs. Auto-set to your Railway domain. | `https://${{RAILWAY_PUBLIC_DOMAIN}}` |

## How Does 9Router Compare Against Other AI Gateway Platforms

### 9Router vs OpenRouter
* **Pricing:** 9Router is free and self-hosted with no markup; OpenRouter charges a 5.5% fee on every token routed through it.
* **Control:** 9Router keeps provider keys and routing logic on your own infrastructure; OpenRouter's proxy sits between you and every provider.
* **Token savings:** 9Router's built-in compression cuts input tokens 20-40% before requests leave your infrastructure; OpenRouter offers no equivalent.

### 9Router vs Portkey
* **Cost:** 9Router has no subscription fee at all; Portkey starts at $49/month before API costs.
* **Deployment:** 9Router is a single self-hosted container; Portkey is a managed SaaS product you don't control the infrastructure of.

### 9Router vs LiteLLM Proxy
* **Focus:** 9Router ships a full dashboard for keys, providers, and usage; LiteLLM proxy is more config-file-driven and developer-oriented.
* **Coding tool integration:** 9Router documents direct setup for Claude Code, Cursor, and Codex; LiteLLM's setup is more generic per-client.

## How to Use 9Router (the Open-Source AI Gateway)?

Deploy the template, log in with the auto-generated `INITIAL_PASSWORD`, set a real password, connect your provider keys, then point your coding tools at the generated 9Router key.

## How to Self Host 9Router on Other VPS Services (9Router Self Hosting Guide)

### Clone the Repository
Clone `github.com/decolua/9router` or pull the `decolua/9router` image directly.

### Install Dependencies
Docker, plus a persistent volume for the SQLite database. No external database service needed.

### Configure Environment Variables
Set `INITIAL_PASSWORD`, `JWT_SECRET`, and `DATA_DIR` before starting the container.

### Start the 9Router Application
Run the container with a volume mounted at `/app/data`, and expose port 20128 behind a reverse proxy with TLS.

## Official Pricing of 9Router (9Router Pricing)

9Router is MIT-licensed and entirely free to self-host, with no user cap, no request cap, and no paid tier gating any feature. The only real cost is your own hosting.

## 9Router Cloud vs Self Hosted Comparison (Pricing, Features, Costs, and More)

There's no separate "9Router Cloud" tier, the project is built for self-hosting. The real comparison is against OpenRouter's markup model: 9Router matches its multi-provider routing and adds token compression, at zero per-token fee.

### Monthly Cost of Self Hosting 9Router on Railway

Typical cost: $5-10/month for the app and its data volume together, regardless of how many providers or keys you configure.

### System Requirements for Hosting 9Router on a VPS

Minimum: 1 shared vCPU, 512MB RAM. 9Router runs on Node.js with bundled SQLite, light enough for the cheapest tier of most hosting providers.

## Frequently Asked Questions (FAQs)

### What is 9Router self hosted?
An open-source AI gateway that routes requests from coding tools and apps across 40+ LLM providers through one unified, OpenAI-compatible endpoint, with built-in token compression and fallback.

### How much does 9Router self hosting cost on Railway?
Typically $5-10/month total for the app and its storage volume combined, with no per-request or per-token fees on top.

### Is 9Router free to use?
Yes, entirely. It's MIT-licensed open source with no paid tier, unlimited providers, and unlimited API keys built in from the start.

### What AI coding tools does 9Router support?
Claude Code, Cursor, Codex, Gemini CLI, and any tool that speaks the OpenAI-compatible API format, since 9Router exposes a standard `/v1` endpoint.

### Do I need to configure every AI provider listed?
No, add only the providers you actually plan to use. Provider connections are configured entirely through the dashboard after deployment, not through template variables.

### Where can I download 9Router?
Source code is at `github.com/decolua/9router`, with Docker images published as `decolua/9router`. This template pulls a specific verified version automatically.
