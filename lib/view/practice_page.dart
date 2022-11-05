import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/util/date_format_util.dart';
import 'package:dacapo/view/video_record_page.dart';
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
  bool _showScore = true;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isWaiting = false;
  bool _noRepeatFlag = false;

  void prepareVideoControllers(String videoFilePath) async {
    _videoController = VideoPlayerController.file(File(videoFilePath));
    await _videoController!.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized,
      // even before the play button has been pressed.
      setState(() {});
    });
    _chewieController =
        widget._presenter.createChewieController(_videoController!);
  }

  @override
  void initState() {
    logger.fine('initState');
    super.initState();

    _currentSliderValue =
        DaCapoUtil.toSliderValue(widget.dto.repeatDelayMilliSeconds!);
    if (widget.dto.videoFilePath != null) {
      prepareVideoControllers(widget.dto.videoFilePath!);
    }

    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_chewieController == null) {
        logger.fine('No video yet...');
        return;
      } else if (_chewieController!.isPlaying) {
        logger.fine('playing! enjoy-!');
        return;
      } else if (_isWaiting) {
        logger.fine('waiting due to delay.');
        return;
      } else if (_noRepeatFlag) {
        logger.fine('no repeat setting!');
        return;
      }

      _isWaiting = true;
      int sleepMilliSec =
          DaCapoUtil.toRepeatDelayMilliSecond(_currentSliderValue);
      logger.fine('sleep $sleepMilliSec ms!');
      sleep(Duration(milliseconds: sleepMilliSec));
      logger.fine('has waken up! repeat again!');
      _chewieController!.play();
      _isWaiting = false;
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

                    final takenXFile = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VideoRecordPage()));
                    logger.fine('takenXFile = $takenXFile');
                    if (takenXFile != null) {
                      widget.dto.videoFilePath = takenXFile!.path;

                      // do not await for parallel process.
                      widget._presenter.update(widget.dto);
                      ScaffoldMessenger.of(context).showSnackBar(
                          widget._presenter.notifyRecordedVideoSnackBar);

                      if (_videoController != null) {
                        await _videoController!.dispose();
                        _chewieController!.dispose();
                      }
                      prepareVideoControllers(widget.dto.videoFilePath!);
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
              const Text('リピート停止'),
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
            child: _createMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _createMainContent() {
    if (_showScore) {
      return Image.file(File(widget.dto.imageFilePath!));
    } else {
      assert(_videoController != null);
      return Chewie(
        controller: _chewieController!,
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
