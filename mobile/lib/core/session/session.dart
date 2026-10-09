import '../../domain/models/account.dart';

/// The app's session states, as seen by the router guard.
///
/// Zero Flutter imports, so the router guard (`resolveRedirect`) stays an
/// exhaustively unit-tested pure function.
sealed class Session {
  const Session();
}

class SessionLoading extends Session {
  const SessionLoading();
}

class Unauthenticated extends Session {
  const Unauthenticated();
}

class Authenticated extends Session {
  const Authenticated(this.account);
  final Account account;
}
