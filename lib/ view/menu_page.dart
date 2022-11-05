import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/%20view/help_page.dart';
import 'package:dacapo/%20view/practice_page.dart';
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

  @override
  Widget build(BuildContext context) {
    logger.fine('build');

    // TODO
    final scoreDtoList = widget._presenter.loadScoreDtoList();

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
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _scoreList.length,
          itemBuilder: (BuildContext context, int index) {
            return _scoreList[index];
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
            setState(() {
              _scoreList.add(_showScoreBox(
                  context, _scoreList.length, takenPictureFilePath.toString()));
            });
          } else {
            logger.fine('It is null');
          }
        },
        tooltip: '新しい楽譜を追加する',
        child: const Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _showScoreBox(
      BuildContext context, int index, String pictureFilePath) {
    return InkWell(
      onTap: () {
        logger.fine('onTap');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PracticePage(pictureFilePath: pictureFilePath)));
      },
      onLongPress: () async {
        logger.fine('onLongPress');

        if (await widget._presenter.showDeleteConfirmDialog(context, index)) {
          setState(() {
            _scoreList.removeAt(index);
          });
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
            File(pictureFilePath),
          ),
        ),
      ),
    );
  }
}
