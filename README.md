 # Mood Music App 🎵😊

A Flutter application that detects your mood through facial emotion recognition and recommends matching music playlists from Spotify.

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

## ✨ Features

- **Real-time Emotion Detection**: Uses camera and ML Kit to analyze facial expressions
- **Smart Music Recommendations**: Matches detected emotions to curated Spotify playlists
- **Beautiful UI**: Clean, modern interface with emotion-based color themes
- **Cross-Platform**: Works on Android, iOS, and other Flutter-supported platforms
- **Offline Fallback**: Continues to work with fallback playlists when offline

📸 Screenshots
<p align="center"> <img src="https://github.com/user-attachments/assets/cd93a381-3e9d-4415-8bd3-dd26713433fb" width="45%" /> <img src="https://github.com/user-attachments/assets/a2692150-338a-4f74-a26d-34e8ba294e5e" width="45%" /> </p>

## 🔬 How It Works

1. **Camera Capture**: The app uses your device's front camera to capture your facial expression
2. **Emotion Analysis**: Machine learning models (ML Kit + TensorFlow Lite) analyze the image to detect emotions
3. **Music Matching**: The detected emotion is mapped to appropriate Spotify playlists
4. **Playlist Recommendation**: You receive a personalized music recommendation that matches your mood

## 😄 Supported Emotions

- **Happy** 😄 - Upbeat and joyful music
- **Sad** 😢 - Melancholic and reflective songs
- **Angry** 😠 - Intense and powerful tracks *(in development)*
- **Surprised** 😲 - Energetic and exciting music
- **Fearful** 😨 - Calming and peaceful sounds *(in development)*
- **Disgusted** 🤢 - Alternative and edgy music *(in development)*
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

## 🚀 Setup Instructions

### Prerequisites
- **Flutter SDK**: Version 3.9.2 or higher ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Spotify Developer Account**: Register at [Spotify for Developers](https://developer.spotify.com/)
- **IDE**: VS Code or Android Studio with Flutter extensions

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/mel-adna/Mood-Music-App.git
   cd Mood-Music-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Spotify API** ⚠️ **IMPORTANT**
   
   a. Create a Spotify app:
   - Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
   - Click "Create app"
   - Fill in the details and create
   - Note your **Client ID** and **Client Secret**
   
   b. Update credentials:
   - Open `lib/config/environment.dart`
   - Replace the placeholder values:
   ```dart
   static const String spotifyClientId = 'YOUR_SPOTIFY_CLIENT_ID_HERE';
   static const String spotifyClientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET_HERE';
   ```
   
   > ⚠️ **Security Warning**: Never commit your actual API credentials to version control!

4. **Add ML Models** *(Optional for production)*
   - The app includes mock emotion detection by default
   - For real ML models, place your TensorFlow Lite model in `assets/tflite/`
   - Update `lib/config/environment.dart` to disable mock detection

5. **Run the app**
   ```bash
   flutter run
   ```

For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md) and [SPOTIFY_SETUP.md](SPOTIFY_SETUP.md).

## 📦 Dependencies

### Core Dependencies
- **camera** `^0.10.6` - Camera functionality for image capture
- **google_ml_kit_face_detection** `^0.10.1` - Face detection and analysis
- **tflite_flutter** `^0.11.0` - TensorFlow Lite integration for emotion classification
- **http** `^1.1.2` - HTTP requests for Spotify Web API

### UI and State Management
- **provider** `^6.1.1` - State management
- **flutter_spinkit** `^5.2.0` - Loading animations
- **cupertino_icons** `^1.0.8` - iOS-style icons

### Utilities
- **permission_handler** `^11.1.0` - Camera permissions
- **shared_preferences** `^2.2.2` - Local data storage
- **path_provider** `^2.1.2` - File system access
- **url_launcher** `^6.2.2` - Opening Spotify links
- **image** `^4.1.7` - Image processing

See [pubspec.yaml](pubspec.yaml) for complete dependency list.

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) to get started.

### Quick Start for Contributors
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## � License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🚧 Future Enhancements

- [ ] **User Authentication**: Spotify login for personalized playlists
- [ ] **Playlist Creation**: Automatically create playlists based on emotion history
- [ ] **Social Features**: Share mood and music with friends
- [ ] **Advanced ML**: More sophisticated emotion detection models
- [ ] **Music Integration**: Direct music playback within the app
- [ ] **Mood History**: Track emotional patterns over time
- [ ] **Multi-language Support**: Internationalization

## 🐛 Known Issues

- Some emotions (Angry, Fearful, Disgusted) are still in development
- Camera preview may freeze on some Android devices (restart camera to fix)

## 📞 Support

If you encounter any issues or have questions:
- Check the [Issues](https://github.com/mel-adna/Mood-Music-App/issues) page
- Read the [SETUP_GUIDE.md](SETUP_GUIDE.md)
- Open a new issue with detailed information

## 🙏 Acknowledgments

- Google ML Kit for face detection
- Spotify Web API for music integration
- Flutter team for the amazing framework

---

**Made with ❤️ and Flutter**

*Feel the music that matches your mood!*
