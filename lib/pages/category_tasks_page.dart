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
    this.onEditCategory,
    this.onDeleteCategory,
    this.showAllTasks = false,
    this.showDoneOnly = false,
  });

  final String category;
  final List<Task> tasks;
  final ValueChanged<Task> onToggle;
  final Future<void> Function(Task task) onEdit;
  final ValueChanged<Task> onDelete;
  final Future<String?> Function(String category)? onEditCategory;
  final Future<bool> Function(String category)? onDeleteCategory;
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
    this.onTogglePin,
    this.showPinControls = false,
    this.reorderIndex,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTogglePin;
  final bool showPinControls;
  final int? reorderIndex;

  @override
  Widget build(BuildContext context) {
    final isNearDeadline =
        task.deadline != null &&
        !task.isDone &&
        !task.deadline!.isBefore(DateTime.now()) &&
        task.deadline!.difference(DateTime.now()) <= const Duration(days: 2);
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
              : task.isPinned && showPinControls && !task.isDone
              ? AppColors.olive
              : task.isDone
              ? AppColors.sage
              : AppColors.line,
          width: isOverdue || (task.isPinned && showPinControls && !task.isDone)
              ? 1.6
              : 1,
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
                    if (task.isPinned && showPinControls && !task.isDone) ...[
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.sage,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.push_pin_rounded,
                          size: 14,
                          color: AppColors.olive,
                        ),
                      ),
                    ],
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
                        isNearDeadline: isNearDeadline,
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
              if (value == 'pin') onTogglePin?.call();
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              if (showPinControls && !task.isDone)
                PopupMenuItem(
                  value: 'pin',
                  child: Row(
                    children: [
                      Icon(
                        task.isPinned
                            ? Icons.push_pin_outlined
                            : Icons.push_pin_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(task.isPinned ? 'Lepas sematan' : 'Sematkan'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
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
          if (showPinControls && !task.isDone)
            ReorderableDragStartListener(
              index: reorderIndex ?? 0,
              child: const Padding(
                padding: EdgeInsets.only(top: 10, right: 4),
                child: Icon(
                  Icons.drag_indicator_rounded,
                  color: AppColors.muted,
                  size: 22,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DeadlineBadge extends StatelessWidget {
  const _DeadlineBadge({
    required this.deadline,
    required this.isOverdue,
    required this.isNearDeadline,
  });

  final DateTime deadline;
  final bool isOverdue;
  final bool isNearDeadline;

  @override
  Widget build(BuildContext context) {
    final badgeColor = isOverdue
        ? const Color(0xFFFFC7BF)
        : AppColors.cream.withValues(alpha: 0.9);
    final contentColor = isOverdue
        ? const Color(0xFFC45E58)
        : isNearDeadline
        ? AppColors.forest
        : AppColors.muted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 13, color: contentColor),
          const SizedBox(width: 5),
          Text(
            isOverdue ? 'Terlambat' : _formatRelativeDeadline(deadline),
            style: TextStyle(
              color: contentColor,
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
  late String _category;

  bool get _canManageCategory =>
      !widget.showAllTasks &&
      !widget.showDoneOnly &&
      widget.onEditCategory != null &&
      widget.onDeleteCategory != null;

  bool get _canReorderTasks => !widget.showAllTasks && !widget.showDoneOnly;

  @override
  void initState() {
    super.initState();
    _category = widget.category;
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
            : widget.tasks.where((task) => task.category == _category))
        .toList();
  }

  List<Task> get _tasks {
    if (widget.showDoneOnly) {
      return _baseTasks.where((task) => task.isDone).toList();
    }

    return _baseTasks.where((task) => !task.isDone).toList();
  }

  bool _isActiveCategoryTask(Task task) {
    return !task.isDone && task.category == _category;
  }

  void _moveTaskToCategoryTop(Task task) {
    widget.tasks.remove(task);
    final insertIndex = widget.tasks.indexWhere(_isActiveCategoryTask);
    widget.tasks.insert(
      insertIndex == -1 ? widget.tasks.length : insertIndex,
      task,
    );
  }

  void _toggleTaskPin(Task task) {
    setState(() {
      task.isPinned = !task.isPinned;
      if (task.isPinned) {
        _moveTaskToCategoryTop(task);
      } else {
        widget.tasks.remove(task);
        final firstUnpinnedIndex = widget.tasks.indexWhere(
          (item) => _isActiveCategoryTask(item) && !item.isPinned,
        );
        widget.tasks.insert(
          firstUnpinnedIndex == -1 ? widget.tasks.length : firstUnpinnedIndex,
          task,
        );
      }
    });
  }

  void _reorderTask(int oldIndex, int newIndex) {
    if (!_canReorderTasks) return;

    final visibleTasks = _tasks;
    if (oldIndex < 0 || oldIndex >= visibleTasks.length) return;

    if (newIndex > oldIndex) newIndex--;
    final movedTask = visibleTasks[oldIndex];
    final remainingVisibleTasks = List<Task>.of(visibleTasks)
      ..removeAt(oldIndex);
    final pinnedCount = visibleTasks.where((task) => task.isPinned).length;
    final pinnedCountAfterMove = remainingVisibleTasks
        .where((task) => task.isPinned)
        .length;
    final safeNewIndex =
        (movedTask.isPinned
                ? newIndex.clamp(0, pinnedCountAfterMove)
                : newIndex.clamp(pinnedCount, remainingVisibleTasks.length))
            .toInt();
    final targetTask = safeNewIndex < remainingVisibleTasks.length
        ? remainingVisibleTasks[safeNewIndex]
        : null;

    setState(() {
      widget.tasks.remove(movedTask);

      if (targetTask != null) {
        final targetIndex = widget.tasks.indexOf(targetTask);
        widget.tasks.insert(targetIndex, movedTask);
        return;
      }

      var insertIndex = widget.tasks.length;
      for (var index = widget.tasks.length - 1; index >= 0; index--) {
        if (_isActiveCategoryTask(widget.tasks[index])) {
          insertIndex = index + 1;
          break;
        }
      }
      widget.tasks.insert(insertIndex, movedTask);
    });
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryTasksPage(
          category: _category,
          tasks: widget.tasks,
          onToggle: widget.onToggle,
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
          onEditCategory: widget.onEditCategory,
          onDeleteCategory: widget.onDeleteCategory,
          showAllTasks: widget.showAllTasks,
          showDoneOnly: true,
        ),
      ),
    );
  }

  Future<void> _handleCategoryAction(String action) async {
    if (action == 'edit') {
      final newName = await widget.onEditCategory?.call(_category);
      if (newName == null || !mounted) return;
      setState(() {
        _category = newName;
      });
      return;
    }

    if (action == 'delete') {
      final deleted = await widget.onDeleteCategory?.call(_category);
      if (deleted != true || !mounted) return;
      Navigator.of(context).pop();
    }
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
                            _category,
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
                        if (_canManageCategory)
                          PopupMenuButton<String>(
                            color: AppColors.white,
                            icon: const Icon(
                              Icons.more_vert_rounded,
                              color: AppColors.muted,
                            ),
                            onSelected: _handleCategoryAction,
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded, size: 18),
                                    SizedBox(width: 10),
                                    Text('Edit kategori'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_rounded, size: 18),
                                    SizedBox(width: 10),
                                    Text('Hapus kategori'),
                                  ],
                                ),
                              ),
                            ],
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
            else if (_canReorderTasks)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    proxyDecorator: (child, index, animation) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          final scale = 1 + animation.value * 0.03;
                          return Transform.scale(
                            scale: scale,
                            child: Material(
                              color: Colors.transparent,
                              child: child,
                            ),
                          );
                        },
                        child: child,
                      );
                    },
                    onReorder: _reorderTask,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        key: ValueKey(task.id),
                        padding: EdgeInsets.only(
                          bottom: index == tasks.length - 1 ? 0 : 12,
                        ),
                        child: TaskTile(
                          task: task,
                          showPinControls: true,
                          reorderIndex: index,
                          onTogglePin: () => _toggleTaskPin(task),
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
                        ),
                      );
                    },
                  ),
                ),
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
                      showPinControls: false,
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
