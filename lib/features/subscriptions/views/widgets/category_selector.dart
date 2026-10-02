import 'package:flutter/material.dart';
import 'package:gestion_suscripciones/core/theme/app_colors.dart';
import '../../models/category_enum.dart';

class CategorySelector extends StatelessWidget {
  final SubscriptionCategory selectedCategory;
  final ValueChanged<SubscriptionCategory> onCategoryChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: SubscriptionCategory.values.map((category) {
        final isSelected = category == selectedCategory;
        return GestureDetector(
          onTap: () => onCategoryChanged(category),
          child: Container(
            width: 75,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.headerDarkBlue : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  category.icon,
                  color: isSelected ? Colors.white : AppColors.headerDarkBlue,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  category.labelTranslated,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

