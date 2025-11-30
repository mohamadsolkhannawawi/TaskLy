// filepath: d:\Code\PBP\Mobile\Flutter\todolist\lib\features\tasks\presentation\widgets\category_selector.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../../../core/utils/app_colors.dart';

/// Category Selector Widget - Dropdown/Picker for selecting task category
class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final categories = provider.availableCategories;
        
        // Ensure selected category exists in list
        final validSelectedCategory = categories.contains(selectedCategory)
            ? selectedCategory
            : (categories.isNotEmpty ? categories.first : 'Other');

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: validSelectedCategory,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              items: categories.map((String category) {
                final categoryColor = AppColors.getCategoryColor(category);
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      // Category Color Indicator
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: categoryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Category Name
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

/// Category Filter Chips - Horizontal scrollable chips for filtering
class CategoryFilterChips extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final categories = ['All', ...provider.availableCategories];
        
        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isAll = category == 'All';
              final isSelected = isAll
                  ? selectedCategory == null
                  : selectedCategory == category;
              final categoryColor = isAll
                  ? AppColors.primary
                  : AppColors.getCategoryColor(category);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    onChanged(isAll ? null : category);
                  },
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  backgroundColor: AppColors.surface,
                  selectedColor: categoryColor,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? categoryColor : AppColors.borderColor,
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  showCheckmark: false,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
