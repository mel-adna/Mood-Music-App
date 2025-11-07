import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../models/emotion_model.dart';

/// Service for emotion detection using Google ML Kit face detection and TFLite
class EmotionService {
  static EmotionService? _instance;
  FaceDetector? _faceDetector;
  Interpreter? _emotionInterpreter;
  bool _isInitialized = false;

  /// Singleton instance
  static EmotionService get instance {
    _instance ??= EmotionService._internal();
    return _instance!;
  }

  EmotionService._internal();

  /// Factory constructor
  factory EmotionService() {
    return instance;
  }

  /// Initialize the emotion detection service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Google ML Kit Face Detection
      await _initializeFaceDetection();

      // Initialize TFLite emotion model
      await _initializeEmotionModel();

      _isInitialized = true;
      if (kDebugMode) {
        print('EmotionService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize EmotionService: $e');
      }
      // Continue without throwing - app can work with mock emotions
    }
  }

  /// Initialize Google ML Kit Face Detection
  Future<void> _initializeFaceDetection() async {
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: false,
      enableTracking: false,
    );
    _faceDetector = FaceDetector(options: options);
  }

  /// Initialize TFLite emotion model
  Future<void> _initializeEmotionModel() async {
    try {
      // Try to load custom emotion model from assets
      // fromAsset expects path without 'assets/' prefix
      _emotionInterpreter = await Interpreter.fromAsset('tflite/model.tflite');
      if (kDebugMode) {
        print('Custom emotion model loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Custom emotion model not found, using mock detection: $e');
      }
      // Continue without TFLite model - we'll use mock detection
    }
  }

  /// Detect emotion from image path
  Future<EmotionResult> detectEmotion(String imagePath) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Check if image file exists
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      // Create InputImage from file
      final inputImage = InputImage.fromFilePath(imagePath);

      // Detect faces using Google ML Kit
      final faces = await _detectFaces(inputImage);

      if (faces.isEmpty) {
        // Return neutral emotion if no face detected
        return EmotionResult(
          emotion: EmotionType.neutral,
          confidence: 0.3,
          timestamp: DateTime.now(),
        );
      }

      // Use the first (largest) face for emotion detection
      final face = faces.first;

      // Extract emotion from face or use mock detection
      final emotionResult = await _classifyEmotion(imagePath, face);
      return emotionResult;
    } catch (e) {
      if (kDebugMode) {
        print('Error detecting emotion: $e');
      }
      // Return mock emotion on error
      return _getMockEmotionResult();
    }
  }

  /// Detect faces using Google ML Kit
  Future<List<Face>> _detectFaces(InputImage inputImage) async {
    if (_faceDetector == null) {
      throw Exception('Face detector not initialized');
    }

    try {
      final faces = await _faceDetector!.processImage(inputImage);
      return faces;
    } catch (e) {
      if (kDebugMode) {
        print('Error detecting faces: $e');
      }
      return [];
    }
  }

  /// Classify emotion using TFLite model or mock detection
  Future<EmotionResult> _classifyEmotion(String imagePath, Face face) async {
    if (_emotionInterpreter != null) {
      return await _classifyWithTFLite(imagePath, face);
    } else {
      return _classifyWithMockDetection(face);
    }
  }

  /// Classify emotion using TFLite model
  Future<EmotionResult> _classifyWithTFLite(String imagePath, Face face) async {
    try {
      // Load and preprocess image
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Extract face region
      final boundingBox = face.boundingBox;
      final faceImage = img.copyCrop(
        image,
        x: boundingBox.left.toInt(),
        y: boundingBox.top.toInt(),
        width: boundingBox.width.toInt(),
        height: boundingBox.height.toInt(),
      );

      // Resize to model input size (typically 48x48 for emotion models)
      final resizedImage = img.copyResize(faceImage, width: 48, height: 48);

      // Convert to grayscale and normalize
      final grayscaleImage = img.grayscale(resizedImage);
      final input = Float32List(48 * 48);

      for (int y = 0; y < 48; y++) {
        for (int x = 0; x < 48; x++) {
          final pixel = grayscaleImage.getPixel(x, y);
          // Normalize to [-1, 1]
          input[y * 48 + x] = (img.getLuminance(pixel) - 127.5) / 127.5;
        }
      }

      // Run inference
      final output = Float32List(
        7,
      ); // 7 emotions (happy, sad, surprised, fearful, angry, disgusted, neutral)
      _emotionInterpreter!.run(
        input.reshape([1, 48, 48, 1]),
        output.reshape([1, 7]),
      );

      // Find emotion with highest confidence
      int maxIndex = 0;
      double maxConfidence = output[0];
      for (int i = 1; i < output.length; i++) {
        if (output[i] > maxConfidence) {
          maxConfidence = output[i];
          maxIndex = i;
        }
      }

      // Map index to emotion type based on labels.txt order
      // 0 Happy, 1 Sad, 2 Surprised, 3 Fearful, 4 Angry, 5 Disgusted, 6 Neutral
      final emotionMapping = [
        EmotionType.happy, // 0
        EmotionType.sad, // 1
        EmotionType.surprised, // 2
        EmotionType.fearful, // 3
        EmotionType.angry, // 4
        EmotionType.disgusted, // 5
        EmotionType.neutral, // 6
      ];

      final detectedEmotion = emotionMapping[maxIndex];

      return EmotionResult(
        emotion: detectedEmotion,
        confidence: maxConfidence,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error in TFLite classification: $e');
      }
      return _getMockEmotionResult();
    }
  }

  /// Mock emotion classification based on face features
  EmotionResult _classifyWithMockDetection(Face face) {
    try {
      // Use face classification if available (from ML Kit)
      double happyProb = 0.2;
      double sadProb = 0.2;

      if (face.smilingProbability != null) {
        happyProb = face.smilingProbability!;
        sadProb = 1.0 - happyProb;
      }

      // Simple rule-based emotion detection
      EmotionType emotion;
      double confidence;

      if (happyProb > 0.7) {
        emotion = EmotionType.happy;
        confidence = happyProb;
      } else if (happyProb < 0.3) {
        emotion = EmotionType.sad;
        confidence = sadProb;
      } else if (face.headEulerAngleY != null &&
          face.headEulerAngleY!.abs() > 15) {
        emotion = EmotionType.surprised;
        confidence = 0.6;
      } else {
        emotion = EmotionType.neutral;
        confidence = 0.5;
      }

      return EmotionResult(
        emotion: emotion,
        confidence: confidence,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return _getMockEmotionResult();
    }
  }

  /// Get random mock emotion result for testing
  EmotionResult _getMockEmotionResult() {
    final random = math.Random();
    final emotions = EmotionType.values;
    final randomEmotion = emotions[random.nextInt(emotions.length)];
    final confidence = 0.6 + (random.nextDouble() * 0.3); // 0.6 to 0.9

    return EmotionResult(
      emotion: randomEmotion,
      confidence: confidence,
      timestamp: DateTime.now(),
    );
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Check if TFLite model is loaded
  bool get hasTFLiteModel => _emotionInterpreter != null;

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _faceDetector?.close();
      _faceDetector = null;

      _emotionInterpreter?.close();
      _emotionInterpreter = null;

      _isInitialized = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error disposing EmotionService: $e');
      }
    }
  }
}
