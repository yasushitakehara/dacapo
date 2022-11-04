// 撮影した写真を表示する画面
import 'dart:io';

import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    logger.fine('build');
    return Scaffold(
      appBar: AppBar(title: const Text('こちらでよろしいでしょうか？')),
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
