import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/video_request.dart';
import '../services/video_service.dart';

final videoProvider = StateNotifierProvider<VideoNotifier, VideoRequest>((ref) {
  return VideoNotifier();
});

class VideoNotifier extends StateNotifier<VideoRequest> {
  final VideoService _videoService = VideoService();

  VideoNotifier()
      : super(VideoRequest(
          backgroundVideoUrl: '',
          text: '',
          backgroundAudioUrl: null,
        ));

  void updateBackgroundVideo(String url) {
    state = state.copyWith(backgroundVideoUrl: url);
  }

  void updateText(String text) {
    state = state.copyWith(text: text);
  }

  void updateBackgroundAudio(String? url) {
    state = state.copyWith(backgroundAudioUrl: url);
  }

  void updateTtsVolumeRatio(double ratio) {
    state = state.copyWith(ttsVolumeRatio: ratio);
  }

  Future<void> generateVideo() async {
    try {
      String videoPath = await downloadVideo();
      String audioPath = await generateAudio();

      await _videoService.generateVideo(videoPath, audioPath);
    } catch (e) {
      debugPrint('Error in generating video: $e');
    }
  }

  Future<String> downloadVideo() async {
    return await _videoService.downloadVideo(state.backgroundVideoUrl);
  }

  Future<String> generateAudio() async {
    return await _videoService.generateTTS(state.text);
  }
}
