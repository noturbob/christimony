import 'package:christimony/core/network/interceptors/error_interceptor.dart';
import 'package:christimony/core/realtime/realtime.dart';
import 'package:christimony/core/session/session_controller.dart';
import 'package:christimony/core/theme/theme.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:christimony/domain/models/account.dart';
import 'package:christimony/domain/models/enums.dart';
import 'package:christimony/features/chat/thread_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  testWidgets('thread renders header, bubbles, read mark; sends', (
    tester,
  ) async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
      ..interceptors.add(ErrorInterceptor());
    DioAdapter(dio: dio)
      ..onGet(
        '/conversations',
        (s) => s.reply(200, [
          {
            'id': 1,
            'match_id': 2,
            'other_profile': {'id': 3, 'name': 'Ruth', 'profile_type': 'self'},
            'last_message': null,
            'unread_count': 0,
          },
        ]),
      )
      ..onGet(
        '/conversations/1/messages',
        (s) => s.reply(200, [
          {
            'id': 1,
            'conversation_id': 1,
            'sender_account_id': 9,
            'body': 'Hi there',
            'sent_at': '2026-10-09T10:00:00Z',
            'read_at': '2026-10-09T10:01:00Z',
          },
          {
            'id': 2,
            'conversation_id': 1,
            'sender_account_id': 7,
            'body': 'Hello Ruth',
            'sent_at': '2026-10-09T10:02:00Z',
            'read_at': '2026-10-09T10:03:00Z',
          },
        ]),
        queryParameters: {'limit': 30},
      )
      ..onPost(
        '/conversations/1/messages',
        (s) => s.reply(201, {
          'id': 3,
          'conversation_id': 1,
          'sender_account_id': 7,
          'body': 'How are you?',
          'sent_at': '2026-10-09T10:04:00Z',
          'read_at': null,
        }),
        data: {'body': 'How are you?'},
      );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          christimonyApiProvider.overrideWithValue(ChristimonyApi(dio)),
          realtimeProvider.overrideWithValue(RealtimeFeed.offline()),
          currentAccountProvider.overrideWithValue(
            const Account(id: 7, accountType: AccountType.individual),
          ),
        ],
        child: MaterialApp(
          theme: buildTheme(),
          home: const ThreadScreen(conversationId: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ruth'), findsOneWidget);
    expect(find.text('Hi there'), findsOneWidget);
    expect(find.text('Hello Ruth'), findsOneWidget);
    expect(find.text('Read'), findsOneWidget);

    final send = find.widgetWithIcon(IconButton, Icons.send_rounded);
    expect(tester.widget<IconButton>(send).onPressed, isNull);
    await tester.enterText(find.byType(TextField), 'How are you?');
    await tester.pump();
    await tester.tap(send);
    await tester.pumpAndSettle();

    expect(find.text('How are you?'), findsOneWidget);
    expect(find.text('Read'), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
