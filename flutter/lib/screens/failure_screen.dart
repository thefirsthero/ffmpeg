import 'package:flutter/material.dart';

class FailureScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const FailureScreen({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(
      title: 'Error',
      body: Center(
        child: _buildErrorContent(),
      ),
    );
  }

  Scaffold _buildScaffold({required String title, required Widget body}) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
    );
  }

  Widget _buildErrorContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
