import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/file_storage.dart';
import 'package:path/path.dart';

class VideoPreviewView extends StatefulWidget {
  const VideoPreviewView({super.key});

  @override
  _VideoPreviewViewState createState() => _VideoPreviewViewState();
}

class _VideoPreviewViewState extends State<VideoPreviewView> {
  VideoPlayerController? _controller;
  List<FileSystemEntity> _videoFiles = [];
  String? _selectedVideoPath;

  @override
  void initState() {
    super.initState();
    _loadVideoFiles();
  }

  Future<void> _loadVideoFiles() async {
    _videoFiles = await FileStorage.getVideoFiles();
    if (_videoFiles.isNotEmpty) {
      _selectedVideoPath =
          _videoFiles.first.path; // Select the first video by default
      _initializeController();
    }
    setState(() {});
  }

  void _initializeController() {
    if (_selectedVideoPath != null) {
      _controller = VideoPlayerController.file(File(_selectedVideoPath!))
        ..initialize().then((_) {
          setState(
              () {}); // Update the state once the controller is initialized
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Preview')),
      body: Column(
        children: [
          if (_videoFiles.isNotEmpty)
            DropdownButton<String>(
              value: _selectedVideoPath,
              items: _videoFiles.map((file) {
                return DropdownMenuItem<String>(
                  value: file.path,
                  child: Text(basename(file.path)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVideoPath = value;
                  _initializeController();
                });
              },
            ),
          Expanded(
            child: _controller != null && _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          if (_videoFiles.isEmpty)
            const Center(child: Text('No videos found.')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller != null && _controller!.value.isInitialized
            ? () {
                setState(() {
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
                });
              }
            : null,
        child: Icon(
          _controller != null && _controller!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
}
