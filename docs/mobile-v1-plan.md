# Christimony Mobile — Flutter app plan (v1)

## Context

Christimony today is two deployables: `web/` (Next.js 16 marketing site + app) and `backend/`
(Rails 8.1 JSON API). The web app is already mobile-shaped — every app screen is a `max-w-md`
column with a fixed 5-tab bottom nav — but it's a browser app, the Rails API isn't deployed
anywhere, and there is no way to put the product in a tester's hand.

We want a **third deployable, `mobile/`**, a Flutter app shipping the full v1 product to Android
and iOS so real trials can start. It must carry the existing brand (warm cream, deep forest green,
maroon, Fraunces/Inter) and — unlike the web — must support **light and dark mode from day one**,
toggleable and system-following.

This is the build brief, written to be executed phase by phase.

---

## 1. Decisions

| Decision | Choice | Why |
|---|---|---|
| Framework | **Flutter** (Dart 3, stable) | The brand is custom-drawn — a serif display face, exact swipe physics, a bespoke card deck. Flutter renders its own pixels, so light/dark fidelity and gesture feel are fully controlled and identical across platforms. React Native buys nothing: the web's styling is Tailwind, which doesn't port either way. |
| API access | **Direct to Rails**, JWT in secure storage | The Next.js BFF is a pure pass-through (`/api/bff/X` → `/api/v1/X` is the identity function). Routing mobile traffic through Vercel would add a hop and couple app releases to web deploys. |
| Auth | Phone OTP **+ Google + Apple** | All three exist server-side. Apple Sign-In is mandatory for review once Google is offered (Guideline 4.8). |
| v1 scope | **Full product** | Core loop, messaging, parent/ward + introductions, verification & subscription. |
| Chat transport | **ActionCable in v1**, behind a transport interface | Ships complete on polling, flips to cable with one config flag — so Rails channel work never blocks the chat feature. |
| Backend work | **In scope, tracked as Phase 1** | Several mobile-blocking gaps (§6). Store-compliance items are non-negotiable. |
| API hosting | **User deploys**; Sonnet makes it deployable and documents it | Deployment needs accounts, billing, and secrets an agent can't create. |
| Dev target | **Android first** | Dev machine is Arch Linux; no Flutter or Android SDK installed yet (JDK 17 and `adb` are present). iOS is CI-only (§Phase 12). |
| Identity | bundle id **`app.christimony`**, display name **"Christimony"** | The product will be renamed later. The **display name changes freely**; the **bundle ID is permanent after first store upload** — but it's invisible to users, so keeping `app.christimony` through a rename is normal. Do not change it post-upload. |
| Dark theme | **Warm ink, lifted brand** | Preserves the warm cream/sand character by inverting into a warm near-black rather than a neutral charcoal. Values in §3.1. |
| State | **Riverpod 3** (not Bloc) | The app is a dependency cascade — token → Dio → repositories → 11 controllers. "Token changed, invalidate downstream" *is* the framework in Riverpod; in Bloc it's manual stream plumbing into every bloc. `AsyncValue` also gives loading/error/data free on ~15 fetch-and-render surfaces. |

---

## 2. Repository layout

Feature-first with **one shared data layer** — not clean-architecture-per-feature, which would
produce 11 near-identical repositories wrapping the same Dio. Features own only `application/`
(controllers) and `presentation/` (widgets).

```
mobile/
├── .fvmrc                      # pin Flutter (do NOT use the AUR package — it owns /opt as root)
├── analysis_options.yaml       # very_good_analysis + custom_lint (riverpod_lint)
├── config/{dev,staging,prod}.json   # --dart-define-from-file; committed, no secrets
├── assets/fonts/               # Fraunces + Inter, variable, bundled
├── lib/
│   ├── main.dart  bootstrap.dart        # binding, error zone, prefs preload, Firebase
│   ├── app/
│   │   ├── app.dart                     # MaterialApp.router + theme wiring
│   │   ├── router/{routes,redirect,router}.dart   # redirect.dart is PURE and unit-tested
│   │   └── shell/app_shell.dart         # StatefulShellRoute.indexedStack, 5 tabs
│   ├── core/
│   │   ├── config/app_config.dart       # String.fromEnvironment, const
│   │   ├── network/
│   │   │   ├── endpoints.dart           # path + method + ENVELOPE, one place
│   │   │   ├── api_exception.dart       # sealed
│   │   │   ├── error_mapper.dart        # 3 shapes + HTML — PURE, tested
│   │   │   ├── dio_provider.dart
│   │   │   └── interceptors/{auth,error,retry,logging}.dart
│   │   ├── realtime/{cable_protocol,cable_connection,cable_subscription}.dart
│   │   ├── storage/{auth_token_holder,secure_token_store,prefs}.dart
│   │   ├── push/  theme/  errors/  utils/
│   ├── domain/models/                   # freezed + json_serializable
│   ├── data/
│   │   ├── api/christimony_api.dart     # ONE typed method per endpoint; owns envelopes
│   │   └── repositories/*.dart
│   ├── features/{auth,onboarding,discover,matches,conversations,introductions,
│   │             profile,subscription,verification}/{application,presentation}/
│   └── ui/{atoms,molecules,layout}/     # design system; imports core/theme ONLY
├── test/{core,data,features,golden}/  integration_test/  android/  ios/
```

**Two rules, enforced by a CI grep (`tool/check_isolation.sh`):**
- No `features/<a>/` may import `features/<b>/`. Cross-feature needs go in `data/` or `ui/`.
- No `Dio` import outside `lib/core/network/`. This is what keeps the envelope hazard (§4.2) contained.

`ui/` may not import `features/` or `data/` at all — that keeps golden tests cheap.

---

## 3. Design system

Port the web's tokens exactly from `web/app/globals.css`. There is no dark palette there (the
`.dark` block was deliberately deleted in `a4f061c`), so the dark column is authored — derived by
mining the marketing page's dark sections, which already use `#E6B9A9` / `#F1C7B7` / `#EAD8CB` as
the brand's on-dark vocabulary.

### 3.1 Colour tokens

| Token | Light | Dark | Notes |
|---|---|---|---|
| `background` | `#FAF6EF` | `#14140F` | warm cream / warm ink |
| `foreground` | `#1B1B18` | `#F0EBE1` | |
| `card` | `#FFFFFF` | `#1F1E19` | |
| `cardForeground` | `#1B1B18` | `#F0EBE1` | |
| `popover` | `#FFFFFF` | `#262420` | dark popover sits one step above card |
| `primary` | `#24463B` | `#6F9C8A` | forest; **lifted on dark** — `#24463B` fails contrast there |
| `primaryForeground` | `#FAF6EF` | `#10201A` | note the inversion: dark text on the sage fill |
| `secondary` | `#E2DACB` | `#2E2A23` | sand / warm charcoal |
| `secondaryForeground` | `#1B1B18` | `#E8E0D2` | |
| `muted` | `#F1ECE1` | `#242118` | |
| `mutedForeground` | `#6B6459` | `#A39A8B` | 5.4:1 light, 6.6:1 dark |
| `accent` | `#7A2E2E` | `#C96A63` | maroon; lifted on dark |
| `accentForeground` | `#FAF6EF` | `#1B1B18` | |
| `destructive` | `#E7000B` | `#FF5A52` | light value is `oklch(0.577 0.245 27.325)` resolved |
| `destructiveForeground` | `#FAFAFA` | `#14140F` | |
| `border` / `input` | `#E2DACB` | `#353027` | |
| `ring` | `#24463B` | `#6F9C8A` | |
| `celebration` | `#24463B` | `#1B3A30` | match-overlay ground — **not** `primary` on dark, or the overlay flashes bright |
| `onCelebration` | `#FAF6EF` | `#EBE4D8` | |
| `peach` / `blush` | `#E6B9A9` / `#F1C7B7` | same | on-dark emphasis, unchanged |
| `scrim` | `rgba(0,0,0,.6)` | `rgba(0,0,0,.72)` | photo-delete chip, overlays |

