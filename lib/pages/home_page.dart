import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                      fontSize: 34,
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

class _HomePageState extends State<HomePage> {
  final List<String> _categories = ['Pribadi', 'Belajar', 'Sekolah', 'Belanja'];

  final Map<String, IconData> _categoryIcons = {
    'Pribadi': Icons.spa_rounded,
    'Belajar': Icons.menu_book_rounded,
    'Sekolah': Icons.school_rounded,
    'Belanja': Icons.shopping_cart_rounded,
  };

  final Map<String, Color> _categoryIconColors = {
    'Pribadi': Color(0xFFFFD1C8),
    'Belajar': Color(0xFFCFE6D9),
    'Sekolah': Color(0xFFFFE0A8),
    'Belanja': Color(0xFFD9D0FF),
  };

  final Map<String, Color> _categoryBadgeColors = {
    'Pribadi': Color(0xFF7F5A68),
    'Belajar': Color(0xFF4F6F68),
    'Sekolah': Color(0xFF8A6F4D),
    'Belanja': Color(0xFF6E5A7D),
  };

  int _nextId = 5;
  Timer? _deadlineAlertTimer;
  final Set<int> _alertedOverdueTaskIds = {};

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
    return normalizedCategory != 'semua' && normalizedCategory != 'ekskul';
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
    SystemSound.play(SystemSoundType.alert);

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
        ),
      ),
    );
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
                    const SizedBox(height: 22),
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
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 100),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final category = _folderCategories[index];
                  final tasks = _tasksForCategory(category);
                  final warning = _deadlineWarningForCategory(tasks);
                  return CategoryCard(
                    label: category,
                    icon: _categoryIcon(category),
                    iconColor: _categoryIconColor(category),
                    badgeColor: _categoryBadgeColor(category),
                    taskCount: tasks.length,
                    doneCount: tasks.where((task) => task.isDone).length,
                    warningLabel: warning?.label,
                    isWarningCritical: warning?.isCritical ?? false,
                    onTap: () => _openCategory(category),
                  );
                }, childCount: _folderCategories.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.12,
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
