import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/router/router.dart';
import '../../app/router/routes.dart';
import '../../data/api/christimony_api.dart';
import '../../ui/cta_button.dart';
import '../config/app_config.dart';
import '../network/api_exception.dart';
import '../network/endpoints.dart';
import '../session/session.dart';
import '../session/session_controller.dart';

/// Written by the Settings screen; push is on unless it says otherwise.
const pushEnabledKey = 'push_enabled';
const _primedKey = 'push_primed';

const _channel = AndroidNotificationChannel(
  'christimony',
  'Messages, matches and introductions',
  importance: Importance.high,
);

/// Null until every Firebase dart-define for this platform is set, which
/// keeps push (and Firebase itself) entirely off in unconfigured builds.
FirebaseOptions? firebaseOptionsFor(TargetPlatform platform) {
  final appId = switch (platform) {
    TargetPlatform.android => AppConfig.firebaseAppIdAndroid,
    TargetPlatform.iOS => AppConfig.firebaseAppIdIos,
    _ => '',
  };
  const shared = [
    AppConfig.firebaseApiKey,
    AppConfig.firebaseMessagingSenderId,
    AppConfig.firebaseProjectId,
  ];
  if (appId.isEmpty || shared.any((v) => v.isEmpty)) return null;
  return FirebaseOptions(
    apiKey: AppConfig.firebaseApiKey,
    appId: appId,
    messagingSenderId: AppConfig.firebaseMessagingSenderId,
    projectId: AppConfig.firebaseProjectId,
  );
}

/// Where a tapped notification leads. FCM `data` values are all strings.
String? pushRoute(Map<String, dynamic> data) => switch (data['type']) {
  'message' => switch (int.tryParse('${data['conversation_id']}')) {
    final int id => Routes.thread(id),
    null => Routes.messages,
  },
  'match' => Routes.matches,
  'introduction' => Routes.family,
  _ => null,
};

Future<void> registerDevice(
  ChristimonyApi api,
  String token,
  TargetPlatform platform,
) => api.send<void>(
  Api.registerDevice,
  fields: {
    'token': token,
    'platform': platform == TargetPlatform.iOS ? 'ios' : 'android',
  },
  decode: (_) {},
);

/// Null (and nothing Firebase is touched) when push isn't configured.
/// Watched by the app root so it lives for the app's lifetime.
final pushServiceProvider = Provider<PushService?>((ref) {
  final options = firebaseOptionsFor(defaultTargetPlatform);
  if (options == null) return null;
  final service = PushService._(ref, options);
  ref.listen(sessionProvider, (prev, next) {
    if (next is Authenticated && prev is! Authenticated) {
      unawaited(service.sync());
    }
  }, fireImmediately: true);
  return service;
});

class PushService {
  PushService._(this._ref, this._options);

  final Ref _ref;
  final FirebaseOptions _options;
  final _local = FlutterLocalNotificationsPlugin();
  Future<void>? _init;

  bool get _android => defaultTargetPlatform == TargetPlatform.android;
  bool get _signedIn => _ref.read(sessionProvider) is Authenticated;

  /// Brings registration in line with the session and the `push_enabled`
  /// setting: primes + asks for permission once, registers the token, or
  /// drops it when push is off. Settings can call this after a toggle.
  Future<void> sync() async {
    try {
      await (_init ??= _initialize());
      if (!_signedIn) return;

      final prefs = await SharedPreferences.getInstance();
      final messaging = FirebaseMessaging.instance;
      if (!(prefs.getBool(pushEnabledKey) ?? true)) {
        // No unregister endpoint: a deleted token is reported unregistered
        // by FCM, and the server drops it on the next send.
        await messaging.deleteToken();
        _ref.read(sessionProvider.notifier).deviceToken = null;
        return;
      }

      if (!_allowed(await messaging.getNotificationSettings())) {
        if (prefs.getBool(_primedKey) ?? false) return;
        final context = rootNavigatorKey.currentContext;
        if (context == null || !context.mounted) return;
        unawaited(prefs.setBool(_primedKey, true));
        if (await _prime(context) != true) return;
        if (!_allowed(await messaging.requestPermission())) return;
      }

      final token = await messaging.getToken();
      if (token != null) await _register(token);
    } on Object catch (e) {
      debugPrint('push: $e');
    }
  }

  static bool _allowed(NotificationSettings s) =>
      s.authorizationStatus == AuthorizationStatus.authorized ||
      s.authorizationStatus == AuthorizationStatus.provisional;

  Future<void> _register(String token) async {
    try {
      await registerDevice(
        _ref.read(christimonyApiProvider),
        token,
        defaultTargetPlatform,
      );
      _ref.read(sessionProvider.notifier).deviceToken = token;
    } on ApiException catch (e) {
      debugPrint('push: device registration failed: $e');
    }
  }

  Future<void> _initialize() async {
    await Firebase.initializeApp(options: _options);
    final messaging = FirebaseMessaging.instance;

    messaging.onTokenRefresh.listen((token) async {
      final prefs = await SharedPreferences.getInstance();
      if (_signedIn && (prefs.getBool(pushEnabledKey) ?? true)) {
        await _register(token);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _open(m.data));

    if (_android) {
      // FCM draws nothing while the app is foregrounded on Android.
      await _local.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_notification'),
        ),
        onDidReceiveNotificationResponse: (r) => _openPayload(r.payload),
      );
      await _local
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
      FirebaseMessaging.onMessage.listen(_showLocal);
      final launch = await _local.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) {
        _openPayload(launch!.notificationResponse?.payload);
      }
    } else {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    final initial = await messaging.getInitialMessage();
    if (initial != null) _open(initial.data);
  }

  Future<void> _showLocal(RemoteMessage message) async {
    final n = message.notification;
    if (n == null) return;
    await _local.show(
      id: message.messageId.hashCode,
      title: n.title,
      body: n.body,
      payload: jsonEncode(message.data),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_notification',
        ),
      ),
    );
  }

  void _openPayload(String? payload) {
    if (payload == null) return;
    _open(jsonDecode(payload) as Map<String, dynamic>);
  }

  void _open(Map<String, dynamic> data) {
    final route = pushRoute(data);
    if (route != null) _ref.read(routerProvider).go(route);
  }
}

Future<bool?> _prime(BuildContext context) => showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Stay in the loop'),
    content: const Text(
      'Christimony can let you know when someone messages you, when you '
      'match, and when a family introduction arrives. Your phone will ask '
      'you to allow notifications next.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Not now'),
      ),
      SizedBox(
        width: 160,
        child: CtaButton(
          label: 'Turn on',
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
    ],
  ),
);
