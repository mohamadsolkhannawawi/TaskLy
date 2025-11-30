// filepath: d:\Code\PBP\Mobile\Flutter\todolist\lib\features\tasks\providers\task_provider.dart

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../../../core/utils/date_utils.dart' as app_date_utils;

/// Task Provider - Central State Management for Tasks with Hive Persistence
class TaskProvider with ChangeNotifier {
  // Hive box reference
  late Box<Task> _taskBox;

  // List of custom categories
  final List<String> _categories = [
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Other',
  ];

  // Selected category filter (null = all categories)
  String? _selectedCategory;

  // Selected date for calendar view
  DateTime _selectedDate = DateTime.now();

  /// Constructor - Initialize Hive box and load data
  TaskProvider() {
    _taskBox = Hive.box<Task>('tasks');
    _initializeDummyDataIfEmpty();
  }

  // ========== GETTERS ==========

  /// Get all tasks from Hive
  List<Task> get allTasks => _taskBox.values.toList();

  /// Get tasks for today
  List<Task> get todayTasks {
    return _taskBox.values
        .where((task) => app_date_utils.DateUtils.isToday(task.deadline))
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get tasks for tomorrow
  List<Task> get tomorrowTasks {
    return _taskBox.values
        .where((task) => app_date_utils.DateUtils.isTomorrow(task.deadline))
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get tasks for a specific date
  List<Task> getTasksByDate(DateTime date) {
    return _taskBox.values
        .where(
          (task) => app_date_utils.DateUtils.isSameDay(task.deadline, date),
        )
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get tasks by category
  List<Task> getTasksByCategory(String category) {
    return _taskBox.values
        .where((task) => task.category.toLowerCase() == category.toLowerCase())
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get selected category
  String? get selectedCategory => _selectedCategory;

  /// Get selected date for calendar
  DateTime get selectedDate => _selectedDate;

  /// Get tasks for selected date
  List<Task> get selectedDateTasks => getTasksByDate(_selectedDate);

  /// Get all available categories
  List<String> get availableCategories {
    return List.unmodifiable(_categories);
  }

  /// Get task count by status
  int get completedTasksCount =>
      _taskBox.values.where((task) => task.isDone).length;
  int get pendingTasksCount =>
      _taskBox.values.where((task) => !task.isDone).length;

  // ========== CATEGORY MANAGEMENT ==========

  /// Add a new category
  void addCategory(String category) {
    if (category.trim().isEmpty) return;
    if (_categories.contains(category.trim())) return;

    _categories.add(category.trim());
    notifyListeners();
  }

  /// Edit/Rename a category
  void editCategory(String oldCategory, String newCategory) {
    if (newCategory.trim().isEmpty) return;
    if (_categories.contains(newCategory.trim()) && oldCategory != newCategory)
      return;

    final index = _categories.indexWhere((cat) => cat == oldCategory);
    if (index != -1) {
      _categories[index] = newCategory.trim();

      // Update all tasks with this category
      for (var task in _taskBox.values.where(
        (t) => t.category == oldCategory,
      )) {
        final updatedTask = task.copyWith(category: newCategory.trim());
        _taskBox.put(task.id, updatedTask);
      }

      notifyListeners();
    }
  }

  /// Delete a category
  void deleteCategory(String category) {
    // Don't allow deleting if it's the last category
    if (_categories.length <= 1) return;

    _categories.remove(category);

    // Move tasks to 'Other' category
    final defaultCategory = _categories.isNotEmpty
        ? _categories.first
        : 'Other';
    for (var task in _taskBox.values.where((t) => t.category == category)) {
      final updatedTask = task.copyWith(category: defaultCategory);
      _taskBox.put(task.id, updatedTask);
    }

    notifyListeners();
  }

  /// Check if category name is valid (not duplicate)
  bool isCategoryNameValid(String name, {String? excludeCategory}) {
    if (name.trim().isEmpty) return false;
    return !_categories.any(
      (cat) =>
          cat.toLowerCase() == name.trim().toLowerCase() &&
          cat != excludeCategory,
    );
  }

  /// Get task count for a specific category
  int getTaskCountByCategory(String category) {
    return _taskBox.values.where((task) => task.category == category).length;
  }

  // ========== ACTIONS ==========

  /// Add a new task
  void addTask(Task task) {
    _taskBox.put(task.id, task);
    notifyListeners();
  }

  /// Edit/Update an existing task
  void editTask(String taskId, Task updatedTask) {
    if (_taskBox.containsKey(taskId)) {
      _taskBox.put(taskId, updatedTask);
      notifyListeners();
    }
  }

  /// Delete a task
  void deleteTask(String taskId) {
    _taskBox.delete(taskId);
    notifyListeners();
  }

  /// Toggle task completion status
  void toggleTaskStatus(String taskId) {
    final task = _taskBox.get(taskId);
    if (task != null) {
      final updatedTask = task.copyWith(isDone: !task.isDone);
      _taskBox.put(taskId, updatedTask);
      notifyListeners();
    }
  }

  /// Set category filter
  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Set selected date for calendar
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Clear all completed tasks
  void clearCompletedTasks() {
    final completedTaskIds = _taskBox.values
        .where((task) => task.isDone)
        .map((task) => task.id)
        .toList();

    for (var taskId in completedTaskIds) {
      _taskBox.delete(taskId);
    }
    notifyListeners();
  }

  // ========== DUMMY DATA INITIALIZATION ==========

  void _initializeDummyDataIfEmpty() {
    // Only add dummy data if the box is empty
    if (_taskBox.isNotEmpty) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    final dummyTasks = [
      // Today's tasks
      Task(
        title: 'Team Meeting at 10 AM',
        category: 'Work',
        startDate: today.add(const Duration(hours: 9)),
        deadline: today.add(const Duration(hours: 10)),
        isDone: false,
      ),
      Task(
        title: 'Finish Flutter Project',
        category: 'Work',
        startDate: today.add(const Duration(hours: 8)),
        deadline: today.add(const Duration(hours: 16)),
        isDone: false,
      ),
      Task(
        title: 'Morning Workout',
        category: 'Health',
        startDate: today.add(const Duration(hours: 6)),
        deadline: today.add(const Duration(hours: 7)),
        isDone: true,
      ),
      Task(
        title: 'Buy Groceries',
        category: 'Shopping',
        startDate: today.add(const Duration(hours: 17)),
        deadline: today.add(const Duration(hours: 18)),
        isDone: false,
      ),

      // Tomorrow's tasks
      Task(
        title: 'Dentist Appointment',
        category: 'Health',
        startDate: tomorrow.add(const Duration(hours: 13, minutes: 30)),
        deadline: tomorrow.add(const Duration(hours: 14)),
        isDone: false,
      ),
      Task(
        title: 'Code Review Session',
        category: 'Work',
        startDate: tomorrow.add(const Duration(hours: 10)),
        deadline: tomorrow.add(const Duration(hours: 11)),
        isDone: false,
      ),
      Task(
        title: 'Call Mom',
        category: 'Personal',
        startDate: tomorrow.add(const Duration(hours: 18)),
        deadline: tomorrow.add(const Duration(hours: 19)),
        isDone: false,
      ),

      // Next week tasks
      Task(
        title: 'Project Presentation',
        category: 'Work',
        startDate: nextWeek.add(const Duration(hours: 9)),
        deadline: nextWeek.add(const Duration(hours: 10)),
        isDone: false,
      ),
      Task(
        title: 'Buy Birthday Gift',
        category: 'Shopping',
        startDate: nextWeek.add(const Duration(hours: 14)),
        deadline: nextWeek.add(const Duration(hours: 15)),
        isDone: false,
      ),
      Task(
        title: 'Yoga Class',
        category: 'Health',
        startDate: nextWeek.add(const Duration(hours: 6)),
        deadline: nextWeek.add(const Duration(hours: 7)),
        isDone: false,
      ),
      Task(
        title: 'Read New Book',
        category: 'Personal',
        startDate: nextWeek.add(const Duration(hours: 19)),
        deadline: nextWeek.add(const Duration(hours: 20)),
        isDone: false,
      ),
    ];

    // Add all dummy tasks to Hive box
    for (var task in dummyTasks) {
      _taskBox.put(task.id, task);
    }
  }
}
