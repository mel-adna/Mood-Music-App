# 🎵 Mood Music App - Setup & Testing Guide

## 📋 Prerequisites

### Required Tools
- **Flutter SDK** (3.9.2 or higher)
- **Android Studio** or **VS Code** with Flutter extension
- **Physical Android/iOS device** (TFLite doesn't work on simulators)
- **Spotify account** (Premium recommended for full features)

### Required Accounts
- **Spotify Developer Account** (free) - for API access
- **Google Account** (if testing on Android)

## 🚀 Setup Instructions

### 1. Install Dependencies
```bash
cd mood_music_app
flutter pub get
```

### 2. Configure Spotify API
1. Follow instructions in `SPOTIFY_SETUP.md`
2. Get your Client ID and Secret from https://developer.spotify.com/dashboard
3. Update `lib/config/environment.dart`:
   ```dart
   static const String spotifyClientId = 'YOUR_ACTUAL_CLIENT_ID';
   static const String spotifyClientSecret = 'YOUR_ACTUAL_SECRET';
   ```

### 3. Add TFLite Emotion Model
1. Download a TFLite emotion recognition model
2. Rename it to `emotion_model.tflite`
3. Place it in `assets/models/emotion_model.tflite`
4. See `assets/models/README.md` for model requirements

### 4. Enable Physical Device
- **Android**: Enable Developer Options and USB Debugging
- **iOS**: Trust your developer certificate

## 🧪 Testing Steps

### 1. Basic Build Test
```bash
flutter analyze
flutter test
```

### 2. Device Connection Test
```bash
flutter devices
```
Should show your connected physical device.

### 3. Install and Run
```bash
# For Android
flutter run

# For iOS (if you have iOS device and Mac)
flutter run -d ios
```

### 4. Feature Testing

#### Camera Test
1. Grant camera permission when prompted
2. Verify camera preview appears
3. Check that front camera is selected

#### Emotion Detection Test
1. Tap "Detect Mood" button
2. If no model: Should show mock emotion detection
3. If model exists: Should analyze your facial expression

#### Spotify Integration Test
1. Ensure Spotify app is installed on device
2. Tap music button after emotion detection
3. Should open Spotify with appropriate playlist

## 🔧 Troubleshooting

### Common Issues

#### 1. Camera Permission Denied
**Solution**: Go to device Settings > Apps > Mood Music > Permissions > Camera > Allow

#### 2. TFLite Model Not Found
**Error**: `Custom emotion model not found`
**Solution**: 
- Add `emotion_model.tflite` to `assets/models/`
- Run `flutter clean && flutter pub get`
- App will use mock detection as fallback

#### 3. Spotify Authentication Failed
**Error**: `Failed to authenticate with Spotify`
**Solutions**:
- Verify Client ID/Secret in `environment.dart`
- Check redirect URI matches in Spotify Dashboard
- Install Spotify app on test device

#### 4. Build Errors on Web
**Issue**: TFLite doesn't support web compilation
**Solution**: Only test on physical Android/iOS devices

#### 5. Network Issues
**Error**: API requests failing
**Solutions**:
- Check internet connection
- Verify Android network security config allows HTTP
- Check firewall settings

### Debugging Commands
```bash
# Clear Flutter cache
flutter clean

# Reinstall dependencies
flutter pub get

# Check for issues
flutter doctor

# View device logs
flutter logs

# Build for debugging
flutter build apk --debug
```

## 📱 Platform-Specific Notes

### Android
- **Minimum SDK**: 26 (Android 8.0)
- **Target SDK**: 33
- **Required Permissions**: Camera, Internet, Network State
- **Testing**: Works on Android 8.0+ devices

### iOS
- **Minimum Version**: iOS 12.0
- **Required Permissions**: Camera access description
- **Testing**: Requires Mac and iOS device for full testing

### Web
- **Status**: ⚠️ Limited functionality
- **Limitations**: No TFLite support, no camera access
- **Use Case**: UI testing only

## 🎯 Expected App Behavior

### 1. App Launch
- Splash screen with loading indicator
- App initialization (3 seconds)
- Navigate to camera screen

### 2. Camera View
- Front camera preview
- Face detection guide overlay
- "Detect Mood" button enabled when camera ready

### 3. Emotion Detection
- Capture photo when button pressed
- Analyze facial expression (or show mock result)
- Display emotion with emoji and confidence
- Auto-suggest music based on detected mood

### 4. Music Integration
- Open Spotify app with curated playlist
- Fallback to web player if app not installed
- Show confirmation message

### 5. Data Persistence
- Save detected emotions to local storage
- Load previous mood on app restart
- Maintain emotion history

## 🔄 Development Workflow

1. **Make Changes**: Edit code in your IDE
2. **Hot Reload**: Press `r` in terminal or use IDE hot reload
3. **Test Features**: Verify functionality on device
4. **Debug Issues**: Use `flutter logs` and IDE debugger
5. **Build Release**: `flutter build apk --release` for distribution

## 📊 Success Criteria

✅ **App launches without crashes**
✅ **Camera permission granted and preview shown**
✅ **Emotion detection completes (mock or real)**
✅ **Spotify integration opens playlists**
✅ **UI responsive and intuitive**
✅ **Data persisted between app sessions**

## 🆘 Getting Help

If you encounter issues:

1. **Check logs**: `flutter logs`
2. **Verify setup**: Follow this guide step by step
3. **Update dependencies**: `flutter pub upgrade`
4. **Clean build**: `flutter clean && flutter pub get`
5. **Test on different device**: Hardware-specific issues are common

## 🎉 Ready to Go!

Once setup is complete, your Mood Music App should:
- 📷 Access front camera for emotion detection
- 😊 Recognize facial expressions (or simulate with mock data)
- 🎵 Suggest music based on detected emotions
- 📱 Integrate seamlessly with Spotify
- 💾 Remember your mood history

Enjoy your personalized mood-based music experience! 🎶