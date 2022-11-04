import 'package:camera/camera.dart';
import 'package:dacapo/util/logger.dart';

class CameraManager {
  static late CameraController _cameraController;
  static CameraController get cameraController => _cameraController;
  static late Future<void> _initializeControllerFuture;
  static Future<void> get initializeControllerFuture =>
      _initializeControllerFuture;

  static initialize() async {
    final cameras = await availableCameras();
    // 利用可能なカメラのリストから特定のカメラを取得
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    // コントローラーを初期化
    _initializeControllerFuture = cameraController.initialize();
  }

  static Future<XFile?> takePicture() async {
    try {
      return cameraController.takePicture();
    } on CameraException catch (e) {
      logger.severe('Error takePicture: $e');
    }
    return null;
  }

  static Future<bool> startVideoRecoding() async {
    if (CameraManager.cameraController.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return false;
    }

    try {
      cameraController.startVideoRecording();
      return true;
    } on CameraException catch (e) {
      logger.severe('Error startVideoRecording: $e');
    }
    return false;
  }

  static Future<XFile?> stopVideoRecoding() async {
    if (!CameraManager.cameraController.value.isRecordingVideo) {
      // Recording is already is stopped state
      return null;
    }

    try {
      return await cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      logger.severe('Error stopVideoRecoding: $e');
    }
    return null;
  }
}
