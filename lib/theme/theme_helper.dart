import 'package:atteventify/core/app_export.dart';
import 'package:flutter/material.dart';

String _appTheme = "primary";
PrimaryColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable

class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };

// A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: appTheme.gray100,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: colorScheme.primaryContainer,
          fontSize: 16.fSize,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.primaryContainer,
          fontSize: 14.fSize,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 32.fSize,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
        labelLarge: TextStyle(
          color: colorScheme.primaryContainer,
          fontSize: 12.fSize,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20.fSize,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 16.fSize,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    primary: Color(0XFF99CED1),
    primaryContainer: Color(0XFF568789),
    errorContainer: Color(0X19000000),
    onPrimary: Color(0XFF0F1919),
  );
}

/// Class containing custom colors for a primary theme.
class PrimaryColors {
  // BlueGray
  Color get blueGray100 => Color(0XFFD1E0E2);
  Color get blueGray400 => Color(0XFF888888);
  Color get gray100 => Color(0XFFF2F7F7);
  Color get gray200 => Color(0XFFE5E8EA);
// Teal
  Color get teal50 => Color(0XFFE2EDED);
// White
  Color get whiteA700 => Color(0XFFFFFFFF);
}
