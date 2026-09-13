# Christimony — Web

The Next.js frontend for Christimony, a Hinge/Bumble-style matrimony platform for Christians. Talks to the Rails API in `../backend` over JSON.

**Note on Next.js version:** this project is on **Next.js 16**, which has real breaking changes from earlier versions (`middleware.ts` → `proxy.ts`, async `params`/`cookies()`/`headers()`, etc.). If you're working on this codebase, read `node_modules/next/dist/docs/` before assuming a pattern from an older version still applies — see `AGENTS.md`.

## Tech Stack

- **Framework:** Next.js 16 (App Router, Turbopack), React 19, TypeScript
- **Styling:** Tailwind CSS v4 (CSS-first config, no `tailwind.config.*`) + shadcn (`base-nova` style, on `@base-ui/react`, not Radix)
- **In-app animation:** [`motion`](https://motion.dev) (Framer Motion's successor) — swipe gestures, layout transitions, accordions
- **Marketing-page animation:** GSAP 3.15 (`ScrollTrigger`, `SplitText`) + [Lenis](https://lenis.darkroom.engineering) smooth scroll
- **Auth:** phone OTP or Google/Apple Sign-In (no email/password anywhere — see below), fronted by an httpOnly cookie session that this app's own route handlers proxy to the Rails API — no token ever reaches client JS

## Getting Started

The Rails API must be running first (see `../backend/README.md`; defaults to `http://localhost:3000`):

```bash
npm install
npm run dev   # http://localhost:3000 collides with Rails' default port — see below
```

By convention this project's dev server runs on **3001** locally (`PORT=3001 npm run dev`), matching the Rails CORS default — though since Phase 2 the browser no longer talks to Rails directly (see Architecture below), so CORS mostly only matters if you're hitting the Rails API directly (e.g. with curl) rather than through this app.

### Environment variables

`.env.local` (gitignored):

```bash
# Points at a non-default Rails API. Server-only (no NEXT_PUBLIC_ prefix)
# -- read by route handlers and Server Components, never inlined into
# client JS. On Vercel, set it for both Production and Preview.
API_BASE_URL=http://localhost:3000/api/v1

# Both optional and independent -- each sign-in button only renders when
# its client ID is set (see components/oauth-buttons.tsx). These ARE
# public identifiers (NEXT_PUBLIC_), safe to expose to client JS.
NEXT_PUBLIC_GOOGLE_CLIENT_ID=       # Web application OAuth client, from Google Cloud Console
NEXT_PUBLIC_APPLE_CLIENT_ID=        # Services ID, from the Apple Developer portal
NEXT_PUBLIC_APPLE_REDIRECT_URI=     # Must match a return URL registered under that Services ID
```

The matching Rails-side `GOOGLE_CLIENT_ID`/`APPLE_CLIENT_ID` (used to verify the ID token server-side) are documented in `../backend/README.md`.

## Architecture: cookie + BFF auth

The frontend does not hold a JWT in `localStorage` or any other place client JS can read. Instead:

1. `lib/session.ts` defines an httpOnly, `SameSite=Lax` cookie (`christimony_session`) that holds the raw Rails JWT.
2. `app/api/auth/session/route.ts` sets/clears that cookie — called right after a successful OTP verify or Google/Apple sign-in (`establishSession` in `lib/auth-context.tsx`, shared by both paths).
3. `app/api/bff/[...path]/route.ts` is a proxy: every client-side API call goes to same-origin `/api/bff/*`, which attaches the cookie's token as `Authorization: Bearer <token>` and forwards to Rails. A `401` from Rails clears the cookie automatically. This is also why the browser never needs Rails' CORS configuration — it only ever talks to itself.
4. `proxy.ts` (Next 16's renamed `middleware.ts`) redirects unauthenticated requests to app routes → `/login`, and authenticated requests to `/login`/`/verify`/`/signup` → `/discover`, entirely server-side (no client-side flash).
5. `(main)/layout.tsx` and `onboarding/layout.tsx` fetch the account **once**, server-side (`lib/server-api.ts`, which calls Rails directly — no BFF hop needed since it already has the cookie), and hydrate it into `AuthContext` via `components/hydrate-auth.tsx`. Every page under those layouts can just call `useAuth()` and trust the account is there — no more per-page `loading` + `redirect-if-missing` boilerplate.

`lib/api.ts` is the client-side fetch wrapper (always through `/api/bff`); `lib/server-api.ts` is the server-side one (direct to Rails). Both fail closed — a network error is treated as "not logged in" rather than crashing the page.

## Route map

```
app/
  page.tsx                    "/"        marketing landing page (static prerender)
  login/page.tsx               "/login"                phone number entry + Google/Apple buttons
  verify/page.tsx               "/verify"               6-digit OTP entry
  signup/page.tsx                "/signup"               same phone-first form as /login, signup-flavored copy
  onboarding/[step]/page.tsx    "/onboarding/:step"     11-step profile-creation wizard
  (main)/                                                the tabbed app shell (bottom nav), session-gated
    discover/                   "/discover"             swipeable card stack
    matches/                    "/matches"
    messages/, messages/[id]/    "/messages", "/messages/:id"
    introductions/               "/introductions"        parent/ward introduction flow
    profile/                     "/profile"              account hub
    profiles/new/, profiles/[id]/, profiles/[id]/edit/
    subscription/, verification/
  api/
    auth/session/route.ts        POST sets the session cookie, DELETE clears it
    bff/[...path]/route.ts       proxies every other API call to Rails
```

`app/login`, `app/signup`, and `app/verify` stay static (`○` in the build output) since they read no request-time API; everything under `(main)/` and `app/onboarding/` is dynamic (`ƒ`) since their layouts read the session cookie. `components/oauth-buttons.tsx` is the one client component both `/login` and `/signup` share for the Google/Apple flow: Google's own GSI script (`accounts.google.com/gsi/client`) renders its button into a ref div, Apple's popup flow (`appleid.auth.js`, `usePopup: true`) is triggered from a plain button — both post the resulting ID token to `POST /auth/google` or `/auth/apple` via `lib/oauth.ts`, then follow the same `establishSession` → onboarding-or-discover redirect as phone verify. Verify the static/dynamic split with `npm run build` after any auth-related change — the route table at the end of the build output is the source of truth.

## Design tokens

`app/globals.css` holds one `:root` with the brand palette (cream/forest-green/maroon/sand/ink), a fluid `clamp()` type scale, and a shared motion vocabulary (`--ease-out-expo`, `--ease-spring`, `--dur-fast/base/slow/slower`) that both `motion` and GSAP animations pull from, so in-app and marketing-page motion don't invent their own timing per component.

## Marketing page (`app/page.tsx`)

Composed from `components/marketing/`:

- `lenis-provider.tsx` — smooth scroll, synced to GSAP's `ScrollTrigger`
- `preloader.tsx` — wordmark + counter, once per browser session
- `site-header.tsx`, `site-footer.tsx`, `marquee.tsx`, `magnetic-link.tsx` — shared chrome
- `sections/*.tsx` — one file per section (hero, positioning, quote, how-it-works, family, faq, final-cta)

Notable choreography: a masked line-by-line headline reveal on the hero (GSAP `SplitText` + `mask: "lines"`), a word-by-word opacity scrub on the denomination quote, and a pinned horizontal scroll through the three "how it works" steps on desktop (`gsap.matchMedia("(min-width: 1024px)")` — mobile gets a plain vertical stack instead, and everything degrades to instant, un-animated final states under `prefers-reduced-motion: reduce`).

Hero and family images live in `public/images/` and are served through `next/image` (automatic AVIF/WebP + resizing on Vercel) rather than hotlinked from an external CDN.

**No Framer Motion on this route** (`motion` is still a dependency — the in-app screens use it, see Tech Stack above). It shipped ~146KB (~49KB gz) for effects that are all opacity/transform/max-height — things CSS already does natively — so the marketing route's in-view fades are a plain IntersectionObserver + CSS transition (`<Reveal>` in `components/marketing/shared.tsx`) instead. Lenis' smooth scroll is skipped entirely on coarse pointers (touch devices already get native scrolling from the platform) — see `lenis-provider.tsx`. If you're adding a new animated section here, follow this pattern rather than reaching for `motion`.

## Known gaps

- The Rails API isn't deployed yet, so phone login/onboarding only work when pointed at a local backend — see the root README.
- Matches/Messages/Introductions/Profile/Verification/Subscription have their original functional-but-plain styling; Discover and the marketing page were prioritized.
- No WebGL/3D on the marketing page — considered and deliberately dropped in favor of a smaller bundle and lower risk on low-end devices; the 2D GSAP choreography carries the "awwwards" feel on its own.
