import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app/router/router.dart';
import 'src/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oebvyoqpyaxsqeaepxms.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9lYnZ5b3FweWF4c3FlYWVweG1zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyNjcyMjQsImV4cCI6MjA4MDg0MzIyNH0.Fq-D0lRrtkfi7YSloyrp2H7WZ67Pd8jytHsvRb_19-s',
  );

  runApp(
    const ProviderScope(
      child: MarketMoveApp(),
    ),
  );
}

class MarketMoveApp extends ConsumerWidget {
  const MarketMoveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'MarketMove',
      routerConfig: router,
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
