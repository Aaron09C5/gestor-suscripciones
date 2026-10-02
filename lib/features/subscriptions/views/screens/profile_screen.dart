import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_suscripciones/core/theme/app_colors.dart';
import 'package:gestion_suscripciones/core/utils/currency_formatter.dart';
import 'package:gestion_suscripciones/core/utils/app_strings.dart';
import '../../models/subscription_model.dart';

class ProfileScreen extends StatefulWidget {
  final List<SubscriptionModel> subscriptions;
  final VoidCallback onResetData;
  final VoidCallback onLanguageOrCurrencyChanged;

  const ProfileScreen({
    super.key,
    required this.subscriptions,
    required this.onResetData,
    required this.onLanguageOrCurrencyChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _userName = '';

  final Map<String, String> _currencies = {
    'USD - Dólar Estadounidense': '\$',
    'EUR - Euro': '€',
    'HNL - Lempira Hondureño': 'L',
    'GBP - Libra Esterlina': '£',
    'JPY - Yen Japonés': '¥',
    'AUD - Dólar Australiano': 'A\$',
    'CAD - Dólar Canadiense': 'C\$',
    'CHF - Franco Suizo': 'CHF',
    'HKD - Dólar de Hong Kong': 'HK\$',
    'NZD - Dólar Neozelandés': 'NZ\$',
    'KRW - Won Surcoreano': '₩',
    'SGD - Dólar Singapurense': 'S\$',
    'INR - Rupia India': '₹',
    'MXN - Peso Mexicano': 'MX\$',
    'BRL - Real Brasileño': 'R\$',
    'ZAR - Rand Sudafricano': 'R',
    'RUB - Rublo Ruso': '₽',
    'TRY - Lira Turca': '₺',
    'COP - Peso Colombiano': 'COP\$',
    'CLP - Peso Chileno': 'CLP\$',
    'ARS - Peso Argentino': 'ARS\$',
    'PEN - Sol Peruano': 'S/',
    'UYU - Peso Uruguayo': '\$U',
  };

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name_data') ?? '';
    });
  }

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name_data', name);
    setState(() {
      _userName = name;
    });
  }

  void _showEditNameDialog() {
    final controller = TextEditingController(text: _userName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(AppStrings.get('profile_edit_name'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: AppStrings.get('profile_your_name'),
              filled: true,
              fillColor: AppColors.background,
              border: const OutlineInputBorder(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAction, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  _saveUserName(controller.text.trim());
                }
                Navigator.pop(context);
              },
              child: Text(AppStrings.get('common_save'), style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showCurrencySelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(AppStrings.get('profile_select_currency'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _currencies.length,
              itemBuilder: (context, index) {
                final key = _currencies.keys.elementAt(index);
                final symbol = _currencies[key]!;
                return ListTile(
                  title: Text(key, style: const TextStyle(color: AppColors.textPrimary)),
                  trailing: Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  onTap: () async {
                    await CurrencyFormatter.updateSymbol(symbol);
                    widget.onLanguageOrCurrencyChanged();
                    if (context.mounted) Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(AppStrings.get('profile_select_language'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          content: SizedBox(
            width: double.maxFinite,
            height: 120,
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Español (ES)', style: TextStyle(color: AppColors.textPrimary)),
                  trailing: AppStrings.currentLanguage == 'es' ? const Icon(Icons.check, color: AppColors.headerCyan) : null,
                  onTap: () async {
                    await AppStrings.setLanguage('es');
                    widget.onLanguageOrCurrencyChanged();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('English (EN)', style: TextStyle(color: AppColors.textPrimary)),
                  trailing: AppStrings.currentLanguage == 'en' ? const Icon(Icons.check, color: AppColors.headerCyan) : null,
                  onTap: () async {
                    await AppStrings.setLanguage('en');
                    widget.onLanguageOrCurrencyChanged();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmResetData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('⚠️ ${AppStrings.get('profile_danger_zone')}', style: const TextStyle(color: AppColors.primaryAction, fontWeight: FontWeight.bold)),
        content: Text(AppStrings.get('profile_reset_warning'), style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get('common_cancel'), style: const TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAction, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              widget.onResetData();
            },
            child: Text(AppStrings.get('common_reset'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeSubs = widget.subscriptions.where((s) => s.isActive).toList();
    final totalSubs = widget.subscriptions.length;
    final annualCost = activeSubs.fold(0.0, (sum, s) => sum + s.monthlyCost) * 12;
    
    final displayName = _userName.isNotEmpty ? _userName : AppStrings.get('profile_default_name');

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(displayName),
          _buildMetrics(totalSubs, annualCost),
          _buildSettings(),
          _buildDangerZone(),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'SubTrack v1.0.0',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String displayName) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 40),
      decoration: const BoxDecoration(
        color: AppColors.headerDarkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.headerCyan, Color(0xFF0083B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${AppStrings.get('profile_hello')} $displayName',
                        style: const TextStyle(color: AppColors.textLight, fontSize: 24, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white70, size: 18),
                      onPressed: _showEditNameDialog,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppStrings.get('profile_premium'),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(int totalSubs, double annualCost) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.headerCyan.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.video_library_rounded, color: AppColors.headerCyan, size: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    totalSubs.toString(), 
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  Text(
                    AppStrings.get('profile_subs'), 
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.headerDarkBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.calendar_month, color: AppColors.headerDarkBlue, size: 24),
                  ),
                  const SizedBox(height: 16),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      CurrencyFormatter.format(annualCost), 
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                    ),
                  ),
                  Text(
                    AppStrings.get('profile_annual'), 
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            AppStrings.get('profile_settings'), 
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Material(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.language, color: Colors.blue, size: 20),
                    ),
                    title: Text(AppStrings.get('profile_language'), style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                    onTap: _showLanguageSelector,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.black12),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.monetization_on, color: Colors.orange, size: 20),
                    ),
                    title: Text(AppStrings.get('profile_currency'), style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                    onTap: _showCurrencySelector,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.black12),
                  SwitchListTile(
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.headerCyan.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.notifications_active, color: AppColors.headerCyan, size: 20),
                    ),
                    title: Text(AppStrings.get('profile_notifications'), style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    activeTrackColor: AppColors.headerCyan.withValues(alpha: 0.5),
                    activeThumbColor: AppColors.headerCyan,
                    value: _notificationsEnabled,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.black12),
                  SwitchListTile(
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.dark_mode, color: Colors.purple, size: 20),
                    ),
                    title: Text(AppStrings.get('profile_dark_mode'), style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    activeTrackColor: Colors.purple.withValues(alpha: 0.5),
                    activeThumbColor: Colors.purple,
                    value: _darkModeEnabled,
                    onChanged: (val) => setState(() => _darkModeEnabled = val),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Text(
            AppStrings.get('profile_danger_zone'), 
            style: const TextStyle(color: AppColors.primaryAction, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryAction.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(color: AppColors.primaryAction.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Material(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.primaryAction.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.delete_forever, color: AppColors.primaryAction, size: 20),
                ),
                title: Text(AppStrings.get('profile_reset'), style: const TextStyle(color: AppColors.primaryAction, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.warning_rounded, color: AppColors.primaryAction, size: 16),
                onTap: _confirmResetData,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
