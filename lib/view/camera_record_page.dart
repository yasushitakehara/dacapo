import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dacapo/view/preview_page.dart';
import 'package:dacapo/model/camera_manager.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';

class CameraRecordPage extends StatefulWidget {
  const CameraRecordPage({Key? key}) : super(key: key);

  @override
  State<CameraRecordPage> createState() => _CameraRecordPageState();
}

class _CameraRecordPageState extends State<CameraRecordPage> {
  static const croppedLength = 80;

  @override
  Widget build(BuildContext context) {
    // FutureBuilder で初期化を待ってからプレビューを表示（それまではインジケータを表示）
    return Scaffold(
      appBar: AppBar(title: const Text('練習したい楽譜の一部を、２本の線の間に収まるように撮影しましょう')),
      body: Center(
        child: Stack(
          children: [
            FutureBuilder<void>(
              future: CameraManager.initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(CameraManager.cameraController);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Positioned(
              top: croppedLength.toDouble(),
              width: MediaQuery.of(context).size.width,
              height: 1.0,
              child: Container(
                width: double.infinity,
                color: Colors.pink,
              ),
            ),
            Positioned(
              bottom: croppedLength.toDouble(),
              width: MediaQuery.of(context).size.width,
              height: 1.0,
              child: Container(
                width: double.infinity,
                color: Colors.pink,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 写真を撮る
          final image = await CameraManager.takePicture();
          if (image == null) {
            return;
          }
          logger.fine('path を出力 =  ${image.path}');
          //imageパッケージのImage型に変換
          final decodedImage =
              decodeImage(await File(image.path).readAsBytes())!;
          final croppedImage = copyCrop(decodedImage, 0, croppedLength,
              decodedImage.width, decodedImage.height - (croppedLength * 2));

//切り抜いた画像をdart:ioのFileオブジェクトに変換
          final croppedImagePath =
              image.path.replaceFirst('.jpg', '_cropped.jpg');
          final croppedImageFile = await File(croppedImagePath)
              .writeAsBytes(encodePng(croppedImage));
          logger.fine(croppedImageFile.path);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  PreviewPage(imagePath: croppedImageFile.path),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
