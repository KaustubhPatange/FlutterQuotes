import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi/mdi.dart';
import 'package:quotes_app/data/blocs/quoteBloc/quote_bloc.dart';
import 'package:quotes_app/data/injection.iconfig.dart';
import 'package:quotes_app/data/repository/quote_repository.dart';
import 'package:quotes_app/ui/global/strings.dart';
import 'package:quotes_app/ui/global/theme/app_themes.dart';
import 'package:quotes_app/ui/global/theme/bloc/theme_bloc.dart';
import 'package:quotes_app/ui/home/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final AppTheme current;
  Home({Key key, @required this.current}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void changeTheme(BuildContext context) async {
    final bloc = BlocProvider.of<ThemeBloc>(context);
    final prefs = await SharedPreferences.getInstance();
    if (widget.current == AppTheme.LIGHT) {
      bloc.add(ThemeChanged(theme: AppTheme.DARK));
      prefs.setInt(AppStrings.PREF_THEME, AppTheme.DARK.index);
    } else {
      bloc.add(ThemeChanged(theme: AppTheme.LIGHT));
      prefs.setInt(AppStrings.PREF_THEME, AppTheme.LIGHT.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Quotes",
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Mdi.lightbulbOutline),
              onPressed: () => changeTheme(context))
        ],
      ),
      body: BlocProvider(
          create: (context) =>
              QuoteBloc(quoteRepository: getIt<QuoteRepository>())
                ..add(GetQuotes()),
          child: BlocBuilder<QuoteBloc, QuoteState>(
            builder: _scaffoldBody,
          )),
    );
  }

  Widget _scaffoldBody(BuildContext context, QuoteState state) {
    if (state is QuoteLoading) {
      return buildForLoading();
    } else if (state is QuoteLoaded) {
      return buildForQuoteLoaded(state);
    } else if (state is QuoteError) {
      return buildForError(state);
    }
    return Text("Hello world");
  }

  Widget buildForLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildForError(QuoteError state) {
    return Text(state.message);
  }

  Widget buildForQuoteLoaded(QuoteLoaded state) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return false;
      },
      child: ListView.builder(
        itemCount: state.quotes.quoteList.length,
        itemBuilder: (context, index) {
          final item = state.quotes.quoteList[index];
          return Card(
            margin: EdgeInsets.only(left: 30, top: 10, bottom: 10),
            key: Key(item.id),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(quote: item)),
                );
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Text(
                      "“",
                      style: TextStyle(fontSize: 50),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(10),
                          child: Text(item.text),
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                              "- ${item.author.isEmpty ? "Anonymous" : item.author}",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
