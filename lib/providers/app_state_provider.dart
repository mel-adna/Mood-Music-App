import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/emotion_model.dart';
import '../services/camera_service.dart';
import '../services/emotion_service.dart';
import '../services/spotify_service.dart';

/// Provider for managing app-wide state using Provider pattern
class AppStateProvider extends ChangeNotifier {
  // Services
  final CameraService _cameraService = CameraService();
  final EmotionService _emotionService = EmotionService();
  final SpotifyService _spotifyService = SpotifyService();

  // State variables
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  EmotionResult? _currentEmotion;
  EmotionResult? _lastSavedEmotion;
  String _statusMessage = '';
  List<EmotionResult> _emotionHistory = [];

  // Getters
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isDetecting => _isDetecting;
  EmotionResult? get currentEmotion => _currentEmotion;
  EmotionResult? get lastSavedEmotion => _lastSavedEmotion;
  String get statusMessage => _statusMessage;
  List<EmotionResult> get emotionHistory => List.unmodifiable(_emotionHistory);

  // Service getters
  CameraService get cameraService => _cameraService;
  EmotionService get emotionService => _emotionService;
  SpotifyService get spotifyService => _spotifyService;

  /// Initialize app state and load saved data
  Future<void> initialize() async {
    try {
      _setStatus('Initializing app...');

      // Load saved emotion history
      await _loadEmotionHistory();

      // Load last saved emotion
      await _loadLastSavedEmotion();

      _setStatus('');
      notifyListeners();
    } catch (e) {
      _setStatus('Initialization error: ${e.toString()}');
      if (kDebugMode) {
        print('AppStateProvider initialization error: $e');
      }
    }
  }

  /// Initialize camera
  Future<void> initializeCamera() async {
    try {
      _setStatus('Initializing camera...');

      await _cameraService.initializeFrontCamera();
      _isCameraInitialized = true;
      _setStatus('');
    } catch (e) {
      _isCameraInitialized = false;
      _setStatus('Camera initialization failed: ${e.toString()}');
      if (kDebugMode) {
        print('Camera initialization error: $e');
      }
    }
    notifyListeners();
  }

  /// Detect emotion from camera
  Future<void> detectEmotion() async {
    if (!_isCameraInitialized || _isDetecting) return;

    _isDetecting = true;
    _setStatus('Detecting your mood...');
    notifyListeners();

    try {
      // Capture image
      final imagePath = await _cameraService.captureImage();

      // Detect emotion
      final emotion = await _emotionService.detectEmotion(imagePath);

      _currentEmotion = emotion;
      _isDetecting = false;
      _setStatus('Detected: ${emotion.emotion.displayName}');

      // Add to history
      _addToHistory(emotion);

      // Save as last emotion
      await _saveLastEmotion(emotion);

      notifyListeners();
    } catch (e) {
      _isDetecting = false;
      _setStatus('Detection failed: ${e.toString()}');
      notifyListeners();

      if (kDebugMode) {
        print('Emotion detection error: $e');
      }
    }
  }

  /// Play music for given emotion
  Future<void> playMusicForEmotion(EmotionType emotion) async {
    try {
      _setStatus('Opening ${emotion.displayName} playlist...');
      notifyListeners();

      final success = await _spotifyService.playPlaylistForEmotion(emotion);

      if (success) {
        _setStatus('Opened ${emotion.displayName} playlist in Spotify');
      } else {
        _setStatus(
          'Failed to open playlist. Please ensure Spotify is installed.',
        );
      }

      notifyListeners();
    } catch (e) {
      _setStatus('Spotify error: ${e.toString()}');
      notifyListeners();

      if (kDebugMode) {
        print('Spotify playback error: $e');
      }
    }
  }

  /// Clear current emotion
  void clearCurrentEmotion() {
    _currentEmotion = null;
    _setStatus('');
    notifyListeners();
  }

  /// Clear emotion history
  Future<void> clearEmotionHistory() async {
    _emotionHistory.clear();
    await _saveEmotionHistory();
    _setStatus('History cleared');
    notifyListeners();
  }

  /// Get emotion statistics
  Map<EmotionType, int> getEmotionStatistics() {
    final stats = <EmotionType, int>{};

    for (final emotion in EmotionType.values) {
      stats[emotion] = 0;
    }

    for (final result in _emotionHistory) {
      stats[result.emotion] = (stats[result.emotion] ?? 0) + 1;
    }

    return stats;
  }

  /// Get most frequent emotion
  EmotionType? getMostFrequentEmotion() {
    final stats = getEmotionStatistics();
    if (stats.isEmpty) return null;

    EmotionType? mostFrequent;
    int maxCount = 0;

    stats.forEach((emotion, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequent = emotion;
      }
    });

    return mostFrequent;
  }

  /// Private method to set status message
  void _setStatus(String message) {
    _statusMessage = message;
  }

  /// Add emotion result to history
  void _addToHistory(EmotionResult emotion) {
    _emotionHistory.insert(0, emotion); // Add to beginning

    // Keep only last 50 emotions to prevent memory issues
    if (_emotionHistory.length > 50) {
      _emotionHistory = _emotionHistory.take(50).toList();
    }

    // Save to persistent storage
    _saveEmotionHistory();
  }

  /// Load emotion history from SharedPreferences
  Future<void> _loadEmotionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('emotion_history') ?? [];

      _emotionHistory = historyJson
          .map((jsonString) {
            try {
              final json = jsonDecode(jsonString) as Map<String, dynamic>;
              return EmotionResult.fromJson(json);
            } catch (e) {
              return null;
            }
          })
          .where((result) => result != null)
          .cast<EmotionResult>()
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading emotion history: $e');
      }
      _emotionHistory = [];
    }
  }

  /// Save emotion history to SharedPreferences
  Future<void> _saveEmotionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _emotionHistory
          .map((result) => jsonEncode(result.toJson()))
          .toList();

      await prefs.setStringList('emotion_history', historyJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving emotion history: $e');
      }
    }
  }

  /// Load last saved emotion from SharedPreferences
  Future<void> _loadLastSavedEmotion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastEmotionJson = prefs.getString('last_emotion');

      if (lastEmotionJson != null) {
        final json = jsonDecode(lastEmotionJson) as Map<String, dynamic>;
        _lastSavedEmotion = EmotionResult.fromJson(json);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading last emotion: $e');
      }
    }
  }

  /// Save last detected emotion to SharedPreferences
  Future<void> _saveLastEmotion(EmotionResult emotion) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_emotion', jsonEncode(emotion.toJson()));
      _lastSavedEmotion = emotion;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving last emotion: $e');
      }
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    // Cleanup services if needed
    super.dispose();
  }
}
