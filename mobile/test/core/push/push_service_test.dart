import 'package:christimony/core/push/push_service.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('notification data routes by type (FCM sends string ids)', () {
    expect(
      pushRoute({'type': 'message', 'conversation_id': '12'}),
      '/messages/12',
    );
    expect(pushRoute({'type': 'message', 'conversation_id': 'x'}), '/messages');
    expect(pushRoute({'type': 'match', 'match_id': '3'}), '/matches');
    expect(
      pushRoute({'type': 'introduction', 'introduction_id': '4'}),
      '/introductions',
    );
    expect(pushRoute({'type': 'other'}), isNull);
    expect(pushRoute({}), isNull);
  });

  test('push is inert without Firebase dart-defines', () {
    expect(firebaseOptionsFor(TargetPlatform.android), isNull);
    expect(firebaseOptionsFor(TargetPlatform.iOS), isNull);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(pushServiceProvider), isNull);
  });

  test('registerDevice posts a flat {token, platform} body', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'));
    DioAdapter(dio: dio).onPost(
      '/devices',
      (s) => s.reply(201, {'id': 1}),
      data: {'token': 'fcm-token', 'platform': 'ios'},
    );

    await registerDevice(ChristimonyApi(dio), 'fcm-token', TargetPlatform.iOS);
  });
}
