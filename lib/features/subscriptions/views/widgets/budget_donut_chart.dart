import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gestion_suscripciones/core/theme/app_colors.dart';
import 'package:gestion_suscripciones/core/utils/currency_formatter.dart';
import 'package:gestion_suscripciones/core/utils/app_strings.dart';
import '../../models/category_enum.dart';

class BudgetDonutChart extends StatefulWidget {
  final Map<SubscriptionCategory, double> categoryTotals;
  final double totalCost;

  const BudgetDonutChart({
    super.key,
    required this.categoryTotals,
    required this.totalCost,
  });

  @override
  State<BudgetDonutChart> createState() => _BudgetDonutChartState();
}

class _BudgetDonutChartState extends State<BudgetDonutChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(BudgetDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalCost != widget.totalCost || oldWidget.categoryTotals != widget.categoryTotals) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _DonutChartPainter(
              categoryTotals: widget.categoryTotals,
              totalCost: widget.totalCost,
              progress: _animation.value,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CurrencyFormatter.format(widget.totalCost),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.get('budget_consumed'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final Map<SubscriptionCategory, double> categoryTotals;
  final double totalCost;
  final double progress;

  _DonutChartPainter({required this.categoryTotals, required this.totalCost, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    const strokeWidth = 20.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    paint.color = AppColors.background;
    canvas.drawCircle(center, radius, paint);

    if (totalCost <= 0 || progress == 0.0) {
      return;
    }

    double startAngle = -pi / 2;

    categoryTotals.forEach((category, amount) {
      if (amount > 0) {
        final sweepAngle = (amount / totalCost) * 2 * pi;
        paint.color = category.color;
        
        final gap = categoryTotals.values.where((v) => v > 0).length > 1 ? 0.05 : 0.0;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          max(0, (sweepAngle - gap) * progress), 
          false,
          paint,
        );

        startAngle += sweepAngle;
      }
    });
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.totalCost != totalCost || 
           oldDelegate.categoryTotals != categoryTotals ||
           oldDelegate.progress != progress;
  }
}
