import 'dart:async';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_colors.dart';

class CategoryTasksPage extends StatefulWidget {
  const CategoryTasksPage({
    super.key,
    required this.category,
    required this.tasks,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.showAllTasks = false,
    this.showDoneOnly = false,
  });

  final String category;
  final List<Task> tasks;
  final ValueChanged<Task> onToggle;
  final Future<void> Function(Task task) onEdit;
  final ValueChanged<Task> onDelete;
  final bool showAllTasks;
  final bool showDoneOnly;

  @override
  State<CategoryTasksPage> createState() => _CategoryTasksPageState();
}

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        task.deadline != null &&
        !task.isDone &&
        task.deadline!.isBefore(DateTime.now());

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
      decoration: BoxDecoration(
        color: isOverdue ? const Color(0xFFFFE3DE) : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isOverdue
              ? const Color(0xFFD86B62)
              : task.isDone
              ? AppColors.sage
              : AppColors.line,
          width: isOverdue ? 1.6 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x145B4734),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: task.isDone ? AppColors.olive : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: task.isDone ? AppColors.olive : AppColors.line,
                  width: 2,
                ),
              ),
              child: task.isDone
                  ? const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: AppColors.cream,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          color: task.isDone ? AppColors.muted : AppColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                if (task.note.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    task.note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: task.isDone
                          ? AppColors.muted.withValues(alpha: 0.72)
                          : AppColors.muted,
                      height: 1.35,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sage.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.category,
                        style: const TextStyle(
                          color: AppColors.forest,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (task.deadline != null)
                      _DeadlineBadge(
                        deadline: task.deadline!,
                        isOverdue: isOverdue,
                      ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            color: AppColors.white,
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.muted),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Hapus'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeadlineBadge extends StatelessWidget {
  const _DeadlineBadge({required this.deadline, required this.isOverdue});

  final DateTime deadline;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isOverdue
            ? const Color(0xFFFFC7BF)
            : AppColors.cream.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 13,
            color: isOverdue ? const Color(0xFFC45E58) : AppColors.muted,
          ),
          const SizedBox(width: 5),
          Text(
            isOverdue ? 'Terlambat' : _formatRelativeDeadline(deadline),
            style: TextStyle(
              color: isOverdue ? const Color(0xFFC45E58) : AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRelativeDeadline(DateTime value) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(value.year, value.month, value.day);
    final difference = date.difference(today).inDays;
    final time = _formatTime(value);

    if (difference == 0) return 'Hari ini, $time';
    if (difference == 1) return 'Besok, $time';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${value.day} ${months[value.month - 1]}, $time';
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: AppColors.sage,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: AppColors.forest,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Belum ada tugas',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan tugas baru atau pilih kategori lain untuk melihat daftar yang tersedia.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _CategoryTasksPageState extends State<CategoryTasksPage> {
  late final Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  List<Task> get _baseTasks {
    return (widget.showAllTasks
            ? widget.tasks
            : widget.tasks.where((task) => task.category == widget.category))
        .toList();
  }

  List<Task> get _tasks {
    if (widget.showDoneOnly) {
      return _baseTasks.where((task) => task.isDone).toList();
    }

    return _baseTasks.where((task) => !task.isDone).toList();
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryTasksPage(
          category: widget.category,
          tasks: widget.tasks,
          onToggle: widget.onToggle,
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
          showAllTasks: widget.showAllTasks,
          showDoneOnly: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _tasks;
    final baseTasks = _baseTasks;
    final doneCount = baseTasks.where((task) => task.isDone).length;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton.filled(
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.forest,
                          ),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontFamily: 'IrishGrover',
                              fontSize: 34,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!widget.showDoneOnly) ...[
                          IconButton.filledTonal(
                            onPressed: _openHistory,
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.line.withValues(
                                alpha: 0.82,
                              ),
                              foregroundColor: AppColors.muted,
                              fixedSize: const Size(34, 34),
                              minimumSize: const Size(34, 34),
                              padding: EdgeInsets.zero,
                            ),
                            icon: const Icon(Icons.check_rounded, size: 20),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          '$doneCount/${baseTasks.length} selesai',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.showDoneOnly
                          ? 'Daftar tugas yang sudah selesai.'
                          : 'Daftar tugas berdasarkan kategori yang kamu pilih.',
                      style: const TextStyle(
                        color: AppColors.muted,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (tasks.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
                sliver: SliverList.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      task: task,
                      onToggle: () {
                        widget.onToggle(task);
                        setState(() {});
                      },
                      onEdit: () async {
                        await widget.onEdit(task);
                        setState(() {});
                      },
                      onDelete: () {
                        widget.onDelete(task);
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
