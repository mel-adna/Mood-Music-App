import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

/// Splash screen that initializes the app and navigates to home
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _startInitialization();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Start app initialization
  Future<void> _startInitialization() async {
    // Start animations
    _animationController.forward();

    try {
      // Initialize app state
      final appState = context.read<AppStateProvider>();
      await appState.initialize();

      // Wait for minimum splash time (for better UX)
      await Future.delayed(const Duration(seconds: 3));

      // Navigate to home
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      // Handle initialization error
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  /// Show error dialog if initialization fails
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Initialization Error'),
        content: Text('Failed to initialize app: $error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startInitialization(); // Retry
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: const Text('Continue Anyway'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF673AB7), // Deep Purple
              Color(0xFF9C27B0), // Purple
              Color(0xFFE91E63), // Pink
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App icon/logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mood,
                          size: 80,
                          color: Color(0xFF673AB7),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // App name
                      const Text(
                        'Mood Music',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Tagline
                      const Text(
                        'Music that matches your mood',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 64),

                      // Loading indicator
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),

                      // Status text
                      Consumer<AppStateProvider>(
                        builder: (context, appState, child) {
                          return Text(
                            appState.statusMessage.isEmpty
                                ? 'Initializing...'
                                : appState.statusMessage,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
