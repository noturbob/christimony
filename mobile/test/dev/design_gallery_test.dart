import 'package:christimony/app/app.dart';
import 'package:christimony/core/theme/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('ChristimonyApp renders the Design Gallery without error', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const ChristimonyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Design Gallery'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);
    expect(find.text('Colors'), findsOneWidget);

    // Scroll to the bottom to confirm the rest of the gallery -- including
    // the match-celebration overlay preview -- builds without error too.
    await tester.dragUntilVisible(
      find.text("It's a match!"),
      find.byType(ListView),
      const Offset(0, -300),
    );
    expect(find.text("It's a match!"), findsOneWidget);
  });

  testWidgets('theme toggle button cycles through modes', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const ChristimonyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Defaults to system.
    expect(find.byIcon(Icons.brightness_auto), findsOneWidget);

    await tester.tap(find.byIcon(Icons.brightness_auto));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.light_mode), findsOneWidget);

    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });
}
