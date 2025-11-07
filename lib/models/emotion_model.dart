/// Enum defining the different types of emotions that can be detected
enum EmotionType { happy, sad, surprised, fearful, angry, disgusted, neutral }

/// Extension methods for EmotionType to provide additional functionality
extension EmotionTypeExtension on EmotionType {
  /// Convert enum to string representation
  String get name {
    switch (this) {
      case EmotionType.happy:
        return 'happy';
      case EmotionType.sad:
        return 'sad';
      case EmotionType.angry:
        return 'angry';
      case EmotionType.surprised:
        return 'surprised';
      case EmotionType.fearful:
        return 'fearful';
      case EmotionType.disgusted:
        return 'disgusted';
      case EmotionType.neutral:
        return 'neutral';
    }
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case EmotionType.happy:
        return 'Happy';
      case EmotionType.sad:
        return 'Sad';
      case EmotionType.angry:
        return 'Angry';
      case EmotionType.surprised:
        return 'Surprised';
      case EmotionType.fearful:
        return 'Fearful';
      case EmotionType.disgusted:
        return 'Disgusted';
      case EmotionType.neutral:
        return 'Neutral';
    }
  }

  /// Get emoji representation
  String get emoji {
    switch (this) {
      case EmotionType.happy:
        return '😄';
      case EmotionType.sad:
        return '😢';
      case EmotionType.angry:
        return '😠';
      case EmotionType.surprised:
        return '😲';
      case EmotionType.fearful:
        return '😨';
      case EmotionType.disgusted:
        return '🤢';
      case EmotionType.neutral:
        return '😐';
    }
  }

  /// Get Spotify playlist URI for this emotion
  String get spotifyPlaylistUri {
    switch (this) {
      case EmotionType.happy:
        return 'spotify:playlist:37i9dQZF1DX0XUsuxWHRQd'; // Happy Hits
      case EmotionType.sad:
        return 'spotify:playlist:37i9dQZF1DX7qK8ma5wgG1'; // Life Sucks
      case EmotionType.angry:
        return 'spotify:playlist:37i9dQZF1DXdxcBWuJkbcy'; // Angry Metal
      case EmotionType.surprised:
        return 'spotify:playlist:37i9dQZF1DX4WYpdgoIcn6'; // Chill Hits
      case EmotionType.fearful:
        return 'spotify:playlist:37i9dQZF1DX1s9knjP51Oa'; // Dark & Stormy
      case EmotionType.disgusted:
        return 'spotify:playlist:37i9dQZF1DX6VdMW310YC7'; // Alternative
      case EmotionType.neutral:
        return 'spotify:playlist:37i9dQZF1DXcBWIGoYBM5M'; // Today's Top Hits
    }
  }

  /// Get Spotify playlist web URL
  String get spotifyWebUrl {
    switch (this) {
      case EmotionType.happy:
        return 'https://open.spotify.com/playlist/37i9dQZF1DX0XUsuxWHRQd';
      case EmotionType.sad:
        return 'https://open.spotify.com/playlist/37i9dQZF1DX7qK8ma5wgG1';
      case EmotionType.angry:
        return 'https://open.spotify.com/playlist/37i9dQZF1DXdxcBWuJkbcy';
      case EmotionType.surprised:
        return 'https://open.spotify.com/playlist/37i9dQZF1DX4WYpdgoIcn6';
      case EmotionType.fearful:
        return 'https://open.spotify.com/playlist/37i9dQZF1DX1s9knjP51Oa';
      case EmotionType.disgusted:
        return 'https://open.spotify.com/playlist/37i9dQZF1DX6VdMW310YC7';
      case EmotionType.neutral:
        return 'https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M';
    }
  }
}

/// Class representing an emotion detection result
class EmotionResult {
  final EmotionType emotion;
  final double confidence;
  final DateTime timestamp;

  EmotionResult({
    required this.emotion,
    required this.confidence,
    required this.timestamp,
  });

  /// Create EmotionResult from JSON
  factory EmotionResult.fromJson(Map<String, dynamic> json) {
    return EmotionResult(
      emotion: EmotionType.values.firstWhere(
        (e) => e.name == json['emotion'],
        orElse: () => EmotionType.neutral,
      ),
      confidence: json['confidence']?.toDouble() ?? 0.0,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  /// Convert EmotionResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'emotion': emotion.name,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Check if the detection is reliable based on confidence
  bool get isReliable => confidence >= 0.6;

  /// Get formatted confidence percentage
  String get confidencePercentage => '${(confidence * 100).toInt()}%';

  @override
  String toString() {
    return 'EmotionResult(emotion: ${emotion.displayName}, confidence: $confidencePercentage, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmotionResult &&
        other.emotion == emotion &&
        other.confidence == confidence &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return emotion.hashCode ^ confidence.hashCode ^ timestamp.hashCode;
  }
}

/// Helper class for emotion-related operations
class EmotionHelper {
  /// Get all available emotions
  static List<EmotionType> getAllEmotions() {
    return EmotionType.values;
  }

  /// Get emotion from string
  static EmotionType? emotionFromString(String emotion) {
    try {
      return EmotionType.values.firstWhere(
        (e) => e.name.toLowerCase() == emotion.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get random emotion (for testing)
  static EmotionType getRandomEmotion() {
    final emotions = EmotionType.values;
    final randomIndex = DateTime.now().millisecond % emotions.length;
    return emotions[randomIndex];
  }
}
