import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'logger.dart';

class VideoRecordPage extends StatefulWidget {
  const VideoRecordPage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<VideoRecordPage> createState() => _VideoRecordPageState();
}

class _VideoRecordPageState extends State<VideoRecordPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecordingInProgress = false;

  @override
  void initState() {
    logger.fine('initState');
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('build');
    // FutureBuilder で初期化を待ってからプレビューを表示（それまではインジケータを表示）
    return Scaffold(
      appBar: AppBar(title: const Text('お手本の指の動きを録画しましょう')),
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          logger.fine('onPressed');
          logger.fine('_isRecordingInProgress = $_isRecordingInProgress');
          if (_isRecordingInProgress) {
            final xfile = await _stopVideoRecording();
            if (xfile != null) {
              logger.fine('xfile = $xfile');
            }

            Navigator.pop(context, xfile);
          } else {
            _startVideoRecording();
          }
        },
        child: Icon(_isRecordingInProgress ? Icons.stop_circle : Icons.circle),
      ),
    );
  }

  Future<void> _startVideoRecording() async {
    logger.fine('_startVideoRecording');
    if (_controller.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return;
    }

    try {
      await _controller.startVideoRecording();
      setState(() {
        _isRecordingInProgress = true;
      });
    } on CameraException catch (e) {
      logger.severe('Error starting to record video: $e');
    }
  }

  Future<XFile?> _stopVideoRecording() async {
    logger.fine('_stopVideoRecording');
    if (!_controller.value.isRecordingVideo) {
      // Recording is already is stopped state
      return null;
    }

    try {
      XFile file = await _controller.stopVideoRecording();
      setState(() {
        _isRecordingInProgress = false;
      });
      return file;
    } on CameraException catch (e) {
      logger.severe('Error stopping video recording: $e');
      return null;
    }
  }
}
