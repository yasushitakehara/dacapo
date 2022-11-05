import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/%20view/help_page.dart';
import 'package:dacapo/%20view/practice_page.dart';
import 'package:dacapo/model/repository/score_dao.dart';
import 'package:dacapo/model/score_dto.dart';
import 'package:dacapo/presenter/menu_presenter.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';

import 'camera_record_page.dart';

class MenuPage extends StatefulWidget {
  MenuPage({super.key});

  final MenuPresenter _presenter = MenuPresenter();

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<Widget> _scoreList = [];
  bool _buildFlag = false;
  _callBuild() {
    setState(() {
      _buildFlag = !_buildFlag;
    });
  }

  Future<List<ScoreDto>> getData() async {
    return await widget._presenter.loadScoreDtoList();
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Da Capo 練習メニュー（楽譜を長押しすると削除できます）'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.help,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HelpPage()));
            },
          )
        ],
      ),
      body: SizedBox(
        height: 200,
        child: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<List<ScoreDto>> snapshot) {
            List<Widget> child;

            if (snapshot.hasData) {
              List<Widget> resultList = [];
              final dtoList = snapshot.data!;
              for (int i = 0; i < dtoList.length; i++) {
                resultList.add(_showScoreBox(context, i, dtoList[i]));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: resultList.length,
                itemBuilder: (BuildContext context, int index) {
                  return resultList[index];
                },
              );
            } else if (snapshot.hasError) {
              child = [
                Center(
                  child: Text('エラー：' + snapshot.data.toString()),
                ),
              ];
            } else {
              child = [Text('')];
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: child,
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          logger.fine('onPressed');
          final takenPictureFilePath = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => CameraRecordPage()));

          if (takenPictureFilePath != null) {
            logger.fine('received ${takenPictureFilePath.toString()}');

            final dto = ScoreDto.createNewScoreDto(takenPictureFilePath);
            widget._presenter.addNewScoreDto(dto);
            _callBuild();
          } else {
            logger.fine('It is null');
          }
        },
        tooltip: '新しい楽譜を追加する',
        child: const Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _showScoreBox(BuildContext context, int index, ScoreDto dto) {
    return InkWell(
      onTap: () {
        logger.fine('onTap');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PracticePage(pictureFilePath: dto.imageFilePath!)));
      },
      onLongPress: () async {
        logger.fine('onLongPress');

        if (await widget._presenter.showDeleteConfirmDialog(context, dto)) {
          await ScoreDao.dao.deleteScoreDto(dto.ID!);
          _callBuild();
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.file(
            File(dto.imageFilePath!),
          ),
        ),
      ),
    );
  }
}
