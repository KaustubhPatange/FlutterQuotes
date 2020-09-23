import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:quotes_app/ui/global/strings.dart';
import 'package:quotes_app/ui/global/theme/app_themes.dart';
import 'package:quotes_app/ui/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/injection.dart';
import 'ui/global/theme/bloc/theme_bloc.dart';

void main() async {
  configureInjection(Env.prod);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool preferenceLoaded = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    if (!preferenceLoaded) {
      preferenceLoaded = true;
      loadPreference(context);
    }
    return OKToast(
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: state.themeData,
          home: Home(
            current: state.theme,
          )),
    );
  }

  void loadPreference(BuildContext context) async {
    // Load previous preference...
    var prefs = await SharedPreferences.getInstance();
    var theme = AppTheme.values[prefs.getInt(AppStrings.PREF_THEME) ?? 0];
    BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: theme));
  }
}
