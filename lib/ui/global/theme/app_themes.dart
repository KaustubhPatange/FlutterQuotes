import 'package:flutter/material.dart';

import '../colors.dart';

enum AppTheme { LIGHT, DARK }

final appThemeData = {
  AppTheme.DARK: ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Epilogue',
    primaryColor: CustomColors.DarkColor,
    scaffoldBackgroundColor: CustomColors.DarkColor,
    cardColor: CustomColors.PaleDarkColor,
    accentColor: CustomColors.LightDarkColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
  AppTheme.LIGHT: ThemeData(
    fontFamily: 'Epilogue',
    primaryColor: CustomColors.LightColor,
    cardColor: CustomColors.PaleLightColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
};
