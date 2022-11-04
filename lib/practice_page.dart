import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/video_record_page.dart';
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

  @override
  Widget build(BuildContext context) {
    print('build!');
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('DaCapo 練習'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                child: ElevatedButton(
                  child: Icon(Icons.video_call),
                  onPressed: () async {
                    // デバイスで使用可能なカメラのリストを取得
                    final cameras = await availableCameras();
                    _specimenVideoXFile = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VideoRecordPage(camera: cameras.first)));
                    print('specimenVideoXFile = $_specimenVideoXFile');
                    if (_specimenVideoXFile != null) {
                      _videoController = VideoPlayerController.file(
                          File(_specimenVideoXFile!.path));
                      print('aaaa');
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
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: ElevatedButton(
                  child: Icon(Icons.compare_arrows),
                  onPressed: () async {
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
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
              ),
              const Text('秒後'),
              Container(
                margin: EdgeInsets.all(8),
                child: ElevatedButton(
                  child: _isPlaying
                      ? Icon(Icons.stop_circle)
                      : Icon(Icons.play_circle),
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
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

    print(_specimenVideoXFile != null);
    print(_videoController != null);
    if (_specimenVideoXFile != null && _videoController != null) {
      return VideoPlayer(_videoController!);
    } else {
      return Text('先にビデオを撮ること');
    }
  }

  Future<void> _startVideoPlayer() async {
    print(_specimenVideoXFile != null);
    if (_specimenVideoXFile != null) {
      await _videoController!.setLooping(true);
      await _videoController!
          .seekTo(Duration.zero)
          .then((_) => _videoController!.play());
    }
  }
}
