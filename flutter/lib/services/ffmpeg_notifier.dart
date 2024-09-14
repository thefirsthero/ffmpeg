import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FFmpegState {
  final bool isRunning;
  final String inputFilePath;
  final String outputFolderPath;
  final String ffmpegCommand;

  FFmpegState({
    required this.isRunning,
    required this.inputFilePath,
    required this.outputFolderPath,
    required this.ffmpegCommand,
  });

  FFmpegState copyWith({
    bool? isRunning,
    String? inputFilePath,
    String? outputFolderPath,
    String? ffmpegCommand,
  }) {
    return FFmpegState(
      isRunning: isRunning ?? this.isRunning,
      inputFilePath: inputFilePath ?? this.inputFilePath,
      outputFolderPath: outputFolderPath ?? this.outputFolderPath,
      ffmpegCommand: ffmpegCommand ?? this.ffmpegCommand,
    );
  }
}

class FFmpegNotifier extends StateNotifier<FFmpegState> {
  FFmpegNotifier()
      : super(FFmpegState(
            isRunning: false,
            inputFilePath: '',
            outputFolderPath: '',
            ffmpegCommand: ''));

  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  void setInputFile(String path) {
    state = state.copyWith(inputFilePath: path);
  }

  void setOutputFolder(String path) {
    state = state.copyWith(outputFolderPath: path);
  }

  void setCommand(String command) {
    state = state.copyWith(ffmpegCommand: command);
  }

  Future<void> startFFmpeg() async {
    if (state.inputFilePath.isEmpty ||
        state.outputFolderPath.isEmpty ||
        state.ffmpegCommand.isEmpty) {
      throw ('All fields are required');
    }

    state = state.copyWith(isRunning: true);

    String finalCommand =
        "-i ${state.inputFilePath} ${state.ffmpegCommand} ${state.outputFolderPath}/output.mp4";

    int rc = await _flutterFFmpeg.execute(finalCommand);
    state = state.copyWith(isRunning: false);

    if (rc == 0) {
      return Future.value('FFmpeg completed successfully');
    } else {
      return Future.error('FFmpeg failed');
    }
  }
}

// Riverpod provider for the FFmpegNotifier
final ffmpegProvider =
    StateNotifierProvider<FFmpegNotifier, FFmpegState>((ref) {
  return FFmpegNotifier();
});
