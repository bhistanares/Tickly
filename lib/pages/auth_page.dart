import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = false;
  bool _useEmail = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(milliseconds: 520), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const HomePage(),
          transitionDuration: const Duration(milliseconds: 520),
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.03),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  void _setMode(bool isSignUp) {
    setState(() {
      _isSignUp = isSignUp;
      if (isSignUp) _useEmail = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(bottom: bottomInset > 0 ? 10 : 0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _AuthHeader(),
                const SizedBox(height: 24),
                _ModeSwitch(isSignUp: _isSignUp, onChanged: _setMode),
                const SizedBox(height: 18),
                _AuthCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _isSignUp ? 'Buat akun' : 'Masuk akun',
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            _EmailToggle(
                              enabled: _useEmail,
                              onTap: _isSignUp
                                  ? null
                                  : () {
                                      setState(() => _useEmail = !_useEmail);
                                    },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isSignUp
                              ? 'Siapkan akun Tickly untuk mulai menata tugasmu.'
                              : _useEmail
                              ? 'Login menggunakan email dan password.'
                              : 'Login menggunakan username dan password.',
                          style: const TextStyle(
                            color: AppColors.muted,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 22),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: _useEmail || _isSignUp
                              ? _AuthTextField(
                                  key: const ValueKey('email-field'),
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'nama@email.com',
                                  icon: Icons.mail_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                )
                              : _AuthTextField(
                                  key: const ValueKey('username-field'),
                                  controller: _nameController,
                                  label: 'Username',
                                  hint: 'Contoh: hyu_tickly',
                                  icon: Icons.person_rounded,
                                  validator: _validateName,
                                ),
                        ),
                        if (_isSignUp) ...[
                          const SizedBox(height: 16),
                          _AuthTextField(
                            controller: _nameController,
                            label: 'Username',
                            hint: 'Contoh: hyu_tickly',
                            icon: Icons.badge_rounded,
                            validator: _validateName,
                          ),
                        ],
                        const SizedBox(height: 16),
                        _AuthTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Minimal 6 karakter',
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
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.olive,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'Ingat saya',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (!_isSignUp)
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Fitur reset password segera hadir',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppColors.forest,
                                    ),
                                  );
                                },
                                child: const Text('Lupa password?'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton.icon(
                            onPressed: _isSubmitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.forest,
                              foregroundColor: AppColors.cream,
                              disabledBackgroundColor: AppColors.forest
                                  .withValues(alpha: 0.42),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: _isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: AppColors.cream,
                                    ),
                                  )
                                : Icon(
                                    _isSignUp
                                        ? Icons.person_add_alt_rounded
                                        : Icons.login_rounded,
                                  ),
                            label: Text(
                              _isSignUp ? 'Daftar Sekarang' : 'Masuk',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _QuickAccessPanel(
                  useEmail: _useEmail || _isSignUp,
                  onEmailTap: () {
                    setState(() {
                      _isSignUp = false;
                      _useEmail = true;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Minimal 3 karakter';
    }
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
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x145B4734),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF0B865), Color(0xFF74411F)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Color(0x55D7C733), blurRadius: 18),
              ],
            ),
            child: const Icon(
              Icons.fact_check_rounded,
              color: Color(0xFFFFF0DB),
              size: 34,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tickly',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontFamily: 'Kranky',
                    fontSize: 42,
                    height: 0.95,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Masuk untuk menjaga semua rencana tetap rapi.',
                  style: TextStyle(
                    color: AppColors.muted,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
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

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.isSignUp, required this.onChanged});

  final bool isSignUp;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          _ModeButton(
            label: 'Login',
            icon: Icons.login_rounded,
            selected: !isSignUp,
            onTap: () => onChanged(false),
          ),
          _ModeButton(
            label: 'Sign Up',
            icon: Icons.person_add_alt_rounded,
            selected: isSignUp,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected ? AppColors.olive : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? AppColors.cream : AppColors.muted,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppColors.cream : AppColors.muted,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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

class _EmailToggle extends StatelessWidget {
  const _EmailToggle({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: enabled ? 'Login email aktif' : 'Gunakan email',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: enabled ? AppColors.sage : AppColors.cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: enabled ? AppColors.olive : AppColors.line,
            ),
          ),
          child: Icon(
            Icons.alternate_email_rounded,
            color: enabled ? AppColors.forest : AppColors.muted,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
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
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFAAA79F)),
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

class _QuickAccessPanel extends StatelessWidget {
  const _QuickAccessPanel({required this.useEmail, required this.onEmailTap});

  final bool useEmail;
  final VoidCallback onEmailTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.sage.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.mark_email_read_rounded,
              color: AppColors.forest,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Punya akun berbasis email?',
              style: TextStyle(
                color: AppColors.forest,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton(
            onPressed: useEmail ? null : onEmailTap,
            child: Text(useEmail ? 'Aktif' : 'Login email'),
          ),
        ],
      ),
    );
  }
}
