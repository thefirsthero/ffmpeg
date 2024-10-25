import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/video_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoRequest = ref.watch(videoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Video Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Background Video URL'),
              onChanged: (value) {
                ref.read(videoProvider.notifier).updateBackgroundVideo(value);
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Text for TTS'),
              onChanged: (value) {
                ref.read(videoProvider.notifier).updateText(value);
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Background Audio URL'),
              onChanged: (value) {
                ref.read(videoProvider.notifier).updateBackgroundAudio(value);
              },
            ),
            Slider(
              value: videoRequest.ttsVolumeRatio,
              min: 0,
              max: 1,
              onChanged: videoRequest.backgroundAudioUrl != null
                  ? (value) {
                      ref.read(videoProvider.notifier).updateTtsVolumeRatio(value);
                    }
                  : null,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(videoProvider.notifier).generateVideo();
                  context.pushNamed('video-preview');
                } catch (e) {
                  context.pushNamed('failure', extra: e.toString());
                }
              },
              child: const Text('Generate Video'),
            ),
          ],
        ),
      ),
    );
  }
}
