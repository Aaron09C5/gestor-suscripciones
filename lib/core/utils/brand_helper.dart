import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../features/subscriptions/models/category_enum.dart';

class BrandInfo {
  final Widget Function(double size, Color color) buildIcon;
  final Color backgroundColor;
  final Color iconColor;

  BrandInfo({
    required this.buildIcon,
    required this.backgroundColor,
    this.iconColor = Colors.white,
  });
}

class BrandHelper {
  static BrandInfo getBrandInfo(String name, SubscriptionCategory category) {
    final lowerName = name.trim().toLowerCase();

    if (lowerName.contains('spotify')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.spotify, size: size, color: color),
        backgroundColor: const Color(0xFF1DB954),
      );
    } else if (lowerName.contains('youtube')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.youtube, size: size, color: color),
        backgroundColor: const Color(0xFFFF0000),
      );
    } else if (lowerName.contains('amazon') || lowerName.contains('prime')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.amazon, size: size, color: color),
        backgroundColor: const Color(0xFF00A8E1),
      );
    } else if (lowerName.contains('apple')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.apple, size: size, color: color),
        backgroundColor: Colors.black,
      );
    } else if (lowerName.contains('google')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.google, size: size, color: color),
        backgroundColor: const Color(0xFF4285F4),
      );
    } else if (lowerName.contains('netflix')) {
      return BrandInfo(
        buildIcon: (size, color) => Icon(Icons.play_arrow_rounded, size: size, color: color),
        backgroundColor: Colors.black,
        iconColor: const Color(0xFFE50914),
      );
    } else if (lowerName.contains('disney')) {
      return BrandInfo(
        buildIcon: (size, color) => Icon(Icons.movie_creation, size: size, color: color),
        backgroundColor: const Color(0xFF113CCF),
      );
    } else if (lowerName.contains('hbo') || lowerName.contains('max')) {
      return BrandInfo(
        buildIcon: (size, color) => Icon(Icons.live_tv, size: size, color: color),
        backgroundColor: const Color(0xFF5A058A),
      );
    } else if (lowerName.contains('dropbox')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.dropbox, size: size, color: color),
        backgroundColor: const Color(0xFF0061FF),
      );
    } else if (lowerName.contains('slack')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.slack, size: size, color: color),
        backgroundColor: const Color(0xFF4A154B),
      );
    } else if (lowerName.contains('github')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.github, size: size, color: color),
        backgroundColor: const Color(0xFF24292E),
      );
    } else if (lowerName.contains('microsoft') || lowerName.contains('xbox')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.microsoft, size: size, color: color),
        backgroundColor: const Color(0xFF00A4EF),
      );
    } else if (lowerName.contains('playstation') || lowerName.contains('psn')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.playstation, size: size, color: color),
        backgroundColor: const Color(0xFF003791),
      );
    } else if (lowerName.contains('steam')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.steam, size: size, color: color),
        backgroundColor: const Color(0xFF171A21),
      );
    } else if (lowerName.contains('twitch')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.twitch, size: size, color: color),
        backgroundColor: const Color(0xFF9146FF),
      );
    } else if (lowerName.contains('discord')) {
      return BrandInfo(
        buildIcon: (size, color) => FaIcon(FontAwesomeIcons.discord, size: size, color: color),
        backgroundColor: const Color(0xFF5865F2),
      );
    } else if (lowerName.contains('adobe')) {
      return BrandInfo(
        buildIcon: (size, color) => Icon(Icons.picture_as_pdf, size: size, color: color),
        backgroundColor: const Color(0xFFFF0000),
      );
    } else if (lowerName.contains('notion')) {
      return BrandInfo(
        buildIcon: (size, color) => Icon(Icons.note_alt, size: size, color: color),
        backgroundColor: Colors.black,
      );
    }

    return BrandInfo(
      buildIcon: (size, color) => Icon(category.icon, size: size, color: color),
      backgroundColor: category.color,
    );
  }
}

