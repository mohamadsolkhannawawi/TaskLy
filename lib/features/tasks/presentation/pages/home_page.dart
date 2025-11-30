// filepath: d:\Code\PBP\Mobile\Flutter\todolist\lib\features\tasks\presentation\pages\home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/category_selector.dart';
import '../../../../core/utils/app_colors.dart';
import 'task_editor_page.dart';
import 'calendar_page.dart';
import 'category_management_page.dart';

/// Home Page - Main screen with Today/Tomorrow tabs
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary, // Purple Header
        title: const Text(
          'TaskLy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Category Management Button
          IconButton(
            icon: const Icon(Icons.category_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryManagementPage(),
                ),
              );
            },
            tooltip: 'Manage Categories',
          ),
          // Calendar Button
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
            tooltip: 'Calendar View',
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Tomorrow'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _TaskListView(filterType: _FilterType.today),
          _TaskListView(filterType: _FilterType.tomorrow),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskEditorPage()),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

enum _FilterType { today, tomorrow }

/// Task List View - Reusable list widget
class _TaskListView extends StatelessWidget {
  final _FilterType filterType;

  const _TaskListView({required this.filterType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        // Category Filter Chips
        Consumer<TaskProvider>(
          builder: (context, provider, child) {
            return CategoryFilterChips(
              selectedCategory: provider.selectedCategory,
              onChanged: (category) {
                provider.setSelectedCategory(category);
              },
            );
          },
        ),

        const SizedBox(height: 16),

        // Task List
        Expanded(
          child: Consumer<TaskProvider>(
            builder: (context, provider, child) {
              // Get tasks based on filter
              var tasks = filterType == _FilterType.today
                  ? provider.todayTasks
                  : provider.tomorrowTasks;

              // Apply category filter
              if (provider.selectedCategory != null) {
                tasks = tasks
                    .where((task) => task.category == provider.selectedCategory)
                    .toList();
              }

              // Empty state
              if (tasks.isEmpty) {
                return _EmptyState(
                  filterType: filterType,
                  hasFilter: provider.selectedCategory != null,
                );
              }

              // Task list
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskEditorPage(task: task),
                        ),
                      );
                    },
                    onToggle: () {
                      provider.toggleTaskStatus(task.id);
                    },
                    onDelete: () {
                      final deletedTask = task;
                      provider.deleteTask(task.id);

                      ScaffoldMessenger.of(context).clearSnackBars();
                      final snackBar = ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Task deleted',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: AppColors
                                  .deleteRaspberry, // Vibrant Raspberry #CD2C58
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(
                                seconds: 5,
                              ), // Auto-dismiss in 5 seconds
                              dismissDirection: DismissDirection.horizontal,
                              action: SnackBarAction(
                                label: 'Undo',
                                textColor: Colors.white,
                                onPressed: () {
                                  provider.addTask(deletedTask);
                                },
                              ),
                            ),
                          );

                      // Force dismiss after exactly 5 seconds
                      Future.delayed(const Duration(seconds: 5), () {
                        snackBar.close();
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Empty State Widget
class _EmptyState extends StatelessWidget {
  final _FilterType filterType;
  final bool hasFilter;

  const _EmptyState({required this.filterType, required this.hasFilter});

  @override
  Widget build(BuildContext context) {
    final title = filterType == _FilterType.today ? 'today' : 'tomorrow';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilter ? Icons.filter_alt_off : Icons.task_alt,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter ? 'No tasks in this category' : 'No tasks for $title',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilter
                ? 'Try selecting a different category'
                : 'Tap the + button to add a new task',
            style: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
