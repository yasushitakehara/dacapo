import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/%20view/practice_page.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';

import 'camera_record_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.fine('build');
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Da Capoとは？'),
          centerTitle: true,
        ),
        body: Column(
          children: [const Text('後で書く')],
        ));
  }
}
