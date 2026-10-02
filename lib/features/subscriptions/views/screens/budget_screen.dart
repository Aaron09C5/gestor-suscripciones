import 'package:flutter/material.dart';
import 'package:gestion_suscripciones/core/theme/app_colors.dart';
import 'package:gestion_suscripciones/core/utils/currency_formatter.dart';
import 'package:gestion_suscripciones/core/utils/app_strings.dart';
import '../../models/subscription_model.dart';
import '../../models/category_enum.dart';
import '../widgets/budget_donut_chart.dart';

class BudgetScreen extends StatelessWidget {
  final List<SubscriptionModel> subscriptions;
  final double budgetLimit;
  final ValueChanged<double> onEditBudget;

  const BudgetScreen({
    super.key,
    required this.subscriptions,
    required this.budgetLimit,
    required this.onEditBudget,
  });

  void _showEditBudgetDialog(BuildContext context) {
    final controller = TextEditingController(text: budgetLimit.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppStrings.get('budget_edit_title'), style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Ej. 100.00',
            prefixIcon: Icon(Icons.attach_money),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get('common_cancel'), style: const TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryAction, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              final newBudget = double.tryParse(controller.text.replaceAll(',', '.'));
              if (newBudget != null && newBudget > 0) {
                onEditBudget(newBudget);
                Navigator.pop(context);
              }
            },
            child: Text(AppStrings.get('common_save'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Map<SubscriptionCategory, double> categoryTotals) {
    final activeCategories = categoryTotals.entries.where((e) => e.value > 0).map((e) => e.key).toList();
    if (activeCategories.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: activeCategories.map((cat) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12, 
              height: 12, 
              decoration: BoxDecoration(color: cat.color, shape: BoxShape.circle)
            ),
            const SizedBox(width: 6),
            Text(
              cat.labelTranslated, 
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold)
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeSubs = subscriptions.where((s) => s.isActive).toList();
    final totalCost = activeSubs.fold(0.0, (sum, s) => sum + s.monthlyCost);
    final percent = budgetLimit > 0 ? (totalCost / budgetLimit) : 0.0;
    final isAlert = percent >= 0.8;
    final remaining = (budgetLimit - totalCost).clamp(0.0, double.infinity);
    final exceeded = totalCost > budgetLimit;

    final categoryTotals = <SubscriptionCategory, double>{};
    for (var sub in activeSubs) {
      categoryTotals[sub.category] = (categoryTotals[sub.category] ?? 0) + sub.monthlyCost;
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 32),
            decoration: const BoxDecoration(
              color: AppColors.headerDarkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                Text(
                  AppStrings.get('budget_title'),
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.get('budget_limit'), style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => _showEditBudgetDialog(context),
                        child: const Icon(Icons.edit, size: 20, color: AppColors.headerCyan),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        CurrencyFormatter.format(budgetLimit),
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        exceeded ? '${AppStrings.get('budget_exceeded')} ${CurrencyFormatter.format(totalCost - budgetLimit)}!' : '${AppStrings.get('budget_available')} ${CurrencyFormatter.format(remaining)}',
                        style: TextStyle(
                          color: isAlert ? AppColors.primaryAction : AppColors.statusActive,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  BudgetDonutChart(
                    categoryTotals: categoryTotals,
                    totalCost: totalCost,
                  ),
                  const SizedBox(height: 32),
                  _buildLegend(categoryTotals),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
        
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              AppStrings.get('budget_category_expense'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final entry = sortedCategories[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: entry.key.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(entry.key.icon, color: entry.key.color),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.key.labelTranslated, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: totalCost > 0 ? entry.value / totalCost : 0,
                              minHeight: 4,
                              backgroundColor: AppColors.background,
                              color: entry.key.color,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        CurrencyFormatter.format(entry.value),
                        style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.textPrimary, fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
              childCount: sortedCategories.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
