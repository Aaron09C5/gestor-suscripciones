import 'package:flutter/material.dart';
import 'category_enum.dart';

class SubscriptionModel {
  final String id;
  final String name;
  final IconData serviceIcon; // Usando IconData nativo temporalmente
  final double monthlyCost;
  final int renewalDay; // Día del mes (1-31)
  final SubscriptionCategory category;
  final bool isActive;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.serviceIcon,
    required this.monthlyCost,
    required this.renewalDay,
    required this.category,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'monthlyCost': monthlyCost,
    'renewalDay': renewalDay,
    'category': category.name,
    'isActive': isActive,
  };

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    final parsedCategory = SubscriptionCategory.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => SubscriptionCategory.streaming,
    );
    
    return SubscriptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      serviceIcon: parsedCategory.icon,
      monthlyCost: (json['monthlyCost'] as num).toDouble(),
      renewalDay: json['renewalDay'] as int,
      category: parsedCategory,
      isActive: json['isActive'] as bool,
    );
  }

  SubscriptionModel copyWith({
    String? id,
    String? name,
    IconData? serviceIcon,
    double? monthlyCost,
    int? renewalDay,
    SubscriptionCategory? category,
    bool? isActive,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      serviceIcon: serviceIcon ?? this.serviceIcon,
      monthlyCost: monthlyCost ?? this.monthlyCost,
      renewalDay: renewalDay ?? this.renewalDay,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
    );
  }

  // Método auxiliar para calcular los días restantes para el próximo pago
  int get daysUntilRenewal {
    final now = DateTime.now();
    DateTime nextRenewal = DateTime(now.year, now.month, renewalDay);
    
    // Si el día de renovación ya pasó este mes, será el próximo mes
    if (now.day > renewalDay) {
      int nextMonth = now.month + 1;
      int nextYear = now.year;
      if (nextMonth > 12) {
        nextMonth = 1;
        nextYear++;
      }
      // Ajustamos por si el próximo mes tiene menos días (ej. febrero y renewalDay es 30)
      int maxDaysInNextMonth = DateUtils.getDaysInMonth(nextYear, nextMonth);
      int safeRenewalDay = renewalDay > maxDaysInNextMonth ? maxDaysInNextMonth : renewalDay;
      
      nextRenewal = DateTime(nextYear, nextMonth, safeRenewalDay);
    }
    
    // Calculamos diferencia desde el inicio del día actual
    final todayMidnight = DateTime(now.year, now.month, now.day);
    return nextRenewal.difference(todayMidnight).inDays;
  }
}
