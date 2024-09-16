import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FeedbackDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onClose;

  const FeedbackDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ShadButton(
          onPressed: onClose,
          text: const Text('OK'),
        ),
      ],
    );
  }
}
