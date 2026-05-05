import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/cyberpunk_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: CyberpunkTheme.gradientBackground,
        child: Stack(
          children: [
            // Animated background grid
            CustomPaint(
              size: size,
              painter: _GridPainter(),
            ),
            // Glow effect at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: size.height * 0.4,
              child: Container(
                decoration: CyberpunkTheme.bottomGlowDecoration,
              ),
            ),
            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Icon with glow
                    Container(
                      width: 120,
                      height: 120,
                      decoration: CyberpunkTheme.neonBorderDecoration,
                      child: const Icon(
                        Icons.hub,
                        size: 64,
                        color: CyberpunkTheme.primaryNeon,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .shimmer(duration: 2000.ms, color: CyberpunkTheme.secondaryNeon.withOpacity(0.3))
                        .animate()
                        .scale(begin: const Offset(0.9, 0.9), duration: 600.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 32),
                    // Title
                    const Text(
                      'BITVERSE',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: CyberpunkTheme.primaryNeon,
                        letterSpacing: 16,
                        fontFamily: 'monospace',
                        shadows: [
                          Shadow(
                            color: CyberpunkTheme.primaryNeon,
                            blurRadius: 20,
                          ),
                          Shadow(
                            color: CyberpunkTheme.secondaryNeon,
                            blurRadius: 40,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 800.ms)
                        .slideY(begin: 0.3, curve: Curves.easeOut),
                    const SizedBox(height: 8),
                    // Subtitle
                    const Text(
                      'QUANTUM CIVILIZATION BUILDER',
                      style: TextStyle(
                        fontSize: 14,
                        color: CyberpunkTheme.textSecondary,
                        letterSpacing: 4,
                        fontFamily: 'monospace',
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .then()
                        .shimmer(delay: 1000.ms, duration: 1500.ms, color: CyberpunkTheme.accentNeon.withOpacity(0.5)),
                    const SizedBox(height: 48),
                    // Loading indicator
                    SizedBox(
                      width: 200,
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            backgroundColor: CyberpunkTheme.surfaceDark,
                            valueColor: const AlwaysStoppedAnimation<Color>(CyberpunkTheme.primaryNeon),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'INITIALIZING QUANTUM ENGINE...',
                            style: TextStyle(
                              fontSize: 10,
                              color: CyberpunkTheme.textSecondary,
                              letterSpacing: 2,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 400.ms),
                    const SizedBox(height: 16),
                    // Version
                    const Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: CyberpunkTheme.textSecondary,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(delay: 1500.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberpunkTheme.primaryNeon.withOpacity(0.05)
      ..strokeWidth = 1;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
