import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  final double? progress;

  const LoadingScreen({
    super.key,
    this.message = "Loading, please wait...",
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
            ),
            if (progress != null) // Show progress if available
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(value: progress),
              ),
          ],
        ),
      ),
    );
  }
}
