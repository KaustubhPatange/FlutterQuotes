import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:quotes_app/ui/global/strings.dart';
import 'package:quotes_app/ui/global/theme/app_themes.dart';
import 'package:quotes_app/ui/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/blocs/quoteBloc/quote_bloc.dart';
import 'data/injection.dart';
import 'data/injection.iconfig.dart';
import 'data/repository/quote_repository.dart';
import 'ui/global/theme/bloc/theme_bloc.dart';

void main() async {
  configureInjection(Env.prod);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => QuoteBloc(getIt<QuoteRepository>())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPreference(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (_, state) => _buildWithTheme(state),
    );
  }

  Widget _buildWithTheme(ThemeState state) {
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
