// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mood_music_app/app.dart';
import 'package:mood_music_app/providers/app_state_provider.dart';

void main() {
  testWidgets('Mood Music App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppStateProvider(),
        child: const MoodMusicApp(),
      ),
    );

    // Verify that our app shows the splash screen
    expect(find.text('Mood Music'), findsOneWidget);
    expect(find.text('Music that matches your mood'), findsOneWidget);

    // Wait for splash screen to complete
    await tester.pump(const Duration(seconds: 4));

    // Verify that we navigate to the home screen
    expect(find.text('Mood Music'), findsOneWidget);
  });
}
