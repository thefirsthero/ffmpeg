import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:devtodollars/services/router_notifier.dart';

void main() async {
  usePathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);
    return ShadApp.router(
      title: 'Shorts Generator',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      builder: (context, child) => Container(child: child),
    );
  }

  ShadThemeData _buildTheme(Brightness brightness) {
    return ShadThemeData(
      brightness: brightness,
      colorScheme: brightness == Brightness.light
          ? const ShadZincColorScheme.light()
          : const ShadZincColorScheme.dark(),
      textTheme: ShadTextTheme(family: 'UbuntuMono'),
    );
  }
}
