import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/user_credentials.dart';
import '../theme/app_colors.dart';
import '../widgets/tickly_bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.completedToday,
    required this.dailyTarget,
    required this.totalTasks,
    required this.doneTasks,
    required this.tasks,
    required this.credentials,
    required this.onCredentialsChanged,
    required this.onAdd,
  });

  final int completedToday;
  final int dailyTarget;
  final int totalTasks;
  final int doneTasks;
  final List<Task> tasks;
  final UserCredentials credentials;
  final ValueChanged<UserCredentials> onCredentialsChanged;
  final VoidCallback onAdd;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.credentials.username,
    );
    _emailController = TextEditingController(text: widget.credentials.email);
    _passwordController = TextEditingController(
      text: widget.credentials.password,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveCredentials() {
    if (!_formKey.currentState!.validate()) return;

    final credentials = UserCredentials(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      signInMethod: SignInMethod.email,
    );

    widget.onCredentialsChanged(credentials);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data sign in diperbarui'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.forest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.dailyTarget == 0
        ? 0.0
        : (widget.completedToday / widget.dailyTarget).clamp(0.0, 1.0);
    final remaining = (widget.dailyTarget - widget.completedToday).clamp(
      0,
      widget.dailyTarget,
    );
    final priorityTasks = _priorityTasks();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 110),
          children: [
            const Text(
              'Profil',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.ink,
                fontFamily: 'IrishGrover',
                fontSize: 34,
                height: 1,
              ),
            ),
            const SizedBox(height: 18),
            _ProfileSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Sign In',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Ubah data yang dipakai untuk masuk ke akun Tickly.',
                    style: TextStyle(
                      color: AppColors.muted,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _ProfileTextField(
                          controller: _usernameController,
                          label: 'Username',
                          icon: Icons.person_rounded,
                          validator: _validateUsername,
                        ),
                        const SizedBox(height: 14),
                        _ProfileTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.mail_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 14),
                        _ProfileTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_rounded,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _saveCredentials,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.forest,
                        foregroundColor: AppColors.cream,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(Icons.save_rounded),
                      label: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ProfileSection(
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
                              'Progress Anda',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 22,
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
                    '${widget.completedToday}/${widget.dailyTarget} tugas selesai hari ini',
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.completedToday >= widget.dailyTarget
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
            _PrioritySection(tasks: priorityTasks),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ProfileMiniCard(
                    label: 'Semua tugas',
                    value: widget.totalTasks.toString(),
                    icon: Icons.format_list_bulleted_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProfileMiniCard(
                    label: 'Total selesai',
                    value: widget.doneTasks.toString(),
                    icon: Icons.check_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: TicklyBottomBar(
        onAdd: widget.onAdd,
        onHome: () => Navigator.of(context).pop(),
        onProfile: () {},
        selectedIndex: 1,
      ),
    );
  }

  String? _validateUsername(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) {
      return widget.credentials.signInMethod == SignInMethod.username
          ? 'Username wajib diisi'
          : null;
    }
    if (username.length < 3) return 'Minimal 3 karakter';
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email wajib diisi';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Format email belum valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password wajib diisi';
    if (value.length < 6) return 'Minimal 6 karakter';
    return null;
  }

  List<Task> _priorityTasks() {
    final tasks = widget.tasks.where((task) => !task.isDone).toList();
    tasks.sort((first, second) {
      final firstScore = _priorityScore(first);
      final secondScore = _priorityScore(second);
      if (firstScore != secondScore) return firstScore.compareTo(secondScore);

      final firstDeadline = first.deadline;
      final secondDeadline = second.deadline;
      if (firstDeadline != null && secondDeadline != null) {
        return firstDeadline.compareTo(secondDeadline);
      }
      if (firstDeadline != null) return -1;
      if (secondDeadline != null) return 1;

      return first.id.compareTo(second.id);
    });

    return tasks.take(3).toList();
  }

  int _priorityScore(Task task) {
    final deadline = task.deadline;
    if (deadline == null) return task.isPinned ? 30 : 40;
    if (deadline.isBefore(DateTime.now())) return 0;
    if (deadline.difference(DateTime.now()) <= const Duration(days: 1)) {
      return 10;
    }
    if (deadline.difference(DateTime.now()) <= const Duration(days: 2)) {
      return 20;
    }
    return task.isPinned ? 25 : 35;
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class _PrioritySection extends StatelessWidget {
  const _PrioritySection({required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blush,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.priority_high_rounded,
                  color: Color(0xFFC45E58),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skala Prioritas',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tugas yang sebaiknya dikerjakan dulu.',
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
          const SizedBox(height: 18),
          if (tasks.isEmpty)
            const _PriorityEmptyState()
          else
            for (var index = 0; index < tasks.length; index++) ...[
              _PriorityTaskTile(task: tasks[index], rank: index + 1),
              if (index != tasks.length - 1) const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _PriorityEmptyState extends StatelessWidget {
  const _PriorityEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: const Text(
        'Tidak ada tugas tertunda. Semua sudah beres.',
        style: TextStyle(
          color: AppColors.muted,
          height: 1.35,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PriorityTaskTile extends StatelessWidget {
  const _PriorityTaskTile({required this.task, required this.rank});

  final Task task;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final deadline = task.deadline;
    final status = _priorityStatus(deadline);
    final statusColor = _priorityColor(deadline);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: statusColor.withValues(alpha: 0.46)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  color: AppColors.cream,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${task.category} • $status',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _priorityStatus(DateTime? deadline) {
    if (deadline == null) return 'Belum ada deadline';

    final now = DateTime.now();
    if (deadline.isBefore(now)) return 'Terlambat';
    if (_isSameDay(deadline, now)) return 'Deadline hari ini';
    if (_isSameDay(deadline, now.add(const Duration(days: 1)))) {
      return 'Deadline besok';
    }

    return 'Deadline ${_formatDate(deadline)}';
  }

  Color _priorityColor(DateTime? deadline) {
    if (deadline == null) return AppColors.forest;

    final remaining = deadline.difference(DateTime.now());
    if (remaining.isNegative) return const Color(0xFFC45E58);
    if (remaining <= const Duration(days: 1)) return const Color(0xFFD58B2A);
    return AppColors.olive;
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.forest),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.cream,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.olive, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFC65F58)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Color(0xFFC65F58),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
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
