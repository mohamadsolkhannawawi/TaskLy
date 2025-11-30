// filepath: d:\Code\PBP\Mobile\Flutter\todolist\lib\features\tasks\presentation\pages\task_editor_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../widgets/category_selector.dart';
import '../../../../core/utils/app_colors.dart';

/// Task Editor Page - Add/Edit task form
class TaskEditorPage extends StatefulWidget {
  final Task? task; // null = Add mode, not null = Edit mode

  const TaskEditorPage({super.key, this.task});

  @override
  State<TaskEditorPage> createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends State<TaskEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _locationController;
  late TextEditingController _titleController;
  late String _selectedCategory;
  late DateTime _selectedStartDate;
  late TimeOfDay _selectedStartTime;
  late DateTime _selectedDeadline;
  late TimeOfDay _selectedTime;

  bool get isEditMode => widget.task != null;
  @override
  void initState() {
    super.initState();

    // Initialize with existing task data or defaults
    if (isEditMode) {
      _titleController = TextEditingController(text: widget.task!.title);
      _locationController = TextEditingController(
        text: widget.task!.location ?? '',
      );
      _selectedCategory = widget.task!.category;
      _selectedStartDate = widget.task!.startDate;
      _selectedStartTime = TimeOfDay.fromDateTime(widget.task!.startDate);
      _selectedDeadline = widget.task!.deadline;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.deadline);
    } else {
      _titleController = TextEditingController();
      _locationController = TextEditingController();
      // Get first available category or default to 'Work'
      final provider = Provider.of<TaskProvider>(context, listen: false);
      final categories = provider.availableCategories;
      _selectedCategory = categories.isNotEmpty ? categories.first : 'Work';
      _selectedStartDate = DateTime.now();
      _selectedStartTime = TimeOfDay.now();
      _selectedDeadline = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.successGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedStartTime.hour,
          _selectedStartTime.minute,
        );

        // Auto-adjust deadline if start date is after deadline
        if (_selectedStartDate.isAfter(_selectedDeadline)) {
          _selectedDeadline = _selectedStartDate.add(const Duration(hours: 1));
          _selectedTime = TimeOfDay.fromDateTime(_selectedDeadline);
        }
      });
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.successGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedStartTime = picked;
        _selectedStartDate = DateTime(
          _selectedStartDate.year,
          _selectedStartDate.month,
          _selectedStartDate.day,
          picked.hour,
          picked.minute,
        );

        // Auto-adjust deadline if start time is after deadline
        if (_selectedStartDate.isAfter(_selectedDeadline)) {
          _selectedDeadline = _selectedStartDate.add(const Duration(hours: 1));
          _selectedTime = TimeOfDay.fromDateTime(_selectedDeadline);
        }
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _selectedDeadline = DateTime(
          _selectedDeadline.year,
          _selectedDeadline.month,
          _selectedDeadline.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TaskProvider>(context, listen: false);

      final task = Task(
        id: isEditMode ? widget.task!.id : null,
        title: _titleController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        category: _selectedCategory,
        startDate: _selectedStartDate,
        deadline: _selectedDeadline,
        isDone: isEditMode ? widget.task!.isDone : false,
      );

      if (isEditMode) {
        provider.editTask(widget.task!.id, task);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Task updated successfully',
              style: TextStyle(
                color: Color(0xFF1B1B1B), // Dark text for readability
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.successMint, // Mint Green
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 5), // Auto-dismiss in 5 seconds
          ),
        );
      } else {
        provider.addTask(task);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Task added successfully',
              style: TextStyle(
                color: Color(0xFF1B1B1B), // Dark text for readability
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.successMint, // Mint Green
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 5), // Auto-dismiss in 5 seconds
          ),
        );
      }

      Navigator.pop(context);
    }
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.warningOrange),
              SizedBox(width: 12),
              Text('Delete Task?'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${widget.task!.title}"? This action cannot be undone.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteTask();
                Navigator.pop(context); // Close dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// Delete the task
  void _deleteTask() {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final taskTitle = widget.task!.title;

    provider.deleteTask(widget.task!.id);

    Navigator.pop(context); // Close editor page

    final snackBar = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task "$taskTitle" deleted',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.deleteRaspberry, // Vibrant Raspberry #CD2C58
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5), // Auto-dismiss in 5 seconds
        dismissDirection: DismissDirection.horizontal,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            provider.addTask(widget.task!);
          },
        ),
      ),
    );

    // Force dismiss after exactly 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      snackBar.close();
    });
  }

  /// Calculate duration between start and deadline
  String _calculateDuration() {
    final duration = _selectedDeadline.difference(_selectedStartDate);

    if (duration.isNegative) {
      return 'Invalid (End before Start)';
    }

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return '$days day${days > 1 ? 's' : ''} ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary, // Purple Header
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? 'Edit Task' : 'Add New Task',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Delete Button (only in Edit mode)
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: _showDeleteConfirmation,
              tooltip: 'Delete Task',
            ),
          TextButton(
            onPressed: _saveTask,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Task Title Input
            const Text(
              'Task Title',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter task title...',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
              autofocus: !isEditMode,
            ),

            const SizedBox(height: 24),

            // Category Selector
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            CategorySelector(
              selectedCategory: _selectedCategory,
              onChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 24),

            // Location / Place Input
            const Text(
              'Place',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter place or location (optional)...',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 24),

            // Start Date Selector (NEW)
            const Text(
              'Start Date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectStartDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_available,
                      color: AppColors.successGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      dateFormat.format(_selectedStartDate),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Start Time Selector (NEW)
            const Text(
              'Start Time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectStartTime,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: AppColors.successGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      timeFormat.format(_selectedStartDate),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Deadline Date Selector
            const Text(
              'Deadline Date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      dateFormat.format(_selectedDeadline),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Time Selector
            const Text(
              'Deadline Time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectTime,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      timeFormat.format(_selectedDeadline),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preview',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _titleController.text.isEmpty
                        ? 'Your task title will appear here'
                        : _titleController.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _titleController.text.isEmpty
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.getCategoryColorLight(
                            _selectedCategory,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _selectedCategory,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.getCategoryColor(
                              _selectedCategory,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Start Date
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available,
                        size: 14,
                        color: AppColors.successGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Start: ${dateFormat.format(_selectedStartDate)} • ${timeFormat.format(_selectedStartDate)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Deadline Date
                  Row(
                    children: [
                      const Icon(
                        Icons.event_busy,
                        size: 14,
                        color: AppColors.errorRed,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'End: ${dateFormat.format(_selectedDeadline)} • ${timeFormat.format(_selectedDeadline)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Duration
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Duration: ${_calculateDuration()}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
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
