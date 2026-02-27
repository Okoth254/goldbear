import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _widthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Route based on mock session state after splash
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) {
        final nextRoute = AuthService.instance.isSignedIn
            ? '/home'
            : (AuthService.instance.hasSeenOnboarding
                  ? '/login'
                  : '/onboarding');
        context.go(nextRoute);
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          // Texture overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 760;
                final iconSize = compact ? 130.0 : 180.0;
                final verticalPad = compact ? 20.0 : 48.0;
                final brandGap = compact ? 20.0 : 48.0;
                final bottomGap = compact ? 12.0 : 24.0;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: verticalPad,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 8),
                      // Center content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: iconSize,
                            height: iconSize,
                            child: CustomPaint(
                              painter: ChairSketchPainter(
                                animation: _controller,
                              ),
                            ),
                          ),
                          SizedBox(height: brandGap),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                Text(
                                  'ATELIER',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.w300,
                                        fontSize: compact ? 40 : null,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Maison & Objet',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        letterSpacing: 0.3,
                                        color: AppTheme.deepForest.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Loading indicator
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 2,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.charcoalBark.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: _widthAnimation,
                                  builder: (context, child) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: 160 * _widthAnimation.value,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          color: AppTheme.deepForest,
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                AnimatedBuilder(
                                  animation: _widthAnimation,
                                  builder: (context, child) {
                                    return Positioned(
                                      left: (160 * _widthAnimation.value) - 2,
                                      top: 0,
                                      child: Container(
                                        width: 2,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          color: AppTheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.primary
                                                  .withValues(alpha: 0.8),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: bottomGap),
                          Text(
                            'CURATING GALLERY',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 0.15,
                              color: AppTheme.charcoalBark.withValues(
                                alpha: 0.4,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChairSketchPainter extends CustomPainter {
  final Animation<double> animation;

  ChairSketchPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.charcoalBark
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final progress = animation.value;

    // Scale factor based on animation
    final drawProgress = (progress * 2.5).clamp(0.0, 1.0);

    if (drawProgress > 0) {
      // Backrest
      path.moveTo(size.width * 0.3, size.height * 0.7);
      path.lineTo(size.width * 0.3, size.height * 0.4);
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.2,
        size.width * 0.7,
        size.height * 0.4,
      );
      path.lineTo(size.width * 0.7, size.height * 0.7);
      canvas.drawPath(path, paint);
    }

    if (drawProgress > 0.3) {
      // Seat
      final seatPaint = Paint()
        ..color = AppTheme.charcoalBark
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(size.width * 0.25, size.height * 0.7),
        Offset(size.width * 0.75, size.height * 0.7),
        seatPaint,
      );
    }

    if (drawProgress > 0.5) {
      // Seat curve
      final seatCurvePaint = Paint()
        ..color = AppTheme.charcoalBark
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final seatCurve = Path();
      seatCurve.moveTo(size.width * 0.3, size.height * 0.7);
      seatCurve.quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.8,
        size.width * 0.7,
        size.height * 0.7,
      );
      canvas.drawPath(seatCurve, seatCurvePaint);
    }

    if (drawProgress > 0.7) {
      // Legs
      final legPaint = Paint()
        ..color = AppTheme.charcoalBark
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(size.width * 0.3, size.height * 0.7),
        Offset(size.width * 0.25, size.height * 0.9),
        legPaint,
      );
      canvas.drawLine(
        Offset(size.width * 0.7, size.height * 0.7),
        Offset(size.width * 0.75, size.height * 0.9),
        legPaint,
      );
    }

    // Decorative strokes
    if (drawProgress > 0.9) {
      final decorPaint = Paint()
        ..color = AppTheme.primary.withValues(alpha: 0.4)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(size.width * 0.8, size.height * 0.3),
        Offset(size.width * 0.85, size.height * 0.25),
        decorPaint,
      );
      canvas.drawLine(
        Offset(size.width * 0.82, size.height * 0.35),
        Offset(size.width * 0.87, size.height * 0.3),
        decorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ChairSketchPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value;
  }
}
