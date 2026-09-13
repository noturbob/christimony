# Christimony — Backend

A modern, Hinge/Bumble-style matrimony platform for Christians, with denomination-based filtering and a unique parent/ward account model that lets a parent manage a profile on behalf of their child while still requiring the child's independent consent before any real connection opens.

This is the Ruby on Rails API backend. It serves the web (Next.js, in `../web`) and a Flutter mobile client (`../mobile`, early scaffold — see its README) over the same JSON API.

## Tech Stack

- **Backend:** Ruby on Rails 8.1 (API-only mode)
- **Database:** PostgreSQL
- **Background jobs / cache / cable:** Solid Queue, Solid Cache, Solid Cable (all database-backed, no Redis required)
- **Auth:** JWT (via the `jwt` gem), issued by phone-number OTP or Google/Apple Sign-In verified server-side — there is no email/password auth
- **OTP hashing:** bcrypt (the 6-digit code, not a password — see Authentication below)
- **Phone parsing:** `phonelib` (normalizes to E.164, default region `IN`)
- **SMS:** pluggable adapter (`app/services/sms/`) — logs to the console in development, Twilio or MSG91 in production
- **File storage:** ActiveStorage, local disk in development, S3-compatible (AWS S3 or Cloudflare R2) in production
- **Web frontend:** Next.js 16 + React 19 + Tailwind v4 (`../web`)

## Getting Started

```bash
bundle install
bin/rails db:prepare   # creates, migrates, and (on a fresh db) seeds
bin/rails server        # http://localhost:3000
```

Run the test suite with `bin/rails test`, style with `bin/rubocop`, and a security scan with `bin/brakeman`.

### Environment variables

None are required for local development — everything has a safe default (Postgres on localhost, `SMS_PROVIDER=log`, local disk storage). For anything beyond that:

