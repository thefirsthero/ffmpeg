import 'package:flutter/foundation.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'file_storage.dart';

class VideoService {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  Future<String> generateTTS(String text) async {
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String audioFilePath =
        join(await FileStorage.getExternalDocumentPath(), '$timestamp.mp3');
    return await FileStorage.saveTtsAudio(text, audioFilePath);
  }

  Future<String> downloadVideo(String url) async {
    return (await FileStorage.downloadVideo(url)).path;
  }

  Future<String> downloadAudio(String url) async {
    return (await FileStorage.downloadAudio(url)).path;
  }

  Future<void> generateVideo(
      String videoPath, String audioPath, String outputPath) async {
    try {
      String command =
          '-i $videoPath -i $audioPath -c:v copy -c:a aac -strict experimental $outputPath';
      int result = await _flutterFFmpeg.execute(command);

      if (result == 0) {
        debugPrint('Video generated successfully: $outputPath');
      } else {
        debugPrint('Error generating video: $result');
        throw Exception('Failed to generate video');
      }
    } catch (e) {
      debugPrint('Error in generateVideo: $e');
      throw Exception('Failed to generate video');
    }
  }
}
