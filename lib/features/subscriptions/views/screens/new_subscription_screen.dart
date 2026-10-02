import 'package:flutter/material.dart';
import 'package:gestion_suscripciones/core/theme/app_colors.dart';
import 'package:gestion_suscripciones/core/utils/currency_formatter.dart';
import 'package:gestion_suscripciones/core/utils/app_strings.dart';
import '../../models/subscription_model.dart';
import '../../models/category_enum.dart';
import '../../repositories/subscription_repository.dart';
import '../widgets/category_selector.dart';
import 'package:gestion_suscripciones/core/utils/brand_helper.dart';

class NewSubscriptionScreen extends StatefulWidget {
  final SubscriptionModel? subscriptionToEdit;
  final int activeCount;

  const NewSubscriptionScreen({
    super.key, 
    this.subscriptionToEdit,
    this.activeCount = 0,
  });

  @override
  State<NewSubscriptionScreen> createState() => _NewSubscriptionScreenState();
}

class _NewSubscriptionScreenState extends State<NewSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  
  SubscriptionCategory _selectedCategory = SubscriptionCategory.streaming;
  int? _selectedBillingDay;
  final _repository = SubscriptionRepository();

  @override
  void initState() {
    super.initState();
    if (widget.subscriptionToEdit != null) {
      _nameController.text = widget.subscriptionToEdit!.name;
      _costController.text = widget.subscriptionToEdit!.monthlyCost.toString();
      _selectedCategory = widget.subscriptionToEdit!.category;
      _selectedBillingDay = widget.subscriptionToEdit!.renewalDay;
    }

    _nameController.addListener(() => setState(() {}));
    _costController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _saveSubscription() async {
    if (_formKey.currentState!.validate() && _selectedBillingDay != null) {
      final isEditing = widget.subscriptionToEdit != null;
      
      final sub = SubscriptionModel(
        id: isEditing ? widget.subscriptionToEdit!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        serviceIcon: _selectedCategory.icon,
        monthlyCost: double.parse(_costController.text.trim().replaceAll(',', '.')),
        renewalDay: _selectedBillingDay!,
        category: _selectedCategory,
        isActive: isEditing ? widget.subscriptionToEdit!.isActive : true,
      );

      if (isEditing) {
        await _repository.updateSubscription(sub);
      } else {
        await _repository.addSubscription(sub);
      }
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else if (_selectedBillingDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('err_date'))),
      );
    }
  }

  Future<void> _selectBillingDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBillingDay != null 
          ? DateTime(now.year, now.month, _selectedBillingDay!)
          : now,
      firstDate: DateTime(now.year, now.month, 1),
      lastDate: DateTime(now.year, now.month + 1, 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.headerCyan,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBillingDay = picked.day;
      });
    }
  }

  Widget _buildCyanCard() {
    final isEditing = widget.subscriptionToEdit != null;
    final title = isEditing 
        ? (_nameController.text.trim().isNotEmpty ? _nameController.text.trim() : AppStrings.get('edit_sub_title')) 
        : (_nameController.text.trim().isNotEmpty ? _nameController.text.trim() : AppStrings.get('new_sub_title'));
    final cost = double.tryParse(_costController.text.replaceAll(',', '.')) ?? 0.0;
    final brandInfo = BrandHelper.getBrandInfo(_nameController.text, _selectedCategory);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.headerCyan, Color(0xFF0083B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.headerCyan.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (_nameController.text.trim().isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: brandInfo.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: brandInfo.buildIcon(16, brandInfo.iconColor),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          title.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.format(cost),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.activeCount} ${AppStrings.get('dashboard_active_subs')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isEditing = widget.subscriptionToEdit != null;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 220,
          decoration: const BoxDecoration(
            color: AppColors.headerDarkBlue,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    isEditing ? AppStrings.get('edit_sub_title') : AppStrings.get('new_sub_title'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100, left: 24, right: 24),
          child: _buildCyanCard(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(AppStrings.get('form_name'), style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: AppStrings.get('form_name_hint'),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                      validator: (value) => value == null || value.isEmpty ? AppStrings.get('err_name') : null,
                    ),
                    const SizedBox(height: 24),

                    Text(AppStrings.get('form_cost'), style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _costController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: AppStrings.get('form_cost_hint'),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.attach_money, color: AppColors.textSecondary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return AppStrings.get('err_cost');
                        if (double.tryParse(value.replaceAll(',', '.')) == null) return AppStrings.get('err_cost');
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    Text(AppStrings.get('form_category'), style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    CategorySelector(
                      selectedCategory: _selectedCategory,
                      onCategoryChanged: (category) => setState(() => _selectedCategory = category),
                    ),
                    const SizedBox(height: 24),

                    Text(AppStrings.get('form_date'), style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectBillingDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppColors.textSecondary),
                            const SizedBox(width: 16),
                            Text(
                              _selectedBillingDay != null 
                                ? '${AppStrings.get('form_date').split(' ')[0]} $_selectedBillingDay' 
                                : AppStrings.get('form_date_hint'),
                              style: TextStyle(
                                color: _selectedBillingDay != null ? AppColors.textPrimary : AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: _saveSubscription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAction,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        shadowColor: AppColors.primaryAction.withValues(alpha: 0.5),
                      ),
                      child: Text(
                        AppStrings.get('form_btn_save'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
