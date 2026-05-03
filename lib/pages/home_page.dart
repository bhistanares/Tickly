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
                      fontSize: 44,
                      fontWeight: FontWeight.w400,
                      height: 1.05,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 16,
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
              padding: EdgeInsets.only(top: 8),
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

class MotivationCard extends StatefulWidget {
  const MotivationCard({super.key});

  @override
  State<MotivationCard> createState() => _MotivationCardState();
}

class _MotivationCardState extends State<MotivationCard> {
  final PageController _pageController = PageController();
  late final Timer _timer;
  int _currentIndex = 0;

  final List<String> _messages = const [
    'Sudah ngapain aja kamu hari ini?',
    'Selesaikan sedikit demi sedikit, nanti terasa ringan.',
    'Buat dirimu lebih santai dengan tugas yang tertata.',
  ];

  final List<List<Color>> _gradients = const [
    [Color(0xFF6B543B), Color(0xFFEEDDC4)],
    [Color(0xFF8F9229), Color(0xFFE7E3BF)],
    [Color(0xFFC86F65), AppColors.blush],
  ];

  final List<Color> _textColors = const [
    AppColors.cream,
    AppColors.ink,
    AppColors.ink,
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % _messages.length;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[_currentIndex];
    final textColor = _textColors[_currentIndex];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x245B4734),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: SizedBox(
        height: 44,
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _messages[index],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
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
  });

  final String label;
  final String value;
  final IconData icon;

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

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x165B4734),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 22),
          const SizedBox(height: 12),
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
            style: TextStyle(
              color: accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
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
    required this.taskCount,
    required this.doneCount,
    required this.onTap,
  });

  final String label;
  final int taskCount;
  final int doneCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pendingCount = taskCount - doneCount;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x145B4734),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _categoryColor(label),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _categoryIcon(label),
                color: label == 'Belanja' ? AppColors.gold : AppColors.forest,
                size: 24,
              ),
            ),
            const Spacer(),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$taskCount tugas - $pendingCount tertunda',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(String category) {
    return switch (category) {
      'Semua' => AppColors.cream,
      'Pribadi' => AppColors.blush,
      'Belajar' => AppColors.sage,
      'Sekolah' => const Color(0xFFF4E0C8),
      'Belanja' => AppColors.forest,
      _ => const Color(0xFFEFE4CF),
    };
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'Semua' => Icons.dashboard_rounded,
      'Pribadi' => Icons.spa_rounded,
      'Belajar' => Icons.menu_book_rounded,
      'Sekolah' => Icons.school_rounded,
      'Belanja' => Icons.shopping_cart_rounded,
      _ => Icons.folder_rounded,
    };
  }
}

class _HomePageState extends State<HomePage> {
  final List<String> _categories = [
    'Semua',
    'Pribadi',
    'Belajar',
    'Sekolah',
    'Belanja',
  ];

  int _nextId = 5;

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

  Future<void> _openTaskForm({Task? task}) async {
    final result = await Navigator.of(context).push<TaskFormResult>(
      MaterialPageRoute(
        builder: (_) => TaskFormPage(
          categories: _categories
              .where((category) => category != 'Semua')
              .toList(),
          task: task,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      if (!_categories.contains(result.category)) {
        _categories.add(result.category);
      }

      if (task == null) {
        _tasks.insert(
          0,
          Task(
            id: _nextId++,
            title: result.title,
            category: result.category,
            note: result.note,
            isDone: false,
          ),
        );
      } else {
        task
          ..title = result.title
          ..category = result.category
          ..note = result.note;
      }
    });
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
    if (category == 'Semua') return _tasks;
    return _tasks.where((task) => task.category == category).toList();
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.removeWhere((item) => item.id == task.id);
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
                    const MotivationCard(),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'Total',
                            value: _tasks.length.toString(),
                            icon: Icons.format_list_bulleted_rounded,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
                            label: 'Selesai',
                            value: _doneCount.toString(),
                            icon: Icons.check_rounded,
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
                          '${_categories.length} folder',
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
                  final category = _categories[index];
                  final tasks = _tasksForCategory(category);
                  return CategoryCard(
                    label: category,
                    taskCount: tasks.length,
                    doneCount: tasks.where((task) => task.isDone).length,
                    onTap: () => _openCategory(category),
                  );
                }, childCount: _categories.length),
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
