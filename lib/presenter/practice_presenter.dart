import 'package:chewie/chewie.dart';
import 'package:dacapo/model/repository/score_dao.dart';
import 'package:dacapo/model/score_dto.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PracticePresenter {
  void update(ScoreDto dto) async {
    logger.fine('update');
    ScoreDao.dao.update(dto);
  }

  final urgeToRecordVideoSnackBar = SnackBar(
    backgroundColor: Colors.pink,
    content: Row(
      children: const [
        Icon(Icons.video_call, color: Colors.white),
        SizedBox(width: 20),
        Expanded(
          child: Text('先にビデオを撮ってください'),
        )
      ],
    ),
  );

  final notifyRecordedVideoSnackBar = SnackBar(
    backgroundColor: Colors.pink,
    content: Row(
      children: const [
        Icon(Icons.video_call, color: Colors.white),
        SizedBox(width: 20),
        Expanded(
          child: Text('ビデオを撮って保存しました'),
        )
      ],
    ),
  );

  ChewieController createChewieController(
      VideoPlayerController videoController) {
    return ChewieController(
      videoPlayerController: videoController!,

      // 以下はオプション（なくてもOK）
      allowFullScreen: false,
      autoInitialize: true, //widget呼び出し時に動画を読み込むかどうか
    );
  }
}
