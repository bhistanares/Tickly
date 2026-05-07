import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/tickly_bottom_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.completedToday,
    required this.dailyTarget,
    required this.totalTasks,
    required this.doneTasks,
    required this.onAdd,
  });

  final int completedToday;
  final int dailyTarget;
  final int totalTasks;
  final int doneTasks;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final progress = dailyTarget == 0
        ? 0.0
        : (completedToday / dailyTarget).clamp(0.0, 1.0);
    final remaining = (dailyTarget - completedToday).clamp(0, dailyTarget);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 110),
          children: [
            const Text(
              'Profil',
              style: TextStyle(
                color: AppColors.ink,
                fontFamily: 'IrishGrover',
                fontSize: 34,
                height: 1,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.line),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x185B4734),
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.sage,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: AppColors.olive,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress hari ini',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Target selesai 5 tugas',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 13,
                      backgroundColor: AppColors.line,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.olive,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '$completedToday/$dailyTarget tugas selesai hari ini',
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    completedToday >= dailyTarget
                        ? 'Target hari ini tercapai. Kerja bagus!'
                        : 'Selesaikan $remaining tugas lagi untuk dapat reward.',
                    style: const TextStyle(
                      color: AppColors.muted,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ProfileMiniCard(
                    label: 'Semua tugas',
                    value: totalTasks.toString(),
                    icon: Icons.format_list_bulleted_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProfileMiniCard(
                    label: 'Total selesai',
                    value: doneTasks.toString(),
                    icon: Icons.check_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: TicklyBottomBar(
        onAdd: onAdd,
        onHome: () => Navigator.of(context).pop(),
        onProfile: () {},
        selectedIndex: 1,
      ),
    );
  }
}

class _ProfileMiniCard extends StatelessWidget {
  const _ProfileMiniCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.forest, size: 24),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
