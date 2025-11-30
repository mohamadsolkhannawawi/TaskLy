// filepath: d:\Code\PBP\Mobile\Flutter\todolist\lib\features\tasks\models\task_model.dart

import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

/// Task Model - Represents a single task/note
@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? location;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime deadline;

  @HiveField(6)
  final bool isDone;

  Task({
    String? id,
    required this.title,
    this.location,
    required this.category,
    DateTime? startDate,
    required this.deadline,
    this.isDone = false,
  }) : id = id ?? const Uuid().v4(),
       startDate = startDate ?? DateTime.now();

  /// Create a copy of task with updated fields
  Task copyWith({
    String? id,
    String? title,
    String? location,
    String? category,
    DateTime? startDate,
    DateTime? deadline,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
      isDone: isDone ?? this.isDone,
    );
  }

  /// Convert task to JSON (for future persistence)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'isDone': isDone,
    };
  }

  /// Create task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      category: json['category'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      deadline: DateTime.parse(json['deadline']),
      isDone: json['isDone'] ?? false,
    );
  }

  /// Get duration between start and deadline
  Duration get duration => deadline.difference(startDate);

  /// Get days remaining from now to deadline
  int get daysRemaining {
    final now = DateTime.now();
    final diff = deadline.difference(DateTime(now.year, now.month, now.day));
    return diff.inDays;
  }

  /// Check if task is overdue
  bool get isOverdue {
    if (isDone) return false;
    return DateTime.now().isAfter(deadline);
  }

  /// Check if task is in progress (started but not finished)
  bool get isInProgress {
    if (isDone) return false;
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(deadline);
  }

  /// Check if task is upcoming (not started yet)
  bool get isUpcoming {
    return DateTime.now().isBefore(startDate);
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, location: $location, category: $category, deadline: $deadline, isDone: $isDone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
