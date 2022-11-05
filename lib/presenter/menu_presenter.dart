import 'package:dacapo/model/repository/score_dao.dart';
import 'package:dacapo/model/score_dto.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';

class MenuPresenter {
  Future<List<ScoreDto>> loadScoreDtoList() async {
    return await ScoreDao.dao.load();
  }

  void addNewScoreDto(ScoreDto dto) async {
    final scoreDtoList = await ScoreDao.dao.load();
    scoreDtoList.add(dto);
    await ScoreDao.dao.save(scoreDtoList);
    logger.info('added $dto');
  }

  Future<bool> showDeleteConfirmDialog(
      BuildContext context, ScoreDto dto) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("削除確認"),
          content: Text("この楽譜データを削除しますか？ ID=${dto.ID!}"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("いいえ"),
              onPressed: () {
                logger.fine('onPressed');
                Navigator.pop(context, false);
              },
            ),
            ElevatedButton(
              child: const Text("はい"),
              onPressed: () {
                logger.fine('onPressed');
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    logger.fine('result = $result');
    return result ?? false;
  }
}
