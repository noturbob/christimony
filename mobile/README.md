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
  and eventually `lib/features`, `lib/ui`) matching the plan's §2 — the
  latter two land once real screens/components exist, see Directory map
  below.
- ✅ Full dependency set resolved and pinned (`pubspec.lock`) — Riverpod 3,
  go_router, Dio, freezed/json_serializable, and the rest of the plan's
  §4.1 list.
- ✅ Design tokens: `ChristimonyColors`/`ChristimonyRadii` as
  `ThemeExtension`s (light + dark, plan §3.1), Fraunces/Inter typography
  (bundled variable fonts, OFL-licensed), motion constants, and a
  `buildLightTheme()`/`buildDarkTheme()` wired into `MaterialApp`. Theme
  mode (System/Light/Dark) persists via `shared_preferences`.
- ✅ Debug **Design Gallery** (`lib/dev/design_gallery.dart`) — the
  current `home:` of the app. Renders every color token, the type scale,
  radii, and first-pass buttons/cards, with a theme-mode toggle in the
  app bar.
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

What's **not** built yet — see the plan's phases 4–12: no screens for
auth, onboarding, discover, matches, messages, introductions, or profile;
no `go_router` route table wired to real screens (the Design Gallery is
the only thing on screen); no ActionCable client; no push notifications;
no app icon/splash. The backend-side Phase 1 work (deploying Rails,
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

`lib/core/theme/tokens.dart` transcribes the design tokens 1:1 as a
`ThemeExtension<ChristimonyColors>` — light values ported verbatim from
`web/app/globals.css`; dark values authored fresh, since the web
deliberately has no dark mode (`.dark` block removed in commit `a4f061c`).
`lib/core/theme/theme.dart` derives a Material `ColorScheme` from those
tokens so stock widgets (dialogs, `TextField`) render correctly without
per-widget overrides. See `../docs/mobile-v1-plan.md` §3 for the full
token table and rationale for every non-obvious choice (e.g. why the
match-celebration overlay uses a separate `celebration` token rather than
`primary` on dark).

## Directory map

```
lib/
  app/            MaterialApp wiring, go_router + the redirect guard (pure, unit-tested)
  core/           theme, networking (Dio + interceptors + error mapping), storage, config
  domain/models/  freezed API response models
  data/           the ChristimonyApi facade + (future) per-resource repositories
  dev/            debug-only tooling; currently the Design Gallery
test/             mirrors lib/ -- unit tests for pure functions, HTTP-contract
                  tests for the envelope machinery, one widget test for the app shell
tool/
  check_isolation.sh   CI check: no cross-feature imports, no Dio outside core/network
```

`lib/features/` (one folder per screen area — auth, onboarding, discover, ...)
and `lib/ui/` (the shared component kit, plan §3.5) don't exist yet — Git
doesn't track empty directories, so pre-creating them as scaffolding
doesn't actually reserve anything and it broke CI once already (see
`tool/check_isolation.sh`'s `[ -d lib/features ]` guard). They'll appear
for real once the first feature/component lands, per the plan's phase
order.

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
