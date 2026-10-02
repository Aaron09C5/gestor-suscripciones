import 'package:flutter/material.dart';
import 'package:gestion_suscripciones/core/theme/app_colors.dart';
import 'package:gestion_suscripciones/core/utils/app_strings.dart';
import '../../models/subscription_model.dart';
import '../../models/category_enum.dart';
import '../../repositories/subscription_repository.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/subscription_card.dart';
import 'new_subscription_screen.dart';
import 'budget_screen.dart';
import 'profile_screen.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final _repository = SubscriptionRepository();
  List<SubscriptionModel> _subscriptions = [];
  bool _isLoading = true;
  SubscriptionCategory? _selectedFilter;
  int _currentIndex = 0;
  double _budgetLimit = 100.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _repository.getSubscriptions();
    final budget = await _repository.getBudget();
    setState(() {
      _subscriptions = data;
      _budgetLimit = budget;
      _isLoading = false;
    });
  }

  Widget _buildFilterChip(String label, SubscriptionCategory? category) {
    final isSelected = _selectedFilter == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedFilter = category),
        backgroundColor: AppColors.cardBackground,
        selectedColor: AppColors.headerDarkBlue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? Colors.transparent : Colors.black12),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildSubscriptionsView() {
    final filteredSubscriptions = _selectedFilter == null 
        ? _subscriptions 
        : _subscriptions.where((s) => s.category == _selectedFilter).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: DashboardHeader(subscriptions: _subscriptions),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                _buildFilterChip(AppStrings.get('subs_all'), null),
                ...SubscriptionCategory.values.map((cat) => _buildFilterChip(cat.labelTranslated, cat)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.get('subs_your_subs'),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  '${filteredSubscriptions.where((s) => s.isActive).length} ${AppStrings.get('subs_active')}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final sub = filteredSubscriptions[index];
                return Dismissible(
                  key: Key(sub.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 32),
                  ),
                  onDismissed: (direction) async {
                    final deletedSub = sub;
                    final globalIndex = _subscriptions.indexOf(sub);

                    setState(() {
                      _subscriptions.removeAt(globalIndex);
                    });
                    await _repository.deleteSubscription(deletedSub.id);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${deletedSub.name} ${AppStrings.get('subs_deleted')}'),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: AppStrings.get('subs_undo'),
                            textColor: Colors.white,
                            onPressed: () async {
                              await _repository.insertSubscription(globalIndex, deletedSub);
                              setState(() {
                                _subscriptions.insert(globalIndex, deletedSub);
                              });
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: SubscriptionCard(
                    subscription: sub,
                    onToggleActive: () async {
                      await _repository.toggleSubscriptionStatus(sub.id);
                      final globalIndex = _subscriptions.indexOf(sub);
                      setState(() {
                        _subscriptions[globalIndex] = sub.copyWith(isActive: !sub.isActive);
                      });
                    },
                    onEdit: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewSubscriptionScreen(
                            subscriptionToEdit: sub,
                            activeCount: _subscriptions.where((s) => s.isActive).length,
                          ),
                        ),
                      );
                      if (result == true) {
                        _loadData();
                      }
                    },
                  ),
                );
              },
              childCount: filteredSubscriptions.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100), 
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 0) return _buildSubscriptionsView();
    if (_currentIndex == 1) {
      return BudgetScreen(
        subscriptions: _subscriptions,
        budgetLimit: _budgetLimit,
        onEditBudget: (newLimit) async {
          await _repository.setBudget(newLimit);
          setState(() {
            _budgetLimit = newLimit;
          });
        },
      );
    }
    if (_currentIndex == 2) {
      return ProfileScreen(
        subscriptions: _subscriptions,
        onResetData: () async {
          await _repository.resetData();
          await _loadData();
          setState(() { _currentIndex = 0; });
        },
        onLanguageOrCurrencyChanged: () {
          setState(() {}); 
        },
      );
    }
    return Center(child: Text(AppStrings.get('subs_under_construction'), style: const TextStyle(color: AppColors.textSecondary)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryAction))
                : _buildBody(),
            floatingActionButton: _currentIndex == 0
                ? FloatingActionButton(
                    backgroundColor: AppColors.primaryAction,
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewSubscriptionScreen(
                            activeCount: _subscriptions.where((s) => s.isActive).length,
                          ),
                        ),
                      );
                      
                      if (result == true) {
                        _loadData();
                      }
                    },
                    child: const Icon(Icons.add, color: AppColors.textLight),
                  )
                : null,
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: AppColors.headerDarkBlue,
                unselectedItemColor: AppColors.textSecondary,
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                showUnselectedLabels: true,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: AppStrings.get('nav_home')),
                  BottomNavigationBarItem(icon: const Icon(Icons.pie_chart_outline), label: AppStrings.get('nav_budget')),
                  BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: AppStrings.get('nav_profile')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