Derived fills — compute with `Color.alphaBlend`, don't hardcode: `primary @10%` (active nav pill),
`primary @5%` (selected option card), `secondary @40%` (prompt/bio/education blocks),
`accent @10%` (interest-sent pill), `secondary @70%`/`@60%` (skeleton bars).

Contrast check on dark: primary 6.0:1, mutedForeground 6.6:1, accent 5.0:1 — all pass AA.

### 3.2 How to express it: `ThemeExtension`, plus a derived `ColorScheme`

Not raw `ColorScheme` alone — M3 has no slot for `muted`, `card`, or `ring`, so the designer's
token names would vanish and "change `muted-foreground`" becomes archaeology. Not a plain
`InheritedWidget` either — it sits outside `ThemeData`, so theme switches snap instead of lerping
and every widget test that pumps a bare `MaterialApp` throws.

`ChristimonyColors extends ThemeExtension<ChristimonyColors>` transcribes the table above **1:1 —
one line per token, no derivation, no opacity math**. That's what makes the handoff mechanical.
Then derive a `ColorScheme` from it so Material's own widgets (dialogs, `TextField` cursors,
`Switch`) are correct without per-widget overrides:

`background`→`surface`, `foreground`→`onSurface`, `card`→`surfaceContainerLowest`,
`primary`/`primaryForeground`→`primary`/`onPrimary`, `secondary`→`secondary`,
`accent`→`tertiary`, `muted`→`surfaceContainerHighest`, `mutedForeground`→`onSurfaceVariant`,
`border`→`outlineVariant`, `destructive`→`error`. (M3 deprecated `background`/`onBackground` —
use `surface`.)

Access via a one-line extension so call sites read like the CSS variables:
`extension ThemeX on BuildContext { ChristimonyColors get c => Theme.of(this).extension<ChristimonyColors>()!; }`
→ `Container(color: context.c.muted)`.

### 3.3 Typography

Bundle **variable** Fraunces and Inter in `assets/fonts/`. **Do not use `google_fonts`** — its
runtime fetch means a font-less first paint, a network dependency on the login screen, and
non-deterministic goldens.

For variable fonts set both `fontWeight` **and** an explicit `wght` axis (`fontWeight` alone isn't
reliably mapped across platforms), and track `opsz` with the rendered size to reproduce the web's
`font-optical-sizing: auto`:

```dart
TextStyle _display(double size, {int weight = 600}) => TextStyle(
  fontFamily: 'Fraunces', fontSize: size, height: 1.15, letterSpacing: -0.4,
  fontVariations: [FontVariation('wght', weight.toDouble()),
                   FontVariation('opsz', size.clamp(9, 144))],
);
```

Scale — the **mobile end** of the web's `clamp()` values:

| Role | Family | Size | Used for |
|---|---|---|---|
| `displayLarge` | Fraunces | 44 | reserved (marketing-scale) |
| `displayMedium` | Fraunces | 36 | **standard page H1** (`font-display text-4xl`) |
| `headlineLarge` | Fraunces | 28 | auth headlines, empty-state headlines |
| `headlineMedium` | Fraunces | 22 | profile name on card |
| `titleMedium` | Inter 500 | 16 | list row names |
| `bodyLarge` / `bodyMedium` | Inter 400 | 16 / 14 | body; chat bubbles, errors |
| `labelLarge` | Inter 500 | 14 | buttons |
| `labelSmall` | Inter 400 | 13 | captions |
| (nav) | Inter 400 | 11 | bottom-nav labels |

Fraunces is loaded at 400/500/600 only, normal style. Set `primaryTextTheme` too, so `AppBar`
inherits it.

### 3.4 Radii, spacing, motion

Radii resolve from `--radius: 12`. These are **non-default** — stock Tailwind `rounded-2xl` is 16,
here it's 21.6. Getting them right is most of the visual fidelity.

`sm 7.2 · md 9.6 · lg 12 · xl 16.8 · 2xl 21.6 · 3xl 26.4 · 4xl 31.2 · full = StadiumBorder`

Spacing base 4: `p-6`=24, `px-4`=16, `gap-4`=16.

```dart
const durFast = Duration(milliseconds: 150);      // micro
const durHover = Duration(milliseconds: 200);
const durStep = Duration(milliseconds: 250);      // wizard step
const durBase = Duration(milliseconds: 300);      // surfaces
const durProgress = Duration(milliseconds: 400);
const durReveal = Duration(milliseconds: 700);
const easeOutQuart = Cubic(0.25, 1.0, 0.5, 1.0);  // the workhorse
const easeOutExpo  = Cubic(0.16, 1.0, 0.3, 1.0);
const easeSpring   = Cubic(0.34, 1.56, 0.64, 1.0);
```

Honour `MediaQuery.disableAnimations` everywhere — the web handles reduced-motion thoroughly.

### 3.5 Component kit (`lib/ui/`)

The web has only four UI primitives; everything else is ad-hoc Tailwind repeated across pages.
Extract those repeated shapes into real components:

- **`CButton`** — `primary` (filled forest, pill), `secondary` (sand, pill), `outline`, `ghost`,
  `destructive`, `link`. Sizes `md` (h 44), `lg` (h 48). **Deliberate deviation:** shadcn base
  heights are 28–36px, but every call site already overrides to pills and native touch targets
  must be ≥ 48dp. Press feedback is a **1px downward nudge**, not a Material ripple — disable the
  default `InkWell` splash globally. Loading = text substitution ("Sending code…"), optionally a
  trailing 16px spinner.
- **`CTextField`** — three treatments: pill compound (with a `+91` prefix chip and 1px divider),
  large wizard field (h 56, r 21.6, 18pt), standard (h 48, r 12). Focus = 3px `ring @50%` halo.
  Wire real `errorText`/`errorBorder` — the web styles an invalid state but never applies it.
- **`CCard`** — r 21.6, 1px `border`, `card` fill, padding 24. Discover's card is the exception:
  r 26.4 + `shadow-sm`.
- **`SectionBlock`** — the `secondary @40%` r-21.6 block used for prompt / About / Education.
- **`OptionCard`** — onboarding selection; selected = `border: primary` + `fill: primary @5%`.
- **`CAvatar`** — 48px circle, falls back to the initial in Fraunces at `primary @30%` on `secondary`.
- **`EmptyState`** — dashed variant (r 21.6, dashed border, padding 48) and bare centred variant
  (Fraunces 24 + `mutedForeground` subline). Keep the copy voice: em-dashes, lowercase-casual,
  never "No data".
