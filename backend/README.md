# Christimony — Backend

A modern, Hinge/Bumble-style matrimony platform for Christians, with denomination-based filtering and a unique parent/ward account model that lets a parent manage a profile on behalf of their child while still requiring the child's independent consent before any real connection opens.

This is the Ruby on Rails API backend. It serves the web (Next.js) and mobile (Flutter) clients over a JSON API.

## Tech Stack

- **Backend:** Ruby on Rails 8.1 (API-only mode)
- **Database:** PostgreSQL
- **Cache:** Redis (via Valkey on Arch Linux)
- **Auth:** JWT (JSON Web Tokens), via the `jwt` gem
- **Password hashing:** bcrypt, via Rails' `has_secure_password`
- **Web frontend:** Next.js + React + TailwindCSS (separate repo/folder)
- **Mobile:** Flutter (separate repo/folder)

## Getting Started

```bash
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails server
```

Server runs on `http://localhost:3000`.

## Core Design Concept: Parent/Ward Accounts

The defining feature of this app: a parent can create and manage a profile on behalf of their child (a "ward"), similar to an IAM admin/user relationship. Critically, **when two parents' own profiles match, their wards are not automatically connected.** Instead, an `Introduction` is created, and each ward must independently accept before a real match (and conversation) opens between them. This preserves the parent's role as matchmaker while protecting the child's right to consent.

## Data Model

14 core models:

| Model | Purpose |
|---|---|
| `Account` | Login credential (email/phone + password). Type: `individual` or `parent`. |
| `Profile` | The matrimony profile shown in the feed. Type: `self` or `ward`. |
| `ProfileAccess` | Join table linking accounts to profiles they can manage (`owner` or `co_pilot` role). This is the IAM-style access layer. |
| `Denomination` | Lookup table (Catholic, Pentecostal, Orthodox, etc.) for feed filtering. |
| `ProfilePhoto` | Ordered photos on a profile. |
| `ProfilePrompt` | Hinge-style question/answer pairs. |
| `Interest` | One-directional "like" from one profile to another. |
| `Match` | Created when two interests are mutual. Type: `direct` or `parent`. |
| `Introduction` | Created when two `parent`-type matches occur; tracks each ward's independent acceptance before creating a real ward-to-ward `Match`. |
| `Conversation` | Wraps a `Match` 1:1. |
| `Message` | A chat message; validates the sender actually has access to a profile in the conversation. |
| `Verification` | Tracks verification attempts per account (ID, phone/email OTP, video KYC). |
| `Vouch` | Soft trust signal (e.g. a pastor vouching for a profile). Doesn't gate anything. |
| `Subscription` | Freemium/premium billing plan. Enforces one active subscription per account. |

Full ERD and field-level details are in `data_model.pdf` / `data_model.tex`.

## Authentication

Token-based (JWT), not cookie/session-based, since this API serves separate web and mobile clients.

- `POST /api/v1/signup` — create an account, returns a token
- `POST /api/v1/login` — authenticate with email/phone + password, returns a token
- `GET /api/v1/me` — protected route, returns the current account (requires `Authorization: Bearer <token>`)

Any controller can protect its actions with `before_action :authenticate_account!` (from `Api::V1::BaseController`), and access the logged-in account via `current_account`.

## API Endpoints

### Profiles
- `GET /api/v1/profiles` — list profiles the current account has access to
- `GET /api/v1/profiles/feed` — browse other active profiles (excludes your own), filterable by `?city=` and `?denomination_id=`
- `GET /api/v1/profiles/:id` — view a profile
- `POST /api/v1/profiles` — create a profile (creator automatically becomes `owner` via `ProfileAccess`)
- `PATCH /api/v1/profiles/:id` — update a profile (requires `ProfileAccess`)

### Vouches
- `GET /api/v1/profiles/:profile_id/vouches`
- `POST /api/v1/profiles/:profile_id/vouches` — no ownership check; anyone can vouch for any profile

### Interests & Matches
- `GET /api/v1/interests?type=sent|received`
- `POST /api/v1/interests` — send interest from a profile you have access to; auto-detects mutual interest and creates a `Match`; if both profiles are parent-owned, also auto-creates an `Introduction`
- `GET /api/v1/matches` — list matches involving your profiles

### Introductions
- `GET /api/v1/introductions`
- `POST /api/v1/introductions/:id/accept` — body: `{ "ward_profile_id": <id> }`
- `POST /api/v1/introductions/:id/decline` — same body shape
- A real `Match` between the two wards is only created once both have accepted

### Conversations & Messages
- `GET /api/v1/conversations`
- `POST /api/v1/conversations` — body: `{ "match_id": <id> }`
- `GET /api/v1/conversations/:conversation_id/messages`
- `POST /api/v1/conversations/:conversation_id/messages` — body: `{ "body": "..." }`

### Verifications
- `GET /api/v1/verifications`
- `POST /api/v1/verifications` — body: `{ "verification_type": "phone_otp" | "email_otp" | "government_id" | "selfie_liveness" | "video_kyc" }`

### Subscriptions
- `GET /api/v1/subscriptions`
- `POST /api/v1/subscriptions` — body: `{ "plan": "free" | "premium" | "family" }`

## Status

All models and endpoints above are built and manually verified end-to-end via curl, including:
- Full mutual-interest → match flow
- Full parent-match → introduction → sequential ward acceptance → ward match flow
- Message access control (rejecting senders with no profile access to a conversation)
- One-active-subscription-per-account enforcement
- Ownership-based authorization on profile updates (403 for non-owners)

## Not Yet Built

- Automated test suite (currently verified manually via console/curl)
- Real payment gateway integration for subscriptions (Razorpay planned)
- Real KYC vendor integration for verification (currently just tracks status)
- ActionCable real-time delivery for messages (currently request/response only)
- Rate limiting on interests sent