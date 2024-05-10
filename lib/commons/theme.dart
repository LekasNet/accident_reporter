import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accident_reporter/commons/colors.dart';
import 'package:accident_reporter/commons/typography.dart';

enum AppThemeType { light, dark, black }

class AppTheme {
  static ThemeColors lightThemeColors = ThemeColors();

  static AppThemeType defaultThemeType = AppThemeType.light;
  static ThemeMode defaultThemeMode = ThemeMode.light;

  static ThemeData theme = AppTheme.getDataByThemeType();

  static final lightTheme = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: lightThemeColors.active,
      displayColor: lightThemeColors.active,
    ),
    scaffoldBackgroundColor: lightThemeColors.background01,
    appBarTheme: AppBarTheme(
      titleSpacing: 24,
      backgroundColor: lightThemeColors.background01,
      shadowColor: Colors.transparent,
      titleTextStyle:
      AppTextStyle.title.copyWith(color: lightThemeColors.active),
      iconTheme: IconThemeData(color: lightThemeColors.active),
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme:
    ThemeData.light().bottomNavigationBarTheme.copyWith(
      type: BottomNavigationBarType.shifting,
      backgroundColor: lightThemeColors.background03,
      selectedItemColor: lightThemeColors.active,
      unselectedItemColor: lightThemeColors.deactive,
      selectedLabelStyle: AppTextStyle.captionL,
      unselectedLabelStyle: AppTextStyle.captionS,
    ),
    colorScheme: ColorScheme(
      background: lightThemeColors.background01,
      brightness: Brightness.light,
      primary: lightThemeColors.primary,
      secondary: lightThemeColors.fieldBackground,
      surface: lightThemeColors.background01,
      onBackground: lightThemeColors.active,
      onSurface: lightThemeColors.active,
      onError: lightThemeColors.active,
      onPrimary: lightThemeColors.white,
      onSecondary: lightThemeColors.active,
      error: lightThemeColors.colorful07,
    ),
  );


  static ThemeData getDataByThemeType({AppThemeType? themeType}) {
    themeType ??= defaultThemeType;

    switch (themeType) {
      case AppThemeType.light:
        return lightTheme;
      case AppThemeType.dark:
        return lightTheme;
      default:
        return lightTheme;
    }
  }

  static ThemeMode getThemeModeByType({AppThemeType? themeType}) {
    themeType ??= defaultThemeType;

    switch (themeType) {
      case AppThemeType.light:
        return ThemeMode.light;
      case AppThemeType.black:
        return ThemeMode.dark;
      default:
        return ThemeMode.dark;
    }
  }

  static void changeThemeType(AppThemeType? themeType) {
    defaultThemeType = themeType ?? AppThemeType.light;
    defaultThemeMode = getThemeModeByType(themeType: defaultThemeType);
    theme = AppTheme.getDataByThemeType();

    // deleting the system status bar color and updating navigation bar color
    // overlay
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppTheme.colors.background01));
  }

  static ThemeColors getColorsByMode({AppThemeType? themeType}) {
    themeType ??= defaultThemeType;

    switch (themeType) {
      case AppThemeType.light:
        return LightThemeColors();
      case AppThemeType.black:
        return LightThemeColors();
      default:
        return ThemeColors();
    }
  }

  /// Returns the current theme data. If the theme is changed, the data will be
  /// updated.
  static ThemeMode get themeMode => getThemeModeByType();

  /// Returns the current theme colors. If the theme is changed, the colors
  /// will be updated.
  static ThemeColors get colors => getColorsByMode();

}