- **`Skeletons`** — every bar is a **pill** filled `secondary` (secondary text @70%, blocks @60%),
  pulsing 1→0.5→1 over 2s. Per-route skeletons mirroring each route's real layout.
- **`PhotoCarousel`** — 4:5, tap left/right thirds, swipe (50px threshold), progress dashes at top.
  **It must handle its own horizontal drags without the deck stealing them** (§Phase 6).
- **`AppBottomNav`** — 5 tabs (Discover/Compass, Matches/Heart, Messages/MessageCircle,
  Family/Users, Profile/User), icon 22, stroke 2.5 active / 1.75 inactive, label 11pt, active pill
  `primary @10%` r 21.6 sliding on a spring, 8px `accent` unread dot with a 2px `background` ring.
  Paint the background *through* the safe area; inset only the content.
- **`CSnack`** — the web has no toast. Invent one in-family: `foreground` ground, `background` text,
  r 21.6.

Icons: Lucide at stroke 1.75–2.0. The three bespoke marketing glyphs are landing-page only, out of scope.

**Deliverables:** a debug-only **Design Gallery** (`lib/dev/design_gallery.dart`) rendering every
component in every state with a light/dark switch — the Phase 2 review surface and the source for
goldens — plus `mobile/docs/design-tokens.md` holding the §3.1 table as the living source of truth,
and a `mobile/README.md` matching the depth of `web/README.md` and `backend/README.md`.

### 3.6 Theme mode

`ThemeMode.system` default, overridable from Settings (three-way System/Light/Dark segmented
control), persisted in `shared_preferences`. **Preload `SharedPreferences` in `bootstrap.dart` and
override the provider in `ProviderScope`** so the controller is synchronous — otherwise the first
frame flashes the wrong theme. Wrap the shell in `AnnotatedRegion<SystemUiOverlayStyle>` driven by
resolved brightness so the status bar and Android nav bar match (the mobile equivalent of the
themed-safe-area work in `2cd93d0`).

---

## 4. Technical architecture

### 4.1 Dependencies

Runtime: `flutter_riverpod` ^3 · `riverpod_annotation` ^3 · `go_router` ^17 · `dio` ^5.9 ·
`freezed_annotation` ^3 / `json_annotation` ^4.9 · `flutter_secure_storage` ^10 ·
`shared_preferences` ^2.5 · `cached_network_image` ^3.4 · `image_picker` ^1.2 ·
`flutter_image_compress` ^2.4 · `web_socket_channel` ^3 · `google_sign_in` ^7.2 ·
`sign_in_with_apple` ^7 · `firebase_core`/`firebase_messaging` · `flutter_local_notifications` ^19 ·
`app_links` ^6.1 · `intl` ^0.20 · `phone_numbers_parser` ^9 · `package_info_plus` ^8 · `uuid` ^4.5 ·
`collection` ^1.19.

Dev: `build_runner` · `freezed` · `json_serializable` · `riverpod_generator` · `custom_lint` +
`riverpod_lint` · `very_good_analysis` · `mocktail` · `http_mock_adapter` · `alchemist` ·
`patrol` · `flutter_launcher_icons` · `flutter_native_splash`.

**Hand-roll instead of depending:**
- **ActionCable client** — every Dart package on pub.dev is stale (2021-era, no backoff, no
  lifecycle). ~250 lines over `web_socket_channel`. Own it (§4.5).
- **Swipe deck** — `appinio_swiper`/`flutter_card_swiper` all break on the one thing that matters:
  a card whose photo carousel handles its own horizontal drags without the deck stealing them.
  ~200 lines of `GestureDetector` + `AnimationController` + `Transform`.
- **Retry, logging** — 40 and 30 lines respectively, and they need *our* rules.
- **Not `flutter_dotenv`** (ships the env file as an extractable bundle asset, forces async init),
  **not `get_it`** (Riverpod is the container), **not `equatable`** (freezed generates it),
  **not `connectivity_plus`** ("has an interface" ≠ "can reach Rails" — just handle the timeout).

### 4.2 Networking

Interceptor order `[Auth, Error, Retry, Logging]` — request in list order, **response/error in
reverse**, so Logging sees raw wire bytes first and Auth's 401 handler runs last, after
normalisation, and can pattern-match on the typed error.

**The envelope hazard, made unrepresentable.** `dio.patch('/profiles/1', data: {...})` compiles
fine and returns an HTML 400, because Rails does `params.require(:profile)`. Fix: the envelope
lives *next to the path*, so you can't see one without the other.

```dart
enum Envelope { none, profile, prompt }

abstract final class Api {
  static const updateProfile = Endpoint('PATCH', '/profiles/{id}', envelope: Envelope.profile);
  static const createPrompt  = Endpoint('POST', '/profiles/{pid}/prompts', envelope: Envelope.prompt);
  static const createVouch   = Endpoint('POST', '/profiles/{pid}/vouches');   // FLAT
  static const sendMessage   = Endpoint('POST', '/conversations/{cid}/messages'); // FLAT
  static const reorderPhotos = Endpoint('PATCH','/profiles/{pid}/photos/reorder'); // FLAT {order:[]}
  // ...
}
```

One low-level `_send` applies it mechanically (`switch (ep.envelope) { none => fields,
profile => {'profile': fields}, prompt => {'prompt': fields} }`). `ChristimonyApi` exposes one
typed method per endpoint; repositories only call `ChristimonyApi`; the CI grep forbids `Dio`
elsewhere. Covered by an `http_mock_adapter` test asserting the **literal outgoing body**.

**`ApiException`, one sealed type from three-and-a-half shapes:** `NetworkFailure` ·
`Unauthorized` · `Forbidden` · `NotFound` · `ValidationFailed(List<String>)` · `RequestRejected` ·
`RateLimited` · `ServerFailure` · `Unexpected`.

`error_mapper.dart` is a **pure function with no Dio types in its signature**:

```dart
ApiException mapError(int? status, Object? data, {Object? cause}) {
  if (status == null) return const NetworkFailure();
  // Raw HTML (ParameterMissing 400, unhandled 500): Rails sends text/html,
  // so dio hands us a String, not a Map. THIS GUARD IS LOAD-BEARING —
  // without it, data['error'] throws _TypeError inside the interceptor and
  // surfaces as an unhandled async error, not an API error.
  if (data is! Map) return ServerFailure(status, raw: data is String ? data : null);
  final errors = data['errors'];
  if (errors is List) return ValidationFailed(errors.map((e) => '$e').toList(), status);
  final msg = data['error'] is String ? data['error'] as String : null;
  return switch (status) {
    401 => Unauthorized(msg ?? 'Your session has expired.'),
    403 => Forbidden(msg ?? 'You do not have access to that.'),
    404 => NotFound(msg ?? 'Not found.'),
    429 => RateLimited(msg ?? 'Too many requests. Try again shortly.'),
    >= 500 => ServerFailure(status),
    _ => RequestRejected(msg ?? 'That did not work.', status),
  };
}
```

