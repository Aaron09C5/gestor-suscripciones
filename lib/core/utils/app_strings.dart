import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStrings {
  static final ValueNotifier<String> languageNotifier = ValueNotifier('es');
  static String get currentLanguage => languageNotifier.value;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    languageNotifier.value = prefs.getString('app_language') ?? 'es';
  }

  static Future<void> setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang);
    languageNotifier.value = lang;
  }

  static String get(String key) {
    final map = _translations[currentLanguage] ?? _translations['es']!;
    return map[key] ?? key;
  }

  static const Map<String, Map<String, String>> _translations = {
    'es': {
      'nav_home': 'Inicio',
      'nav_budget': 'Presupuesto',
      'nav_profile': 'Perfil',
      
      'dashboard_monthly_cost': 'Gasto Mensual',
      'dashboard_active_subs': 'Suscripciones Activas',
      
      'subs_all': 'Todas',
      'subs_your_subs': 'TUS SUSCRIPCIONES',
      'subs_active': 'ACTIVAS',
      'subs_deleted': 'eliminada',
      'subs_undo': 'DESHACER',
      'subs_under_construction': 'Pantalla en construcción',
      
      'card_active': 'Activa',
      'card_inactive': 'Inactiva',
      'card_per_month': '/mes',
      'card_renews_in': 'Renueva en',
      'card_days': 'días',
      'card_today': 'hoy',
      'card_tomorrow': 'mañana',
      
      'budget_title': 'Presupuesto Mensual',
      'budget_limit': 'Límite de Presupuesto',
      'budget_available': 'Disponible:',
      'budget_exceeded': '¡Excedido por',
      'budget_consumed': 'consumido',
      'budget_category_expense': 'GASTO POR CATEGORÍA',
      'budget_edit_title': 'Editar Presupuesto',
      
      'profile_hello': 'Hola,',
      'profile_default_name': 'Nombre',
      'profile_premium': 'Miembro premium',
      'profile_subs': 'Suscripciones',
      'profile_annual': 'Gasto Anual',
      'profile_settings': 'AJUSTES Y PREFERENCIAS',
      'profile_currency': 'Formato de Moneda',
      'profile_notifications': 'Recordatorios de pago',
      'profile_dark_mode': 'Tema Oscuro',
      'profile_language': 'Idioma / Language',
      'profile_danger_zone': 'ZONA DE PELIGRO',
      'profile_reset': 'Restablecer datos',
      'profile_edit_name': 'Editar Nombre',
      'profile_your_name': 'Tu nombre',
      'profile_select_currency': 'Seleccionar Moneda',
      'profile_select_language': 'Seleccionar Idioma',
      'profile_reset_warning': '¿Estás seguro? Se eliminarán todas las suscripciones actuales y se cargarán los datos de ejemplo por defecto. Esta acción no se puede deshacer.',
      
      'common_cancel': 'CANCELAR',
      'common_save': 'GUARDAR',
      'common_reset': 'RESTABLECER',
      
      'new_sub_title': 'NUEVA SUSCRIPCIÓN',
      'edit_sub_title': 'EDITAR SUSCRIPCIÓN',
      'form_name': 'Nombre del servicio',
      'form_name_hint': 'Ej. Netflix, Spotify',
      'form_cost': 'Costo mensual',
      'form_cost_hint': 'Ej. 14.99',
      'form_category': 'Categoría',
      'form_date': 'Día de facturación',
      'form_date_hint': 'Selecciona una fecha',
      'form_btn_save': 'GUARDAR SUSCRIPCIÓN',
      'err_name': 'Por favor ingresa un nombre',
      'err_cost': 'Por favor ingresa un costo válido',
      'err_date': 'Por favor selecciona un día',
      
      'cat_streaming': 'Streaming',
      'cat_musica': 'Música',
      'cat_hogar': 'Hogar',
      'cat_software': 'Software',
    },
    'en': {
      'nav_home': 'Home',
      'nav_budget': 'Budget',
      'nav_profile': 'Profile',
      
      'dashboard_monthly_cost': 'Monthly Cost',
      'dashboard_active_subs': 'Active Subscriptions',
      
      'subs_all': 'All',
      'subs_your_subs': 'YOUR SUBSCRIPTIONS',
      'subs_active': 'ACTIVE',
      'subs_deleted': 'deleted',
      'subs_undo': 'UNDO',
      'subs_under_construction': 'Screen under construction',
      
      'card_active': 'Active',
      'card_inactive': 'Inactive',
      'card_per_month': '/mo',
      'card_renews_in': 'Renews in',
      'card_days': 'days',
      'card_today': 'today',
      'card_tomorrow': 'tomorrow',
      
      'budget_title': 'Monthly Budget',
      'budget_limit': 'Budget Limit',
      'budget_available': 'Available:',
      'budget_exceeded': 'Exceeded by',
      'budget_consumed': 'consumed',
      'budget_category_expense': 'EXPENSE BY CATEGORY',
      'budget_edit_title': 'Edit Budget',
      
      'profile_hello': 'Hello,',
      'profile_default_name': 'Name',
      'profile_premium': 'Premium Member',
      'profile_subs': 'Subscriptions',
      'profile_annual': 'Annual Cost',
      'profile_settings': 'SETTINGS & PREFERENCES',
      'profile_currency': 'Currency Format',
      'profile_notifications': 'Payment Reminders',
      'profile_dark_mode': 'Dark Mode',
      'profile_language': 'Language / Idioma',
      'profile_danger_zone': 'DANGER ZONE',
      'profile_reset': 'Reset Data',
      'profile_edit_name': 'Edit Name',
      'profile_your_name': 'Your name',
      'profile_select_currency': 'Select Currency',
      'profile_select_language': 'Select Language',
      'profile_reset_warning': 'Are you sure? All current subscriptions will be deleted and default example data will be loaded. This action cannot be undone.',
      
      'common_cancel': 'CANCEL',
      'common_save': 'SAVE',
      'common_reset': 'RESET',
      
      'new_sub_title': 'NEW SUBSCRIPTION',
      'edit_sub_title': 'EDIT SUBSCRIPTION',
      'form_name': 'Service Name',
      'form_name_hint': 'E.g. Netflix, Spotify',
      'form_cost': 'Monthly Cost',
      'form_cost_hint': 'E.g. 14.99',
      'form_category': 'Category',
      'form_date': 'Billing Day',
      'form_date_hint': 'Select a date',
      'form_btn_save': 'SAVE SUBSCRIPTION',
      'err_name': 'Please enter a name',
      'err_cost': 'Please enter a valid cost',
      'err_date': 'Please select a day',
      
      'cat_streaming': 'Streaming',
      'cat_musica': 'Music',
      'cat_hogar': 'Home',
      'cat_software': 'Software',
    }
  };
}
