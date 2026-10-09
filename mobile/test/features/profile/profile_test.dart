import 'package:christimony/core/network/interceptors/error_interceptor.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:christimony/features/profile/photo_strip.dart';
import 'package:christimony/features/profile/profile_form.dart';
import 'package:christimony/features/profile/settings_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Map<String, Object> _photo(int id, int position) => {
  'id': id,
  'url': 'https://x.test/$id',
  'thumb_url': 'https://x.test/$id/t',
  'position': position,
};

void main() {
  late Dio dio;
  late DioAdapter adapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
      ..interceptors.add(ErrorInterceptor());
    adapter = DioAdapter(dio: dio);
  });

  group('photo reorder', () {
    test('movedIds keeps every id exactly once', () {
      const ids = [1, 2, 3, 4];
      expect(movedIds(ids, 0, 3), [2, 3, 4, 1]);
      expect(movedIds(ids, 3, 0), [4, 1, 2, 3]);
      expect(movedIds(ids, 1, 2), [1, 3, 2, 4]);
      for (var from = 0; from < 4; from++) {
        for (var to = 0; to < 4; to++) {
          expect(movedIds(ids, from, to)..sort(), ids);
        }
      }
    });

    test('request body lists every photo id in the new order', () async {
      adapter.onPatch(
        '/profiles/9/photos/reorder',
        (s) => s.reply(200, [_photo(3, 0), _photo(1, 1), _photo(2, 2)]),
        data: {
          'order': [3, 1, 2],
        },
      );

      final photos = await reorderPhotos(
        ChristimonyApi(dio),
        9,
        movedIds([1, 2, 3], 2, 0),
      );

      expect(photos.map((p) => p.id), [3, 1, 2]);
    });
  });

  test('latestAdultDob is exactly 18 years back', () {
    expect(latestAdultDob(DateTime(2026, 10, 9)), DateTime(2008, 10, 9));
    expect(formatCivilDate(DateTime(1998, 4, 2)), '1998-04-02');
  });

  testWidgets('delete account stays disabled until DELETE is typed', (
    tester,
  ) async {
    // Pops true only after DELETE /me succeeds.
    adapter.onDelete('/me', (s) => s.reply(204, null));
    bool? popped;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          christimonyApiProvider.overrideWithValue(ChristimonyApi(dio)),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async => popped = await showDialog<bool>(
                context: context,
                builder: (_) => const DeleteAccountDialog(),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final button = find.widgetWithText(TextButton, 'Delete forever');
    bool enabled() => tester.widget<TextButton>(button).onPressed != null;

    expect(enabled(), isFalse);
    await tester.enterText(find.byType(TextField), 'delete');
    await tester.pump();
    expect(enabled(), isFalse);
    await tester.enterText(find.byType(TextField), 'DELETE ');
    await tester.pump();
    expect(enabled(), isFalse);
    await tester.enterText(find.byType(TextField), 'DELETE');
    await tester.pump();
    expect(enabled(), isTrue);
    expect(popped, isNull);

    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(popped, isTrue);
  });
}
