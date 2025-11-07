/// Environment configuration for API keys and settings
class Environment {
  // Spotify API Configuration
  // Configured with your Spotify App credentials
  // Get these from: https://developer.spotify.com/dashboard
  static const String spotifyClientId = '2fce32d68b334388a19632cd3e3c281d';
  static const String spotifyClientSecret = 'de57d32b514c4984a790bad8a798ce79';
  static const String spotifyRedirectUri = 'moodmusic://callback';

  // API Endpoints
  static const String spotifyApiBaseUrl = 'https://api.spotify.com/v1';
  static const String spotifyAccountsBaseUrl = 'https://accounts.spotify.com';

  // App Configuration
  static const String appPackageName = 'com.example.mood_music_app';
  static const String appScheme = 'moodmusic';

  // TFLite Model Configuration
  static const String emotionModelPath = 'assets/tflite/model.tflite';
  static const int modelInputSize = 48; // Standard emotion detection model size
  static const List<String> emotionLabels = [
    'happy',
    'sad',
    'surprised',
    'fearful',
    'angry',
    'disgusted',
    'neutral',
  ];

  // Feature Flags
  static const bool enableMockEmotionDetection =
      true; // Set to false when real model is available
  static const bool enableSpotifyIntegration = true;
  static const bool enableEmotionHistory = true;

  // Development Settings
  static const bool isDebugMode = true; // Set to false for production
  static const Duration splashScreenDuration = Duration(seconds: 3);
  static const Duration cameraInitTimeout = Duration(seconds: 10);

  // Validation Methods
  static bool get hasValidSpotifyCredentials {
    return spotifyClientId != 'YOUR_SPOTIFY_CLIENT_ID_HERE' &&
        spotifyClientSecret != 'YOUR_SPOTIFY_CLIENT_SECRET_HERE' &&
        spotifyClientId.isNotEmpty &&
        spotifyClientSecret.isNotEmpty;
  }

  static bool get isProductionBuild {
    return !isDebugMode;
  }
}

/// Development-only configuration
class DevEnvironment {
  // Test data for development
  static const String testImagePath = 'assets/test_images/sample_face.jpg';

  // Mock API responses
  static const Map<String, dynamic> mockSpotifyResponse = {
    'access_token': 'mock_token',
    'token_type': 'Bearer',
    'expires_in': 3600,
  };

  // Feature toggle for testing
  static const bool useMockServices = false;
}
