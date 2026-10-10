# Christimony

Christimony is a modern Christian matrimony platform built for relationship-focused discovery, with a denomination-aware feed and a parent/ward model that keeps the child’s consent central before any real connection opens.

The project is split into three deployable parts:

- `web/` — Next.js 16 frontend with the app shell and marketing site
- `backend/` — Rails API with auth, profiles, matchmaking, messaging, and safety features
- `mobile/` — Flutter client scaffold for Android/iOS
- `docs/` — deployment and product planning docs

## Live status

- Web marketing site: [christimony.vercel.app](https://christimony.vercel.app)
- Backend API: currently deployed to Render at `https://christimony-api.onrender.com` and wired to the web app via `API_BASE_URL`
- Mobile: early Android/iOS scaffold; not yet a full end-user app

## Repository layout

```text
christimony/
├── README.md
├── docs/
│   ├── deploy.md
│   ├── mobile-v1-plan.md
│   └── ...
├── web/
│   ├── app/
│   ├── components/
│   ├── lib/
│   ├── public/
│   ├── README.md
│   └── package.json
├── backend/
│   ├── app/
│   ├── config/
│   ├── db/
│   ├── test/
│   ├── README.md
│   └── Dockerfile
├── mobile/
│   ├── lib/
│   ├── test/
│   ├── config/
│   ├── README.md
│   └── pubspec.yaml
└── ...
```

## What this project includes

### Core product concept

- Christian-focused matchmaking with denomination-aware filtering
- Parent/ward account model where a parent can manage a child’s profile, but the child must still independently consent before a real introduction or connection opens
- No email/password auth; sign-in is via phone OTP, Google, or Apple
- Safety features including report, block, profile visibility restrictions, and account deletion
- Profiles, interests, introductions, matches, conversations, verification status, and subscription state

### App architecture

```text
Browser / app user                     Flutter app
  │ same-origin only                     │ Authorization: Bearer <jwt>
  │ (/api/bff/*, /api/auth/*)           │ stored in secure device storage
  ▼                                     ▼
Next.js frontend (web/)                 Rails API (backend/) 
  │ httpOnly cookie session             │ JSON API
  │ forwards token to Rails            │ PostgreSQL + S3-compatible storage
  ▼                                     ▼
Rails API (backend/)                    Postgres + object storage
```

The browser never talks to Rails directly. The Next.js app stores the JWT in an httpOnly cookie and uses a same-origin BFF proxy to forward authenticated requests. The mobile app skips that hop and calls the Rails API directly with a bearer token stored securely on-device.

## Quick start

### 1) Backend

```bash
cd backend
bundle install
bin/rails db:prepare
bin/rails server
```

Default API URL in development: `http://localhost:3000`

### 2) Web frontend

```bash
cd web
npm install
PORT=3001 npm run dev
```

The frontend runs on `http://localhost:3001` by convention to avoid the Rails default port conflict.

### 3) Mobile app

```bash
cd mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define-from-file=config/dev.json
```

The mobile app is still early-stage and not a full user-facing app yet; it currently includes a design gallery and network/debug scaffolding.

## Environment variables

### Web

The frontend uses a server-only `API_BASE_URL` and public OAuth client IDs:

```bash
API_BASE_URL=http://localhost:3000/api/v1
NEXT_PUBLIC_GOOGLE_CLIENT_ID=
NEXT_PUBLIC_APPLE_CLIENT_ID=
NEXT_PUBLIC_APPLE_REDIRECT_URI=
```

See [web/README.md](web/README.md) for the full frontend auth and routing details.

### Backend

The backend is safe to run locally with defaults, but production requires a few variables. The main ones are:

| Variable | Purpose |
|---|---|
| `BACKEND_DATABASE_HOST` | Postgres host for production |
| `BACKEND_DATABASE_PORT` | Postgres port |
| `BACKEND_DATABASE_USERNAME` | DB username |
| `BACKEND_DATABASE_PASSWORD` | DB password |
| `CORS_ORIGINS` | Allowed frontend origins |
| `SMS_PROVIDER` | `log`, `twilio`, or `msg91` |
| `GOOGLE_CLIENT_ID` | Google OAuth verification |
| `APPLE_CLIENT_IDS` | Accepted Apple audiences |
| `S3_BUCKET` / `AWS_*` | Object storage for uploaded photos |
| `FCM_PROJECT_ID` / `FCM_CREDENTIALS_JSON` | Push notifications |
| `RAILS_MASTER_KEY` | Required to decrypt `config/credentials.yml.enc` |

See [backend/README.md](backend/README.md) and [docs/deploy.md](docs/deploy.md) for the full environment manifest and deployment workflow.

## Deployment status

### Current production setup

- Web frontend: deployed on Vercel
- Rails API: deployed on Render at `christimony-api.onrender.com`
- Database: Neon Postgres
- Frontend points to the Render API via `API_BASE_URL`

### Deployment notes

- The backend Docker setup is production-ready for Render, Railway, or Fly.io
- The app does not require a separate buildpack config for Docker-based hosting
- Render is currently the live backend target and the deployment notes are documented in [docs/deploy.md](docs/deploy.md)

## Auth and security model

- No password-based auth anywhere in the app
- Phone OTP and provider-based sign-in are the only primary login flows
- JWTs are issued by the backend and used as bearer tokens for API calls
- The web app stores the token in an httpOnly cookie, never in JavaScript-readable storage
- Safety actions include report, block, profile hiding, and account deletion
- Backend access control includes authorization checks on conversations, vouches, and profile access

## Product status by layer

### Web

- ✅ Marketing landing page is live
- ✅ Login / OTP flow and onboarding flows are implemented against a local Rails API
- ✅ App shell, profile screens, discovery flow, messaging flow, and safety actions are built
- ✅ Auth is protected behind a cookie/BFF architecture
- ⚠️ Production usage requires the deployed Rails API to be live

### Backend

- ✅ Rails 8 API with PostgreSQL, JWT auth, media uploads, feed pagination, matches, messages, reports, blocks, and push support
- ✅ Model and API tests are in place
- ✅ Access-control bugs and parameter-handling consistency have been fixed
- ⚠️ Real payment gateway, real KYC, and some production hardening remain outside the current scope

### Mobile

- ✅ Flutter toolchain, theme system, app scaffold, networking core, and design gallery are in place
- ✅ Core models, routing guard, and test coverage are implemented
- ⚠️ No production-ready screens or real app flows yet; this is still an early scaffold

## Known gaps and roadmap

- Real payment integration for subscriptions (Razorpay planned)
- Real KYC provider integration for verification
- Full realtime messaging and push configuration for all production environments
- Additional product polish across the app flows beyond the current core implementation
- The backend and mobile client are still being expanded toward full feature parity with the web app

## Verification and quality

The repo includes live verification and testing guidance in each service README:

- `backend`: model, API, security, and auth tests are included
- `web`: app build and route/auth checks are expected before shipping auth changes
- `mobile`: analyzer, tests, and isolation checks are included

## Documentation map

- [web/README.md](web/README.md) — frontend architecture, auth flow, and route map
- [backend/README.md](backend/README.md) — API model, auth, endpoints, and status
- [mobile/README.md](mobile/README.md) — Flutter scaffold status and design system
- [docs/deploy.md](docs/deploy.md) — deployment steps, env vars, and production configuration
- [docs/mobile-v1-plan.md](docs/mobile-v1-plan.md) — mobile roadmap and API contract notes

## Notes for contributors

- Treat the three app layers as independent deployables: web, backend, and mobile do not share a database or direct app runtime
- Keep auth and API contracts aligned across the frontend and backend before shipping changes
- Use the per-service README files as the source of truth for local setup and environment variables
- For deployment work, follow [docs/deploy.md](docs/deploy.md) rather than guessing at host-specific settings

This repository is a monorepo for a full-stack Christian dating product, and the root README is intended to serve as the central overview while the service-specific READMEs hold the implementation details.
