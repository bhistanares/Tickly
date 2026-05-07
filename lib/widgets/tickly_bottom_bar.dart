import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TicklyBottomBar extends StatelessWidget {
  const TicklyBottomBar({
    super.key,
    required this.onAdd,
    required this.onHome,
    required this.onProfile,
    required this.selectedIndex,
  });

  final VoidCallback onAdd;
  final VoidCallback onHome;
  final VoidCallback onProfile;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.forest,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x285B4734),
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              _BottomNavButton(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: selectedIndex == 0,
                onTap: onHome,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: onAdd,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.olive,
                  foregroundColor: AppColors.cream,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  'Tambah',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              const Spacer(),
              _BottomNavButton(
                icon: Icons.person_rounded,
                label: 'Profil',
                selected: selectedIndex == 1,
                onTap: onProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected ? AppColors.gold : AppColors.cream;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.gold.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: foregroundColor),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          builder: (context, color, child) {
            return AnimatedScale(
              scale: selected ? 1.06 : 1,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
