// filepath: d:\Code\PBP\Mobile\Flutter\todolist\lib\features\tasks\presentation\pages\calendar_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../providers/task_provider.dart';
import '../../models/task_model.dart';
import '../widgets/task_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;
import 'task_editor_page.dart';

/// Calendar Page - Full calendar view with task list per selected date
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // Set initial selected date in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).setSelectedDate(_selectedDay!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary, // Purple Header
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Calendar View',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Calendar Widget
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                return TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    provider.setSelectedDate(selectedDay);
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },

                  // Event Loader - Show markers for dates with tasks
                  eventLoader: (day) {
                    return provider.getTasksByDate(day);
                  },

                  // Calendar Style
                  calendarStyle: CalendarStyle(
                    // Today
                    todayDecoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    todayTextStyle: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),

                    // Selected Day
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),

                    // Default Days
                    defaultDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: const TextStyle(
                      color: AppColors.textPrimary,
                    ),

                    // Weekend Days
                    weekendDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: const TextStyle(
                      color: AppColors.errorRed,
                    ),

                    // Outside Days
                    outsideDaysVisible: false,

                    // Markers (dots below dates with tasks)
                    markerDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 6,
                    markersMaxCount: 3,
                    markersAlignment: Alignment.bottomCenter,
                  ),

                  // Header Style
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    formatButtonTextStyle: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    titleTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: AppColors.primary,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: AppColors.primary,
                    ),
                  ),

                  // Days of Week Style
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: TextStyle(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),

          // Divider
          const SizedBox(height: 8),

          // Selected Date Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE').format(_selectedDay!),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(_selectedDay!),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Consumer<TaskProvider>(
                  builder: (context, provider, child) {
                    final tasks = provider.selectedDateTasks;
                    final completedCount = tasks.where((t) => t.isDone).length;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$completedCount/${tasks.length} Done',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.dividerColor),

          // Task List for Selected Date
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                final tasks = provider.selectedDateTasks;

                if (tasks.isEmpty) {
                  return _EmptyTaskList(selectedDate: _selectedDay!);
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
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
                        provider.deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Task deleted'),
                            backgroundColor: AppColors.errorRed,
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Undo',
                              textColor: Colors.white,
                              onPressed: () {
                                provider.addTask(task);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button - Add task for selected date
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskEditorPage(
                task: Task(
                  title: '',
                  category: 'Work',
                  deadline: _selectedDay!,
                  isDone: false,
                ),
              ),
            ),
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

/// Empty Task List Widget
class _EmptyTaskList extends StatelessWidget {
  final DateTime selectedDate;

  const _EmptyTaskList({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final isToday = app_date_utils.DateUtils.isToday(selectedDate);
    final isTomorrow = app_date_utils.DateUtils.isTomorrow(selectedDate);

    String dateText;
    if (isToday) {
      dateText = 'today';
    } else if (isTomorrow) {
      dateText = 'tomorrow';
    } else {
      dateText = 'this day';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.event_available,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks for $dateText',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to add a new task',
            style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