`ServerFailure`/`Unexpected` must **never** show the raw payload to a user — Rails' HTML 500 page
contains stack traces. `core/errors/error_presenter.dart` is the only place that produces
user-facing copy.

**Breaking the Dio ↔ auth cycle.** Dio needs a token; the session controller needs Dio. Use a
mutable holder that is *not* a provider dependency:

```dart
class AuthTokenHolder { String? token; void Function()? onUnauthenticated; }
```

`dioProvider` watches only the holder (stable identity), so **Dio is constructed exactly once for
the app's lifetime** — otherwise every login/logout orphans in-flight requests and their
`CancelToken`s. `AuthInterceptor.onRequest` attaches `Bearer` unless the path is public
(`/auth/phone/start|verify`, `/auth/google`, `/auth/apple`). On a normalised `Unauthorized` it
calls `holder.onUnauthenticated` **once** (guarded by a `_loggingOut` flag), which wipes storage
and sets `Unauthenticated`. **No navigation call anywhere** — go_router's `refreshListenable` fires
and the guard walks the user to `/login`. One authority for "where should this user be", same
reason the web does a hard navigation.

**Refresh:** build the single-flight machinery now, stub the endpoint. Use `QueuedInterceptor`, not
plain `Interceptor` — it serialises error handlers, so ten concurrent 401s produce one refresh
attempt and nine awaiting retries. Gate on `AppConfig.refreshEnabled` so flipping it on is one line
once Rails ships `/auth/refresh`.

**Retry** only when `NetworkFailure` or `status >= 500`, **and** method is `GET`, **and**
attempt < 2. Backoff 400ms → 1200ms with ±25% jitter. **Never retry a `FormData` body** — the
multipart stream is single-read and a retry sends an empty body. Never auto-retry 429; the OTP
screen owns that cooldown using `retry_after: 30` from the response body (Rails sends no
`Retry-After` header).

**Multipart.** Compress client-side, always — Rails validates neither content-type nor size, and
`photo_thumb_url` runs ImageMagick inline in the serializer. `FlutterImageCompress` at
`minWidth/minHeight 1600, quality 82, format: jpeg` turns a 12MB iPhone HEIC into ~350KB, i.e. a
40-second upload on Indian 4G into two seconds. **JPEG, not HEIC** — Rails' variant pipeline needs
`libheif` in the image and the Dockerfile may not have it. Photo upload gets its own 60s
`receiveTimeout` and a `CancelToken` bound to the screen's `ref.onDispose`.

### 4.3 State management

```
appConfigProvider ─────────────┐
authTokenHolderProvider ───────┼─► dioProvider ─► christimonyApiProvider ─► *Repository
secureTokenStoreProvider ──────┘                                                │
        └──────────────► sessionControllerProvider (AsyncNotifier<Session>) ◄────┘
                                   ├─► routerProvider
                                   ├─► cableConnectionProvider
                                   └─► pushRegistrationProvider
```

`sealed class Session`: `SessionLoading` · `Unauthenticated` · `Authenticated(token, account)`.

`SessionController.build()`: read token → null ⇒ `Unauthenticated`; else push into the holder,
wire `onUnauthenticated`, `GET /me`. On `Unauthorized` wipe and log out. **On `NetworkFailure`,
stay `Authenticated` using the `Account` cached in prefs** — a flaky network must never log people
out. `refreshAccount()` after the wizard activates a profile, because `onboarding.complete` is
server-derived and the router guard reads it. `logout()` is **local only** — there is no revocation
endpoint; say so in a code comment so nobody assumes the server was told.

**Router guard as a pure function** (`app/router/redirect.dart`, zero Flutter imports, unit-tested
as a truth table — 3 session states × 6 locations ≈ 18 assertions):

```dart
String? resolveRedirect(Session s, String loc) {
  final isAuthRoute = loc == Routes.login || loc == Routes.otp;
  final isOnboarding = loc.startsWith(Routes.onboarding);
  switch (s) {
    case SessionLoading():  return loc == Routes.splash ? null : Routes.splash;
    case Unauthenticated(): return isAuthRoute ? null
                             : '${Routes.login}?next=${Uri.encodeComponent(loc)}';
    case Authenticated(:final account):
      if (loc == Routes.splash) {
        return account.onboarding.complete ? Routes.discover : Routes.onboardingFirstStep;
      }
      if (!account.onboarding.complete) return isOnboarding ? null : Routes.onboardingFirstStep;
      if (isAuthRoute || isOnboarding) return Routes.discover;
      return null;
  }
}
```

This is `web/proxy.ts` plus the branch the web guard can't do (it only checks cookie *presence*).
Wire it with `refreshListenable` fed by `ref.listen(sessionControllerProvider, …)`.

Use `StatefulShellRoute.indexedStack` for the 5 tabs, so pushing a chat thread inside Messages,
switching to Discover, and coming back preserves the thread and its scroll position.

**Deck** (`DeckState`: `queue`, `seenIds`, `passedIds`, `nextPage`, `loadingMore`, `exhausted`,
`actingProfileId`, `filters`). Prefetch when `queue.length < 5`. `ref.keepAlive()` — losing your
place in the queue every time you check Messages is the most annoying possible bug here.

**Chat — one controller, two transports.** `abstract interface class ChatTransport { Stream<Message>
messages(int conversationId); }` with `CableChatTransport` and `PollingChatTransport` (5s, matching
the web). `chatTransportProvider` picks by `AppConfig.cableEnabled`. **This is what stops the Rails
channel work from blocking the chat feature.**

`ChatController extends AutoDisposeFamilyAsyncNotifier<ChatState, int>`; `ChatState` holds
`messages` (ascending by `sentAt, id`), `outbox` (`PendingMessage(clientToken, body, failed)`), and
`live`. Every inbound message goes through one **pure** `upsert(sorted, m)` that dedupes on server
id and binary-inserts — so a cable echo racing the POST response is safe in either order. The
outbox is a **separate list**, not entries spliced into `messages`, because Rails doesn't echo a
client token and fuzzy body+timestamp matching is a bug factory.

**Onboarding draft** mirrors `web/lib/onboarding.ts` field-for-field. Persist to
`SharedPreferences`, not secure storage and not a session-scoped store — the web uses
`sessionStorage` because a browser tab *is* the session, but a mobile app gets killed mid-wizard
and must resume days later. Debounce writes at 300ms. `dob` stays a `'YYYY-MM-DD'` **string**, never
a `DateTime` — see §4.6.

### 4.4 Offline and caching

**No local database in v1.** Not drift, not isar. The API offers nothing to sync against: no
ETags, no `If-Modified-Since`, no cursors, and **no `updated_at` in any serialized payload**. A
local DB is only worth its weight with incremental sync; without a change feed you'd write a
full-replace-on-fetch cache — a strictly worse in-memory cache that also has migrations and a new
class of stale-data bugs.

- **Disk** (`cached_network_image`, `stalePeriod: 14d`, `maxNrOfCacheObjects: 400`): all photos.
  ~95% of the perceived offline win, because photos are ~99% of the bytes. ActiveStorage's signed
  redirect URLs are stable and permanent, so they're excellent cache keys.
