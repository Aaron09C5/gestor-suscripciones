import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../models/category_enum.dart';

class MockSubscriptionRepository {
  // Singleton pattern para mantener el estado en memoria
  static final MockSubscriptionRepository _instance = MockSubscriptionRepository._internal();
  factory MockSubscriptionRepository() => _instance;

  late final List<SubscriptionModel> _subscriptions;

  MockSubscriptionRepository._internal() {
    _subscriptions = [
      SubscriptionModel(
        id: '1',
        name: 'Netflix Premium',
        serviceIcon: Icons.movie, 
        monthlyCost: 17.99,
        renewalDay: _getDayOffset(4), // Aprox 4 días restantes
        category: SubscriptionCategory.streaming,
        isActive: true,
      ),
      SubscriptionModel(
        id: '2',
        name: 'Spotify Family',
        serviceIcon: Icons.music_note, 
        monthlyCost: 14.99,
        renewalDay: _getDayOffset(12), // Aprox 12 días restantes
        category: SubscriptionCategory.musica,
        isActive: true,
      ),
      SubscriptionModel(
        id: '3',
        name: 'Internet (Digi)',
        serviceIcon: Icons.wifi, 
        monthlyCost: 35.00,
        renewalDay: _getDayOffset(19), // Aprox 19 días restantes
        category: SubscriptionCategory.hogar,
        isActive: true,
      ),
    ];
  }

  // Función para simular días futuros de forma segura
  int _getDayOffset(int offset) {
    int day = DateTime.now().day + offset;
    if (day > 28) day -= 28;
    return day;
  }

  Future<List<SubscriptionModel>> getSubscriptions() async {
    // Simulamos un retraso de red
    await Future.delayed(const Duration(milliseconds: 300));
    return _subscriptions.toList();
  }

  Future<void> addSubscription(SubscriptionModel sub) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _subscriptions.add(sub);
  }
}
