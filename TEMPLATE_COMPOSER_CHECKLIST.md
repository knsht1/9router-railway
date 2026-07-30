# Railway Template Composer Checklist — 9Router

Apply these settings in the Railway template composer when generating the template from the project.

**Expected services this template deploys:** `9router` (the app, single service). **Verify against the actual live service name once deployed** — Railway auto-assigns a random adjective-noun name to GitHub-connected services (e.g. `selfless-dedication` on the Postiz template, `vaultwarden-railway` on the Vaultwarden template since it matched the repo name), so `9router` below is a placeholder until confirmed live via `railway status --json`.

---

## 1. Healthcheck Settings

### `9router` (app service)
- **Healthcheck Path:** `/api/health` — confirmed real, unauthenticated endpoint by reading the actual route source (`src/app/api/health/route.js`), returns `{ok: true}`, not guessed from docs.
- **Healthcheck Timeout:** `60` seconds — Node.js/Next.js app with bundled SQLite, no external database to wait on, should come up fast. Verify empirically on first real deploy.

---

## 2. Variable Descriptions (Add to EVERY variable)

### `9router` (App) Variables

| Variable | Value | Mark Optional? | Description |
|----------|-------|-----------------|-------------|
| `INITIAL_PASSWORD` | `${{secret(24)}}` | No | Bootstrap login password. **Critical: confirmed via source code that if this is ever unset, 9Router falls back to a hardcoded password (`123456`)** — never mark this optional or leave it blank. |
| `JWT_SECRET` | `${{secret(32)}}` | No | Signs dashboard session tokens. If unset, the app auto-generates one and writes it to a file in `DATA_DIR` — but setting it explicitly as a Railway variable avoids any risk of session invalidation if that file location ever changes across a redeploy. |
| `API_KEY_SECRET` | `${{secret(32)}}` | No | Secret used internally to derive and validate issued 9Router API keys. |
| `MACHINE_ID_SALT` | `${{secret(16)}}` | No | Salt used for internal instance identification. |
| `DATA_DIR` | `/app/data` | No | Directory where the SQLite database and settings are stored. Must match the Railway volume mount path exactly. |
| `PORT` | `20128` | No | Port Railway routes external traffic to. Must be an explicit Railway variable, not just a Dockerfile `ENV` default — this project has confirmed the hard way (Metabase, Postiz, Vaultwarden) that a Dockerfile-only default alone doesn't reliably get picked up by Railway's edge routing. |
| `HOSTNAME` | `0.0.0.0` | No | Binds the Next.js standalone server to all network interfaces. Already set as a Dockerfile default too, but set explicitly here for the same reason as `PORT`. |
| `BASE_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | **Yes** | Public URL of the instance, used for internal callback/sync jobs. Optional per the app's own `.env.example`, but setting it avoids any sync-related edge cases. |

---

## 3. Secrets That Must Use `${{secret()}}`

| Variable | Template Syntax |
|----------|-----------------|
| `INITIAL_PASSWORD` | `${{secret(24)}}` |
| `JWT_SECRET` | `${{secret(32)}}` |
| `API_KEY_SECRET` | `${{secret(32)}}` |
| `MACHINE_ID_SALT` | `${{secret(16)}}` |

---

## 4. Volumes

**Required.** Mount a Railway Volume to `/app/data` on the `9router` service. This is where 9Router stores its SQLite database (`db/data.sqlite`), containing all settings, provider connections, issued API keys, and usage history. Without this volume, all of that is lost on every redeploy.

---

## 5. Known Troubleshooting

- **Dashboard login falls back to a weak default password:** if `INITIAL_PASSWORD` is ever removed or left blank, 9Router's own auth code (`src/lib/auth/dashboardSession.js`) falls back to a hardcoded `123456` password. This was confirmed by reading the actual source, not assumed from docs — treat this variable as never-optional.
- **Headroom sidecar is not part of this template:** 9Router's official `docker-compose.yml` includes an optional `headroom` service for extra token compression, but the project's own `DOCKER.md` explicitly calls it optional and documents running 9Router without it. This template deliberately skips it to keep the stack to one service. If a deployer wants it later, they'd add `ghcr.io/chopratejas/headroom:latest` as a second service and set `HEADROOM_URL` to point at it.
- **Session gets invalidated after every redeploy:** happens if `JWT_SECRET` isn't set as an explicit Railway variable, since the app would otherwise auto-generate a new one and (depending on where it writes the fallback file) potentially lose it across redeploys. Setting `JWT_SECRET` explicitly avoids this entirely.
- **Floating `latest` tag risk:** avoided by pinning `decolua/9router:0.5.45`, verified against Docker Hub's tags API as the current numbered release matching `latest`'s push date at authoring time. This project is under active development (multiple releases per week observed), so re-verify the pinned version is still reasonably current before publishing if significant time has passed since authoring.

---

## 6. Post-Deploy Steps

After the template is published, test-deploy from a fresh Railway account (incognito window) and verify:

1. No "needs configuration" prompts appear for any variable.
2. The service comes online and responds with a real `200` at `/api/health`.
3. Open the actual Railway domain in a browser and log in using the real `INITIAL_PASSWORD` value copied from Railway's variables tab, not a guessed default.
4. Set a real password from account settings immediately after logging in.
5. Add at least one real AI provider API key, generate a 9Router API key, and confirm a request through a connected tool (or a direct `curl` to `/v1`) actually succeeds and shows up under Usage.
6. Redeploy the service once and confirm the dashboard login/session still works afterward, not just that the app comes back online.