- **Prefs** (small, JSON): `auth_account` (last-known, so a cold start on a flaky network renders
  the shell instead of bouncing to login), `onboarding_draft`, `passed_profile_ids`, `theme_mode`,
  `feed_filters`, and `denominations`/`prompt_questions` (tiny, effectively immutable, on the
  onboarding cold-start critical path — serve instantly, revalidate in background).
- **Secure storage:** the JWT. Nothing else.
- **In-memory only:** profiles, feed, matches, introductions, conversations, messages. All
  authorization-scoped, cheap to refetch, and a privacy liability if persisted on a shared device.
- **On logout:** clear secure storage, clear every prefs key except `theme_mode`, `ref.invalidate`
  the graph, **and `CacheManager.emptyCache()`** — otherwise the next user sees the previous user's
  match photos.

Revisit when Rails ships message pagination and a cursor; the first justified drift table is
`messages`.

### 4.5 ActionCable client

`cable_protocol.dart` is pure and fully unit-tested; `cable_connection.dart` owns the socket.

Wire format: S→C `welcome` / `ping` (every 3s) / `confirm_subscription` / `reject_subscription` /
`disconnect{reason, reconnect}` / `{identifier, message}`; C→S
`{command: subscribe|unsubscribe|message, identifier, data?}`.

**The identifier gotcha:** `identifier` is a JSON *string* and Rails echoes the exact byte sequence
back as the routing key. Build it once with canonically sorted keys
(`jsonEncode(SplayTreeMap.from(params))`), store it on the subscription object, and never rebuild
it ad hoc at the unsubscribe site.

**Auth: query param `wss://host/cable?token=<jwt>`.** `IOWebSocketChannel` *can* send headers, but
(1) `HtmlWebSocketChannel` can't — the browser WebSocket API has no header API — so a header-based
client can never run under a test harness that uses it; (2) the platform-agnostic
`WebSocketChannel.connect` doesn't expose headers at all, so you'd fork on `dart:io`; (3) Rails'
side is `request.params[:token]`, one line. The cost is the JWT in access logs — mitigate with
log scrubbing now, and properly later with a **cable ticket** (`POST /cable/ticket` →
`{ticket, expires_in: 60}`, single-use). Route token acquisition through a
`Future<String> Function() tokenProvider` so that swap is one line.

- **Backoff** `min(30s, 500ms · 2^attempt)` with ±30% jitter, reset on `welcome`. Jitter matters:
  without it a Rails restart reconnects every client in the same 500ms and you re-DDoS yourself.
- **Heartbeat watchdog** — a 3s timer checking `now - lastPing > 6s` (two missed pings); if stale,
  close and reconnect. TCP on mobile dies silently constantly; without this the socket looks open
  for minutes while delivering nothing. Rails' own JS client uses exactly this heuristic.
- **Resubscribe on reconnect**, then each subscription's `onConfirmed` fires a REST reconciliation
  fetch folded through `upsert` — so gaps close and duplicates are impossible.
- **`disconnect` with `reason: "unauthorized"`** ⇒ do not reconnect; call the same
  `onUnauthenticated` hook the HTTP interceptor uses. With a 30-day token and no refresh, this
  *will* happen in production.
- **Lifecycle** via `AppLifecycleListener`: close on `paused`/`detached` (iOS suspends and kills a
  held socket anyway; holding it drains Android battery), reconnect + resubscribe + reconcile on
  `resumed`. Don't try to keep it alive in the background — that's what push is for.

**Two channels, not N.** `AccountChannel` for the whole session (new match, new introduction,
new-message-anywhere → live badge updates without polling) and `ConversationChannel(id)` only while
a chat screen is mounted, unsubscribed in `ref.onDispose`. Broadcast from `Message
after_create_commit`, not the controller, so delivery matches what actually persisted.

### 4.6 API contract gotchas

Base `<API_BASE_URL>/api/v1`, `Authorization: Bearer`. `web/lib/*.ts` is a reliable reference for
every call shape (the BFF is the identity function).

1. **Three error shapes**, one of which is HTML — see §4.2. The `data is! Map` guard is load-bearing.
2. **Inconsistent bodies:** nested for `profiles`/`prompts`, flat for everything else, multipart
   (field `image`) for photo create. Solved by §4.2's `Endpoint`.
3. **Only `/profiles/feed` paginates.** Everything else is an unbounded bare array — including the
   whole message thread.
4. **The feed's exclusion set mutates as you swipe.** `already_interested_ids` is rebuilt per
   request, then `.order(:id).offset((page-1)*per)` is applied. Every like shrinks the result set,
   so page 2 **silently skips as many profiles as you liked on page 1**. Client-side `seenIds`
   dedupe stops duplicate *cards* but cannot recover the skipped profiles. Real fix is keyset
   pagination (`?after_id=`) — on the Rails list.
5. **`GET /conversations/:id/messages` mutates read state.** Only a foreground, visible chat screen
   may call it — never a badge computation, background refresh, or prefetch. Comment it on the
   repository method and make `ChatController` the only caller.
6. **`sender_account_id` is an Account id, not a Profile id.** Compare against `/me`'s `id`.
7. **A mutual match does not create a conversation.** `check_for_mutual_match` creates only the
   `Match`; the client must follow with `POST /conversations {match_id}` (idempotent, but returns
   201 even when it already existed).
8. **`Introduction#accept!` is not idempotent** — `advance_status` falls through the `case` when
   already `accepted`, then line 40 runs `create_ward_match!` again, **creating a duplicate Match
   every time**. Accepting from the wrong side is a silent 200 no-op. Guard in the UI *and* fix in
   Rails. `decline!` is terminal for both wards with no reopen path — gate it behind a confirmation.
9. **`profile_summary.cover_photo_url` is nullable.** Every list, match card, and chat header needs
   an initials fallback, not a broken-image box.
10. **`dob` is a bare civil date** (`"1998-04-02"`). Parse as a civil date and **never `.toLocal()`**
    — a UTC→IST conversion shifts birthdays by a day. Everything else (`sent_at`, `matched_at`,
    `verified_at`) is a UTC instant and *should* be localised. Two differently-named helpers in
    `core/utils/dates.dart` so they can't be confused.
11. **Prompts are keyed by question text**, not an id — editing wording server-side orphans answers.
12. **Photo URLs are signed 302 redirects**, permanent and unauthenticated; follow redirects, cache
    freely. But note `rails_blob_url(host: request.base_url)` — a device hitting `192.168.x.x` gets
    photo URLs on `192.168.x.x`, which break the moment anyone tests from elsewhere.
13. **JWT is 30 days, HS256, no refresh, no revocation.** Every screen must survive a sudden
    `Unauthorized` — including the photo uploader and the cable connection.

Model every enum as a Dart enum **with an `unknown` fallback** — never crash on an unrecognised
string: `account_type` `individual|parent`; `profile_type` `self|ward`; `status`
`draft|active|paused|banned`; `gender` `male|female`; `interest.status`
`pending|accepted|declined`; `match_type` `direct|parent`; `introduction.status`
`pending_both|pending_a|pending_b|accepted|declined`; `verification_type`
`government_id|selfie_liveness|phone_otp|email_otp|video_kyc`; `verification.status`
`pending|verified|rejected`; `subscription.plan` `free|premium|family`; `subscription.status`
`active|expired|cancelled`; `voucher_role` `pastor|elder|family_friend|other`.

