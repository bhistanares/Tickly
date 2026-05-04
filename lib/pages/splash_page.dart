import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _shineController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.84, end: 1).animate(
      CurvedAnimation(parent: _introController, curve: Curves.elasticOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.22), end: Offset.zero).animate(
          CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
        );

    _introController.forward();
    _timer = Timer(const Duration(milliseconds: 2600), _openHome);
  }

  void _openHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const HomePage(),
        transitionDuration: const Duration(milliseconds: 520),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _introController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _openHome,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8A4B27), Color(0xFFB06A32), Color(0xFF7A3D22)],
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: _WarmTexture()),
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _TicklyBadge(shineAnimation: _shineController),
                          const SizedBox(height: 28),
                          const Text(
                            'Tickly',
                            style: TextStyle(
                              color: Color(0xFFFFE8B3),
                              fontFamily: 'Kranky',
                              fontSize: 60,
                              height: 1,
                              shadows: [
                                Shadow(
                                  color: Color(0x99000000),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                                Shadow(
                                  color: Color(0x99FFF0C7),
                                  blurRadius: 12,
                                  offset: Offset(0, -1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Rapi hari ini, ringan nanti',
                            style: TextStyle(
                              color: AppColors.cream.withValues(alpha: 0.84),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicklyBadge extends StatelessWidget {
  const _TicklyBadge({required this.shineAnimation});

  final Animation<double> shineAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shineAnimation,
      builder: (context, child) {
        final lift = (shineAnimation.value - 0.5) * 8;

        return Transform.translate(
          offset: Offset(0, lift),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 178,
                height: 178,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE6B25B),
                      Color(0xFF9B572C),
                      Color(0xFFD78A3F),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFFFE4A7).withValues(alpha: 0.72),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x77000000),
                      blurRadius: 36,
                      offset: Offset(0, 20),
                    ),
                    BoxShadow(
                      color: Color(0x66FFE0A0),
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -18,
                      bottom: -24,
                      child: Container(
                        width: 120,
                        height: 160,
                        decoration: BoxDecoration(
                          color: AppColors.cream.withValues(alpha: 0.11),
                          borderRadius: BorderRadius.circular(70),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 104,
                        height: 124,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8B3),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66000000),
                              blurRadius: 16,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fact_check_rounded,
                          color: Color(0xFF8A4B27),
                          size: 70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: -12,
                top: 68,
                child: _Sparkle(
                  size: 28,
                  opacity: 0.74 + shineAnimation.value * 0.2,
                ),
              ),
              Positioned(
                right: -12,
                top: 28,
                child: _Sparkle(
                  size: 34,
                  opacity: 0.72 + shineAnimation.value * 0.24,
                ),
              ),
              Positioned(
                right: 12,
                top: 62,
                child: _Sparkle(
                  size: 24,
                  opacity: 0.58 + shineAnimation.value * 0.28,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome_rounded,
      color: const Color(0xFFFFF1C9).withValues(alpha: opacity.clamp(0, 1)),
      size: size,
      shadows: const [Shadow(color: Color(0xFFFFDF82), blurRadius: 14)],
    );
  }
}

class _WarmTexture extends StatelessWidget {
  const _WarmTexture();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _WarmTexturePainter());
  }
}

class _WarmTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stripePaint = Paint()
      ..color = const Color(0x22F6C783)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), stripePaint);
    }

    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [const Color(0x44FFE1A3), const Color(0x00FFE1A3)],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width / 2, size.height * 0.42),
              radius: size.width * 0.72,
            ),
          );
    canvas.drawRect(Offset.zero & size, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
