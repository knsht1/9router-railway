# Deploy and Host 9Router Self-Hosted on Railway

9Router is the open-source AI gateway that puts every LLM provider behind one endpoint. Point Claude Code, Cursor, Codex, or any OpenAI-compatible tool at it, and it routes requests across 40+ providers with automatic fallback and built-in token compression, without touching client config every time you switch models.

## About Hosting 9Router-Self-Hosted

OpenRouter charges a 5.5% markup on every token you route through it, on top of whatever the underlying provider already bills. On a team spending $2,000/month on API calls, that's $110 a month handed over just for routing. Portkey's managed gateway starts at $49/month before any API costs at all. 9Router self-hosted on Railway costs a flat infrastructure fee, no markup, no per-seat charge, so the more you route through it, the more you save compared to OpenRouter specifically.

The bigger reason to self-host this particular category of tool isn't price alone. A gateway sees every request you send to every AI provider: your prompts, your code, your API keys for each provider. Routing that through someone else's proxy means trusting their logging practices and their breach history with everything your coding tools send. Self-hosting keeps that traffic on infrastructure you control, end to end.

It's also worth being specific about what 9Router actually saves beyond the markup. Its built-in RTK Token Saver compresses git diffs, grep output, and file trees losslessly before they ever reach the LLM, cutting input token consumption 20-40% on every request. That's real money back on top of skipping OpenRouter's fee, not a separate feature you have to configure.

And it's not a small or unproven project. 9Router has crossed 23,000 GitHub stars, which puts it well ahead of most self-hosted AI infrastructure tools in this category. That kind of adoption matters for a gateway specifically, since it's the single piece of infrastructure every one of your AI coding requests passes through, and a large, active community means bugs and provider-compatibility issues get caught and fixed fast.

## Common Use Cases

- **Developers running multiple AI coding tools**: Point Claude Code, Cursor, and Codex at the same provider pool through one gateway instead of managing separate keys and configs per tool.
- **Cost-conscious individual developers**: Stack the 20-40% token compression on top of zero markup, a meaningful cut to a monthly AI spend that adds up fast with heavy coding-assistant use.
- **Teams needing reliability**: Configure 3-tier automatic fallback (subscription tier to cheap tier to free tier) so one provider's outage or rate limit doesn't stall a whole team's workflow.
- **Agencies billing AI usage to clients**: Issue a separate scoped API key per client or project, with usage tracked per key from one dashboard instead of reconciling multiple provider bills.
- **Privacy-focused teams**: Keep every provider credential and routing decision on infrastructure you own, with zero requests passing through a third party's servers.
- **Open-source and indie developers**: Get enterprise-style gateway features (fallback, compression, unified billing view) without an enterprise gateway's subscription cost.

## Dependencies for 9Router-Self-Hosted Hosting

- A persistent volume for 9Router's own SQLite database, storing settings, provider connections, API keys, and usage history.

### Deployment Dependencies