Denominations and prompt questions are **fetched**, not hardcoded.

---

## 5. Phased roadmap

### Phase 0 — Toolchain and scaffold
- Flutter via **FVM or a plain tarball to `~/.local/share/flutter`** — *not* the AUR package, which
  owns `/opt/flutter` as root and fights `flutter upgrade` and the pub cache. Android SDK via the
  standalone `cmdline-tools` zip to `~/Android/Sdk`, then `sdkmanager platform-tools
  "platforms;android-36" "build-tools;36.0.0"`; `flutter doctor --android-licenses`. Emulator image
  + `kvm` group, or a physical device over the already-installed `adb`.
- `flutter create --org app --project-name christimony --platforms=android,ios mobile`
  → package `christimony`, applicationId / bundle id **`app.christimony`**.
- Strict `analysis_options.yaml`; `tool/check_isolation.sh`; `mobile/` in the root `.gitignore`;
  a `mobile/` row in the root README's structure table.
- Three flavors with **distinct application ids so all three install side by side**:
  `app.christimony.dev` / `.staging` / `app.christimony`. `--dart-define-from-file config/<flavor>.json`.
  Assert `apiBaseUrl.isNotEmpty` in `bootstrap.dart` — fail loudly, not at first request.
- CI: analyze + format + codegen-diff + test + debug APK on `ubuntu-latest`.
- **Done when:** `flutter analyze` is clean and a debug APK launches on the emulator.

### Phase 1 — Rails enablement *(blocks most of what follows)*

**1a — blocking mobile development**
- **Deploy the API — the user does this.** Sonnet makes it deployable and documents it: verify the
  Dockerfile, write `docs/deploy.md`, and produce the full env-var manifest (`SECRET_KEY_BASE`,
  `BACKEND_DATABASE_PASSWORD`, S3/R2 keys, `SMS_PROVIDER` + Twilio/MSG91 keys,
  `GOOGLE_CLIENT_IDS`, `APPLE_CLIENT_IDS`, `CORS_ORIGINS`).
  **Deploy gotcha:** `config/database.yml`'s production block defines **four** databases —
  `primary`, `cache`, `queue`, `cable` (`backend_production{,_cache,_queue,_cable}`) — using
  `username: backend` + `BACKEND_DATABASE_PASSWORD`, *not* a single `DATABASE_URL`. On Fly/Railway,
  which hand you one `DATABASE_URL`, you must either create the three extra databases or collapse
  the config. This will fail at boot otherwise. `db:prepare` loads `db/{cable,cache,queue}_schema.rb`.
  Until the host is live, dev runs against `http://10.0.2.2:3000` (emulator host loopback) or a LAN
  IP with `config.hosts <<`, cleartext-traffic scoped to the **dev flavor only**.
- **JSON errors everywhere.** `rescue_from ActiveRecord::RecordNotFound`,
  `ActionController::ParameterMissing`, `ActiveRecord::RecordInvalid` in `base_controller.rb`.
  Today these render HTML.
- **`APPLE_CLIENT_IDS` as a list — this is a hard release blocker (§6).**
- **Token refresh + logout.** `POST /auth/refresh`, `DELETE /auth/session` (unregisters the push
  token). Add a `jti` denylist alongside, so "log out" can mean something.
- **Pass/skip.** A left-swipe records nothing today, so passed profiles reappear. Add
  `profile_passes` + `POST /passes` + `DELETE /passes/:id` (undo), excluded in `#feed`.
- **Keyset pagination for the feed** (`?after_id=`), replacing offset — see §4.6.4.
- **Message pagination + explicit read.** `GET …/messages?before_id=&limit=` (default 30) and
  `POST …/read`. Decouple "read" from "fetch".
- **ActionCable.** `app/channels/` does not exist at all. Add `ApplicationCable::Connection`
  reading `request.params[:token]`, `ConversationChannel` + `AccountChannel` authorised with the
  same `my_profile_ids & [profile_a_id, profile_b_id]` check `MessagesController` uses, a `Message
  after_create_commit` broadcast, and **`config.action_cable.disable_request_forgery_protection =
  true`** — a Dart `IOWebSocketChannel` sends no `Origin` header and Rails rejects a nil origin.
  Safe here because auth is a bearer token in the URL, not a cookie: no ambient authority for CSRF
  to steal. The line is already sitting commented out in `config/environments/development.rb:71`.
- **Introduction idempotency fix** — see §4.6.8.
- **Move thumbnail generation off the request.** `photo_thumb_url`
  (`concerns/profile_serialization.rb:75`) calls `.variant(resize_to_limit: [600,750]).processed`
  **inline**. A feed page is up to 25 profiles × 6 photos = 150 ImageMagick runs in one request.
  Pre-generate in a Solid Queue job on upload, or drop `.processed` and let ActiveStorage generate
  lazily on first GET.
- **Fix the N+1s.** `#feed` has no `includes` — add
  `.includes(:denomination, :profile_prompts, profile_photos: { image_attachment: :blob })`.
  `ConversationsController#index` is the same (a `last_message` and an `unread_count` query per row)
  and the app polls it for the unread badge.

**1b — required before store submission**
- **Block & report** + exclusion from feed/matches/conversations. App Store Guideline 1.2 requires
  this for user-generated content; review will reject without it.
- **Account deletion** `DELETE /api/v1/me` (Guideline 5.1.1(v)). **No model has
  `dependent: :destroy`**, so this needs explicit cascade/nullify or it hits FK constraints.
- **Close the profile-enumeration hole.** `ProfilesController#show` has no authorization beyond
  "is authenticated" — any account can read **any** profile by id, including `draft`, `paused`, and
  `banned`, and ids are sequential. `ProfilePromptsController#index` and `VouchesController#index`
  are the same. This matters more on mobile: a shipped binary makes the API trivially scriptable.
- **Push.** `devices` table, `POST`/`DELETE /api/v1/devices`, an FCM service, and Solid Queue jobs
  for interest received / new match / new message / introduction created / introduction resolved.
  There are currently **zero** background jobs and no notification system of any kind.
- **Rate limiting.** The only throttle in the whole API is the hand-rolled OTP limit (5/hour/phone,
  30s resend). Add `rack-attack`. Also cap `Message#body` length and validate photo content-type
  and size — neither exists today.
- Optional but cheap: `GET /api/v1/config` with a minimum supported build, so a bad release can be
  force-upgraded.

### Phase 2 — Design system
Everything in §3: tokens both modes, typography, radii, motion, the component kit, theme-mode
persistence, and the Design Gallery. Goldens for every component in **both** themes.
- **Done when:** the gallery renders all components light and dark, and goldens pass in CI.

### Phase 3 — Core plumbing
Freezed models; Dio + interceptors; `ApiException` + `error_mapper`; `endpoints.dart`; secure
storage; `SessionController`; `go_router` with `resolveRedirect`.
- **Done when:** repository unit tests pass against a mocked client, including all three error
  shapes and a **real captured Rails HTML 400** from `params.require(:profile)`.

