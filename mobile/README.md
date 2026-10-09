# Christimony — Mobile

The Flutter client for Christimony, a Hinge/Bumble-style matrimony platform
for Christians. Talks to the Rails API in `../backend` **directly** (no BFF
hop — see "Why not the Next.js BFF" below).

Full build brief, design tokens, phased roadmap, and API-contract gotchas:
[`../docs/mobile-v1-plan.md`](../docs/mobile-v1-plan.md). This README covers
what actually exists in this directory today; the plan covers everything
still to build.

## Status

This is an early, in-progress scaffold — **not yet a usable app**. What's
real and tested:

- ✅ Toolchain: Flutter 3.47.4 stable + a minimal Android SDK (platform 35/36,
  build-tools) — no emulator system image installed (disk-constrained dev
  box), so local testing needs a physical device over `adb`.
- ✅ Project scaffold: `app.christimony` bundle id on both platforms,
  feature-first directory layout (`lib/core`, `lib/domain`, `lib/data`,
  `lib/ui`, and eventually `lib/features`) matching the plan's §2 — see
  Directory map below.
- ✅ Full dependency set resolved and pinned (`pubspec.lock`) — Riverpod 3,
  go_router, Dio, freezed/json_serializable, and the rest of the plan's
  §4.1 list.
- ✅ Design tokens: the web's dark "chalkboard" palette and radii
  (`AppColors`/`AppRadii`), Bricolage Grotesque + Fraunces italic
  typography (bundled variable fonts, OFL-licensed), motion constants, and
  one dark `buildTheme()`. Dark-only, like the web.
- ✅ First components in `lib/ui/`: `CtaButton` (the gradient-hairline
  primary action) and `LogoMark` (the new cross-and-ring mark).
- ✅ Debug **Design Gallery** (`lib/dev/design_gallery.dart`) — the
  current `home:` of the app. Renders every colour token, the type scale,
  radii, buttons, a card, and the match-celebration heading.
- ✅ Core networking layer: the `ChristimonyApi` facade + `Endpoint`
  registry that makes the profiles/prompts request-envelope inconsistency
  unrepresentable (plan §4.2), a pure `mapError` covering all three (plus
  raw-HTML) Rails error shapes, and the Dio interceptor stack (auth,
  error-normalization, retry, debug logging).
- ✅ Every domain model (`lib/domain/models/`) as `freezed` classes with
  `unknown`-fallback enums, matching the exact JSON shapes documented in
  the plan (including the two *different* match shapes returned by
  `POST /interests` vs `GET /matches`, and the civil-date-vs-instant
  distinction for `dob`).
- ✅ The router's redirect guard (`resolveRedirect`) as a pure function,
  unit-tested as an exhaustive truth table — this is the piece the whole
  app's navigation correctness rests on.
- ✅ 40 passing tests: `flutter analyze` is clean, `dart format` is
  clean, and `tool/check_isolation.sh` (the "no cross-feature imports, no
  Dio outside `core/network`" CI check) passes.
- ✅ CI (`.github/workflows/mobile-ci.yml`) is green end to end, including
  the debug APK build. Getting there caught three bugs that only showed
  up on a fresh checkout: two empty directories Git doesn't track
  (`assets/images/`, `lib/features/`), and `flutter_local_notifications`
  needing core library desugaring enabled in `android/app/build.gradle.kts`.

What's **not** built yet — see the plan's phases 4–12: no screens for
auth, onboarding, discover, matches, messages, introductions, or profile;
no `go_router` route table wired to real screens (the Design Gallery is
the only thing on screen); no ActionCable client. The backend-side Phase 1 work (deploying Rails,
fixing the feed's N+1 and offset-pagination bug, adding `/passes`, the
Apple OAuth audience-list fix, etc.) is also not started.

## Getting started

You need a Flutter SDK and a way to run an Android or iOS build — neither
is bundled with this repo. This dev environment installed Flutter to
`~/.local/share/flutter` and the Android SDK to `~/Android/Sdk` (not via
the Arch `flutter` AUR package, which owns `/opt/flutter` as root and
fights `flutter upgrade`); adjust `PATH` for wherever yours lives.

```bash
cd mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # regenerate *.freezed.dart / *.g.dart
flutter analyze
flutter test
```

To actually run the app, point it at a Rails server (`../backend`, see
its README — nothing is deployed yet) via `--dart-define-from-file`:

```bash
flutter run --dart-define-from-file=config/dev.json
```

`config/dev.json` defaults to `10.0.2.2:3000`, the Android emulator's
loopback to the host machine. On a physical device, change it to your
machine's LAN IP and add a Rails `config.hosts <<` entry for that IP (see
`../docs/mobile-v1-plan.md` §Phase 1a) plus an Android cleartext-traffic
exception for the `dev` flavor.

### Flavors

Three flavors, distinct application ids so all three can be installed
side by side: `app.christimony.dev`, `app.christimony.staging`,
`app.christimony` (prod). Configured via `config/{dev,staging,prod}.json`
and `--dart-define-from-file` rather than a runtime `.env` file — values
are compile-time-folded, so a build can't accidentally ship pointed at
the wrong API. `staging.json`/`prod.json` have placeholder hosts; fill
them in once Rails is deployed.

## Architecture

### Why not the Next.js BFF

`web/app/api/bff/[...path]/route.ts` is a pure pass-through — it
attaches `Authorization: Bearer <token>` from an httpOnly cookie and
forwards the request to Rails unchanged. A native app can hold that same
JWT safely in platform secure storage (Keychain/Keystore via
`flutter_secure_storage`), so routing mobile traffic through Vercel would
add a hop and couple app releases to web deploys for no benefit. The app
talks to `<API_BASE_URL>/api/v1` directly.