This template provisions a persistent Railway volume automatically, wired to the 9Router container. No Postgres, no Redis, no separate database service to configure. Reference: [9Router GitHub Repository](https://github.com/decolua/9router), [9Router Docker Documentation](https://github.com/decolua/9router/blob/main/DOCKER.md), [Environment Variable Reference](https://github.com/decolua/9router/blob/main/.env.example).

### Implementation Details

This template runs `decolua/9router:0.5.45`, verified as the newest actual stable release tag in the registry at build time, matching the image's own `latest` digest rather than trusting a floating tag that could change under you. `INITIAL_PASSWORD` and `JWT_SECRET` are both auto-generated Railway secrets. This matters more than it sounds: reading 9Router's actual authentication source code directly showed that if `INITIAL_PASSWORD` is ever left unset, the app silently falls back to a hardcoded password (`123456`), a real, confirmed security gap this template closes by always setting it. An optional "Headroom" token-compression sidecar is documented in 9Router's own repo, but it's explicitly marked optional there too, not required for the gateway to function, so this template skips it to keep the stack simple.

## How 9Router Compares to the Alternatives

**Vs. OpenRouter**: OpenRouter is fully managed and requires zero infrastructure knowledge, but takes a 5.5% cut of every token you route, forever, on top of whatever the provider charges. 9Router trades a few minutes of setup for zero ongoing markup and full control of the credentials passing through it.

**Vs. Portkey**: Portkey's managed dashboard is polished and enterprise-ready, but starts at $49/month before any API costs. 9Router ships a comparable dashboard experience, providers, keys, usage tracking, at the cost of self-hosting instead of a subscription.

**Vs. LiteLLM Proxy**: LiteLLM is powerful and widely used, but leans more toward YAML config files than a point-and-click dashboard. 9Router optimizes specifically for AI coding tool workflows, with documented setup steps for Claude Code, Cursor, and Codex rather than generic per-client instructions.

## Getting Started

After deploying, wait for the healthcheck to pass, it should be quick since 9Router runs on Node.js with a bundled SQLite database, no separate database service to wait on.

Open your Railway domain and log in using the `INITIAL_PASSWORD` value from your Railway variables tab. This is a bootstrap credential only, go to account settings inside the dashboard and set a real password immediately, the same way you'd rotate any default credential on a freshly deployed service.

From the dashboard, go to Providers and add API keys for whichever AI providers you actually plan to use, OpenAI, Anthropic, Gemini, or any of the 40+ supported options. You don't need to configure all of them, only the ones you'll route requests to.

Next, go to Keys and generate a 9Router API key. This is what you'll put into your coding tools, not your underlying provider keys directly. Point Claude Code, Cursor, Codex, or any OpenAI-compatible client at your Railway domain with `/v1` appended as the base URL, and use this new key for authentication.

The real test worth running before trusting this in daily work: send an actual request through a connected coding tool and confirm it completes successfully, then check the Usage tab in the dashboard and confirm that request shows up there. A gateway that accepts requests but doesn't log usage correctly is a much harder problem to notice later than one that simply doesn't work.

Once the basic path works, test token compression directly rather than assuming it's active. Send a large git diff through a connected coding tool and compare the token count your provider actually billed against what the raw request would have cost. Seeing the real number once beats trusting a percentage from documentation, and the same habit applies to fallback tiers: deliberately break your primary provider's key and confirm requests actually fail over instead of just failing.

If you're moving from an existing setup, migrate one tool at a time rather than repointing everything at once. Update Claude Code's base URL first, confirm a full session works, then move to Cursor or Codex. Catching a wrong API key on one tool beats discovering it across your whole toolchain mid-task.

## Why Deploy 9Router-Self-Hosted on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying 9Router-self-hosted on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.

## Frequently Asked Questions

### Is the INITIAL_PASSWORD safe to leave as-is after deploying?
No. It's meant as a one-time bootstrap credential, not a permanent password. Log in with it once, then set a real password from the dashboard's account settings. 9Router's own source code falls back to a hardcoded, publicly-known default if this variable is ever removed, so treat it seriously.

### Do I need to add every AI provider 9Router supports?
No. Add only the providers whose API keys you actually have and plan to route to. Everything else stays unconfigured with no downside.

### What happens if a provider I'm using goes down or rate-limits me?
If you've configured fallback tiers, 9Router automatically routes to your next configured provider instead of failing the request outright. Without fallback configured, the request fails the same way it would calling that provider directly.

### Will my provider keys and settings survive a redeploy?
Yes, as long as the Railway volume this template provisions stays attached to your project. Everything, settings, provider connections, issued API keys, usage history, lives in the SQLite database on that volume.

### Is the Headroom sidecar required for 9Router to work?
No. It's an optional add-on for extra token compression, documented in 9Router's own repo as explicitly optional. This template doesn't provision it, and 9Router works fully without it.

### Where can I download 9Router?
Source code is at `github.com/decolua/9router`, with Docker images published as `decolua/9router`. This template pulls a specific verified version automatically.
