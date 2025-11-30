// filepath: d:\Code\PBP\Mobile\Flutter\todolist\lib\features\tasks\presentation\widgets\task_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';
import '../../../../core/utils/app_colors.dart';

/// Task Card Widget - Displays individual task item
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  /// Get status color based on task state
  Color _getStatusColor(Task task) {
    if (task.isOverdue) return AppColors.errorRed;
    if (task.isInProgress) return AppColors.primary;
    if (task.isUpcoming) return AppColors.warningOrange;
    return AppColors.textSecondary;
  }

  /// Get status text based on task state
  String _getStatusText(Task task) {
    if (task.isOverdue) return 'OVERDUE';
    if (task.isInProgress) return 'IN PROGRESS';
    if (task.isUpcoming) return 'UPCOMING';
    return 'PENDING';
  }

  /// Show bottom sheet with task options
  void _showTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Task title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const Divider(height: 1),

              // Edit option
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('Edit Task'),
                onTap: () {
                  Navigator.pop(context);
                  onTap();
                },
              ),

              // Toggle status option
              ListTile(
                leading: Icon(
                  task.isDone ? Icons.close : Icons.check_circle_outline,
                  color: task.isDone
                      ? AppColors.warningOrange
                      : AppColors.successGreen,
                ),
                title: Text(
                  task.isDone ? 'Mark as Incomplete' : 'Mark as Complete',
                ),
                onTap: () {
                  Navigator.pop(context);
                  onToggle();
                },
              ),

              // Delete option
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.errorRed,
                ),
                title: const Text(
                  'Delete Task',
                  style: TextStyle(color: AppColors.errorRed),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// Confirm delete action
  void _confirmDelete(BuildContext context) {
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
            'Are you sure you want to delete "${task.title}"?',
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
                Navigator.pop(context);
                onDelete();
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

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppColors.getCategoryColor(task.category);
    final categoryColorLight = AppColors.getCategoryColorLight(task.category);
    final timeFormat = DateFormat('HH:mm');

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.errorRed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: () => _showTaskOptions(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Custom Checkbox
                  GestureDetector(
                    onTap: onToggle,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: task.isDone
                              ? AppColors.primary
                              : AppColors.borderColor,
                          width: 2,
                        ),
                        color: task.isDone
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                      child: task.isDone
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Task Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task Title
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: task.isDone
                                ? AppColors.textTertiary
                                : AppColors.textPrimary,
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Location (optional)
                        if (task.location != null &&
                            task.location!.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    task.location!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Category & Time
                        Row(
                          children: [
                            // Category Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: categoryColorLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                task.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: categoryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Deadline Time
                            Icon(
                              Icons.event_busy,
                              size: 14,
                              color: task.isOverdue
                                  ? AppColors.errorRed
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeFormat.format(task.deadline),
                              style: TextStyle(
                                fontSize: 13,
                                color: task.isOverdue
                                    ? AppColors.errorRed
                                    : AppColors.textSecondary,
                                fontWeight: task.isOverdue
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),

                        // Start Date & Status (NEW)
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Start Date
                            Icon(
                              Icons.event_available,
                              size: 12,
                              color: AppColors.successGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Start: ${timeFormat.format(task.startDate)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Status Badge
                            if (!task.isDone)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    task,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: _getStatusColor(task),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _getStatusText(task),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(task),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Edit Icon
                  IconButton(
                    onPressed: onTap,
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
