import 'package:camera/camera.dart';

class CameraManager {
  static late CameraController _cameraController;
  static late Future<void> initializeControllerFuture;

  static initialize() async {
    // デバイスで使用可能なカメラのリストを取得
    final cameras = await availableCameras();
    // 利用可能なカメラのリストから特定のカメラを取得
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    // コントローラーを初期化
    initializeControllerFuture = _cameraController.initialize();
  }

  static takePicture() async {
    return _cameraController.takePicture();
  }
}
