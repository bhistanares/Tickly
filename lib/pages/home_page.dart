import 'dart:async';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_colors.dart';
import 'category_tasks_page.dart';
import 'task_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Header extends StatelessWidget {
  const Header({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, Hyu!',
                    maxLines: 1,
                    style: TextStyle(
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
    final warningColor = isWarningCritical
        ? const Color(0xFFC45E58)
        : const Color(0xFFD36A4D);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: hasDeadlineWarning
                  ? const Color(0xFFFFE3DE)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: hasDeadlineWarning ? warningColor : AppColors.line,
                width: hasDeadlineWarning ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: hasDeadlineWarning
                      ? warningColor.withValues(alpha: 0.26)
                      : const Color(0x145B4734),
                  blurRadius: hasDeadlineWarning ? 20 : 16,
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
                    color: hasDeadlineWarning ? warningColor : AppColors.muted,
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
                      color: warningColor.withValues(alpha: 0.42),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '!',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
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

class CategoryDeadlineWarning {
  const CategoryDeadlineWarning({
    required this.label,
    required this.isCritical,
  });

  final String label;
  final bool isCritical;
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
    final warningColor = isWarningCritical
        ? const Color(0xFFC45E58)
        : const Color(0xFFD36A4D);
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
                  color: hasDeadlineWarning ? warningColor : AppColors.line,
                  width: hasDeadlineWarning ? 1.6 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (hasDeadlineWarning ? warningColor : folderColor)
                        .withValues(alpha: hasDeadlineWarning ? 0.22 : 0.18),
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
                      color: hasDeadlineWarning
                          ? warningColor
                          : AppColors.muted,
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
                      color: warningColor.withValues(alpha: 0.38),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '!',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
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
  final List<String> _categories = [
    'Pribadi',
    'Belajar',
    'Sekolah',
    'Belanja',
    'Rumah',
    'Ekskul',
    'Hang Out',
    'Simpan',
  ];

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
    'Pribadi': Color(0xFF7F5A68),
    'Belajar': Color(0xFF4F6F68),
    'Sekolah': Color(0xFF8A6F4D),
    'Belanja': Color(0xFF6E5A7D),
    'Rumah': Color(0xFF89901D),
    'Ekskul': Color(0xFF6D604F),
    'Hang Out': Color(0xFF9A6A4D),
    'Simpan': Color(0xFF776B51),
  };

  int _nextId = 5;
  Timer? _deadlineAlertTimer;
  final Set<int> _alertedOverdueTaskIds = {};
  String? _draggingCategory;
  bool _isCategoryStackExpanded = false;

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
      title: 'Beli sticky notes',
      category: 'Belanja',
      note: 'Pilih warna soft yellow atau cream.',
      isDone: false,
    ),
  ];

  int get _doneCount => _tasks.where((task) => task.isDone).length;

  List<String> get _folderCategories => _categories.where((category) {
    final normalizedCategory = category.toLowerCase();
    return normalizedCategory != 'semua';
  }).toList();

  IconData _categoryIcon(String category) {
    return _categoryIcons[category] ?? Icons.folder_rounded;
  }

  Color _categoryIconColor(String category) {
    return _categoryIconColors[category] ?? const Color(0xFFD6E3CE);
  }

  Color _categoryBadgeColor(String category) {
    return _categoryBadgeColors[category] ?? const Color(0xFF6F6458);
  }

  @override
  void initState() {
    super.initState();
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
    final result = await Navigator.of(context).push<TaskFormResult>(
      MaterialPageRoute(
        builder: (_) => TaskFormPage(
          categories: _folderCategories,
          categoryIcons: _categoryIcons,
          task: task,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      if (!_categories.contains(result.category)) {
        _categories.add(result.category);
      }
      _categoryIcons[result.category] = result.categoryIcon;

      if (task == null) {
        _tasks.insert(
          0,
          Task(
            id: _nextId++,
            title: result.title,
            category: result.category,
            note: result.note,
            isDone: false,
            deadline: result.deadline,
          ),
        );
      } else {
        task
          ..title = result.title
          ..category = result.category
          ..note = result.note
          ..deadline = result.deadline;
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

  void _moveCategory({
    required String draggedCategory,
    required String targetCategory,
  }) {
    if (draggedCategory == targetCategory) return;

    final oldIndex = _categories.indexOf(draggedCategory);
    final targetIndex = _categories.indexOf(targetCategory);
    if (oldIndex == -1 || targetIndex == -1) return;

    setState(() {
      final category = _categories.removeAt(oldIndex);
      _categories.insert(targetIndex, category);
    });
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
    setState(() {
      task.isDone = !task.isDone;
    });
    _checkOverdueTasks();
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
                    Header(date: _formattedDate()),
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
                  duration: const Duration(milliseconds: 360),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1,
                        child: child,
                      ),
                    );
                  },
                  child: _isCategoryStackExpanded
                      ? Column(
                          key: const ValueKey('expanded-folders'),
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isCategoryStackExpanded = false;
                                  });
                                },
                                child: const Text('Satukan folder'),
                              ),
                            ),
                            const SizedBox(height: 4),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _folderCategories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 14,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 1.08,
                                  ),
                              itemBuilder: (context, index) {
                                final category = _folderCategories[index];
                                final tasks = _tasksForCategory(category);
                                final warning = _deadlineWarningForCategory(
                                  tasks,
                                );
                                return TweenAnimationBuilder<double>(
                                  duration: Duration(
                                    milliseconds: 260 + index * 45,
                                  ),
                                  curve: Curves.easeOutBack,
                                  tween: Tween(begin: 0, end: 1),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(0, (1 - value) * 22),
                                      child: Transform.scale(
                                        scale: 0.86 + value * 0.14,
                                        child: Opacity(
                                          opacity: value.clamp(0, 1),
                                          child: child,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ReorderableCategoryCard(
                                    category: category,
                                    icon: _categoryIcon(category),
                                    iconColor: _categoryIconColor(category),
                                    badgeColor: _categoryBadgeColor(category),
                                    taskCount: tasks.length,
                                    doneCount: tasks
                                        .where((task) => task.isDone)
                                        .length,
                                    warning: warning,
                                    isDragging: _draggingCategory == category,
                                    onTap: () => _openCategory(category),
                                    onMove: (draggedCategory) => _moveCategory(
                                      draggedCategory: draggedCategory,
                                      targetCategory: category,
                                    ),
                                    onDragStarted: () {
                                      setState(() {
                                        _draggingCategory = category;
                                      });
                                    },
                                    onDragFinished: () {
                                      if (_draggingCategory == null) return;
                                      setState(() {
                                        _draggingCategory = null;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : CategoryFolderStackPreview(
                          key: const ValueKey('collapsed-folders'),
                          categories: _folderCategories,
                          folderColors: _categoryBadgeColors,
                          taskCount: _tasks.length,
                          onTap: () {
                            setState(() {
                              _isCategoryStackExpanded = true;
                            });
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openTaskForm(),
        backgroundColor: AppColors.olive,
        foregroundColor: AppColors.cream,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