### Phase 4 — Auth
Login (pill `+91` field, 10-digit validation via `phone_numbers_parser` matching Rails'
`Phonelib.parse(phone, "IN")`), OTP screen (6 boxes, auto-advance, backspace-back, paste-fills-all,
auto-submit on the 6th digit, shake + clear on failure, 30s cooldown from `retry_after`,
`autofill: oneTimeCode`), Google, Apple, session restore, silent refresh.
Reference: `web/app/login/page.tsx`, `web/app/verify/page.tsx`, `web/components/oauth-buttons.tsx`.

**Google is not blocked on Rails** if written correctly: pass `serverClientId: <the existing web
client id>` to `GoogleSignIn` and the ID token's `aud` stays the value `GOOGLE_CLIENT_ID` already
holds. iOS additionally needs the iOS OAuth client's reversed id in `CFBundleURLTypes` — a
client-side config item.

**Testing caveat:** `dev_code` is returned **only when `Rails.env.development?`**, so a deployed
staging server needs a real SMS provider or a staging-only allowlist of test numbers with a fixed
code. Decide before Phase 4 or device testing stalls. Server error copy is already user-ready
(`"That code isn't right. Try again."`) — display it verbatim.
- **Done when:** all three methods complete on a device and survive an app restart.

### Phase 5 — Onboarding wizard
The 11 steps in order: `account-type · name · dob · gender · denomination · city · education ·
photos · prompts · bio · review`. Port `web/lib/onboarding.ts` and
`web/app/onboarding/[step]/page.tsx` exactly, including:
- profile **created on leaving `education`** (`MIN_PHOTOS = 2`, `REQUIRED_PROMPTS = 3` are the web's
  constants), prompts POSTed on leaving `prompts`, bio PATCHed on leaving `bio`, `review` PATCHes
  `status: "active"` — then `refreshAccount()` so the router guard releases the user;
- draft resumable across an OS kill, holding `profileId` so resuming can't duplicate profiles;
- validation: name non-empty; DOB 18+ ("You must be 18 or older to join Christimony."); gender
  required; denomination optional; city non-empty; ≥2 photos; exactly 3 prompts, all answered;
- chrome: sticky back chevron + progress bar (h 6, pill, `secondary` track, `primary` fill, 400ms
  easeOut), step transition slide+fade (±24px, 250ms easeOut).
- **Fix a web bug while porting:** the `account-type` answer is never sent anywhere. Send it.
- **Prompt for a ward profile when `account_type == "parent"`** — see the Phase 8 trap.
- **Done when:** a fresh phone number reaches an active, discoverable profile.

### Phase 6 — Discover
Deck ported precisely from `web/components/swipe-card.tsx`: `THRESHOLD 120px · FLING_VELOCITY
600px/s · EXIT_DISTANCE 500px · rotation ±16° over x ∈ [-300,300] · dragElastic 0.6 · exit 250ms
easeOut then callback at 180ms · snap-back spring (stiffness 320, damping 26)`. LIKE stamp
top-left −12° fading in over x ∈ [24,140]; PASS top-right +12° over x ∈ [−140,−24]. Next card behind
at `scale 0.96, translateY 2, opacity 0.7`. Frame `70vh, min 460, max 640`. Card content: 4:5
carousel, name + age, `city · denomination · profession`, then first prompt / About / Education as
`SectionBlock`s, scrolling **inside** the card.

**The gesture conflict is the hard part:** the photo carousel must consume its own horizontal drags
without the deck stealing them. This is what every off-the-shelf swiper package gets wrong, and
why the deck is hand-rolled.

Plus: acting-as profile selector when the account owns >1 profile; the **full** filter set (city,
denomination, gender, age range — the web wired only city); `next_page` prefetch when the queue
runs low (the web ignores pagination and stops after 25); like → `POST /interests`, and on a
non-null `match`, `POST /conversations` then the celebration sheet with a "Say hello" CTA;
**pass → `POST /passes`** with a persisted `passedIds` LRU set as the interim client-side
mitigation; single-step undo.

**The feed applies no gender preference of its own** — it returns everyone unless the client passes
`gender`. Default the filter to the opposite gender of the acting profile, or the deck shows
same-gender profiles from the first swipe.
- **Done when:** swiping works, matches fire, and passed profiles don't return after a restart.

### Phase 7 — Matches, Messages, realtime
Matches list (48px avatar, name, `city · Matched <date>`, Message → `POST /conversations` → thread).
Inbox with unread dots and last-message preview. Thread with a real header (avatar + name — the web
has none), paginated history, r-21.6 bubbles with the tail corner dropped to 7.2 (`primary` right /
`secondary` left), day separators and timestamps (the web shows neither), read receipts.

Realtime per §4.5, behind `ChatTransport` so this phase ships complete on polling and flips to
cable with one config value.
- **Done when:** two emulators exchange messages live, and killing the socket mid-conversation
  recovers with no duplicate or missing messages.

### Phase 8 — Family (introductions) and the parent/ward model
Status vocabulary verbatim from `web/app/(main)/introductions/page.tsx`: `accepted` → "Both
accepted — check Matches"; `declined` → "Declined"; `pending_both` → "Awaiting a response from both
sides"; `pending_a`/`pending_b` → "Waiting on you" or "Waiting on the other family". Accept/decline
post `{ward_profile_id}`; disable once resolved; confirm before declining (terminal, no reopen).
Header copy verbatim: *"When you and another parent both express interest, your children are
introduced here — nothing opens between them until they each say yes."*

**A silent-failure trap to design around:** `create_introduction_if_parent_match` does
`return unless ward_a && ward_b` — if either parent has no `ward`-type profile, the parent match is
created but **no introduction ever appears**, with no error anywhere. Make a missing ward profile
impossible to miss: prompt during onboarding for parent accounts, and show a persistent banner on
the Family tab while no ward exists.
- **Done when:** two parent accounts match, both accept, and a ward-to-ward match appears in the
  wards' Matches.

### Phase 9 — Profile, settings, and the rest
Profile hub (own profiles with draft badges, Account section). Profile create. Profile edit: photo
grid (max 6, min 2 to activate) **plus drag-to-reorder** — the endpoint exists and the web never
used it. **Prompt editing**, which the web also lacks. Vouches. Public profile detail with
send-interest. Verification (4 types — no capture flow behind them, they just create a `pending`
record; label that honestly). Settings: **theme toggle**, notification preferences, blocked users,
logout, **delete account**.

**Subscription — do not take payment in v1.** Render the three plans (Free ₹0 / Premium ₹499/mo /
Family ₹899/mo) as informational with a "Coming soon" state. The backend plans Razorpay, but
**Apple requires In-App Purchase for digital subscriptions** (Guideline 3.1.1) — a third-party
payment sheet is an automatic rejection, and dating/matrimony is the category Apple enforces most
strictly. Real billing means `in_app_purchase` with StoreKit + Play Billing and server-side receipt
validation: its own phase, after launch.
- **Done when:** every CRUD path round-trips and the theme toggle persists across restarts.

### Phase 10 — Push notifications and deep links
Firebase + FCM (APNs bridged on iOS); permission priming before the OS prompt; registration on
login, de-registration on logout; foreground (needs `flutter_local_notifications` — FCM shows no
tray notification when foregrounded) / background / cold-start handling; tap → deep link via
`app_links` into the right route; badge counts.
- **Done when:** a message sent while backgrounded produces a notification whose tap opens the
  correct thread.

