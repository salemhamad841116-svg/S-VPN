import 'package:flutter/material.dart';

class AppTheme {
  // Obsidian Base Palette
  static const Color obsidianVoid = Color(0xFF080A0F);
  static const Color obsidianSurface = Color(0xFF0E121B);
  static const Color obsidianElevated = Color(0xFF151B27);
  static const Color obsidianBorder = Color(0x28FFFFFF);

  // Neon Cyber Accents
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonEmerald = Color(0xFF00F59B);
  static const Color neonCrimson = Color(0xFFFF3366);
  static const Color neonPurple = Color(0xFFA855F7);
  static const Color neonAmber = Color(0xFFFFB020);
  static const Color neonBlue = Color(0xFF38BDF8);

  // Aurora Backdrop Colors
  static const Color auroraTeal = Color(0xFF0D9488);
  static const Color auroraIndigo = Color(0xFF4338CA);
  static const Color auroraRose = Color(0xFFBE185D);

  // Glass Values
  static const double glassBlur = 18.0;
  static final Color glassFill = Colors.white.withOpacity(0.05);
  static final Color glassFillHover = Colors.white.withOpacity(0.08);
  static final Color glassBorderColor = Colors.white.withOpacity(0.12);
  static final Color glassBorderHighlight = neonCyan.withOpacity(0.35);

  // Typography Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Modern Gradients
  static const LinearGradient connectedGradient = LinearGradient(
    colors: [neonEmerald, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient disconnectedGradient = LinearGradient(
    colors: [neonCrimson, Color(0xFFE11D48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient connectingGradient = LinearGradient(
    colors: [neonCyan, Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonShieldIdleGradient = LinearGradient(
    colors: [Color(0x33FF3366), Color(0x08FF3366)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient neonShieldActiveGradient = LinearGradient(
    colors: [Color(0x3300F59B), Color(0x0800F59B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidianVoid,
      primaryColor: neonCyan,
      fontFamily: 'SF Pro Display',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        secondary: neonPurple,
        surface: obsidianSurface,
        background: obsidianVoid,
        error: neonCrimson,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(obsidianElevated),
          elevation: MaterialStateProperty.all(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: glassBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: glassBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: neonCyan, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );
  }
}
