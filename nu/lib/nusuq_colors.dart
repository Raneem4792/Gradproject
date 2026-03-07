// ============================================
// Nusuq Color System
// ملف الألوان الرسمي لتطبيق نُسُق
// ============================================

import 'package:flutter/material.dart';

abstract class NusuqColors {

  // 🟢 Green — Primary (الأخضر الرئيسي)
  static const Color deepForest  = Color(0xFF0A2E1C); // Header background
  static const Color forest      = Color(0xFF0D3D26); // Dark cards background
  static const Color midGreen    = Color(0xFF1A6641); // Buttons, links, active nav
  static const Color brightGreen = Color(0xFF2ECC71); // Accent, badges, FAB
  static const Color paleGreen   = Color(0xFFC8F0D8); // Tag backgrounds
  static const Color mintSurface = Color(0xFFE8F8EF); // Active nav bg, pale sections

  // 🟡 Gold — Secondary (الذهبي الثانوي)
  static const Color gold        = Color(0xFFC9A84C); // Logo accent, badges
  static const Color goldLight   = Color(0xFFE0BE60); // Plate highlight, hover
  static const Color goldSurface = Color(0xFFF5E9C8); // Order history card bg
  static const Color darkGold    = Color(0xFF3D2A08); // Gold gradient start

  // ⚪ Neutrals — Base (المحايدات)
  static const Color textDark    = Color(0xFF1A2E22); // Primary text
  static const Color muted       = Color(0xFF7A9986); // Subtitles, placeholders
  static const Color border      = Color(0xFFDDEEE5); // Card borders, dividers
  static const Color cream       = Color(0xFFFAFAF7); // App background, cards
  static const Color appBg       = Color(0xFFE8F0EB); // Scaffold background

  // 🎨 Gradients (التدرجات)
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A2E1C), Color(0xFF1A6641)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3D2A08), Color(0xFF5A3E10)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A6641), Color(0xFF2ECC71)],
  );

  static const LinearGradient cardDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D3D26), Color(0xFF1E9E60)],
  );

}
