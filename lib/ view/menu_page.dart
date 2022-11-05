import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/%20view/help_page.dart';
import 'package:dacapo/%20view/practice_page.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';

import 'camera_record_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<Widget> _scoreList = [];

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
      onLongPress: () {
        logger.fine('onLongPress');
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("削除確認"),
              content: Text("この楽譜データ[$index]を削除しますか？"),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("いいえ"),
                  onPressed: () {
                    logger.fine('onPressed');
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: const Text("はい"),
                  onPressed: () {
                    logger.fine('onPressed');
                    setState(() {
                      _scoreList.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
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
