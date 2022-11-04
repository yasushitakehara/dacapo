import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/%20view/video_record_page.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  List<bool> _selections = [false];

  @override
  Widget build(BuildContext context) {
    logger.fine('build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Da Capo 練習'),
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

                    _specimenVideoXFile = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoRecordPage()));
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
                      _videoController!.addListener(() {
                        if (_isPlaying &&
                            !_videoController!.value.isPlaying &&
                            (_videoController!.value.duration ==
                                _videoController!.value.position)) {
                          //checking the duration and position every time
                          logger.fine('reached the end of the movie!');
                          logger.fine(
                              'sleep ${(_currentSliderValue * 1000).toInt()} milliseconds');
                          sleep(Duration(
                              milliseconds:
                                  (_currentSliderValue * 1000).toInt()));
                          logger.fine('repeat again!');
                          //setState(() {
                          //_videoController!.play();
                          //});
                          _videoController!
                              .seekTo(Duration.zero)
                              .then((_) => _videoController!.play());
                        }
                        ;
                      });
                    }
                  },
                  child: const Icon(Icons.video_call),
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
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
              ),
              const Text('秒'),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: _isPlaying
                      ? const Icon(Icons.stop_circle)
                      : const Icon(Icons.play_circle),
                  onPressed: _specimenVideoXFile == null
                      ? null
                      : () {
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
              Container(
                margin: const EdgeInsets.all(8),
                child: ToggleButtons(
                  children: <Widget>[
                    Icon(Icons.waving_hand),
                  ],
                  isSelected: _selections,
                  onPressed: (int index) {
                    logger.fine('onPressed index=$index');
                    setState(() {
                      _selections[index] = !_selections[index];
                      _showScore = !_showScore;
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
              //margin: const EdgeInsets.all(8),
              // child: FittedBox(fit: BoxFit.contain, child: _createMainContent()),
              // width: 400, //double.infinity,
              // height: 200,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.black),
              //   borderRadius: BorderRadius.circular(20),
              // ),
              child: Container(
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
      await _videoController!
          .seekTo(Duration.zero)
          .then((_) => _videoController!.play());
    }
  }
}
