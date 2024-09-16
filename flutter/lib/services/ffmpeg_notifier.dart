import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FFmpegState {
  final bool isRunning;
  final String inputFilePath;
  final String outputFolderPath;
  final String ffmpegCommand;
  final String? outputMessage; // Added to store output message
  final String? errorMessage; // Added to store error message

  FFmpegState({
    required this.isRunning,
    required this.inputFilePath,
    required this.outputFolderPath,
    required this.ffmpegCommand,
    this.outputMessage,
    this.errorMessage,
  });

  FFmpegState copyWith({
    bool? isRunning,
    String? inputFilePath,
    String? outputFolderPath,
    String? ffmpegCommand,
    String? outputMessage,
    String? errorMessage,
  }) {
    return FFmpegState(
      isRunning: isRunning ?? this.isRunning,
      inputFilePath: inputFilePath ?? this.inputFilePath,
      outputFolderPath: outputFolderPath ?? this.outputFolderPath,
      ffmpegCommand: ffmpegCommand ?? this.ffmpegCommand,
      outputMessage: outputMessage ?? this.outputMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FFmpegNotifier extends StateNotifier<FFmpegState> {
  FFmpegNotifier()
      : super(FFmpegState(
            isRunning: false,
            inputFilePath: '',
            outputFolderPath: '',
            ffmpegCommand: '',
            outputMessage: null,
            errorMessage: null));

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

  void setOutputMessage(String message) {
    state = state.copyWith(outputMessage: message, errorMessage: null);
  }

  void setErrorMessage(String message) {
    state = state.copyWith(errorMessage: message, outputMessage: null);
  }

  Future<void> startFFmpeg() async {
    if (state.inputFilePath.isEmpty ||
        state.outputFolderPath.isEmpty ||
        state.ffmpegCommand.isEmpty) {
      setErrorMessage('All fields are required');
      throw ('All fields are required');
    }

    state = state.copyWith(isRunning: true);

    String finalCommand =
        "-i ${state.inputFilePath} ${state.ffmpegCommand} ${state.outputFolderPath}/output.mp4";

    int rc = await _flutterFFmpeg.execute(finalCommand);
    state = state.copyWith(isRunning: false);

    if (rc == 0) {
      setOutputMessage('FFmpeg completed successfully');
    } else {
      setErrorMessage('FFmpeg failed with return code: $rc');
      throw ('FFmpeg failed');
    }
  }
}

// Riverpod provider for the FFmpegNotifier
final ffmpegProvider =
    StateNotifierProvider<FFmpegNotifier, FFmpegState>((ref) {
  return FFmpegNotifier();
});
