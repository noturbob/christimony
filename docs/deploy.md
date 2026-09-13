# Deploying the backend

The Rails API (`backend/`) isn't deployed anywhere yet — this is the
walkthrough for doing that. The app itself needs no changes to be
deployable (a couple of small gaps found while writing this doc are
already fixed on `main` — see "What was fixed to make this possible"
below); what's left is entirely on the hosting side.

**Who does what:** you create the hosting account, provision Postgres,
and set the env vars. Nothing here requires code changes from this
point on — if a step below doesn't match what you see on your chosen
host's dashboard, that's a hosting-UI difference, not a sign that the
app needs more work.

## Choosing a host

**Recommended: a managed PaaS with Docker support and a Postgres
add-on** — Railway, Render, or Fly.io all work. `backend/Dockerfile` is
a real production Dockerfile (multi-stage, non-root, Thruster-fronted
Puma) that any of them can build directly; there's no separate
buildpack config to write. This doc walks through Railway specifically
since its multi-database provisioning is the least fiddly for this
app's particular setup (see the four-databases section below), but the
env vars and gotchas are identical on Render or Fly.

**Alternative: Kamal, to your own server.** `backend/config/deploy.yml`
already exists, but it's Rails' generated *template* — `servers.web`
still points at the placeholder IP `192.168.0.1`, there's no configured
registry, and the `env` block doesn't pass through most of what this
app actually needs (compare it against the env var list below). Use
this path only if you already have a VPS and are comfortable finishing
that config yourself; it's not a "run one command" path the way a PaaS
deploy is.

## Deploying on Railway

1. **Create a project, add a Postgres database.** Railway's Postgres
   add-on gives you `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD` (or a
   bundled `DATABASE_URL`) — you'll map these into this app's own var
   names in step 3, since the app doesn't read Railway's names directly
   (see "Why the database env vars look the way they do" below).

2. **Add a second service from this repo, then point it at `backend/`.**
   This is a monorepo (`backend/`, `web/`, `mobile/`, `docs/` all live at
   the same top level), and Railway's default builder (Railpack) scans
   whatever directory the service is rooted at — if you just connect the
   repo and deploy without changing anything, it scans the repo **root**,
   finds no recognizable app there (the `Dockerfile` is inside
   `backend/`, not at the top level), and fails with something like:
   ```
   ✖ Railpack could not determine how to build the app.
   ```
   Fix: open the service → **Settings → Source → Root Directory** → set
   it to `/backend` (leading slash — that's the exact form Railway's own
   docs use, and the field is picky about it). **This only applies to
   deployments created after you save it** — it does not retroactively
   fix a build that's already running or queued, so after saving,
   explicitly click Deploy/Redeploy rather than assuming the next
   automatic build will pick it up. Once Railway is scanning the right
   directory it auto-detects the `Dockerfile` there and switches its
   builder from Railpack to Docker on its own — no other build
   configuration needed. (Config-as-code `railway.json`/`railway.toml`
   can declare a lot of Railway service config, but *not* this setting —
   Root Directory is dashboard/CLI/API-only, so there's no way to pin it
   in a file this repo could ship.)



3. **Set the environment variables.** `backend/.env.production.example`
   lists every var the app reads, grouped by whether it's required,
   strongly recommended, or optional-with-a-sane-default, each with an
   explanation of what breaks (or silently degrades) if it's left
   unset. Copy values in from wherever they actually come from:

   - `RAILS_MASTER_KEY`: run `cat backend/config/master.key` locally
     and paste the output. This file is gitignored on purpose — it's
     the only way to decrypt `config/credentials.yml.enc` — so this
     value has to travel to the host out-of-band, not through git.
   - `BACKEND_DATABASE_HOST` / `BACKEND_DATABASE_PASSWORD` /
     `BACKEND_DATABASE_PORT` / `BACKEND_DATABASE_USERNAME`: copy from
     the Postgres add-on's own connection details (`PGHOST` →
     `BACKEND_DATABASE_HOST`, etc). Railway lets you reference another
     service's variables directly in the UI (`${{Postgres.PGHOST}}`
     etc.) instead of copy-pasting — use that if it's available, so a
     Postgres credential rotation doesn't silently break the app.
   - Everything else: see the inline comments in
     `.env.production.example`, or `backend/README.md`'s own env var
     table for the same list in a different format.

4. **Point Railway's health check at `/up`** (Rails' built-in health
   check route — always returns 200 once the app has booted, no auth
   needed). Most platforms auto-detect this; if yours asks, that's the
   path.

5. **Deploy, then verify:**
   ```bash
   curl https://<your-service>.up.railway.app/up
   # => 200, empty body

   curl https://<your-service>.up.railway.app/api/v1/denominations
   # => [{"id":1,"name":"Catholic"}, ...] if db:prepare's seed step ran
   ```
   The container's entrypoint (`bin/docker-entrypoint`) runs
   `bin/rails db:prepare` automatically on every boot when the command
   is `rails server` — so the first deploy creates and migrates all
   four databases and seeds `denominations`/`prompt_questions` with no
   manual step. If the second curl 404s or 500s instead, jump to
   Troubleshooting below.

