import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for managing camera operations for emotion detection
class CameraService {
  static CameraService? _instance;
  List<CameraDescription>? _cameras;
  CameraController? _controller;

  /// Singleton instance
  static CameraService get instance {
    _instance ??= CameraService._internal();
    return _instance!;
  }

  CameraService._internal();

  /// Factory constructor
  factory CameraService() {
    return instance;
  }

  /// Get available cameras
  Future<List<CameraDescription>> getAvailableCameras() async {
    _cameras ??= await availableCameras();
    return _cameras!;
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status == PermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting camera permission: $e');
      }
      return false;
    }
  }

  /// Check if camera permission is granted
  Future<bool> isCameraPermissionGranted() async {
    try {
      final status = await Permission.camera.status;
      return status == PermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking camera permission: $e');
      }
      return false;
    }
  }

  /// Initialize front camera for emotion detection
  Future<CameraController> initializeFrontCamera() async {
    // Check permission first
    bool hasPermission = await isCameraPermissionGranted();
    if (!hasPermission) {
      hasPermission = await requestCameraPermission();
      if (!hasPermission) {
        throw Exception('Camera permission not granted');
      }
    }

    final cameras = await getAvailableCameras();

    if (cameras.isEmpty) {
      throw Exception('No cameras available on this device');
    }

    // Find front camera
    CameraDescription frontCamera;
    try {
      frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } catch (e) {
      // Fallback to first available camera
      frontCamera = cameras.first;
      if (kDebugMode) {
        print('Front camera not found, using: ${frontCamera.name}');
      }
    }

    // Dispose existing controller if any
    await disposeController();

    // Create new controller
    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
    return _controller!;
  }

  /// Get current camera controller
  CameraController? get controller => _controller;

  /// Check if camera is initialized
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  /// Capture image for emotion detection
  Future<String> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera is not initialized');
    }

    try {
      final image = await _controller!.takePicture();
      return image.path;
    } catch (e) {
      throw Exception('Failed to capture image: $e');
    }
  }

  /// Check if front camera is available
  Future<bool> isFrontCameraAvailable() async {
    try {
      final cameras = await getAvailableCameras();
      return cameras.any(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } catch (e) {
      return false;
    }
  }

  /// Dispose camera controller
  Future<void> disposeController() async {
    if (_controller != null) {
      try {
        await _controller!.dispose();
        _controller = null;
      } catch (e) {
        if (kDebugMode) {
          print('Error disposing camera controller: $e');
        }
      }
    }
  }

  /// Start camera preview (for UI)
  Future<void> startPreview() async {
    if (_controller != null && _controller!.value.isInitialized) {
      // Camera preview is automatically started when initialized
      return;
    }
    throw Exception('Camera is not initialized');
  }

  /// Stop camera preview
  Future<void> stopPreview() async {
    if (_controller != null && _controller!.value.isInitialized) {
      // For mobile platforms, we can pause the preview
      try {
        await _controller!.pausePreview();
      } catch (e) {
        if (kDebugMode) {
          print('Pause preview not supported: $e');
        }
      }
    }
  }

  /// Resume camera preview
  Future<void> resumePreview() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.resumePreview();
      } catch (e) {
        if (kDebugMode) {
          print('Resume preview not supported: $e');
        }
      }
    }
  }
}
