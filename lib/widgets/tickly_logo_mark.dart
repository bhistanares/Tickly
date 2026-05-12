import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TicklyLogoMark extends StatelessWidget {
  const TicklyLogoMark({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, size * 0.07),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF4C2915).withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(size * 0.24),
                  boxShadow: const [
                    BoxShadow(color: Color(0x44FFD88A), blurRadius: 18),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF2BF70),
                    Color(0xFFC47A38),
                    Color(0xFF71401F),
                  ],
                  stops: [0, 0.48, 1],
                ),
                borderRadius: BorderRadius.circular(size * 0.24),
                border: Border.all(
                  color: const Color(0xFFFFE7A8).withValues(alpha: 0.74),
                  width: 1.4,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x385B4734),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0x77FFF2C2),
                    blurRadius: 8,
                    offset: Offset(-1, -1),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.24),
              child: Stack(
                children: [
                  Positioned(
                    right: -size * 0.2,
                    bottom: -size * 0.22,
                    child: Container(
                      width: size * 0.74,
                      height: size * 0.88,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(size * 0.36),
                      ),
                    ),
                  ),
                  Positioned(
                    left: size * 0.14,
                    top: -size * 0.52,
                    child: Transform.rotate(
                      angle: -0.44,
                      child: Container(
                        width: size * 0.16,
                        height: size * 1.9,
                        color: AppColors.white.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset(size * 0.025, size * 0.035),
                  child: Icon(
                    Icons.assignment_turned_in_rounded,
                    color: const Color(0xFF4A2815).withValues(alpha: 0.24),
                    size: size * 0.58,
                  ),
                ),
                Icon(
                  Icons.assignment_turned_in_rounded,
                  color: const Color(0xFFFFF1C4),
                  size: size * 0.56,
                ),
              ],
            ),
          ),
          Positioned(
            right: -size * 0.04,
            top: size * 0.03,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: const Color(0xFFFFF5D1).withValues(alpha: 0.9),
              size: size * 0.23,
              shadows: const [Shadow(color: Color(0xFFFFE18A), blurRadius: 10)],
            ),
          ),
          Positioned(
            left: -size * 0.05,
            top: size * 0.44,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: const Color(0xFFFFF5D1).withValues(alpha: 0.76),
              size: size * 0.17,
              shadows: const [Shadow(color: Color(0xFFFFE18A), blurRadius: 8)],
            ),
          ),
        ],
      ),
    );
  }
}
