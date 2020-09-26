import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/data/state/theme_store.dart';
import 'package:quotes_app/ui/global/strings.dart';
import 'package:quotes_app/ui/global/theme/app_themes.dart';
import 'package:quotes_app/ui/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/injection.dart';

// TODO: flutter packages pub run build_runner watch
void main() async {
  configureInjection(Env.prod);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ThemeStore(),
      child: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  MainApp({Key key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeStore _themeStore;
  static bool preferenceLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeStore = Provider.of<ThemeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildWithTheme(context),
    );
  }

  Widget _buildWithTheme(BuildContext context) {
    if (!preferenceLoaded) {
      preferenceLoaded = true;
      loadPreference(context);
    }
    return OKToast(
      child: Observer(
        builder: (_) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: _themeStore.themeData,
          home: Home(),
        ),
      ),
    );
  }

  void loadPreference(BuildContext context) async {
    // Load previous preference...
    var prefs = await SharedPreferences.getInstance();
    var theme = AppTheme.values[prefs.getInt(AppStrings.PREF_THEME) ?? 0];
    _themeStore.changeTheme(theme);
  }
}
