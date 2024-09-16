import 'package:devtodollars/components/feedback_dialog.dart';
import 'package:devtodollars/components/ffmpeg_action_button.dart';
import 'package:devtodollars/components/file_selector_button.dart';
import 'package:devtodollars/components/folder_selector_button.dart';
import 'package:devtodollars/services/ffmpeg_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ffmpegState = ref.watch(ffmpegProvider);
    final ffmpegNotifier = ref.read(ffmpegProvider.notifier);

    void showSuccessDialog() {
      showDialog(
        context: context,
        builder: (context) => FeedbackDialog(
          title: 'Success',
          message: 'FFmpeg process completed successfully!',
          onClose: () => Navigator.of(context).pop(),
        ),
      );
    }

    void showErrorDialog(String errorMessage) {
      showDialog(
        context: context,
        builder: (context) => FeedbackDialog(
          title: 'Error',
          message: errorMessage,
          onClose: () => Navigator.of(context).pop(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Input File:', style: TextStyle(fontSize: 16)),
            FileSelectorButton(
              buttonText: 'Select File',
              onFileSelected: (filePath) =>
                  ffmpegNotifier.setInputFile(filePath),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text('Selected File: ${ffmpegState.inputFilePath}'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            const Text('Enter FFmpeg Command:', style: TextStyle(fontSize: 16)),
            TextField(
              decoration:
                  const InputDecoration(hintText: 'e.g. -c:v copy -c:a copy'),
              onChanged: (value) => ffmpegNotifier.setCommand(value),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            const Text('Select Output Folder:', style: TextStyle(fontSize: 16)),
            FolderSelectorButton(
              buttonText: 'Select Folder',
              onFolderSelected: (folderPath) =>
                  ffmpegNotifier.setOutputFolder(folderPath),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text('Output Folder: ${ffmpegState.outputFolderPath}'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: FFmpegActionButton(
                isRunning: ffmpegState.isRunning,
                onSuccess: showSuccessDialog,
                onError: showErrorDialog,
                startFFmpeg: () => ffmpegNotifier
                    .startFFmpeg(), // Passing function for starting FFmpeg
                mounted:
                    mounted, // Pass the 'mounted' check from the stateful widget
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            if (ffmpegState.outputMessage != null ||
                ffmpegState.errorMessage != null)
              Expanded(
                child: SelectableText(
                  ffmpegState.errorMessage ?? ffmpegState.outputMessage ?? '',
                  style: const TextStyle(color: Colors.red),
                  showCursor: true,
                  cursorColor: Colors.blue,
                  contextMenuBuilder: (context, editableTextState) {
                    return AdaptiveTextSelectionToolbar.editableText(
                      editableTextState: editableTextState,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