### Phase 11 — Hardening
Accessibility: semantics on every icon-only control, 48dp minimum targets, `disableAnimations`
respected, text scaling to 200% without clipping, contrast pass (the web has several sub-AA
low-alpha text uses — raise to ≥0.6 alpha on light, ≥0.7 on dark). Offline/error states with retry
everywhere. Performance: `thumb_url` in lists and `url` only on the full card, list virtualisation,
jank profiling on a low-end Android device. App icon and splash — none exist; derive from the
wordmark badge (a forest circle with a cream Fraunces "C").
- **Done when:** the a11y checklist passes and there is no dropped-frame regression on the deck.

### Phase 12 — Release engineering
Android: keystore from a base64 secret decoded to `runner.temp` (never the repo tree), Play internal
testing, data-safety form. iOS: **cannot be built on this machine** — a `macos-15` GitHub Actions
runner with **fastlane `match`** against a private certs repo. Match, not hand-managed
`.p12`/`.mobileprovision` secrets: with no Mac in the building, it's the only way anyone can
reproduce or repair signing when a certificate expires.

**Run the iOS workflow in week 1 against a hello-world build.** Every iOS-specific problem —
signing, entitlements, the Sign in with Apple capability, `CFBundleURLTypes`, `Info.plist` usage
strings, APNs — is discoverable only in CI. Finding them all at once in week 10 is how mobile
launches slip a month.
- **Done when:** signed builds are live on Play internal testing and TestFlight.

---

## 6. Risks and sequencing

**Highest-leverage unblocks, in order:**

1. **Sign in with Apple is hard-blocked.** `Oauth::AppleVerifier` passes a single
   `ENV["APPLE_CLIENT_ID"]` as `aud`. Native `sign_in_with_apple` produces a token whose `aud` is
   the **app's bundle identifier**, not the Services ID the web flow uses. There is no client-side
   workaround — Rails must accept a list (`ENV.fetch("APPLE_CLIENT_IDS","").split(",")`; ruby-jwt
   accepts an Array). Guideline 4.8 requires Apple Sign-In because Google is offered, so this is a
   release blocker, not a nice-to-have. Do it before iOS auth work starts.
2. **Nothing is deployed.** Physical-device testing needs LAN IP juggling, iOS CI has nothing to
   point at, and ActiveStorage embeds the request host in photo URLs so a LAN-tested build's photo
   URLs break everywhere else. Deploy a staging Rails in week 1.
3. **ActionCable needs four Rails items** and `app/channels/` doesn't exist. Mitigated by the
   `ChatTransport` interface — chat ships on polling and flips with one flag. Don't let it block.
4. **Push is blocked on** device-token registration, an FCM service account, and an APNs auth key
   (requires a paid Apple Developer account). Plumbing can be built against a 404ing endpoint.
5. **`/passes` and keyset pagination.** Mitigated client-side, but the mitigation is per-device
   (pass on your phone, they return on the web) and can't recover feed-skipped profiles.

**Other constraints:**
- **No macOS.** iOS is CI-only; budget a day for signing setup and expect the first Apple review to
  surface issues undiagnosable from Linux. Consider a rented Mac when an iOS-only bug appears.
- **Razorpay will not pass Apple review** for in-app subscriptions — hence Phase 9's
  non-transacting screen. Decide billing before v1.1; Apple takes 30% (15% after year one), which
  affects pricing.
- **The feed has no ranking** (`ORDER BY id ASC`). Fine for a trial, broken at scale. First v1.1 item.
- **No `dependent: :destroy` anywhere**, making account and profile deletion more work than it looks.
- **Dark mode is authored, not ported.** §3.1 is a considered starting point, not a verified design
  — budget a review pass over every screen in dark mode in Phase 11.
- **`unread_count` in `conversations#index` ignores the `my_profile_ids` it's passed**, so a parent
  managing a ward sees an aggregated badge. Cosmetic; don't work around it client-side.

**Suggested sequencing.** Week 0 (parallel): Rails deploy + `APPLE_CLIENT_IDS`; Flutter scaffold,
theme, `core/network`, CI on both platforms with a hello-world build. Weeks 1–2: auth + session +
router guards — this validates the whole spine against a real server. Weeks 2–4: onboarding +
photo upload (biggest surface; stresses the envelope machinery and multipart). Weeks 4–6: discover,
matches, profile. Weeks 5–7: conversations on **polling**. Weeks 6–7 (Rails, parallel): channels,
then flip `CABLE_ENABLED`. Weeks 7–8: Family, subscription, verification. Week 8+: push, then the
remaining Rails items.

---

## 7. Verification

1. **`flutter analyze --fatal-infos`, `dart format --set-exit-if-changed`, `dart run custom_lint`,
   and a codegen-diff check** (generated code is committed; drift must be a visible diff) — all in CI.
2. **Unit tests — the highest-value set, all pure functions:**
   - `error_mapper` against all four shapes, including a **real captured Rails HTML 400** and a
     real HTML 500. Assert nothing throws. This is the single test most likely to prevent a
     production crash.
   - `resolveRedirect` as an exhaustive truth table (~18 assertions, 30 lines). The whole app's
     navigation correctness rests on this.
   - `cable_protocol`: identifier canonicalisation stability; welcome/ping/confirm/reject/disconnect
     decoding; an unknown `type` is ignored, not thrown.
   - `upsert`: out-of-order arrival, duplicate id, cable-before-POST-response and the reverse.
   - Deck reducer: dedupe against `seenIds`/`passedIds`, prefetch threshold, filter reset.
3. **HTTP contract tests (`http_mock_adapter`)** — one per write endpoint, asserting the **literal
   outgoing body**: `updateProfile` → `{"profile":{...}}`, `createVouch` → flat, `sendMessage` →
   `{"body":"hi"}`. ~15 lines each; the regression net for the envelope hazard.
4. **Model round-trips against captured real responses** — record with `curl` against a running
   Rails server and commit as fixtures. Hand-written fixtures will paper over the inconsistencies.
5. **Widget tests** only where there's real branching: OTP cooldown and error states, each wizard
   step's validation gate, the chat screen's `messages` + `outbox` + failed-send retry, and the
   empty/error/loading states of the three list screens.
6. **Goldens (`alchemist`)** on `ui/atoms` and `ui/molecules` only, light and dark, **Linux runner
   only** (macOS renders text differently and you'll regenerate forever). Do not golden whole
   screens — they churn on every copy change and train the team to `--update-goldens` reflexively.
7. **One integration test (`patrol`)**: phone start (reading `dev_code`) → verify → all 11 wizard
   steps → discover → like, against a Rails container. `patrol` over raw `integration_test` because
   it can dismiss the native permission dialogs `image_picker` triggers at the photos step.
8. **Backend:** `cd backend && bin/rails test` after every Phase 1 change, plus `brakeman`
   (currently zero warnings — keep it). Verify new endpoints with `curl` before wiring the client.
9. **Manual on a real device:** deck feel, OTP autofill, dark mode on every screen, safe areas on a
   notched phone, and the cable reconnect path (toggle airplane mode mid-conversation).
