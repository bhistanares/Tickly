import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'auth_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _ambientController;
  late final AnimationController _pressController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<Offset> _contentSlideAnimation;
  Timer? _timer;
  Offset _dragOffset = Offset.zero;
  bool _isOpening = false;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    );
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0, 0.84, curve: Curves.easeOut),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.72, end: 1).animate(
      CurvedAnimation(parent: _introController, curve: Curves.elasticOut),
    );
    _contentSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
        );

    _introController.forward();
    _timer = Timer(const Duration(milliseconds: 4100), _openHome);
  }

  void _openHome() {
    if (!mounted || _isOpening) return;
    _isOpening = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const AuthPage(),
        transitionDuration: const Duration(milliseconds: 680),
        reverseTransitionDuration: const Duration(milliseconds: 420),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.025),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final width = MediaQuery.sizeOf(context).width;
    setState(() {
      _dragOffset += details.delta / width;
      _dragOffset = Offset(
        _dragOffset.dx.clamp(-0.08, 0.08),
        _dragOffset.dy.clamp(-0.08, 0.08),
      );
    });
  }

  void _resetDrag() {
    if (_dragOffset == Offset.zero) return;
    setState(() => _dragOffset = Offset.zero);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _introController.dispose();
    _ambientController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _pressController.forward(),
        onTapCancel: () => _pressController.reverse(),
        onTapUp: (_) {
          _pressController.reverse();
          _openHome();
        },
        onPanUpdate: _handlePanUpdate,
        onPanEnd: (_) => _resetDrag(),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _introController,
            _ambientController,
            _pressController,
          ]),
          builder: (context, child) {
            final ambient = _ambientController.value;
            final reveal = _introController.value;
            final pressScale = 1 - (_pressController.value * 0.035);
            final parallax = Offset(_dragOffset.dx * 22, _dragOffset.dy * 22);

            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _OpeningBackgroundPainter(
                      progress: ambient,
                      dragOffset: _dragOffset,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 34,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _contentSlideAnimation,
                          child: Column(
                            children: [
                              const Spacer(flex: 2),
                              Transform.translate(
                                offset: parallax,
                                child: Transform.scale(
                                  scale: _logoScaleAnimation.value * pressScale,
                                  child: _TicklyOpeningLogo(
                                    progress: ambient,
                                    revealProgress: reveal,
                                    maxWidth: math.min(size.width * 0.64, 230),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Transform.translate(
                                offset: Offset(parallax.dx * 0.35, 0),
                                child: Opacity(
                                  opacity: Curves.easeOut.transform(
                                    ((reveal - 0.58) / 0.32).clamp(0, 1),
                                  ),
                                  child: const Text(
                                    'Tickly',
                                    style: TextStyle(
                                      color: AppColors.forest,
                                      fontFamily: 'Kranky',
                                      fontSize: 64,
                                      height: 0.92,
                                      shadows: [
                                        Shadow(
                                          color: Color(0x55D7C733),
                                          blurRadius: 18,
                                          offset: Offset(0, 8),
                                        ),
                                        Shadow(
                                          color: Color(0x88FFF2C8),
                                          blurRadius: 10,
                                          offset: Offset(0, -1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Opacity(
                                opacity: Curves.easeOut.transform(
                                  ((reveal - 0.68) / 0.24).clamp(0, 1),
                                ),
                                child: Text(
                                  'Atur hari dengan ringan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.muted.withValues(
                                      alpha: 0.88,
                                    ),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 26),
                              _OpeningProgress(
                                progress: _introController.value,
                              ),
                              const Spacer(flex: 3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TicklyOpeningLogo extends StatelessWidget {
  const _TicklyOpeningLogo({
    required this.progress,
    required this.revealProgress,
    required this.maxWidth,
  });

  final double progress;
  final double revealProgress;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      height: maxWidth,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: -18,
            child: Container(
              width: maxWidth * 0.78,
              height: maxWidth * 0.16,
              decoration: BoxDecoration(
                color: const Color(0xFF4D2411).withValues(alpha: 0.26),
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66FFD88A),
                    blurRadius: 24,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),
          CustomPaint(
            size: Size.square(maxWidth),
            painter: _LogoPainter(
              progress: progress,
              revealProgress: revealProgress,
            ),
          ),
          Positioned(
            right: maxWidth * 0.02,
            top: maxWidth * 0.03,
            child: Opacity(
              opacity: ((revealProgress - 0.62) / 0.2).clamp(0, 1),
              child: _Sparkle(
                size: maxWidth * 0.17,
                progress: progress,
                phase: 0.02,
              ),
            ),
          ),
          Positioned(
            left: -maxWidth * 0.08,
            top: maxWidth * 0.38,
            child: Opacity(
              opacity: ((revealProgress - 0.76) / 0.18).clamp(0, 1),
              child: _Sparkle(
                size: maxWidth * 0.13,
                progress: progress,
                phase: 0.42,
              ),
            ),
          ),
          Positioned(
            right: maxWidth * 0.1,
            top: maxWidth * 0.23,
            child: Opacity(
              opacity: ((revealProgress - 0.72) / 0.16).clamp(0, 1),
              child: _Sparkle(
                size: maxWidth * 0.1,
                progress: progress,
                phase: 0.72,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter({required this.progress, required this.revealProgress});

  final double progress;
  final double revealProgress;

  double _stage(double start, double end) {
    return Curves.easeOutCubic.transform(
      ((revealProgress - start) / (end - start)).clamp(0, 1),
    );
  }

  void _drawPathProgress(Canvas canvas, Path path, Paint paint, double amount) {
    if (amount <= 0) return;
    final metrics = path.computeMetrics().toList();
    final totalLength = metrics.fold<double>(
      0,
      (length, metric) => length + metric.length,
    );
    var remaining = totalLength * amount.clamp(0, 1);

    for (final metric in metrics) {
      if (remaining <= 0) break;
      final length = math.min(metric.length, remaining);
      canvas.drawPath(metric.extractPath(0, length), paint);
      remaining -= metric.length;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = size.width * 0.22;
    final shimmerX = (progress * 2.2 - 0.55) * size.width;
    final trailProgress = _stage(0, 0.2);
    final cardProgress = _stage(0.12, 0.42);
    final boardProgress = _stage(0.34, 0.62);
    final detailProgress = _stage(0.52, 0.86);
    final finalGlow = _stage(0.72, 1);

    final cardPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect.deflate(8), Radius.circular(radius)),
      );

    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.2
      ..shader = const LinearGradient(
        colors: [Color(0x00FFF8D2), Color(0xFFFFF4C2), Color(0xFFD7C733)],
      ).createShader(rect);
    final trail = Path()
      ..moveTo(size.width * 0.04, size.height * 0.82)
      ..cubicTo(
        size.width * 0.14,
        size.height * 0.58,
        size.width * 0.33,
        size.height * 0.52,
        size.width * 0.42,
        size.height * 0.32,
      )
      ..cubicTo(
        size.width * 0.54,
        size.height * 0.08,
        size.width * 0.8,
        size.height * 0.1,
        size.width * 0.87,
        size.height * 0.22,
      );
    _drawPathProgress(canvas, trail, trailPaint, trailProgress);

    final shadowPaint = Paint()
      ..color = Color.lerp(
        Colors.transparent,
        const Color(0x385B4734),
        cardProgress,
      )!
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawPath(cardPath.shift(Offset(0, size.height * 0.08)), shadowPaint);

    final cardPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(
            const Color(0x00F0B865),
            const Color(0xFFF0B865),
            cardProgress,
          )!,
          Color.lerp(
            const Color(0x00A95D2E),
            const Color(0xFFB56A32),
            cardProgress,
          )!,
          Color.lerp(
            const Color(0x00C87535),
            const Color(0xFFC98039),
            cardProgress,
          )!,
          Color.lerp(
            const Color(0x005D2A12),
            const Color(0xFF74411F),
            cardProgress,
          )!,
        ],
        stops: [0, 0.34, 0.68, 1],
      ).createShader(rect);
    canvas.drawPath(cardPath, cardPaint);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFF2C2), Color(0x99FFE0A0), Color(0x66FFFFFF)],
      ).createShader(rect);
    _drawPathProgress(canvas, cardPath, borderPaint, cardProgress);

    final lightPanelPaint = Paint()
      ..color = const Color(0x22FFF6D7).withValues(alpha: 0.14 * cardProgress)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.55,
          size.height * 0.18,
          size.width * 0.36,
          size.height * 0.6,
        ),
        Radius.circular(size.width * 0.18),
      ),
      lightPanelPaint,
    );

    canvas.save();
    canvas.clipPath(cardPath);
    final shinePaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: 0.42 * finalGlow),
              Colors.white.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromLTWH(shimmerX, 0, size.width * 0.24, size.height),
          );
    canvas.translate(shimmerX, 0);
    canvas.rotate(-0.48);
    canvas.drawRect(
      Rect.fromLTWH(
        -size.width * 0.08,
        -size.height * 0.2,
        size.width * 0.18,
        size.height * 1.35,
      ),
      shinePaint,
    );
    canvas.restore();

    final boardRect = Rect.fromLTWH(
      size.width * 0.25,
      size.height * 0.23,
      size.width * 0.5,
      size.height * 0.54,
    );
    final boardPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(
            const Color(0x00FFE8B2),
            const Color(0xFFFFE8B2),
            boardProgress,
          )!,
          Color.lerp(
            const Color(0x00C07834),
            const Color(0xFFC07834),
            boardProgress,
          )!,
        ],
      ).createShader(boardRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(boardRect, Radius.circular(size.width * 0.08)),
      boardPaint,
    );

    final boardStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = const Color(0xFFFFF0C4);
    _drawPathProgress(
      canvas,
      Path()..addRRect(
        RRect.fromRectAndRadius(boardRect, Radius.circular(size.width * 0.08)),
      ),
      boardStroke,
      boardProgress,
    );

    final clipRect = Rect.fromLTWH(
      size.width * 0.41,
      size.height * 0.13,
      size.width * 0.18,
      size.height * 0.17,
    );
    final clipPaint = Paint()
      ..color = const Color(0xFFFFF1C4).withValues(alpha: boardProgress);
    canvas.drawRRect(
      RRect.fromRectAndRadius(clipRect, Radius.circular(size.width * 0.06)),
      clipPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.32,
        size.height * 0.25,
        size.width * 0.36,
        size.height * 0.08,
      ),
      clipPaint,
    );

    final checkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.6
      ..color = const Color(0xFFFFF6D7);
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.1
      ..color = const Color(0xFFFFF6D7);
    final boxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.3
      ..color = const Color(0xFFFFF6D7);

    for (var i = 0; i < 3; i++) {
      final rowProgress = ((detailProgress - i * 0.16) / 0.52)
          .clamp(0, 1)
          .toDouble();
      final y = size.height * (0.42 + i * 0.14);
      final box = Rect.fromLTWH(size.width * 0.33, y - 8, 16, 16);
      _drawPathProgress(
        canvas,
        Path()
          ..addRRect(RRect.fromRectAndRadius(box, const Radius.circular(3))),
        boxPaint,
        rowProgress,
      );

      if (i != 1) {
        final check = Path()
          ..moveTo(size.width * 0.345, y)
          ..lineTo(size.width * 0.358, y + 5)
          ..lineTo(size.width * 0.386, y - 7);
        _drawPathProgress(canvas, check, checkPaint, rowProgress);
      }

      _drawPathProgress(
        canvas,
        Path()
          ..moveTo(size.width * 0.45, y - 4)
          ..lineTo(size.width * 0.64, y - 4),
        linePaint,
        rowProgress,
      );
      _drawPathProgress(
        canvas,
        Path()
          ..moveTo(size.width * 0.45, y + 5)
          ..lineTo(size.width * 0.6, y + 5),
        linePaint..color = const Color(0xDDFFF6D7),
        rowProgress,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.revealProgress != revealProgress;
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({
    required this.size,
    required this.progress,
    required this.phase,
  });

  final double size;
  final double progress;
  final double phase;

  @override
  Widget build(BuildContext context) {
    final pulse = (math.sin((progress + phase) * math.pi * 2) + 1) / 2;

    return Transform.scale(
      scale: 0.82 + pulse * 0.24,
      child: Icon(
        Icons.auto_awesome_rounded,
        color: const Color(0xFFFFF5D1).withValues(alpha: 0.56 + pulse * 0.36),
        size: size,
        shadows: const [
          Shadow(color: Color(0xFFFFE18A), blurRadius: 18),
          Shadow(color: Color(0xAAFFFFFF), blurRadius: 8),
        ],
      ),
    );
  }
}

class _OpeningProgress extends StatelessWidget {
  const _OpeningProgress({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOutCubic.transform(progress.clamp(0, 1));

    return Container(
      width: 148,
      height: 8,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.line),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: eased,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.gold, AppColors.olive],
              ),
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [
                BoxShadow(color: Color(0x6687891F), blurRadius: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OpeningBackgroundPainter extends CustomPainter {
  const _OpeningBackgroundPainter({
    required this.progress,
    required this.dragOffset,
  });

  final double progress;
  final Offset dragOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(
      size.width * (0.5 + dragOffset.dx),
      size.height * (0.42 + dragOffset.dy),
    );

    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.background,
          AppColors.cream,
          AppColors.white,
          Color(0xFFE3E1BE),
        ],
        stops: [0, 0.42, 0.74, 1],
      ).createShader(rect);
    canvas.drawRect(rect, basePaint);

    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0x99FFE0A8),
              const Color(0x66D7C733),
              const Color(0x00D7C733),
            ],
          ).createShader(
            Rect.fromCircle(center: center, radius: size.shortestSide * 0.82),
          );
    canvas.drawRect(rect, glowPaint);

    final sweepPaint = Paint()
      ..shader = SweepGradient(
        transform: GradientRotation(progress * math.pi * 2),
        colors: const [
          Color(0x00FFFFFF),
          Color(0x55FFF7E8),
          Color(0x00FFFFFF),
          Color(0x2A87891F),
          Color(0x00FFFFFF),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width));
    canvas.drawCircle(center, size.width * 0.72, sweepPaint);

    final texturePaint = Paint()
      ..color = AppColors.forest.withValues(alpha: 0.05)
      ..strokeWidth = 0.7;
    for (var x = -size.height; x < size.width; x += 28) {
      canvas.drawLine(
        Offset(x + progress * 28, 0),
        Offset(x + size.height + progress * 28, size.height),
        texturePaint,
      );
    }

    final dotPaint = Paint()..color = AppColors.olive.withValues(alpha: 0.18);
    for (var i = 0; i < 24; i++) {
      final phase = progress * math.pi * 2 + i * 0.73;
      final orbit = 34 + (i % 5) * 32.0;
      final x = center.dx + math.cos(phase) * orbit + (i % 3 - 1) * 72;
      final y = center.dy + math.sin(phase * 0.8) * orbit + ((i ~/ 3) - 4) * 58;
      canvas.drawCircle(Offset(x, y), 1.4 + (i % 4) * 0.55, dotPaint);
    }

    final vignettePaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              Colors.transparent,
              AppColors.forest.withValues(alpha: 0.12),
            ],
          ).createShader(
            Rect.fromCircle(center: center, radius: size.longestSide * 0.72),
          );
    canvas.drawRect(rect, vignettePaint);
  }

  @override
  bool shouldRepaint(covariant _OpeningBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.dragOffset != dragOffset;
  }
}
