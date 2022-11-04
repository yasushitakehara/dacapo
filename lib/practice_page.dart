import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/video_record_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'logger.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key, required this.pictureFilePath});

  final String pictureFilePath;

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  double _currentSliderValue = 1.0;
  bool _isPlaying = false;
  XFile? _specimenVideoXFile;
  bool _showScore = true;
  VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    logger.fine('build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('DaCapo 練習'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    logger.fine('onPressed');
                    // デバイスで使用可能なカメラのリストを取得
                    final cameras = await availableCameras();
                    _specimenVideoXFile = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VideoRecordPage(camera: cameras.first)));
                    logger.fine('specimenVideoXFile = $_specimenVideoXFile');
                    if (_specimenVideoXFile != null) {
                      logger.fine('_specimenVideoXFile != null');
                      _videoController = VideoPlayerController.file(
                          File(_specimenVideoXFile!.path));
                      await _videoController!.initialize().then((_) {
                        // Ensure the first frame is shown after the video is initialized,
                        // even before the play button has been pressed.
                        setState(() {});
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent
                      //onPrimary: Colors.black,
                      ),
                  child: const Icon(Icons.video_call),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Icon(Icons.compare_arrows),
                  onPressed: () async {
                    logger.fine('onPressed');
                    setState(() {
                      _showScore = !_showScore;
                    });
                  },
                ),
              ),
              const Text('リピート間隔'),
              Expanded(
                child: Slider(
                  value: _currentSliderValue,
                  min: 0,
                  max: 9.9,
                  divisions: 100,
                  label: _currentSliderValue.toStringAsFixed(1),
                  onChanged: (double value) {
                    logger.fine('onChanged');
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
              ),
              const Text('秒後'),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: _isPlaying
                      ? const Icon(Icons.stop_circle)
                      : const Icon(Icons.play_circle),
                  onPressed: () {
                    logger.fine('onPressed');
                    setState(() {
                      _isPlaying = !_isPlaying;
                      logger.fine('_isPlaying = $_isPlaying');
                      if (_isPlaying) {
                        _startVideoPlayer();
                      } else {
                        _videoController!.pause();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
              margin: const EdgeInsets.all(8),
              // child: FittedBox(fit: BoxFit.contain, child: _createMainContent()),
              // width: 400, //double.infinity,
              // height: 200,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.black),
              //   borderRadius: BorderRadius.circular(20),
              // ),
              child: SizedBox(
                height: 200,
                width: 400,
                child: _createMainContent(),
              )),
        ],
      ),
    );
  }

  Widget _createMainContent() {
    if (_showScore) {
      return Image.file(File(widget.pictureFilePath));
    }

    logger.fine(_specimenVideoXFile != null);
    logger.fine(_videoController != null);
    if (_specimenVideoXFile != null && _videoController != null) {
      return VideoPlayer(_videoController!);
    } else {
      return const Text('先にビデオを撮ること');
    }
  }

  Future<void> _startVideoPlayer() async {
    logger.fine(_specimenVideoXFile != null);
    if (_specimenVideoXFile != null) {
      await _videoController!.setLooping(true);
      await _videoController!
          .seekTo(Duration.zero)
          .then((_) => _videoController!.play());
    }
  }
}
