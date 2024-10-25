import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory directory;
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Download/ShortsGenerator");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    debugPrint("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> downloadVideo(String url) async {
    var yt = YoutubeExplode();
    try {
      // Get the video details
      var video = await yt.videos.get(url);
      var manifest = await yt.videos.streamsClient.getManifest(video.id);

      // Get the highest quality video-only stream
      var videoStreamInfo = manifest.videoOnly.withHighestBitrate();

      // Set up file path for saving the video
      String fileName = 'background_video.mp4';
      String filePath = join(await _localPath, fileName);
      File file = File(filePath);

      // Download the video-only stream
      var videoStream = yt.videos.streamsClient.get(videoStreamInfo);
      var fileStream = file.openWrite();
      await videoStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      debugPrint('Video downloaded without audio to: $filePath');
      return file;
    } catch (e) {
      debugPrint('Error downloading video: $e');
      throw Exception('Failed to download video');
    } finally {
      yt.close();
    }
  }

  static Future<File> downloadAudio(String url) async {
    var yt = YoutubeExplode();
    try {
      // Get the video information
      var video = await yt.videos.get(url);
      // Fetch audio-only stream manifest
      var manifest = await yt.videos.streamsClient.getManifest(video.id);
      var audioStreamInfo = manifest.audioOnly.withHighestBitrate();

      // Get the audio stream
      var audioStream = yt.videos.streamsClient.get(audioStreamInfo);
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String fileName = '$timestamp.mp3';
      String filePath = join(await _localPath, fileName);
      File file = File(filePath);

      var fileStream = file.openWrite();
      await audioStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      debugPrint('Audio downloaded to: $filePath');
      return file;
    } catch (e) {
      debugPrint('Error downloading audio: $e');
      throw Exception('Failed to download audio');
    } finally {
      yt.close();
    }
  }

  static Future<String> saveTtsAudio(String text) async {
    FlutterTts tts = FlutterTts();
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.setVolume(1.0);

    // Generate a timestamp for the filename
    String fileName =
        Platform.isAndroid ? "tts.wav" : "tts.caf"; 
    String outputPath = join(await _localPath, fileName);

    // Synthesize TTS to file
    await tts.synthesizeToFile(text, outputPath);
    debugPrint('TTS audio saved to: $outputPath');
    return outputPath;
  }
}
