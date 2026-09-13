# Christimony

A modern, Hinge/Bumble-style matrimony platform for Christians — denomination-aware matching, and a distinctive parent/ward model where a parent can guide a profile on a child's behalf, but the child always gives independent consent before any real connection opens.

**Live:** [christimony.vercel.app](https://christimony.vercel.app) — the marketing landing page is live; phone login and the app itself need the Rails API deployed first (see Status below).

## Structure

```
web/       Next.js 16 frontend (App Router, React 19, Tailwind v4)   → web/README.md
backend/   Ruby on Rails 8.1 API (Postgres, JWT auth)                → backend/README.md
mobile/    Flutter client (Android + iOS), early scaffold            → mobile/README.md
docs/      Cross-cutting design docs and build plans
```

`web`, `backend`, and `mobile` are independent deployables that talk over JSON: `web` and `mobile` never touch the database directly, and `backend` knows nothing about Next.js or Flutter. Each has its own README with full setup instructions, environment variables, and API/route details — this file is just the map. `mobile/` is the newest and least complete of the three (early scaffold — toolchain, design tokens, and the networking core exist, no actual screens yet); see [`mobile/README.md`](mobile/README.md) for exactly what's built and [`docs/mobile-v1-plan.md`](docs/mobile-v1-plan.md) for the full phased build brief, including the design-token set and the API-contract gotchas a native client has to handle.

## Architecture at a glance

```
Browser                          Flutter app (mobile/, early scaffold)
  │  same-origin only               │  Authorization: Bearer <jwt>,
  │  (/api/bff/*, /api/auth/*)      │  held in platform secure storage
  ▼                                 │  (Keychain/Keystore)
Next.js (Vercel)                    │
  │  httpOnly cookie session        │
  │  → Authorization: Bearer <jwt>  │
  ▼                                 ▼
Rails API (not yet deployed) ◄──────┘
  │
  ▼
PostgreSQL + S3-compatible object storage
```

The browser never talks to Rails directly and never holds the JWT in a place client JS can read — see `web/README.md`'s Architecture section for how the cookie/BFF proxy works, and why that's what let the app screens drop their auth boilerplate. Mobile skips that hop entirely and talks to Rails directly, since a native app can hold the JWT safely on-device without a browser's exposure — see `mobile/README.md`'s "Why not the Next.js BFF".

## Running locally

```bash
# terminal 1
cd backend && bundle install && bin/rails db:prepare && bin/rails server   # :3000

# terminal 2
cd web && npm install && PORT=3001 npm run dev                             # :3001
```

Phone login in development never sends a real SMS: the OTP is printed to the Rails log and also returned in the API response as `dev_code` (visible as a small banner on the `/verify` page).

There's no third terminal for `mobile/` yet in the useful sense — no screens exist to run past the debug Design Gallery. If you want to see that: `cd mobile && flutter pub get && flutter run --dart-define-from-file=config/dev.json` (needs a connected device or emulator; see `mobile/README.md`).

## Status

- ✅ **Frontend** deployed to Vercel and working end-to-end for the marketing page; phone login, Google/Apple sign-in, onboarding, and the app screens are built and tested against a local backend but need a deployed API to work in production.
- ⏳ **Backend** is not deployed anywhere yet. It's a standard Rails 8 API (Dockerfile included) — Railway, Fly.io, or Render all work with minimal setup. Once deployed, set `API_BASE_URL` (web) and `CORS_ORIGINS` (backend, if the frontend isn't on `*.vercel.app`) accordingly.
- 🏗️ **Mobile** is an early Flutter scaffold — toolchain, design tokens, and the networking core are built and tested (40 tests, `flutter analyze` clean), but no actual screens exist yet. See `mobile/README.md` for exactly what's there.
- ⏳ Payments (Razorpay), real KYC verification, and real-time messaging (ActionCable/Solid Cable) are designed for but not wired up — see `backend/README.md`'s "Not Yet Built".
