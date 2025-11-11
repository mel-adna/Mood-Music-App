import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/mood_display_widget.dart';

/// Main home screen with camera preview and emotion detection
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize camera through provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppStateProvider>().initializeCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final appState = context.read<AppStateProvider>();

    if (state == AppLifecycleState.inactive) {
      // Handle camera disposal if needed
    } else if (state == AppLifecycleState.resumed) {
      appState.initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: colorScheme.surface,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.tertiary],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.music_note_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Mood Music',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      'Let your mood pick the playlist',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                color: colorScheme.primary,
                tooltip: 'Refresh camera',
                onPressed: () {
                  appState.clearCurrentEmotion();
                  appState.initializeCamera();
                },
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StatusBanner(message: appState.statusMessage),
                  Expanded(
                    flex: 11,
                    child: _CameraSection(
                      appState: appState,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ControlButtons(appState: appState),
                  const SizedBox(height: 16),
                  Flexible(flex: 9, child: _MoodSection(appState: appState)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CameraSection extends StatelessWidget {
  const _CameraSection({required this.appState, required this.color});

  final AppStateProvider appState;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _CameraView(appState: appState, accentColor: color),
    );
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView({required this.appState, required this.accentColor});

  final AppStateProvider appState;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!appState.isCameraInitialized ||
        appState.cameraService.controller == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accentColor.withValues(alpha: 0.12),
              accentColor.withValues(alpha: 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 52,
                color: colorScheme.onPrimaryContainer,
              ),
              const SizedBox(height: 12),
              Text(
                appState.statusMessage.isNotEmpty
                    ? appState.statusMessage
                    : 'Camera warming up…',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              if (appState.statusMessage.contains('permission'))
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: FilledButton(
                    onPressed: () => appState.initializeCamera(),
                    child: const Text('Retry'),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(appState.cameraService.controller!),
        ),
        if (appState.isDetecting)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Analyzing your expression…',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (!appState.isDetecting && appState.isCameraInitialized)
          Positioned.fill(
            child: CustomPaint(
              painter: FaceGuidePainter(
                accentColor: accentColor.withValues(alpha: 0.75),
              ),
            ),
          ),
      ],
    );
  }
}

class _ControlButtons extends StatelessWidget {
  const _ControlButtons({required this.appState});

  final AppStateProvider appState;

  @override
  Widget build(BuildContext context) {
    final detectDisabled =
        !appState.isCameraInitialized || appState.isDetecting;

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: detectDisabled ? null : () => appState.detectEmotion(),
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Detect mood'),
          ),
        ),
        if (appState.currentEmotion != null) ...[
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => appState.playMusicForEmotion(
                appState.currentEmotion!.emotion,
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Play music'),
            ),
          ),
        ],
      ],
    );
  }
}

class _MoodSection extends StatelessWidget {
  const _MoodSection({required this.appState});

  final AppStateProvider appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final key = appState.isDetecting
        ? const ValueKey('detecting')
        : ValueKey(appState.currentEmotion?.emotion ?? 'empty');

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: Container(
        key: key,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: MoodDisplayWidget(
          emotionResult: appState.currentEmotion,
          isDetecting: appState.isDetecting,
          onPlayMusic: appState.currentEmotion != null
              ? () => appState.playMusicForEmotion(
                  appState.currentEmotion!.emotion,
                )
              : null,
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: message.isEmpty
          ? const SizedBox(height: 8)
          : Container(
              key: ValueKey(message),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Custom painter for face detection guide overlay
class FaceGuidePainter extends CustomPainter {
  FaceGuidePainter({required this.accentColor});

  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;

    // Draw circular face guide
    canvas.drawCircle(center, radius, paint);

    // Draw corner brackets
    final bracketLength = radius * 0.3;
    final bracketOffset = radius * 0.7;

    // Top-left bracket
    canvas.drawLine(
      Offset(center.dx - bracketOffset, center.dy - bracketOffset),
      Offset(
        center.dx - bracketOffset + bracketLength,
        center.dy - bracketOffset,
      ),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - bracketOffset, center.dy - bracketOffset),
      Offset(
        center.dx - bracketOffset,
        center.dy - bracketOffset + bracketLength,
      ),
      paint,
    );

    // Top-right bracket
    canvas.drawLine(
      Offset(center.dx + bracketOffset, center.dy - bracketOffset),
      Offset(
        center.dx + bracketOffset - bracketLength,
        center.dy - bracketOffset,
      ),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + bracketOffset, center.dy - bracketOffset),
      Offset(
        center.dx + bracketOffset,
        center.dy - bracketOffset + bracketLength,
      ),
      paint,
    );

    // Bottom-left bracket
    canvas.drawLine(
      Offset(center.dx - bracketOffset, center.dy + bracketOffset),
      Offset(
        center.dx - bracketOffset + bracketLength,
        center.dy + bracketOffset,
      ),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - bracketOffset, center.dy + bracketOffset),
      Offset(
        center.dx - bracketOffset,
        center.dy + bracketOffset - bracketLength,
      ),
      paint,
    );

    // Bottom-right bracket
    canvas.drawLine(
      Offset(center.dx + bracketOffset, center.dy + bracketOffset),
      Offset(
        center.dx + bracketOffset - bracketLength,
        center.dy + bracketOffset,
      ),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + bracketOffset, center.dy + bracketOffset),
      Offset(
        center.dx + bracketOffset,
        center.dy + bracketOffset - bracketLength,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
