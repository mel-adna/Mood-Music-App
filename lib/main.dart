import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/app_state_provider.dart';

/// Main entry point of the Mood Music App
Future<void> main() async {
  // Ensure Flutter is properly initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Run the app with Provider
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppStateProvider(),
      child: const MoodMusicApp(),
    ),
  );
}
