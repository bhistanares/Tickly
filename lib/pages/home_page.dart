import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/user_credentials.dart';
import '../theme/app_colors.dart';
import '../widgets/tickly_bottom_bar.dart';
import 'category_tasks_page.dart';
import 'profile_page.dart';
import 'task_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initialCredentials});

  final UserCredentials? initialCredentials;

  @override
  State<HomePage> createState() => _HomePageState();
}

class Header extends StatelessWidget {
  const Header({super.key, required this.date, required this.username});

  final String date;
  final String username;

  @override
  Widget build(BuildContext context) {
    final displayName = username.trim().isEmpty ? 'Tickly' : username.trim();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, $displayName!',
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontFamily: 'IrishGrover',
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      height: 1.05,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          const Flexible(
            flex: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Tickly',
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.ink,
                    fontFamily: 'Kranky',
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (label) {
      'Selesai' => AppColors.sage,
      'Tertunda' => AppColors.blush,
      _ => AppColors.white,
    };
    final accentColor = switch (label) {
      'Tertunda' => const Color(0xFFC45E58),
      'Total' => AppColors.forest,
      _ => AppColors.olive,
    };
    final depthColor = switch (label) {
      'Tertunda' => const Color(0xFF9E4945),
      'Total' => const Color(0xFF3C2D1E),
      _ => const Color(0xFF6E7119),
    };
    final highlightColor = switch (label) {
      'Tertunda' => const Color(0xFFFFE1DB),
      'Total' => const Color(0xFFFFFFFF),
      _ => const Color(0xFFF4F0C8),
    };
    final gradientColors = switch (label) {
      'Tertunda' => const [Color(0xFFFFD8D2), Color(0xFFF2ADA7)],
      'Total' => const [Color(0xFFF3D9BE), Color(0xFFD9B48F)],
      _ => const [Color(0xFFF1EFC8), Color(0xFFCFCF88)],
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, 5),
              child: Container(
                decoration: BoxDecoration(
                  color: depthColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: highlightColor.withValues(alpha: 0.9),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: depthColor.withValues(alpha: 0.24),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: highlightColor.withValues(alpha: 0.64),
                  blurRadius: 8,
                  offset: const Offset(-2, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 38,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StatIcon(icon: icon, color: accentColor),
                        const SizedBox(width: 6),
                        Text(
                          value,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatIcon extends StatelessWidget {
  const StatIcon({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(2.2, 2.4),
            child: Icon(
              icon,
              color: AppColors.ink.withValues(alpha: 0.22),
              size: 28,
            ),
          ),
          Transform.translate(
            offset: const Offset(1, 1),
            child: Icon(icon, color: color.withValues(alpha: 0.55), size: 28),
          ),
          Icon(icon, color: color, size: 28),
          Transform.translate(
            offset: const Offset(-1.6, -1.6),
            child: Icon(
              icon,
              color: AppColors.white.withValues(alpha: 0.45),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.badgeColor,
    required this.taskCount,
    required this.doneCount,
    this.warningLabel,
    this.isWarningCritical = false,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color badgeColor;
  final int taskCount;
  final int doneCount;
  final String? warningLabel;
  final bool isWarningCritical;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pendingCount = taskCount - doneCount;
    final hasDeadlineWarning = warningLabel != null;
    final isOverdueWarning = hasDeadlineWarning && isWarningCritical;
    final warningColor = isWarningCritical
        ? const Color(0xFFC45E58)
        : AppColors.forest;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isOverdueWarning
                  ? const Color(0xFFFFE3DE)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isOverdueWarning ? warningColor : AppColors.line,
                width: isOverdueWarning ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isOverdueWarning
                      ? warningColor.withValues(alpha: 0.26)
                      : const Color(0x145B4734),
                  blurRadius: isOverdueWarning ? 20 : 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 46),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: badgeColor.withValues(alpha: 0.38),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: iconColor, size: 24),
                      const SizedBox(width: 9),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '$taskCount tugas - $pendingCount tertunda',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isOverdueWarning ? warningColor : AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (hasDeadlineWarning)
            Positioned(
              left: -5,
              top: -5,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: warningColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: warningColor.withValues(
                        alpha: isOverdueWarning ? 0.42 : 0.2,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: isOverdueWarning
                      ? const Text(
                          '!',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        )
                      : const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.cream,
                          size: 14,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CategoryDeadlineWarning {
  const CategoryDeadlineWarning({
    required this.label,
    required this.isCritical,
  });

  final String label;
  final bool isCritical;
}

class CategoryViewSwitch extends StatelessWidget {
  const CategoryViewSwitch({
    super.key,
    required this.showGrid,
    required this.onChanged,
  });

  final bool showGrid;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget option({
      required bool value,
      required IconData icon,
      required String label,
    }) {
      final selected = showGrid == value;

      return InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: 34,
          height: 32,
          decoration: BoxDecoration(
            color: selected ? AppColors.olive : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.olive.withValues(alpha: 0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Tooltip(
            message: label,
            child: Icon(
              icon,
              size: 18,
              color: selected ? AppColors.cream : AppColors.muted,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B4734).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          option(
            value: false,
            icon: Icons.layers_rounded,
            label: 'Tampilan lembaran',
          ),
          option(
            value: true,
            icon: Icons.grid_view_rounded,
            label: 'Tampilan kotak',
          ),
        ],
      ),
    );
  }
}

class CategoryFolderCard extends StatelessWidget {
  const CategoryFolderCard({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.folderColor,
    required this.taskCount,
    required this.doneCount,
    this.warningLabel,
    this.isWarningCritical = false,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color folderColor;
  final int taskCount;
  final int doneCount;
  final String? warningLabel;
  final bool isWarningCritical;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pendingCount = taskCount - doneCount;
    final hasDeadlineWarning = warningLabel != null;
    final isOverdueWarning = hasDeadlineWarning && isWarningCritical;
    final warningColor = isWarningCritical
        ? const Color(0xFFC45E58)
        : AppColors.forest;
    final bodyColor = Color.lerp(folderColor, AppColors.white, 0.68)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: bodyColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isOverdueWarning ? warningColor : AppColors.line,
                  width: isOverdueWarning ? 1.6 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isOverdueWarning ? warningColor : folderColor)
                        .withValues(alpha: isOverdueWarning ? 0.22 : 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: folderColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: folderColor.withValues(alpha: 0.28),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: iconColor, size: 23),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$taskCount tugas - $pendingCount tertunda',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isOverdueWarning ? warningColor : AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasDeadlineWarning)
            Positioned(
              right: 12,
              top: 22,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: warningColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: warningColor.withValues(
                        alpha: isOverdueWarning ? 0.38 : 0.2,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: isOverdueWarning
                      ? const Text(
                          '!',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        )
                      : const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.cream,
                          size: 14,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CategoryFolderStackPreview extends StatelessWidget {
  const CategoryFolderStackPreview({
    super.key,
    required this.categories,
    required this.folderColors,
    required this.taskCount,
    required this.onTap,
  });

  final List<String> categories;
  final Map<String, Color> folderColors;
  final int taskCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final visibleCategories = categories.take(5).toList();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 310,
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.white, AppColors.cream],
                  ),
                ),
              ),
            ),
            for (var index = 0; index < visibleCategories.length; index++)
              _StackedFolderLayer(
                category: visibleCategories[index],
                color:
                    folderColors[visibleCategories[index]] ??
                    const Color(0xFF6F6458),
                top: 28.0 + index * 45,
                isFront: index == visibleCategories.length - 1,
              ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 22,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.sage,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.folder_copy_rounded,
                      color: AppColors.forest,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kumpulan folder',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${categories.length} kategori - $taskCount tugas',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StackedFolderLayer extends StatelessWidget {
  const _StackedFolderLayer({
    required this.category,
    required this.color,
    required this.top,
    required this.isFront,
  });

  final String category;
  final Color color;
  final double top;
  final bool isFront;

  @override
  Widget build(BuildContext context) {
    final bodyColor = isFront
        ? AppColors.cream
        : Color.lerp(color, AppColors.white, 0.34)!;

    return Positioned(
      left: 20,
      right: 20,
      top: top,
      child: SizedBox(
        height: isFront ? 122 : 78,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 18,
              top: -14,
              child: Container(
                width: 92,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.lerp(color, AppColors.white, 0.18),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.forest,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: bodyColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isFront
                      ? AppColors.line
                      : color.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: isFront ? 0.16 : 0.1),
                    blurRadius: isFront ? 18 : 10,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryFolderSheetStack extends StatelessWidget {
  const CategoryFolderSheetStack({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.isExpanded,
    required this.folderColors,
    required this.iconForCategory,
    required this.taskCountForCategory,
    required this.doneCountForCategory,
    required this.warningForCategory,
    required this.onTapCategory,
  });

  final List<String> categories;
  final String? selectedCategory;
  final bool isExpanded;
  final Map<String, Color> folderColors;
  final IconData Function(String category) iconForCategory;
  final int Function(String category) taskCountForCategory;
  final int Function(String category) doneCountForCategory;
  final CategoryDeadlineWarning? Function(String category) warningForCategory;
  final ValueChanged<String> onTapCategory;

  static const double _sheetHeight = 122;
  static const double _collapsedStep = 42;
  static const double _expandedStep = 76;
  static const double _selectedGap = 58;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedIndex = categories.indexOf(selectedCategory ?? '');
    final totalTaskCount = categories.fold<int>(
      0,
      (total, category) => total + taskCountForCategory(category),
    );
    final stackHeight =
        _topForIndex(categories.length - 1, selectedIndex) +
        _sheetHeight +
        (selectedIndex == categories.length - 1 ? _selectedGap : 0) +
        24;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      height: stackHeight,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.78),
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.white, AppColors.cream],
                ),
              ),
            ),
          ),
          for (var index = 0; index < categories.length; index++)
            AnimatedPositioned(
              key: ValueKey(categories[index]),
              duration: Duration(milliseconds: 260 + index * 18),
              curve: Curves.easeOutCubic,
              left: 18,
              right: 18,
              top: 22 + _topForIndex(index, selectedIndex),
              child: CategoryFolderSheet(
                category: categories[index],
                icon: iconForCategory(categories[index]),
                color:
                    folderColors[categories[index]] ?? const Color(0xFF9A8DA7),
                taskCount: taskCountForCategory(categories[index]),
                doneCount: doneCountForCategory(categories[index]),
                warning: warningForCategory(categories[index]),
                tabSlot: index % 3,
                isSelected: isExpanded && selectedCategory == categories[index],
                selectedExtension:
                    isExpanded && selectedCategory == categories[index]
                    ? _selectedGap
                    : 0,
                onTap: () => onTapCategory(categories[index]),
              ),
            ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 22,
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isExpanded ? 0 : 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.9),
                      width: 1.4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x245B4734),
                        blurRadius: 22,
                        offset: Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Color(0x55FFFCF7),
                        blurRadius: 8,
                        offset: Offset(-2, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.sage,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.folder_copy_rounded,
                          color: AppColors.forest,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kumpulan folder',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${categories.length} kategori - $totalTaskCount tugas',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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
    );
  }

  double _topForIndex(int index, int selectedIndex) {
    final step = isExpanded ? _expandedStep : _collapsedStep;
    final pushedBySelection =
        isExpanded && selectedIndex != -1 && index > selectedIndex;
    return index * step + (pushedBySelection ? _selectedGap : 0);
  }
}

class DailyRewardOverlay extends StatefulWidget {
  const DailyRewardOverlay({super.key});

  @override
  State<DailyRewardOverlay> createState() => _DailyRewardOverlayState();
}

class _DailyRewardOverlayState extends State<DailyRewardOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_ConfettiPiece> _pieces;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..forward();
    _pieces = _buildConfettiPieces();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_ConfettiPiece> _buildConfettiPieces() {
    final random = math.Random(12);
    const colors = [
      Color(0xFFD9A1AD),
      Color(0xFF93B4A8),
      Color(0xFFD4A25D),
      Color(0xFF6E5A7D),
      Color(0xFF89901D),
      Color(0xFFC89B7F),
      Color(0xFF85A7BE),
      Color(0xFFFFD1C8),
    ];

    return List.generate(82, (index) {
      final side = index.isEven ? -1.0 : 1.0;
      return _ConfettiPiece(
        startX: 0.42 + random.nextDouble() * 0.16,
        drift: side * (0.18 + random.nextDouble() * 0.34),
        fall: 0.48 + random.nextDouble() * 0.42,
        delay: random.nextDouble() * 0.28,
        size: 5 + random.nextDouble() * 8,
        spin: (random.nextDouble() * 2 - 1) * math.pi * 2.8,
        color: colors[index % colors.length],
        shape: index % 3,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final value = _controller.value;
            final messageOpacity = value < 0.78
                ? Curves.easeOut.transform((value / 0.22).clamp(0.0, 1.0))
                : Curves.easeIn.transform(((1 - value) / 0.22).clamp(0.0, 1.0));
            final backgroundOpacity = value < 0.78
                ? Curves.easeOut.transform((value / 0.18).clamp(0.0, 1.0))
                : Curves.easeIn.transform(((1 - value) / 0.22).clamp(0.0, 1.0));

            return Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: AppColors.ink.withValues(
                      alpha: 0.68 * backgroundOpacity,
                    ),
                  ),
                ),
                CustomPaint(
                  painter: _ConfettiPainter(progress: value, pieces: _pieces),
                  size: Size.infinite,
                ),
                Align(
                  alignment: const Alignment(0, -0.18),
                  child: Opacity(
                    opacity: messageOpacity,
                    child: Transform.scale(
                      scale: 0.88 + (0.12 * messageOpacity),
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppColors.line),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x285B4734),
                                blurRadius: 24,
                                offset: Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.celebration_rounded,
                                color: AppColors.olive,
                                size: 30,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Kamu keren!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                '5 tugas sudah terselesaikan.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
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

class _ConfettiPiece {
  const _ConfettiPiece({
    required this.startX,
    required this.drift,
    required this.fall,
    required this.delay,
    required this.size,
    required this.spin,
    required this.color,
    required this.shape,
  });

  final double startX;
  final double drift;
  final double fall;
  final double delay;
  final double size;
  final double spin;
  final Color color;
  final int shape;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.progress, required this.pieces});

  final double progress;
  final List<_ConfettiPiece> pieces;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final centerY = size.height * 0.32;

    for (final piece in pieces) {
      final localProgress = ((progress - piece.delay) / (1 - piece.delay))
          .clamp(0.0, 1.0);
      if (localProgress <= 0) continue;

      final eased = Curves.easeOutCubic.transform(localProgress);
      final fall = Curves.easeIn.transform(localProgress);
      final opacity = localProgress < 0.72
          ? 1.0
          : ((1 - localProgress) / 0.28).clamp(0.0, 1.0);
      final x =
          (piece.startX * size.width) +
          (piece.drift * size.width * eased) +
          math.sin(localProgress * math.pi * 4) * 14;
      final y =
          centerY -
          (size.height * 0.18 * (1 - eased)) +
          (piece.fall * size.height * fall);

      paint.color = piece.color.withValues(alpha: opacity);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(piece.spin * localProgress);

      if (piece.shape == 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: piece.size * 0.8,
              height: piece.size * 1.6,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
      } else if (piece.shape == 1) {
        canvas.drawCircle(Offset.zero, piece.size * 0.45, paint);
      } else {
        final path = Path()
          ..moveTo(0, -piece.size * 0.7)
          ..lineTo(piece.size * 0.7, piece.size * 0.55)
          ..lineTo(-piece.size * 0.7, piece.size * 0.55)
          ..close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.pieces != pieces;
  }
}

class CategoryFolderSheet extends StatelessWidget {
  const CategoryFolderSheet({
    super.key,
    required this.category,
    required this.icon,
    required this.color,
    required this.taskCount,
    required this.doneCount,
    required this.warning,
    required this.tabSlot,
    required this.isSelected,
    required this.selectedExtension,
    required this.onTap,
  });

  final String category;
  final IconData icon;
  final Color color;
  final int taskCount;
  final int doneCount;
  final CategoryDeadlineWarning? warning;
  final int tabSlot;
  final bool isSelected;
  final double selectedExtension;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pendingCount = taskCount - doneCount;
    final isOverdueWarning = warning?.isCritical ?? false;
    final warningColor = isOverdueWarning
        ? const Color(0xFFC45E58)
        : AppColors.forest;
    final bodyColor = Color.lerp(color, AppColors.white, 0.34)!;
    final tabColor = Color.lerp(color, AppColors.white, 0.12)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 122 + selectedExtension,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = (constraints.maxWidth * 0.36).clamp(104.0, 138.0);
            final tabLeft = switch (tabSlot) {
              0 => 20.0,
              1 => (constraints.maxWidth - tabWidth) / 2,
              _ => constraints.maxWidth - tabWidth - 20,
            };

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: tabLeft,
                  top: 0,
                  width: tabWidth,
                  height: 34,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 4,
                        right: 4,
                        bottom: -4,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.16),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: tabColor,
                          border: Border(
                            top: BorderSide(
                              color: AppColors.white.withValues(alpha: 0.38),
                              width: 1.2,
                            ),
                            left: BorderSide(
                              color: color.withValues(alpha: 0.36),
                            ),
                            right: BorderSide(
                              color: color.withValues(alpha: 0.36),
                            ),
                          ),
                        ),
                        child: Text(
                          category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        top: 6,
                        child: Container(
                          height: 1,
                          color: AppColors.white.withValues(alpha: 0.22),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 28,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: bodyColor,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.lerp(bodyColor, AppColors.white, 0.18)!,
                          bodyColor,
                          Color.lerp(bodyColor, AppColors.ink, 0.035)!,
                        ],
                        stops: const [0, 0.62, 1],
                      ),
                      borderRadius: BorderRadius.zero,
                      border: Border.all(
                        color: isOverdueWarning
                            ? warningColor
                            : (isSelected
                                  ? AppColors.olive.withValues(alpha: 0.55)
                                  : color.withValues(alpha: 0.18)),
                        width: isOverdueWarning || isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isOverdueWarning ? warningColor : color)
                              .withValues(alpha: isSelected ? 0.24 : 0.14),
                          blurRadius: isSelected ? 22 : 14,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _PaperTexturePainter(
                              lineColor: color.withValues(alpha: 0.28),
                              edgeColor: color.withValues(alpha: 0.34),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 4,
                            color: color.withValues(alpha: 0.34),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          child: Container(
                            height: 2,
                            color: AppColors.white.withValues(alpha: 0.36),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                            child: SizedBox(
                              height: 58,
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withValues(
                                        alpha: 0.42,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: AppColors.white.withValues(
                                          alpha: 0.28,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      icon,
                                      color: AppColors.forest,
                                      size: 23,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          category,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.ink,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '$taskCount tugas - $pendingCount tertunda',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isOverdueWarning
                                                ? warningColor
                                                : AppColors.muted,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (warning != null)
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: warningColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: isOverdueWarning
                                            ? const Text(
                                                '!',
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w900,
                                                  height: 1,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.schedule_rounded,
                                                color: AppColors.cream,
                                                size: 15,
                                              ),
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppColors.muted,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CustomPaint(
                            size: const Size(34, 34),
                            painter: _PaperFoldPainter(
                              foldColor: Color.lerp(
                                bodyColor,
                                AppColors.white,
                                0.28,
                              )!,
                              shadowColor: color.withValues(alpha: 0.18),
                            ),
                          ),
                        ),
                      ],
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

class _PaperTexturePainter extends CustomPainter {
  const _PaperTexturePainter({
    required this.lineColor,
    required this.edgeColor,
  });

  final Color lineColor;
  final Color edgeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.25;
    final edgePaint = Paint()
      ..color = edgeColor
      ..strokeWidth = 1.5;

    for (var y = 36.0; y < size.height - 8; y += 26) {
      canvas.drawLine(Offset(18, y), Offset(size.width - 18, y), linePaint);
    }

    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      edgePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PaperTexturePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.edgeColor != edgeColor;
  }
}

class _PaperFoldPainter extends CustomPainter {
  const _PaperFoldPainter({required this.foldColor, required this.shadowColor});

  final Color foldColor;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final foldPath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final shadowPath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(shadowPath, Paint()..color = shadowColor);
    canvas.drawPath(
      foldPath,
      Paint()..color = foldColor.withValues(alpha: 0.58),
    );
  }

  @override
  bool shouldRepaint(covariant _PaperFoldPainter oldDelegate) {
    return oldDelegate.foldColor != foldColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}

class ReorderableCategoryCard extends StatelessWidget {
  const ReorderableCategoryCard({
    super.key,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.badgeColor,
    required this.taskCount,
    required this.doneCount,
    required this.warning,
    required this.isDragging,
    required this.onTap,
    required this.onMove,
    required this.onDragStarted,
    required this.onDragFinished,
  });

  final String category;
  final IconData icon;
  final Color iconColor;
  final Color badgeColor;
  final int taskCount;
  final int doneCount;
  final CategoryDeadlineWarning? warning;
  final bool isDragging;
  final VoidCallback onTap;
  final ValueChanged<String> onMove;
  final VoidCallback onDragStarted;
  final VoidCallback onDragFinished;

  @override
  Widget build(BuildContext context) {
    Widget card({required VoidCallback onTap}) {
      return CategoryFolderCard(
        label: category,
        icon: icon,
        iconColor: iconColor,
        folderColor: badgeColor,
        taskCount: taskCount,
        doneCount: doneCount,
        warningLabel: warning?.label,
        isWarningCritical: warning?.isCritical ?? false,
        onTap: onTap,
      );
    }

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => details.data != category,
      onAcceptWithDetails: (details) => onMove(details.data),
      builder: (context, candidateData, rejectedData) {
        final isTargeted = candidateData.isNotEmpty;

        return AnimatedScale(
          scale: isTargeted ? 0.96 : 1,
          duration: const Duration(milliseconds: 140),
          child: LongPressDraggable<String>(
            data: category,
            onDragStarted: onDragStarted,
            onDragEnd: (_) => onDragFinished(),
            onDraggableCanceled: (_, __) => onDragFinished(),
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 168,
                height: 150,
                child: Opacity(opacity: 0.92, child: card(onTap: () {})),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.38,
              child: card(onTap: () {}),
            ),
            child: Opacity(
              opacity: isDragging ? 0.72 : 1,
              child: card(onTap: onTap),
            ),
          ),
        );
      },
    );
  }
}

class _HomePageState extends State<HomePage> {
  final List<String> _categories = ['Pribadi', 'Belajar', 'Sekolah'];

  final Map<String, IconData> _categoryIcons = {
    'Pribadi': Icons.spa_rounded,
    'Belajar': Icons.menu_book_rounded,
    'Sekolah': Icons.school_rounded,
    'Belanja': Icons.shopping_cart_rounded,
    'Rumah': Icons.home_rounded,
    'Ekskul': Icons.groups_rounded,
    'Hang Out': Icons.celebration_rounded,
    'Simpan': Icons.bookmark_border_rounded,
  };

  final Map<String, Color> _categoryIconColors = {
    'Pribadi': Color(0xFFFFD1C8),
    'Belajar': Color(0xFFCFE6D9),
    'Sekolah': Color(0xFFFFE0A8),
    'Belanja': Color(0xFFD9D0FF),
    'Rumah': Color(0xFFFFD8B8),
    'Ekskul': Color(0xFFD5E4FF),
    'Hang Out': Color(0xFFFFCFC2),
    'Simpan': Color(0xFFE4D8B8),
  };

  final Map<String, Color> _categoryBadgeColors = {
    'Pribadi': Color(0xFFD9A1AD),
    'Belajar': Color(0xFF93B4A8),
    'Sekolah': Color(0xFFD4A25D),
    'Belanja': Color(0xFF6E5A7D),
    'Rumah': Color(0xFF89901D),
    'Ekskul': Color(0xFF6D604F),
    'Hang Out': Color(0xFF9A6A4D),
    'Simpan': Color(0xFF776B51),
  };

  int _nextId = 5;
  static const int _dailyTarget = 5;
  Timer? _deadlineAlertTimer;
  final Set<int> _alertedOverdueTaskIds = {};
  bool _isCategoryStackExpanded = false;
  bool _showCategoryGrid = false;
  bool _isOpeningTaskForm = false;
  int _selectedBottomIndex = 0;
  String? _selectedStackCategory;
  late UserCredentials _credentials;

  final List<Task> _tasks = [
    Task(
      id: 1,
      title: 'Review materi matematika',
      category: 'Belajar',
      note: 'Kerjakan 10 soal latihan sebelum malam.',
      isDone: false,
    ),
    Task(
      id: 2,
      title: 'Kumpulkan tugas sejarah',
      category: 'Sekolah',
      note: 'Upload ke classroom sebelum jam 20.00.',
      isDone: true,
    ),
    Task(
      id: 3,
      title: 'Rapikan meja belajar',
      category: 'Pribadi',
      note: 'Biar besok pagi langsung fokus.',
      isDone: false,
    ),
    Task(
      id: 4,
      title: 'Siapkan perlengkapan kelas',
      category: 'Sekolah',
      note: 'Cek buku catatan dan alat tulis.',
      isDone: false,
    ),
  ];

  int get _doneCount => _tasks.where((task) => task.isDone).length;

  int get _completedTodayCount {
    return _tasks.where((task) {
      final completedAt = task.completedAt;
      return task.isDone && completedAt != null && _isSameDay(completedAt);
    }).length;
  }

  List<String> get _folderCategories => _categories.where((category) {
    final normalizedCategory = category.toLowerCase();
    return normalizedCategory != 'semua';
  }).toList();

  Color _fallbackCategoryColor(String category) {
    const colors = [
      Color(0xFFD9A1AD),
      Color(0xFF93B4A8),
      Color(0xFFD4A25D),
      Color(0xFFA899B5),
      Color(0xFFB8C67A),
      Color(0xFFC89B7F),
      Color(0xFFA9A394),
      Color(0xFF85A7BE),
    ];
    final index = category.codeUnits.fold<int>(
      0,
      (total, codeUnit) => total + codeUnit,
    );
    return colors[index % colors.length];
  }

  IconData _categoryIcon(String category) {
    return _categoryIcons[category] ?? Icons.folder_rounded;
  }

  bool _isSameDay(DateTime value, [DateTime? compareTo]) {
    final date = compareTo ?? DateTime.now();
    return value.year == date.year &&
        value.month == date.month &&
        value.day == date.day;
  }

  void _showDailyReward() {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(builder: (_) => const DailyRewardOverlay());
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 2800), () {
      entry.remove();
    });
  }

  void _openProfile() {
    setState(() {
      _selectedBottomIndex = 1;
    });

    Navigator.of(context)
        .push(
          PageRouteBuilder<void>(
            transitionDuration: const Duration(milliseconds: 420),
            reverseTransitionDuration: const Duration(milliseconds: 320),
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProfilePage(
                  completedToday: _completedTodayCount,
                  dailyTarget: _dailyTarget,
                  totalTasks: _tasks.length,
                  doneTasks: _doneCount,
                  tasks: _tasks,
                  credentials: _credentials,
                  onCredentialsChanged: (credentials) {
                    setState(() {
                      _credentials = credentials;
                    });
                  },
                  onAdd: () => _openTaskForm(),
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final fadeAnimation = CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.08, 1, curve: Curves.easeOut),
                    reverseCurve: Curves.easeIn,
                  );
                  final offsetAnimation =
                      Tween<Offset>(
                        begin: const Offset(0, 0.035),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                          reverseCurve: Curves.easeInCubic,
                        ),
                      );
                  final scaleAnimation = Tween<double>(begin: 0.985, end: 1)
                      .animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                          reverseCurve: Curves.easeInCubic,
                        ),
                      );

                  return FadeTransition(
                    opacity: fadeAnimation,
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: child,
                      ),
                    ),
                  );
                },
          ),
        )
        .then((_) {
          if (!mounted) return;
          setState(() {
            _selectedBottomIndex = 0;
          });
        });
  }