| Variable | Purpose | Default |
|---|---|---|
| `CORS_ORIGINS` | Comma-separated list of allowed origins, in addition to any `*.vercel.app` subdomain (always allowed) | `http://localhost:3001` |
| `SMS_PROVIDER` | `log` \| `twilio` \| `msg91` | `log` (prints the OTP to the Rails log; also returned as `dev_code` in the API response when `RAILS_ENV=development`) |
| `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_FROM` | Required when `SMS_PROVIDER=twilio` | — |
| `MSG91_AUTH_KEY`, `MSG91_TEMPLATE_ID` | Required when `SMS_PROVIDER=msg91` (DLT-registered template for Indian transactional SMS) | — |
| `S3_BUCKET`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `S3_REGION`, `S3_ENDPOINT` | Object storage for profile photos in production. `S3_ENDPOINT` is only needed for R2/non-AWS providers. Falls back to local disk if `S3_BUCKET` is unset | — |
| `APP_HOST`, `APP_PROTOCOL` | Host used to build absolute URLs (e.g. photo URLs) outside of a request context | — |
| `GOOGLE_CLIENT_ID` | Google OAuth client ID — verifies the ID token's `aud` claim server-side (`app/services/oauth/google_verifier.rb`). Must match the frontend's `NEXT_PUBLIC_GOOGLE_CLIENT_ID` (see `../web/README.md`) | — |
| `APPLE_CLIENT_IDS` | Comma-separated list of accepted Apple audiences (`app/services/oauth/apple_verifier.rb`). Apple's `aud` claim differs per client surface: the web flow's Services ID (matching the frontend's `NEXT_PUBLIC_APPLE_CLIENT_ID`) **and** each native app's bundle id (e.g. `app.christimony`) need to be listed — a single value can't satisfy both | — |
| `RAILS_MASTER_KEY` | Required in production to decrypt `config/credentials.yml.enc` | — |
| `DATABASE_URL` | Standard Rails database URL, production only | — |

## Core Design Concept: Parent/Ward Accounts

The defining feature of this app: a parent can create and manage a profile on behalf of their child (a "ward"), similar to an IAM admin/user relationship. Critically, **when two parents' own profiles match, their wards are not automatically connected.** Instead, an `Introduction` is created, and each ward must independently accept before a real match (and conversation) opens between them. This preserves the parent's role as matchmaker while protecting the child's right to consent.

## Data Model

15 core models:

| Model | Purpose |
|---|---|
| `Account` | Login identity — a verified phone number, a connected Google/Apple account, or both (there is no password anywhere; see Authentication below). Type: `individual` or `parent`. |
| `OtpCode` | A single issued 6-digit code for phone verification: hashed, expiring, attempt-limited. |
| `Profile` | The matrimony profile shown in the feed. Type: `self` or `ward`. Status: `draft` (created by the onboarding wizard, invisible in feeds) → `active` → `paused`/`banned`. |
| `ProfileAccess` | Join table linking accounts to profiles they can manage (`owner` or `co_pilot` role). This is the IAM-style access layer. |
| `Denomination` | Lookup table (Catholic, Orthodox, Pentecostal, Baptist, etc.) for feed filtering — seeded, see `db/seeds.rb`. |
| `ProfilePhoto` | Ordered, reorderable photos on a profile, backed by ActiveStorage with an auto-generated thumbnail variant. |
| `ProfilePrompt` | Hinge-style question/answer pairs, drawn from a static question bank (`GET /prompt_questions`). |
| `Interest` | One-directional "like" from one profile to another. |
| `Match` | Created when two interests are mutual. Type: `direct` or `parent`. |
| `Introduction` | Created when two `parent`-type matches occur; tracks each ward's independent acceptance before creating a real ward-to-ward `Match`. |
| `Conversation` | Wraps a `Match` 1:1. |
| `Message` | A chat message; validates the sender actually has access to a profile in the conversation, and is marked read when the recipient fetches the thread. |
| `Verification` | Tracks verification attempts per account (phone/email OTP, government ID, selfie liveness, video KYC). Phone verification is created automatically on a successful OTP login. |
| `Vouch` | A third-party trust signal (e.g. a pastor vouching for a profile) that a profile owner requests. Doesn't gate anything. |
| `Subscription` | Freemium/premium billing plan. Enforces one active subscription per account. |

## Authentication

Token-based (JWT), not cookie/session-based, since this API serves clients directly (the Next.js frontend fronts it with its own httpOnly-cookie session — see `../web/README.md` — but the API itself only ever speaks Bearer tokens). There is no email/password login anywhere — every account is created via one of two proofs of identity:

- `POST /api/v1/auth/phone/start` — body `{ "phone": "9876543210" }`. Issues and sends a 6-digit OTP (5 min expiry, locks out after 5 failed attempts, 30s resend cooldown, capped at 5 sends/hour/phone). Never reveals whether an account already exists for that number.
- `POST /api/v1/auth/phone/verify` — body `{ "phone": "...", "code": "123456" }`. On success, finds or creates the account, marks the phone verified, and returns a token.
- `POST /api/v1/auth/google` / `POST /api/v1/auth/apple` — body `{ "id_token": "..." }`, the provider's own signed ID token from the client-side sign-in SDK. Verified server-side against `GOOGLE_CLIENT_ID`/`APPLE_CLIENT_IDS` (`app/services/oauth/`), then finds or creates the account by `(oauth_provider, oauth_uid)`. If the token's email isn't already claimed by another account, it's attached — but only opportunistically; a taken email never fails the sign-in. Google needs only one accepted audience since a native app passing `serverClientId: <web client id>` to `GoogleSignIn` produces a token whose `aud` is that same web client id; Apple needs the list (see `APPLE_CLIENT_IDS` above) because native `sign_in_with_apple` puts the app's bundle id in `aud` instead of the web Services ID.
- `GET /api/v1/me` — protected; returns the current account.

The three sign-in endpoints (phone verify, Google, Apple) all return the **same** envelope:

```jsonc
{
  "token": "<jwt>",
  "account": {
    "id": 1,
    "phone": "+919876543210",
    "email": "a@b.com",
    "account_type": "individual",
    "phone_verified_at": "2026-01-01T00:00:00Z"
  },
  "is_new_account": false,
  "onboarding": { "complete": false, "profile_id": null }
}
```

`GET /me` returns a **differently-shaped** response for the same account — the `account` fields flattened at the top level, no `token`/`is_new_account` (there's already a session):

```jsonc
{
  "id": 1,
  "email": "a@b.com",
  "phone": "+919876543210",
  "phone_verified_at": "2026-01-01T00:00:00Z",
  "account_type": "individual",
  "onboarding": { "complete": false, "profile_id": null }
}
```

A client has to handle both shapes rather than assume one "account object" — see the doc comment on `../mobile/lib/domain/models/account.dart`'s `Account` class for exactly how the Flutter client's model handles this split. `onboarding.complete` is `true` once the account owns at least one `status: "active"` profile — the frontend uses this to decide whether to route into the onboarding wizard or straight into the app.

Any controller can protect its actions with `before_action :authenticate_account!` (from `Api::V1::BaseController`), and access the logged-in account via `current_account`.

## API Endpoints

### Denominations & prompts (unauthenticated)
- `GET /api/v1/denominations` — `[{ id, name }]`
- `GET /api/v1/prompt_questions` — `["A faith habit I'd love to build together…", ...]`

### Profiles
- `GET /api/v1/profiles` — profiles the current account has access to
- `GET /api/v1/profiles/feed` — paginated (`?page=&per=`, max 25/page), filterable by `?city=`, `?denomination_id=`, `?gender=`, `?min_age=`, `?max_age=`; excludes your own profiles and anyone you've already sent an interest to. Returns `{ profiles: [...], next_page: number | null }`.
- `GET /api/v1/profiles/:id` — view a profile (includes `photos` and `prompts`)
- `POST /api/v1/profiles` — always created as `status: "draft"` regardless of what's sent; the owning account gets `ProfileAccess(role: "owner")` automatically
- `PATCH /api/v1/profiles/:id` — requires `ProfileAccess`; this is how a profile is activated (`{ "profile": { "status": "active" } }`)

### Photos
- `POST /api/v1/profiles/:profile_id/photos` — multipart, field `image`; requires `ProfileAccess`
- `DELETE /api/v1/profiles/:profile_id/photos/:id`
- `PATCH /api/v1/profiles/:profile_id/photos/reorder` — body `{ "order": [photo_id, photo_id, ...] }`, must include every photo id exactly once

### Prompts
- `GET/POST /api/v1/profiles/:profile_id/prompts`
- `PATCH/DELETE /api/v1/profiles/:profile_id/prompts/:id`

### Vouches
- `GET /api/v1/profiles/:profile_id/vouches`
- `POST /api/v1/profiles/:profile_id/vouches` — requires `ProfileAccess` on the target profile (only the owner can request a vouch on their own profile's behalf)

### Interests & Matches
- `GET /api/v1/interests?type=sent|received`
- `POST /api/v1/interests` — send interest from a profile you have access to; auto-detects mutual interest and creates a `Match`; if both profiles are parent-owned, also auto-creates an `Introduction`
- `GET /api/v1/matches` — list matches involving your profiles; each includes `my_profile_id` so the client doesn't have to work out which side is "me"

### Introductions
- `GET /api/v1/introductions`
- `POST /api/v1/introductions/:id/accept` — body: `{ "ward_profile_id": <id> }`
- `POST /api/v1/introductions/:id/decline` — same body shape
- A real `Match` between the two wards is only created once both have accepted

### Conversations & Messages
- `GET /api/v1/conversations` — includes `unread_count` per conversation
- `POST /api/v1/conversations` — body: `{ "match_id": <id> }`
- `GET /api/v1/conversations/:conversation_id/messages` — requires the requester to be a participant; marks unread messages as read as a side effect
- `POST /api/v1/conversations/:conversation_id/messages` — body: `{ "body": "..." }`

### Verifications
- `GET /api/v1/verifications`
- `POST /api/v1/verifications` — body: `{ "verification_type": "phone_otp" | "email_otp" | "government_id" | "selfie_liveness" | "video_kyc" }`

### Subscriptions
- `GET /api/v1/subscriptions`
- `POST /api/v1/subscriptions` — body: `{ "plan": "free" | "premium" | "family" }`

## Status

- Automated test suite (`bin/rails test`) covers models plus the phone-auth, OAuth, and messages-authorization controllers — 70 tests, all passing; Brakeman reports zero warnings.
- Verified manually end-to-end via curl: the full phone OTP flow including rate-limit and lockout behavior, the photo upload → thumbnail-variant → reorder pipeline, feed pagination and filters, and both authorization fixes below.
- Two access-control bugs fixed: `GET /conversations/:id/messages` used to return any conversation's messages to any authenticated account regardless of participation; `POST /profiles/:id/vouches` used to accept a vouch from any authenticated account for any profile. Both now check `ProfileAccess`/participation.

## Not Yet Built

- Real payment gateway integration for subscriptions (Razorpay planned)
- Real KYC vendor integration for verification (currently just tracks status)
- ActionCable real-time delivery for messages (currently the frontend polls; Solid Cable is configured and ready for this)
- The Rails API is not yet deployed anywhere — see the root README for current deployment status
