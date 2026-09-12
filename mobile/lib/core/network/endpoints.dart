/// How a write endpoint's body must be wrapped.
///
/// Rails' body convention is inconsistent per-endpoint: `profiles` and
/// `prompts` expect the payload nested under a root key
/// (`{"profile": {...}}`), while everything else — auth, interests,
/// conversations, messages, vouches, verifications, subscriptions, photo
/// reorder — expects a flat body. Encoding the envelope on the
/// [Endpoint] itself (rather than leaving it to call-site discipline)
/// makes the wrong body unrepresentable: see `docs/mobile-v1-plan.md`
/// §4.2.
enum Envelope { none, profile, prompt }

/// One HTTP call: verb, URL template, and its body envelope.
///
/// Path parameters are written as `{name}` in [template] and filled in by
/// [path]. Declaring every endpoint here (rather than inlining strings at
/// call sites) is what keeps a CI grep able to enforce "no `Dio` outside
/// `core/network`" — this file is the only place a route string appears.
class Endpoint {
  const Endpoint(this.method, this.template, {this.envelope = Envelope.none});

  final String method;
  final String template;
  final Envelope envelope;

  String path(Map<String, Object> params) {
    var result = template;
    for (final entry in params.entries) {
      result = result.replaceAll('{${entry.key}}', '${entry.value}');
    }
    return result;
  }
}

/// Every Rails `/api/v1` route the app calls. See
/// `backend/config/routes.rb` for the source of truth and
/// `docs/mobile-v1-plan.md` §4.6 for the gotchas attached to several of
/// these (feed pagination, the messages read side-effect, etc).
abstract final class Api {
  // --- Auth (public — no Authorization header attached) ---
  static const phoneStart = Endpoint('POST', '/auth/phone/start');
  static const phoneVerify = Endpoint('POST', '/auth/phone/verify');
  static const googleAuth = Endpoint('POST', '/auth/google');
  static const appleAuth = Endpoint('POST', '/auth/apple');

  static const me = Endpoint('GET', '/me');

  // --- Reference data ---
  static const denominations = Endpoint('GET', '/denominations');
  static const promptQuestions = Endpoint('GET', '/prompt_questions');

  // --- Profiles ---
  static const myProfiles = Endpoint('GET', '/profiles');
  static const feed = Endpoint('GET', '/profiles/feed');
  static const showProfile = Endpoint('GET', '/profiles/{id}');
  static const createProfile = Endpoint(
    'POST',
    '/profiles',
    envelope: Envelope.profile,
  );
  static const updateProfile = Endpoint(
    'PATCH',
    '/profiles/{id}',
    envelope: Envelope.profile,
  );

  // --- Photos (multipart create; flat reorder body) ---
  static const createPhoto = Endpoint('POST', '/profiles/{pid}/photos');
  static const deletePhoto = Endpoint('DELETE', '/profiles/{pid}/photos/{id}');
  static const reorderPhotos = Endpoint(
    'PATCH',
    '/profiles/{pid}/photos/reorder',
  );

  // --- Prompts ---
  static const listPrompts = Endpoint('GET', '/profiles/{pid}/prompts');
  static const createPrompt = Endpoint(
    'POST',
    '/profiles/{pid}/prompts',
    envelope: Envelope.prompt,
  );
  static const updatePrompt = Endpoint(
    'PATCH',
    '/profiles/{pid}/prompts/{id}',
    envelope: Envelope.prompt,
  );
  static const deletePrompt = Endpoint(
    'DELETE',
    '/profiles/{pid}/prompts/{id}',
  );

  // --- Vouches (flat body) ---
  static const listVouches = Endpoint('GET', '/profiles/{pid}/vouches');
  static const createVouch = Endpoint('POST', '/profiles/{pid}/vouches');

  // --- Interests / matches ---
  static const listInterests = Endpoint('GET', '/interests');
  static const createInterest = Endpoint('POST', '/interests');
  static const listMatches = Endpoint('GET', '/matches');

  // --- Introductions (flat body) ---
  static const listIntroductions = Endpoint('GET', '/introductions');
  static const acceptIntroduction = Endpoint(
    'POST',
    '/introductions/{id}/accept',
  );
  static const declineIntroduction = Endpoint(
    'POST',
    '/introductions/{id}/decline',
  );

  // --- Conversations / messages (flat bodies) ---
  static const listConversations = Endpoint('GET', '/conversations');
  static const createConversation = Endpoint('POST', '/conversations');

  /// NOTE: this endpoint has a server-side side effect — it marks every
  /// unread message not sent by the caller as read. Only a foreground,
  /// visible chat screen may call it. See `ChatController` and plan §4.6.
  static const listMessages = Endpoint('GET', '/conversations/{cid}/messages');
  static const createMessage = Endpoint(
    'POST',
    '/conversations/{cid}/messages',
  );

  // --- Verification / subscription (flat bodies) ---
  static const listVerifications = Endpoint('GET', '/verifications');
  static const createVerification = Endpoint('POST', '/verifications');
  static const listSubscriptions = Endpoint('GET', '/subscriptions');
  static const createSubscription = Endpoint('POST', '/subscriptions');

  /// Public auth paths — the `AuthInterceptor` never attaches a Bearer
  /// token to these, and a 401 from one of these never triggers
  /// force-logout (there is no session yet to lose).
  static const publicPaths = <Endpoint>{
    phoneStart,
    phoneVerify,
    googleAuth,
    appleAuth,
  };
}
