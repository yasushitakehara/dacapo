import 'package:camera/camera.dart';
import 'package:dacapo/model/camera_manager.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';

class VideoRecordPage extends StatefulWidget {
  const VideoRecordPage({Key? key}) : super(key: key);

  @override
  State<VideoRecordPage> createState() => _VideoRecordPageState();
}

class _VideoRecordPageState extends State<VideoRecordPage> {
  bool _isRecordingInProgress = false;

  @override
  void initState() {
    logger.fine('initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('build');
    // FutureBuilder で初期化を待ってからプレビューを表示（それまではインジケータを表示）
    return Scaffold(
      appBar: AppBar(title: const Text('お手本の指の動きを録画しましょう')),
      body: Center(
        child: FutureBuilder<void>(
          future: CameraManager.initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(CameraManager.cameraController);
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
            if (await CameraManager.startVideoRecoding()) {
              setState(() {
                _isRecordingInProgress = true;
              });
            }
          }
        },
        child: Icon(_isRecordingInProgress ? Icons.stop_circle : Icons.circle),
      ),
    );
  }

  Future<XFile?> _stopVideoRecording() async {
    logger.fine('_stopVideoRecording');
    XFile? file = await CameraManager.stopVideoRecoding();
    if (file == null) {
      // can't continue;
      Navigator.pop(context);
    }
    setState(() {
      _isRecordingInProgress = false;
    });
    return file;
  }
}
