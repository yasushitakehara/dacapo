import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/%20view/video_record_page.dart';
import 'package:dacapo/model/score_dto.dart';
import 'package:dacapo/presenter/practice_presenter.dart';
import 'package:dacapo/util/dacapo_util.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PracticePage extends StatefulWidget {
  PracticePage({super.key, required this.dto});

  final PracticePresenter _presenter = PracticePresenter();
  final ScoreDto dto;

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  double _currentSliderValue = 3.0;
  XFile? _specimenVideoXFile;
  bool _showScore = true;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isWaiting = false;
  bool _noRepeatFlag = false;

  @override
  void initState() {
    logger.fine('initState');
    super.initState();
    Timer.periodic(new Duration(milliseconds: 500), (timer) {
      if (_chewieController == null) {
        logger.fine('No video yet...');
        return;
      }
      logger.info('isPlaying? ${_chewieController!.isPlaying}');
      if (_chewieController!.isPlaying) {
        logger.fine('playing! enjoy-!');
        return;
      } else if (_isWaiting) {
        logger.fine('waiting for delay.');
        return;
      } else if (_noRepeatFlag) {
        logger.fine('do not repeat!');
        return;
      }

      logger.fine('we will repeat after a while!');
      _isWaiting = true;

      int sleepMilliSec =
          DaCapoUtil.toRepeatDelayMilliSecond(_currentSliderValue);
      logger.fine('sleep $sleepMilliSec millisecondssssss');
      sleep(Duration(milliseconds: sleepMilliSec));
      logger.fine('has waken up! repeat again!');
      _chewieController!.play();
      setState(
        () {
          _isWaiting = false;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('お手本を動画で撮って、リピートさせて練習しましょう'),
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
                      widget.dto.videoFilePath = _specimenVideoXFile!.path;

                      // do not await for parallel process.
                      widget._presenter.update(widget.dto);
                      ScaffoldMessenger.of(context).showSnackBar(
                          widget._presenter.notifyRecordedVideoSnackBar);

                      if (_videoController != null) {
                        await _videoController!.dispose();
                        _chewieController!.dispose();
                      }
                      _videoController = VideoPlayerController.file(
                          File(_specimenVideoXFile!.path));
                      await _videoController!.initialize().then((_) {
                        // Ensure the first frame is shown after the video is initialized,
                        // even before the play button has been pressed.
                        setState(() {});
                      });
                      _chewieController = ChewieController(
                        videoPlayerController: _videoController!,

                        // 以下はオプション（なくてもOK）
                        allowFullScreen: false,
                        materialProgressColors: ChewieProgressColors(
                          playedColor: Colors.red, //再生済み部分（左側）の色
                          handleColor: Colors.blue, //再生地点を示すハンドルの色
                          backgroundColor: Colors.grey, //再生前のプログレスバーの色
                          bufferedColor: Colors.lightGreen, //未再生部分（右側）の色
                        ),
                        /*placeholder: Container(
                          color: Colors.white, //動画読み込み前の背景色
                        ),*/
                        autoInitialize: true, //widget呼び出し時に動画を読み込むかどうか
                      );
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
                    // no logging due to be called many times!
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                  onChangeEnd: (double value) {
                    logger.fine('onChangeEnd $value');
                    setState(() {
                      _currentSliderValue = value;
                      widget.dto.repeatDelayMilliSeconds =
                          DaCapoUtil.toRepeatDelayMilliSecond(value);
                      widget._presenter.update(widget.dto);
                    });
                  },
                ),
              ),
              const Text('秒'),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _showScore = true;
                    });
                  },
                  child: const Icon(Icons.lyrics),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_chewieController == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          widget._presenter.urgeToRecordVideoSnackBar);
                      return;
                    }
                    setState(() {
                      _showScore = false;
                    });
                  },
                  child: const Icon(Icons.music_video),
                ),
              ),
              Text('リピート停止'),
              Switch(
                  value: _noRepeatFlag,
                  onChanged: (value) {
                    setState(() {
                      _noRepeatFlag = value;
                    });
                    logger.info('_noRepeatFlag=$_noRepeatFlag');
                  }),
            ],
          ),
          Expanded(
              //margin: const EdgeInsets.all(8),
              // child: FittedBox(fit: BoxFit.contain, child: _createMainContent()),
              // width: 400, //double.infinity,
              // height: 200,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.black),
              //   borderRadius: BorderRadius.circular(20),
              // ),
              child: Container(
            //height: 200,
            child: _createMainContent(),
          )),
        ],
      ),
    );
  }

  Widget _createMainContent() {
    if (_showScore) {
      return Image.file(File(widget.dto.imageFilePath!));
    }

    logger.fine(_specimenVideoXFile != null);
    logger.fine(_videoController != null);
    if (_specimenVideoXFile != null && _videoController != null) {
      return Chewie(
        controller: _chewieController!,
      );
    } else {
      return const Center(
        child: Text('お手本をビデオを撮ると、ここに表示されます。リピートさせながら練習しましよう。'),
      );
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
