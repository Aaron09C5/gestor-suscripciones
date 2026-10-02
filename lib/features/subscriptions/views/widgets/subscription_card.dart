import 'package:flutter/material.dart';
import 'package:gestion_suscripciones/core/theme/app_colors.dart';
import 'package:gestion_suscripciones/core/utils/currency_formatter.dart';
import 'package:gestion_suscripciones/core/utils/app_strings.dart';
import 'package:gestion_suscripciones/core/utils/brand_helper.dart';
import '../../models/subscription_model.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback onToggleActive;
  final VoidCallback onEdit;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.onToggleActive,
    required this.onEdit,
  });

  int _getDaysRemainingInt(int renewalDay) {
    final now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    
    int targetDay = renewalDay;
    int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    if (targetDay > daysInMonth) targetDay = daysInMonth;

    DateTime nextBillingDate = DateTime(currentYear, currentMonth, targetDay);

    if (now.isAfter(nextBillingDate) || now.day == targetDay) {
      currentMonth++;
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
      daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
      if (targetDay > daysInMonth) targetDay = daysInMonth;
      nextBillingDate = DateTime(currentYear, currentMonth, targetDay);
    }

    return nextBillingDate.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final remainingDays = _getDaysRemainingInt(subscription.renewalDay);
    final double progress = ((30 - remainingDays) / 30).clamp(0.0, 1.0);
    final brandInfo = BrandHelper.getBrandInfo(subscription.name, subscription.category);

    return GestureDetector(
      onDoubleTap: onEdit,
      child: Opacity(
        opacity: subscription.isActive ? 1.0 : 0.6,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: brandInfo.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: brandInfo.buildIcon(28, brandInfo.iconColor),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subscription.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              CurrencyFormatter.format(subscription.monthlyCost),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              ' ${AppStrings.get('card_per_month')}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onToggleActive,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: subscription.isActive
                            ? AppColors.statusActive.withValues(alpha: 0.1)
                            : AppColors.textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        subscription.isActive ? AppStrings.get('card_active') : AppStrings.get('card_inactive'),
                        style: TextStyle(
                          color: subscription.isActive ? AppColors.statusActive : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (subscription.isActive) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.headerCyan,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$remainingDays/30 ${AppStrings.get('card_days')}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
