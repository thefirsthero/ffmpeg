class VideoRequest {
  final String backgroundVideoUrl;
  final String text;
  final String? backgroundAudioUrl;
  final double ttsVolumeRatio;

  VideoRequest({
    required this.backgroundVideoUrl,
    required this.text,
    this.backgroundAudioUrl,
    this.ttsVolumeRatio = 1.0,
  });

  VideoRequest copyWith({
    String? backgroundVideoUrl,
    String? text,
    String? backgroundAudioUrl,
    double? ttsVolumeRatio,
  }) {
    return VideoRequest(
      backgroundVideoUrl: backgroundVideoUrl ?? this.backgroundVideoUrl,
      text: text ?? this.text,
      backgroundAudioUrl: backgroundAudioUrl ?? this.backgroundAudioUrl,
      ttsVolumeRatio: ttsVolumeRatio ?? this.ttsVolumeRatio,
    );
  }
}
