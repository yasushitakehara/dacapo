import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/%20view/debug_page.dart';
import 'package:dacapo/%20view/practice_page.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.info,
            ),
            onPressed: () async {
              final info = await PackageInfo.fromPlatform();
              showLicensePage(
                context: context,
                applicationName: info.appName,
                applicationVersion: info.version,
                applicationIcon: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/icon/app-icon.png'),
                ),
                applicationLegalese: '(C) Yasushi Takehara',
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Text(''),
            const Text(
              'Da Capoは、ピアノの部分練習を繰り返し行うためのアプリです。',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            ),
            const Text(''),
            const Text(
              '特徴',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('1) 会員登録・ログイン不要'),
            const Text('2) オフライン環境で使用可能'),
            const Text(''),
            const Text(
              '以下のステップで練習します',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('1) 楽譜をカメラで撮る'),
            const Text('2) お手本をビデオで撮る'),
            const Text('3) リピート再生する'),
            GestureDetector(
              onDoubleTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DebugPage()));
              },
              // タッチ検出対象のWidget
              child: const Text('4) リピート再生の合間に自分で弾いて、お手本と比較する'),
            ),
          ],
        ),
      ),
    );
  }
}
