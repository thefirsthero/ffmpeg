import 'package:devtodollars/screens/failure_screen.dart';
import 'package:devtodollars/screens/loading_screen.dart';
import 'package:devtodollars/screens/video_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:devtodollars/screens/home_screen.dart';
part 'router_notifier.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Uri? initUrl = Uri.base;

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        name: 'preview',
        path: '/video-preview',
        builder: (context, state) => const VideoPreviewView(),
      ),
      GoRoute(
        name: 'loading',
        path: '/loading',
        builder: (context, state) {
          final progress = state.extra as double?; // Cast extra as double
          return LoadingScreen(progress: progress);
        },
      ),
      GoRoute(
        name: 'failure',
        path: '/failure',
        builder: (context, state) => FailureScreen(
          message: state.extra.toString(),
          onRetry: () {
            context.go('/'); // Example retry action
          },
        ),
      ),
    ],
  );
}
