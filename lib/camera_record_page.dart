import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';

import 'logger.dart';
import 'preview_page.dart';

class CameraRecordPage extends StatefulWidget {
  const CameraRecordPage({
    Key? key,
    required this.cameraDesc,
  }) : super(key: key);

  final CameraDescription cameraDesc;

  @override
  State<CameraRecordPage> createState() => _CameraRecordPageState();
}

class _CameraRecordPageState extends State<CameraRecordPage> {
  static const croppedLength = 100;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // カメラを指定
      widget.cameraDesc,
      // 解像度を定義
      ResolutionPreset.medium,
    );
    // コントローラーを初期化
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder で初期化を待ってからプレビューを表示（それまではインジケータを表示）
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
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
          final image = await _controller.takePicture();
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
