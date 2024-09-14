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

  // This widget is the root of your application.
  @override
  Widget build(context, ref) {
    final goRouter = ref.watch(routerProvider);
    return ShadApp.router(
      title: 'FFMPEG',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
        textTheme: ShadTextTheme(family: 'UbuntuMono'),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
        textTheme: ShadTextTheme(family: 'UbuntuMono'),
      ),
      builder: (context, child) => Container(child: child),
    );
  }
}
