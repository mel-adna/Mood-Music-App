# Mood Music App 🎵😊

A Flutter application that detects your mood through facial emotion recognition and recommends matching music playlists from Spotify.

## Features ✨

- **Real-time Emotion Detection**: Uses camera and ML Kit to analyze facial expressions
- **Smart Music Recommendations**: Matches detected emotions to curated Spotify playlists
- **Beautiful UI**: Clean, modern interface with emotion-based color themes
- **Cross-Platform**: Works on Android, iOS, and other Flutter-supported platforms
- **Offline Fallback**: Continues to work with fallback playlists when offline

## How It Works 🔬

1. **Camera Capture**: The app uses your device's front camera to capture your facial expression
2. **Emotion Analysis**: Machine learning models (ML Kit + TensorFlow Lite) analyze the image to detect emotions
3. **Music Matching**: The detected emotion is mapped to appropriate Spotify playlists
4. **Playlist Recommendation**: You receive a personalized music recommendation that matches your mood

## Supported Emotions 😄

- **Happy** 😄 - Upbeat and joyful music
- **Sad** 😢 - Melancholic and reflective songs
- **Angry** 😠 - Intense and powerful tracks
- **Surprised** 😲 - Energetic and exciting music
- **Fearful** 😨 - Calming and peaceful sounds
- **Disgusted** 🤢 - Alternative and edgy music
- **Neutral** 😐 - Balanced and versatile playlists

## Project Structure 📁

```
mood_music_app/
├── android/                # Flutter Android build configuration
├── ios/                    # Flutter iOS build configuration
├── lib/
│   ├── main.dart           # App entry point with service initialization
│   ├── app.dart            # Main app widget with routing and theming
│   ├── screens/
│   │   ├── home_screen.dart      # Main screen with camera + emotion + playlist
│   │   └── loading_screen.dart   # App loading screen with animations
│   ├── widgets/
│   │   └── emotion_display.dart  # Widget for displaying detected emotions
│   ├── services/
│   │   ├── camera_service.dart   # Camera management and image capture
│   │   ├── emotion_service.dart  # ML Kit + TFLite emotion classification
│   │   └── spotify_service.dart  # Spotify Web API integration
│   ├── models/
│   │   └── emotion_model.dart    # Data models for emotions and results
│   └── utils/
│       └── constants.dart        # App constants, playlist mappings, colors
├── assets/
│   ├── images/             # App images and icons
│   ├── models/             # TensorFlow Lite models for emotion detection
│   └── fonts/              # Custom fonts
├── pubspec.yaml            # Dependencies and configuration
└── README.md               # This file
```

## Dependencies 📦

### Core Flutter Dependencies
- **camera**: Camera functionality for image capture
- **google_ml_kit**: Face detection and analysis
- **tflite_flutter**: TensorFlow Lite integration for emotion classification
- **http**: HTTP requests for Spotify Web API

### UI and UX Dependencies
- **flutter_spinkit**: Beautiful loading animations
- **provider**: State management (for future enhancements)
- **url_launcher**: Opening Spotify links

### Utility Dependencies
- **permission_handler**: Camera permissions
- **shared_preferences**: Local data storage
- **path_provider**: File system access
- **image_picker**: Additional image functionality

## Setup Instructions 🚀

### Prerequisites
1. **Flutter SDK**: Install Flutter (3.9.2 or higher)
2. **Spotify Developer Account**: Register at [Spotify for Developers](https://developer.spotify.com/)
3. **ML Models**: Download emotion detection models (see ML Setup section)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mood_music_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Spotify API**
   - Create a new app in your Spotify Developer Dashboard
   - Copy your Client ID and Client Secret
   - Update `lib/utils/constants.dart`:
   ```dart
   class SpotifyConstants {
     static const String clientId = 'your_client_id_here';
     static const String clientSecret = 'your_client_secret_here';
   }
   ```

4. **Add ML Models** (Optional for production)
   - Download a pre-trained emotion detection TensorFlow Lite model
   - Place the model file in `assets/models/emotion_model.tflite`
   - Add corresponding labels file in `assets/models/emotion_labels.txt`

5. **Run the app**
   ```bash
   flutter run
   ```

## Future Enhancements 🚀

- **User Authentication**: Spotify login for personalized playlists
- **Playlist Creation**: Automatically create playlists based on emotion history
- **Social Features**: Share mood and music with friends
- **Advanced ML**: More sophisticated emotion detection models
- **Music Integration**: Direct music playback within the app

---

**Made with ❤️ and Flutter**

*Feel the music that matches your mood!*
# Mood-Music-App