  @override
  void initState() {
    super.initState();
    _credentials =
        widget.initialCredentials ??
        const UserCredentials(
          username: 'hyu_tickly',
          email: 'hyu@email.com',
          password: 'tickly123',
          signInMethod: SignInMethod.username,
        );
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverdueTasks());
    _deadlineAlertTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(() {});
      _checkOverdueTasks();
    });
  }

  @override
  void dispose() {
    _deadlineAlertTimer?.cancel();
    super.dispose();
  }

  bool _isTaskOverdue(Task task) {
    return !task.isDone &&
        task.deadline != null &&
        task.deadline!.isBefore(DateTime.now());
  }

  bool _isTaskNearDeadline(Task task) {
    if (task.isDone || task.deadline == null || _isTaskOverdue(task)) {
      return false;
    }

    final remaining = task.deadline!.difference(DateTime.now());
    return remaining <= const Duration(days: 2);
  }

  CategoryDeadlineWarning? _deadlineWarningForCategory(List<Task> tasks) {
    final overdueCount = tasks.where(_isTaskOverdue).length;
    if (overdueCount > 0) {
      return CategoryDeadlineWarning(
        label: '$overdueCount tugas terlambat',
        isCritical: true,
      );
    }

    final nearDeadlineCount = tasks.where(_isTaskNearDeadline).length;
    if (nearDeadlineCount > 0) {
      return CategoryDeadlineWarning(
        label: '$nearDeadlineCount deadline H-2',
        isCritical: false,
      );
    }

    return null;
  }

  void _checkOverdueTasks() {
    if (!mounted) return;

    _alertedOverdueTaskIds.removeWhere((taskId) {
      Task? task;
      for (final item in _tasks) {
        if (item.id == taskId) {
          task = item;
          break;
        }
      }
      return task == null || !_isTaskOverdue(task);
    });

    final overdueTasks = _tasks
        .where(
          (task) =>
              _isTaskOverdue(task) && !_alertedOverdueTaskIds.contains(task.id),
        )
        .toList();
    if (overdueTasks.isEmpty) return;

    final task = overdueTasks.first;
    _alertedOverdueTaskIds.addAll(overdueTasks.map((task) => task.id));

    final extraCount = overdueTasks.length - 1;
    final message = extraCount > 0
        ? '${task.title} dan $extraCount tugas lain melewati deadline!'
        : '${task.title} sudah melewati deadline!';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.cream),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFC45E58),
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
  }

  Future<void> _openTaskForm({Task? task}) async {
    if (_isOpeningTaskForm) return;
    _isOpeningTaskForm = true;

    final TaskFormResult? result;
    try {
      result = await Navigator.of(context).push<TaskFormResult>(
        MaterialPageRoute(
          builder: (_) => TaskFormPage(
            categories: _categoryIcons.keys.toList(),
            categoryIcons: _categoryIcons,
            task: task,
          ),
        ),
      );
    } finally {
      _isOpeningTaskForm = false;
    }

    if (result == null) return;
    final taskResult = result;

    setState(() {
      if (!_categories.contains(taskResult.category)) {
        _categories.add(taskResult.category);
      }
      _categoryIcons[taskResult.category] = taskResult.categoryIcon;
      _categoryBadgeColors.putIfAbsent(
        taskResult.category,
        () => _fallbackCategoryColor(taskResult.category),
      );

      if (task == null) {
        _tasks.insert(
          0,
          Task(
            id: _nextId++,
            title: taskResult.title,
            category: taskResult.category,
            note: taskResult.note,
            isDone: false,
            deadline: taskResult.deadline,
          ),
        );
      } else {
        task
          ..title = taskResult.title
          ..category = taskResult.category
          ..note = taskResult.note
          ..deadline = taskResult.deadline;
      }
    });
    _checkOverdueTasks();
  }

  void _openCategory(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryTasksPage(
          category: category,
          tasks: _tasks,
          onToggle: _toggleTask,
          onEdit: (task) => _openTaskForm(task: task),
          onDelete: _deleteTask,
          onEditCategory: _editCategory,
          onDeleteCategory: _deleteCategory,
        ),
      ),
    );
  }

  Future<String?> _editCategory(String category) async {
    final controller = TextEditingController(text: category);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: const Text(
            'Edit kategori',
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Nama kategori',
              filled: true,
              fillColor: AppColors.cream,
              prefixIcon: const Icon(
                Icons.folder_rounded,
                color: AppColors.forest,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.olive,
                  width: 1.4,
                ),
              ),
            ),
            onSubmitted: (_) => Navigator.of(context).pop(controller.text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.olive,
                foregroundColor: AppColors.cream,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
    controller.dispose();

    if (newName == null) return null;
    final trimmedName = newName.trim();
    if (trimmedName.isEmpty || trimmedName == category) return null;

    final existingCategory = _categories
        .where((item) => item != category)
        .any((item) => item.toLowerCase() == trimmedName.toLowerCase());
    if (existingCategory) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama kategori sudah ada'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.forest,
        ),
      );
      return null;
    }

    setState(() {
      final index = _categories.indexOf(category);
      if (index != -1) {
        _categories[index] = trimmedName;
      }

      final icon = _categoryIcons.remove(category);
      final iconColor = _categoryIconColors.remove(category);
      final badgeColor = _categoryBadgeColors.remove(category);
      if (icon != null) _categoryIcons[trimmedName] = icon;
      if (iconColor != null) _categoryIconColors[trimmedName] = iconColor;
      if (badgeColor != null) _categoryBadgeColors[trimmedName] = badgeColor;

      for (final task in _tasks) {
        if (task.category == category) {
          task.category = trimmedName;
        }
      }
    });

    return trimmedName;
  }

  Future<bool> _deleteCategory(String category) async {
    if (_folderCategories.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal harus ada 1 kategori'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.forest,
        ),
      );
      return false;
    }

    final taskCount = _tasksForCategory(category).length;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: const Text(
            'Hapus kategori?',
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900),
          ),
          content: Text(
            taskCount == 0
                ? 'Kategori "$category" akan dihapus.'
                : 'Kategori "$category" dan $taskCount tugas di dalamnya akan dihapus.',
            style: const TextStyle(color: AppColors.muted, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFC45E58),
                foregroundColor: AppColors.cream,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return false;

    setState(() {
      final deletedTaskIds = _tasks
          .where((task) => task.category == category)
          .map((task) => task.id)
          .toSet();
      _categories.remove(category);
      _categoryIcons.remove(category);
      _categoryIconColors.remove(category);
      _categoryBadgeColors.remove(category);
      _tasks.removeWhere((task) => task.category == category);
      _alertedOverdueTaskIds.removeWhere(deletedTaskIds.contains);
    });

    if (!mounted) return true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kategori $category dihapus'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.forest,
      ),
    );

    return true;
  }

  List<Task> _tasksForCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  void _toggleTask(Task task) {
    final beforeCompletedToday = _completedTodayCount;
    final wasDone = task.isDone;
    setState(() {
      task.isDone = !task.isDone;
      if (task.isDone) {
        task.completedAt = DateTime.now();
      } else {
        task.completedAt = null;
      }
    });
    _checkOverdueTasks();

    final completedToday = _completedTodayCount;
    final reachedTarget =
        !wasDone &&
        completedToday > 0 &&
        completedToday % _dailyTarget == 0 &&
        beforeCompletedToday ~/ _dailyTarget < completedToday ~/ _dailyTarget;

    if (reachedTarget) {
      _showDailyReward();
    }
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.removeWhere((item) => item.id == task.id);
      _alertedOverdueTaskIds.remove(task.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${task.title} dihapus'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.forest,
      ),
    );
  }

  String _formattedDate() {
    const weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final now = DateTime.now();
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _tasks.length - _doneCount;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      date: _formattedDate(),
                      username: _credentials.username,
                    ),
                    const SizedBox(height: 34),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'Total',
                            value: _tasks.length.toString(),
                            icon: Icons.format_list_bulleted_rounded,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CategoryTasksPage(
                                    category: 'Total',
                                    tasks: _tasks,
                                    onToggle: _toggleTask,
                                    onEdit: (task) => _openTaskForm(task: task),
                                    onDelete: _deleteTask,
                                    showAllTasks: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
                            label: 'Selesai',
                            value: _doneCount.toString(),
                            icon: Icons.check_rounded,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CategoryTasksPage(
                                    category: 'Selesai',
                                    tasks: _tasks,
                                    onToggle: _toggleTask,
                                    onEdit: (task) => _openTaskForm(task: task),
                                    onDelete: _deleteTask,
                                    showAllTasks: true,
                                    showDoneOnly: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
                            label: 'Tertunda',
                            value: pendingCount.toString(),
                            icon: Icons.schedule_rounded,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CategoryTasksPage(
                                    category: 'Tertunda',
                                    tasks: _tasks,
                                    onToggle: _toggleTask,
                                    onEdit: (task) => _openTaskForm(task: task),
                                    onDelete: _deleteTask,
                                    showAllTasks: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Kategori',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          '${_folderCategories.length} folder',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        CategoryViewSwitch(
                          showGrid: _showCategoryGrid,
                          onChanged: (value) {
                            setState(() {
                              _showCategoryGrid = value;
                              if (value) {
                                _isCategoryStackExpanded = false;
                                _selectedStackCategory = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 100),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _showCategoryGrid
                      ? GridView.builder(
                          key: const ValueKey('category-grid-view'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _folderCategories.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 1.15,
                              ),
                          itemBuilder: (context, index) {
                            final category = _folderCategories[index];
                            final tasks = _tasksForCategory(category);
                            final warning = _deadlineWarningForCategory(tasks);

                            return CategoryFolderCard(
                              label: category,
                              icon: _categoryIcon(category),
                              iconColor:
                                  _categoryIconColors[category] ??
                                  AppColors.cream,
                              folderColor:
                                  _categoryBadgeColors[category] ??
                                  _fallbackCategoryColor(category),
                              taskCount: tasks.length,
                              doneCount: tasks
                                  .where((task) => task.isDone)
                                  .length,
                              warningLabel: warning?.label,
                              isWarningCritical: warning?.isCritical ?? false,
                              onTap: () => _openCategory(category),
                            );
                          },
                        )
                      : CategoryFolderSheetStack(
                          key: const ValueKey('category-sheet-view'),
                          categories: _folderCategories,
                          selectedCategory: _selectedStackCategory,
                          isExpanded: _isCategoryStackExpanded,
                          folderColors: _categoryBadgeColors,
                          iconForCategory: _categoryIcon,
                          taskCountForCategory: (category) =>
                              _tasksForCategory(category).length,
                          doneCountForCategory: (category) => _tasksForCategory(
                            category,
                          ).where((task) => task.isDone).length,
                          warningForCategory: (category) =>
                              _deadlineWarningForCategory(
                                _tasksForCategory(category),
                              ),
                          onTapCategory: (category) {
                            if (_isCategoryStackExpanded &&
                                _selectedStackCategory == category) {
                              _openCategory(category);
                              return;
                            }

                            setState(() {
                              _isCategoryStackExpanded = true;
                              _selectedStackCategory = category;
                            });
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TicklyBottomBar(
        onAdd: () => _openTaskForm(),
        onHome: () {
          setState(() {
            _selectedBottomIndex = 0;
          });
        },
        onProfile: _openProfile,
        selectedIndex: _selectedBottomIndex,
      ),
    );
  }
}