## Why the database env vars look the way they do

`backend/config/database.yml`'s production block used to have no
`host`/`port` at all — omitting them makes Postgres's client library
(`libpq`) connect over a local Unix socket, which only works if
Postgres runs on the *same machine* as the Rails process (true for a
Kamal deploy with a colocated `db` accessory, false for essentially
every managed Postgres add-on, which runs as its own separate host).
It also hardcoded `username: backend`, which assumes you can create a
role with that exact name — most managed add-ons assign their own
username instead and don't let you rename it.

Both are now configurable (`BACKEND_DATABASE_HOST`,
`BACKEND_DATABASE_PORT`, `BACKEND_DATABASE_USERNAME`), defaulting to
the original same-machine, `username: backend` behavior when left
unset — so this didn't change anything about the Kamal path, it just
makes the managed-Postgres path actually work. Found and fixed while
writing this doc, since a deploy walkthrough describing a config that
can't reach a real managed database wouldn't be much of a walkthrough.

## The four-databases gotcha

`config/database.yml` configures **four** separate databases from one
set of credentials: `backend_production`, `_cache`, `_queue`, and
`_cable` (Rails 8's default Solid Queue/Solid Cache/Solid Cable setup,
which keeps each concern in its own database rather than one shared
schema). `db:prepare` creates all four automatically **as long as the
Postgres role you're connecting as has `CREATEDB` privilege** on that
server. This is true by default for the primary/owner role a managed
Postgres add-on gives you — but if you ever see a permission error
mentioning `backend_production_cache` (or `_queue`/`_cable`) during the
first boot, that's what to check: either grant `CREATEDB` to the role,
or create the three extra databases yourself ahead of time.

## Wiring up the frontend and mobile app once this is live

- **Web** (`web/`): set `API_BASE_URL` to
  `https://<your-api-host>/api/v1` in Vercel's environment variables
  (both Production and Preview) — see `web/README.md`.
- **Mobile** (`mobile/`): update `mobile/config/staging.json` and
  `prod.json`'s `API_BASE_URL`/`CABLE_URL` placeholders — see
  `mobile/README.md`.
- Both also need `CORS_ORIGINS` set on the backend if the frontend
  isn't on a `*.vercel.app` subdomain (that pattern's always allowed
  without extra config).

## Troubleshooting

- **Build fails with "Railpack could not determine how to build the
  app" (or your platform's equivalent auto-detection failure), listing
  `backend/`, `web/`, `mobile/`, `docs/` as the scanned contents:** the
  service is building from the repo root instead of `backend/` — see
  step 2 above. If you already set Root Directory and get the *exact
  same* failure again, the most likely cause isn't the value itself —
  it's that the build shown was already queued/running before the
  setting saved. Reload the settings page to confirm it still shows
  `/backend`, then explicitly trigger a new deployment rather than
  waiting.
- **500 on every request, HTML body with a stack trace:** the app
  booted but is missing `RAILS_MASTER_KEY`, or it's the wrong value
  (doesn't match the key `config/credentials.yml.enc` was encrypted
  with). Don't generate a new master key — that re-encrypts
  credentials with a key nobody else has; use the exact existing one.
- **Times out / connection refused on every request:** almost always
  the Thruster port mismatch — see the `HTTP_PORT`/`TARGET_PORT` note
  in `.env.production.example`. Thruster (the proxy in front of Puma)
  listens on `HTTP_PORT` (default 80, matching the Dockerfile's
  `EXPOSE 80`); most Docker-native platforms detect that and route
  correctly with no env vars set, but if yours assigns its own dynamic
  port instead and expects the app to listen there, set `HTTP_PORT` to
  that value.
- **`PG::ConnectionBad` / "could not connect to server" on boot:**
  `BACKEND_DATABASE_HOST` is unset or wrong — see "Why the database env
  vars look the way they do" above. This is the single most likely
  first-deploy failure, since it's a genuinely new requirement this app
  didn't previously support.
- **`PG::InsufficientPrivilege` mentioning a database name ending in
  `_cache`/`_queue`/`_cable`:** see "The four-databases gotcha" above.
- **`/api/v1/auth/google` or `/auth/apple` returns 401 "sign-in is not
  configured":** `GOOGLE_CLIENT_ID`/`APPLE_CLIENT_IDS` aren't set. This
  fails closed on purpose rather than silently accepting any token.
- **Uploaded photos disappear after a redeploy:** `S3_BUCKET` (and the
  AWS/R2 credentials alongside it) aren't set, so storage fell back to
  local disk — which almost no host persists across deploys. This is a
  silent fallback, not an error, so it's easy to miss until someone
  notices their photos are gone.
