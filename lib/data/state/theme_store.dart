import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:quotes_app/ui/global/theme/app_themes.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  @observable
  AppTheme current = AppTheme.LIGHT;

  @observable
  ThemeData themeData = appThemeData[AppTheme.LIGHT];

  void changeTheme(AppTheme theme) {
    current = theme;
    themeData = appThemeData[theme];
  }
}
