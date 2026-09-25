import 'package:christimony/app/app.dart';
import 'package:christimony/ui/cta_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the Design Gallery builds end to end', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ChristimonyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Design Gallery'), findsOneWidget);
    expect(find.text('Colours'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text("It's a match.", findRichText: true),
      find.byType(ListView),
      const Offset(0, -300),
    );
    expect(find.text("It's a match.", findRichText: true), findsOneWidget);
  });

  testWidgets('CtaButton fires when enabled and not when disabled', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            CtaButton(label: 'Go', onPressed: () => taps++),
            const CtaButton(label: 'Off', onPressed: null),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.tap(find.text('Off'));
    expect(taps, 1);
  });
}
