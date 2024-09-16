import 'package:devtodollars/services/ffmpeg_notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Access WidgetRef using the 'ref' property
    final ffmpegState = ref.watch(ffmpegProvider);
    final ffmpegNotifier = ref.read(ffmpegProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Input File:', style: TextStyle(fontSize: 16)),
            ShadButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  ffmpegNotifier.setInputFile(result.files.single.path!);
                }
              },
              text: const Text('Select File'),
            ),
            Text('Selected File: ${ffmpegState.inputFilePath}'),
            const SizedBox(height: 20),
            const Text('Enter FFmpeg Command:', style: TextStyle(fontSize: 16)),
            TextField(
              decoration: const InputDecoration(
                hintText: 'e.g. -c:v copy -c:a copy',
              ),
              onChanged: (value) {
                ffmpegNotifier.setCommand(value);
              },
            ),
            const SizedBox(height: 20),
            const Text('Select Output Folder:', style: TextStyle(fontSize: 16)),
            ShadButton(
              onPressed: () async {
                String? selectedDirectory =
                    await FilePicker.platform.getDirectoryPath();
                if (selectedDirectory != null) {
                  ffmpegNotifier.setOutputFolder(selectedDirectory);
                }
              },
              text: const Text('Select Folder'),
            ),
            Text('Output Folder: ${ffmpegState.outputFolderPath}'),
            const SizedBox(height: 30),
            Center(
              child: ShadButton(
                onPressed: ffmpegState.isRunning
                    ? null
                    : () async {
                        try {
                          await ffmpegNotifier.startFFmpeg();

                          showDialog(
                            context: context,
                            builder: (context) => ShadDialog(
                              title: const Text('Success'),
                              content: const Text(
                                  'FFmpeg process completed successfully!'),
                              actions: [
                                ShadButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          ffmpegNotifier.setErrorMessage(e.toString());
                          showDialog(
                            context: context,
                            builder: (context) => ShadDialog(
                              title: const Text('Error'),
                              content: Text(e.toString()),
                              actions: [
                                ShadButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                text: ffmpegState.isRunning
                    ? const CircularProgressIndicator()
                    : const Text('Start'),
              ),
            ),
            const SizedBox(height: 30),
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
