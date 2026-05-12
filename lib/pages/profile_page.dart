import 'package:flutter/material.dart';

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
    required this.credentials,
    required this.onCredentialsChanged,
    required this.onAdd,
  });

  final int completedToday;
  final int dailyTarget;
  final int totalTasks;
  final int doneTasks;
  final UserCredentials credentials;
  final ValueChanged<UserCredentials> onCredentialsChanged;
  final VoidCallback onAdd;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    final credentials = UserCredentials(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      signInMethod: widget.credentials.signInMethod,
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
    final signInMethod = widget.credentials.signInMethod;
    final identifierController = signInMethod == SignInMethod.email
        ? _emailController
        : _usernameController;
    final identifierLabel = signInMethod == SignInMethod.email
        ? 'Email'
        : 'Username';
    final identifierIcon = signInMethod == SignInMethod.email
        ? Icons.mail_rounded
        : Icons.person_rounded;

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
                  _ProfileTextField(
                    controller: identifierController,
                    label: identifierLabel,
                    icon: identifierIcon,
                    keyboardType: signInMethod == SignInMethod.email
                        ? TextInputType.emailAddress
                        : TextInputType.text,
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

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

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
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
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
