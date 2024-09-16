import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FFmpegActionButton extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onSuccess;
  final Function(String) onError;
  final Future<void> Function() startFFmpeg;
  final bool mounted;

  const FFmpegActionButton({
    Key? key,
    required this.isRunning,
    required this.onSuccess,
    required this.onError,
    required this.startFFmpeg,
    required this.mounted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      onPressed: isRunning
          ? null
          : () async {
              try {
                await startFFmpeg(); // Call the passed FFmpeg function
                if (!mounted) return;
                onSuccess();
              } catch (e) {
                if (!mounted) return;
                onError(e.toString());
              }
            },
      text: isRunning ? const CircularProgressIndicator() : const Text('Start'),
    );
  }
}
