import 'package:flutter/material.dart';

import '../colors.dart';

enum AppTheme { LIGHT, DARK }

final appThemeData = {
  AppTheme.DARK: ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Epilogue',
    primaryColor: CustomColors.DarkColor,
    scaffoldBackgroundColor: CustomColors.DarkColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
  AppTheme.LIGHT: ThemeData(
    fontFamily: 'Epilogue',
    primaryColor: CustomColors.LightColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
};
