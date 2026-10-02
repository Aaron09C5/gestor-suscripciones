import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription_model.dart';
import '../models/category_enum.dart';

class SubscriptionRepository {
  static final SubscriptionRepository _instance = SubscriptionRepository._internal();
  factory SubscriptionRepository() => _instance;

  SubscriptionRepository._internal();

  static const String _storageKey = 'subscriptions_data';
  List<SubscriptionModel> _subscriptions = [];
  bool _isInitialized = false;

  // Función para simular días futuros de forma segura para los ejemplos
  int _getDayOffset(int offset) {
    int day = DateTime.now().day + offset;
    if (day > 28) day -= 28;
    return day;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _subscriptions = decoded
          .map((e) => SubscriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      // Si es la primera vez (no hay datos), cargamos los ejemplos iniciales
      _subscriptions = [
        SubscriptionModel(
          id: '1',
          name: 'Netflix Premium',
          serviceIcon: Icons.movie, 
          monthlyCost: 17.99,
          renewalDay: _getDayOffset(4),
          category: SubscriptionCategory.streaming,
          isActive: true,
        ),
        SubscriptionModel(
          id: '2',
          name: 'Spotify Family',
          serviceIcon: Icons.music_note, 
          monthlyCost: 14.99,
          renewalDay: _getDayOffset(12),
          category: SubscriptionCategory.musica,
          isActive: true,
        ),
        SubscriptionModel(
          id: '3',
          name: 'Internet (Digi)',
          serviceIcon: Icons.wifi, 
          monthlyCost: 35.00,
          renewalDay: _getDayOffset(19),
          category: SubscriptionCategory.hogar,
          isActive: true,
        ),
      ];
      await _saveToDisk();
    }
    _isInitialized = true;
  }

  Future<List<SubscriptionModel>> getSubscriptions() async {
    if (!_isInitialized) {
      await init();
    }
    return _subscriptions.toList();
  }

  Future<void> addSubscription(SubscriptionModel sub) async {
    _subscriptions.add(sub);
    await _saveToDisk();
  }

  Future<void> deleteSubscription(String id) async {
    _subscriptions.removeWhere((s) => s.id == id);
    await _saveToDisk();
  }

  Future<void> updateSubscription(SubscriptionModel updatedSub) async {
    final index = _subscriptions.indexWhere((s) => s.id == updatedSub.id);
    if (index != -1) {
      _subscriptions[index] = updatedSub;
      await _saveToDisk();
    }
  }

  Future<double> getBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('budget_limit_data') ?? 100.0;
  }

  Future<void> setBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('budget_limit_data', budget);
  }

  Future<void> resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    await prefs.remove('budget_limit_data');
    _subscriptions.clear();
    _isInitialized = false;
    await init();
  }

  Future<void> insertSubscription(int index, SubscriptionModel sub) async {
    _subscriptions.insert(index, sub);
    await _saveToDisk();
  }

  Future<void> toggleSubscriptionStatus(String id) async {
    final index = _subscriptions.indexWhere((s) => s.id == id);
    if (index != -1) {
      final sub = _subscriptions[index];
      _subscriptions[index] = sub.copyWith(isActive: !sub.isActive);
      await _saveToDisk();
    }
  }

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_subscriptions.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }
}
