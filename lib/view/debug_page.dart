import 'dart:io';

import 'package:dacapo/model/repository/score_dao.dart';
import 'package:dacapo/model/score_dto.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({
    Key? key,
  }) : super(key: key);

  Future<List<ScoreDto>> _loadScoreDtoList() async {
    return await ScoreDao.dao.load();
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('build');
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('デバッグ用画面（SharedPreferenceの中身）'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _loadScoreDtoList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ScoreDto>> snapshot) {
          if (snapshot.hasData) {
            return renderScoreDtoList(snapshot.data!);
          } else {
            return const Text("データ読み込み中");
          }
        },
      ),
    );
  }

  Widget renderScoreDtoList(List<ScoreDto> dtoList) {
    return ListView.builder(
      itemCount: dtoList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: ListTile(
            leading: Image.file(File(dtoList[index].imageFilePath!)),
            title: Text(
                'ID:${dtoList[index].ID}, RepeatDelayMilliSec:${dtoList[index].repeatDelayMilliSeconds}'),
            subtitle: Text(
                'Image:${dtoList[index].imageFilePath}\nVideo:${dtoList[index].videoFilePath}'),
          ),
        );
      },
    );
  }
}
