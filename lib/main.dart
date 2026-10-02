import 'package:flutter/material.dart';
import 'package:gestion_suscripciones/core/theme/app_theme.dart';
import 'package:gestion_suscripciones/core/utils/currency_formatter.dart';
import 'package:gestion_suscripciones/core/utils/app_strings.dart';
import 'package:gestion_suscripciones/features/subscriptions/views/screens/subscriptions_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CurrencyFormatter.init();
  await AppStrings.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppStrings.languageNotifier,
      builder: (context, lang, child) {
        return MaterialApp(
          title: 'Gestión de Suscripciones',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const SubscriptionsScreen(),
        );
      },
    );
  }
}
