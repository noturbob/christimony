import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/push/push_service.dart';
import '../core/theme/theme.dart';
import 'router/router.dart';

class ChristimonyApp extends ConsumerWidget {
  const ChristimonyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pushServiceProvider);
    return MaterialApp.router(
      title: 'Christimony',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