### The envelope hazard

Rails' request-body convention is inconsistent per endpoint: `profiles`
and `prompts` expect the payload nested under a root key
(`{"profile": {...}}`), while everything else — auth, interests,
conversations, messages, vouches, verifications, subscriptions, photo
reorder — expects a flat body. `lib/core/network/endpoints.dart` encodes
each endpoint's `Envelope` right next to its path, and
`lib/data/api/christimony_api.dart`'s single `send()` method applies it
mechanically — so a call site cannot forget (or wrongly add) a wrapper.
`test/data/api/christimony_api_envelope_test.dart` asserts the literal
outgoing body for a representative endpoint on each side of this.

### Error handling

Rails has no `rescue_from` anywhere, so three-and-a-half response shapes
exist: `{"error": "..."}` (401/403/404/429, OTP 422s), `{"errors": [...]}`
(model-validation 422s), raw HTML (an unhandled exception — `params.require`
misses render as a 400 HTML page, and so does any 500), and a genuine
network failure. `lib/core/network/error_mapper.dart`'s `mapError` is a
pure function that normalizes all of these into one sealed
`ApiException` hierarchy (`lib/core/network/api_exception.dart`); the
`data is! Map` guard at its top is load-bearing — without it, an HTML
body would throw `_TypeError` *inside* the interceptor rather than
surfacing as a normal, displayable exception.
`test/core/network/error_mapper_test.dart` covers all four shapes,
including a captured HTML error page.

### Theming

`lib/core/theme/tokens.dart` transcribes `web/app/globals.css`'s `:root`
1:1 as plain constants — the dark "chalkboard" palette (forest-tinted
near-black, cream "chalk" text, and one highlighter per part of the
product: sage = brand/primary action, gold = browsing, lilac = pace,
blush = family). The web is dark-only, so the app is too: one theme, no
light/dark switch. `lib/core/theme/theme.dart` derives a Material
`ColorScheme` from those tokens so stock widgets (dialogs, `TextField`)
render on-brand without per-widget overrides.

The primary action is `CtaButton`, never a filled block — same rule as
the web's `.pill-cta`. When the web's tokens change, update `tokens.dart`
to match; the older token table in `../docs/mobile-v1-plan.md` §3
predates the chalkboard redesign.

## Push notifications

`lib/core/push/push_service.dart`, started from the app root. **Off until
configured**: with any `FIREBASE_*` value in `config/<flavor>.json` empty,
Firebase is never initialised and the app runs normally. There is no
`google-services.json` / `GoogleService-Info.plist` and no Google Services
Gradle plugin -- `Firebase.initializeApp(options:)` is fed from dart-defines.

Once configured and signed in: a one-time in-app explanation precedes the
OS permission prompt; the FCM token goes to `POST /devices` (again on
refresh) and becomes `SessionController.deviceToken` so logout drops it.
The Settings `push_enabled` pref (default on) is honoured -- after toggling
it, call `ref.read(pushServiceProvider)?.sync()`. Foreground messages show
as local notifications on Android (iOS uses FCM's foreground presentation).
A tap routes by `data.type`: `message` -> the thread, `match` -> Matches,
`introduction` -> Family.

Setup (once): create a Firebase project; add Android apps
`app.christimony`, `app.christimony.staging`, `app.christimony.dev` and iOS
apps with the same bundle ids; copy each app's values into its flavor's
`FIREBASE_API_KEY`, `FIREBASE_APP_ID_ANDROID`, `FIREBASE_APP_ID_IOS`,
`FIREBASE_MESSAGING_SENDER_ID` (project number), `FIREBASE_PROJECT_ID`.
iOS also needs an APNs auth key (.p8) uploaded under Project settings ->
Cloud Messaging, and the Push Notifications capability + `remote-notification`
background mode on the Runner target. Backend: `FCM_PROJECT_ID` +
`FCM_CREDENTIALS_JSON` (a service-account key JSON).

## App icon and splash

Sources are in `assets/icon/`, rendered from `web/app/icon.svg` (full-bleed
icon, adaptive-icon foreground on `#0f1311`, splash marks). The white
`ic_notification` drawables are the notification small icon. After changing
them: `dart run flutter_launcher_icons` and
`dart run flutter_native_splash:create`, then commit the platform files
(revert the launcher-icons tool's `project.pbxproj` edit -- it clobbers
`ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS`).

## Directory map

```
lib/
  app/            MaterialApp wiring, go_router + the redirect guard (pure, unit-tested)
  core/           theme, networking (Dio + interceptors + error mapping), storage, config
  domain/models/  freezed API response models
  data/           the ChristimonyApi facade + (future) per-resource repositories
  ui/             shared components (CtaButton, LogoMark)
  dev/            debug-only tooling; currently the Design Gallery
test/             mirrors lib/ -- unit tests for pure functions, HTTP-contract
                  tests for the envelope machinery, one widget test for the app shell
tool/
  check_isolation.sh   CI check: no cross-feature imports, no Dio outside core/network
```

`lib/features/` (one folder per screen area — auth, onboarding, discover, ...)
doesn't exist yet — Git doesn't track empty directories, so pre-creating it
as scaffolding doesn't reserve anything and it broke CI once already (see
`tool/check_isolation.sh`'s `[ -d lib/features ]` guard). It'll appear once
the first screen lands.

## Verification

```bash
flutter analyze                # zero issues
dart format --output=none --set-exit-if-changed .
dart run build_runner build --delete-conflicting-outputs && git diff --exit-code   # generated code must be committed
flutter test                   # 40 tests today
./tool/check_isolation.sh
```

All of the above run in `.github/workflows/mobile-ci.yml` on every PR
touching `mobile/**`.
