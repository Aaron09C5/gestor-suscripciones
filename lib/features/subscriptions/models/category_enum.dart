import 'package:flutter/material.dart';
import 'package:gestion_suscripciones/core/utils/app_strings.dart';

enum SubscriptionCategory {
  streaming('Streaming', Icons.play_circle_fill),
  hogar('Hogar', Icons.home),
  software('Software', Icons.computer),
  musica('Música', Icons.music_note);

  final String label;
  final IconData icon;

  const SubscriptionCategory(this.label, this.icon);

  String get labelTranslated {
    switch (this) {
      case SubscriptionCategory.streaming: return AppStrings.get('cat_streaming');
      case SubscriptionCategory.musica: return AppStrings.get('cat_musica');
      case SubscriptionCategory.hogar: return AppStrings.get('cat_hogar');
      case SubscriptionCategory.software: return AppStrings.get('cat_software');
    }
  }

  Color get color {
    switch (this) {
      case SubscriptionCategory.streaming:
        return Colors.black87;
      case SubscriptionCategory.musica:
        return const Color(0xFF1DB954);
      case SubscriptionCategory.hogar:
        return const Color(0xFF00ACC1);
      case SubscriptionCategory.software:
        return const Color(0xFF5C6BC0);
    }
  }
}
