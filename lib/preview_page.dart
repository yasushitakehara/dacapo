// 撮影した写真を表示する画面
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'logger.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    logger.fine('build');
    return Scaffold(
      appBar: AppBar(title: const Text('撮れた写真')),
      body: Center(child: Image.file(File(imagePath))),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          logger.fine('onPressed');
          Navigator.of(context).pop();
          Navigator.of(context).pop(imagePath);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
