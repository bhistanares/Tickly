import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_colors.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({
    super.key,
    required this.categories,
    required this.categoryIcons,
    this.task,
  });

  final List<String> categories;
  final Map<String, IconData> categoryIcons;
  final Task? task;

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late final TextEditingController _newCategoryController;
  late final List<String> _categories;
  late String _category;
  DateTime? _deadline;
  bool _showNewCategoryField = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _noteController = TextEditingController(text: widget.task?.note ?? '');
    _newCategoryController = TextEditingController();
    _categories = List<String>.from(widget.categories);
    final taskCategory = widget.task?.category;
    if (taskCategory != null && !_categories.contains(taskCategory)) {
      _categories.add(taskCategory);
    }
    _category = widget.task?.category ?? _categories.first;
    _deadline = widget.task?.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  void _addCategory() {
    final newCategory = _newCategoryController.text.trim();
    if (newCategory.isEmpty) return;

    final existingIndex = _categories.indexWhere(
      (category) => category.toLowerCase() == newCategory.toLowerCase(),
    );

    setState(() {
      if (existingIndex == -1) {
        _categories.add(newCategory);
        _category = newCategory;
      } else {
        _category = _categories[existingIndex];
      }

      _newCategoryController.clear();
      _showNewCategoryField = false;
    });
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      TaskFormResult(
        title: _titleController.text.trim(),
        category: _category,
        categoryIcon: widget.categoryIcons[_category] ?? Icons.folder_rounded,
        note: _noteController.text.trim(),
        deadline: _deadline,
      ),
    );
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final initialDate = _deadline ?? now;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Pilih deadline',
      cancelText: 'Batal',
      confirmText: 'Lanjut',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.olive,
              onPrimary: AppColors.cream,
              surface: AppColors.white,
              onSurface: AppColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null || !mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _deadline == null
          ? TimeOfDay.fromDateTime(now)
          : TimeOfDay.fromDateTime(_deadline!),
      helpText: 'Pilih jam',
      cancelText: 'Batal',
      confirmText: 'Pakai',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.olive,
              onPrimary: AppColors.cream,
              surface: AppColors.white,
              onSurface: AppColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null) return;

    setState(() {
      _deadline = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    });
  }

  void _clearDeadline() {
    setState(() {
      _deadline = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          child: Form(
            key: _formKey,
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
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _isEditing ? 'Perbarui tugasmu' : 'Buat tugas baru',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const Text(
                  'Tulis jelas, pilih kategori, lalu simpan supaya rencana hari ini lebih tertata.',
                  style: TextStyle(
                    color: AppColors.muted,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                FormCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel(label: 'Judul tugas'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration(
                          hint: 'Contoh: Kerjakan PR Bahasa Inggris',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Judul tugas wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const FieldLabel(label: 'Kategori'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: _inputDecoration(hint: 'Pilih kategori'),
                        borderRadius: BorderRadius.circular(18),
                        dropdownColor: AppColors.white,
                        items: _categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Row(
                                  children: [
                                    Icon(
                                      widget.categoryIcons[category] ??
                                          Icons.folder_rounded,
                                      size: 18,
                                      color: AppColors.forest,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(category),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _category = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _showNewCategoryField = !_showNewCategoryField;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.olive,
                            padding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            _showNewCategoryField
                                ? Icons.close_rounded
                                : Icons.create_new_folder_rounded,
                            size: 18,
                          ),
                          label: Text(
                            _showNewCategoryField
                                ? 'Batal tambah kategori'
                                : 'Tambah kategori baru',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      if (_showNewCategoryField) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _newCategoryController,
                                textInputAction: TextInputAction.done,
                                decoration: _inputDecoration(
                                  hint: 'Contoh: Organisasi',
                                  prefixIcon: const Icon(
                                    Icons.folder_rounded,
                                    color: AppColors.forest,
                                  ),
                                ),
                                onFieldSubmitted: (_) => _addCategory(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 54,
                              child: FilledButton(
                                onPressed: _addCategory,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.olive,
                                  foregroundColor: AppColors.cream,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Pakai',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
                      const FieldLabel(label: 'Deadline'),
                      const SizedBox(height: 8),
                      _DeadlineSelector(
                        deadline: _deadline,
                        onPick: _pickDeadline,
                        onClear: _clearDeadline,
                      ),
                      const SizedBox(height: 20),
                      const FieldLabel(label: 'Catatan'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _noteController,
                        minLines: 4,
                        maxLines: 5,
                        decoration: _inputDecoration(
                          hint: 'Tambahkan detail kecil agar mudah dikerjakan',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _saveTask,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.forest,
                      foregroundColor: AppColors.cream,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.check_rounded),
                    label: Text(
                      _isEditing ? 'Simpan Perubahan' : 'Tambah Tugas',
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
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAAA79F)),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: AppColors.cream,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        borderSide: const BorderSide(color: Color(0xFFC65F58), width: 1.4),
      ),
    );
  }
}

class FormCard extends StatelessWidget {
  const FormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x165B4734),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DeadlineSelector extends StatelessWidget {
  const _DeadlineSelector({
    required this.deadline,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? deadline;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasDeadline = deadline != null;

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: hasDeadline ? AppColors.blush : AppColors.sage,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                hasDeadline
                    ? Icons.event_available_rounded
                    : Icons.event_rounded,
                color: AppColors.forest,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasDeadline
                        ? _formatDeadline(deadline!)
                        : 'Pilih tanggal dan jam',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hasDeadline ? 'Deadline tugas' : 'Opsional',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (hasDeadline)
              IconButton(
                onPressed: onClear,
                color: AppColors.muted,
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Hapus deadline',
              )
            else
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }

  String _formatDeadline(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day/$month/${value.year} - $hour.$minute';
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900),
    );
  }
}
