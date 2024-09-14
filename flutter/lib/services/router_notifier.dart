import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:devtodollars/screens/home_screen.dart';
part 'router_notifier.g.dart';

// This is crucial for making sure that the same navigator is used
// when rebuilding the GoRouter and not throwing away the whole widget tree.
final navigatorKey = GlobalKey<NavigatorState>();
Uri? initUrl = Uri.base; // needed to set intiial url state

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: initUrl?.path, // DO NOT REMOVE
    navigatorKey: navigatorKey,
    observers: [PosthogObserver()],
    routes: <RouteBase>[
      GoRoute(
        name: 'loading',
        path: '/loading',
        builder: (context, state) {
          return const Center(child: CircularProgressIndicator());
        },
      ),
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) {
          return const HomeScreen(title: "DevToDollars");
        },
      ),
    ],
  );
}
