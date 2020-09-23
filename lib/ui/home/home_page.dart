import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mdi/mdi.dart';
import 'package:quotes_app/data/blocs/quoteBloc/quote_bloc.dart';
import 'package:quotes_app/data/injection.iconfig.dart';
import 'package:quotes_app/data/model/quote.dart';
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
      return buildForQuoteLoaded(context, state);
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

  Widget buildForQuoteLoaded(BuildContext context, QuoteLoaded state) {
    final bloc = BlocProvider.of<QuoteBloc>(context);
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return false;
      },
      child: LazyLoadScrollView(
        onEndOfPage: () {
          if (int.parse(state.quotes.currentPage) < state.quotes.totalPages) {
            print("Loading page: ${state.quotes.currentPage}");
            bloc.add(GetQuotes());
          }
        },
        scrollOffset: 100,
        child: ListView.builder(
          itemCount: _calculateListItemCount(state),
          itemBuilder: (context, index) {
            return index >= state.quotes.quoteList.length
                ? Padding(padding: EdgeInsets.all(10), child: buildForLoading())
                : buildForCardItem(state.quotes.quoteList[index]);
          },
        ),
      ),
    );
  }

  int _calculateListItemCount(QuoteLoaded state) {
    if (int.parse(state.quotes.currentPage) >= state.quotes.totalPages) {
      return state.quotes.quoteList.length;
    } else {
      // + 1 for the loading indicator
      return state.quotes.quoteList.length + 1;
    }
  }

  Widget buildForCardItem(Quote item) {
    return Card(
      margin: EdgeInsets.only(left: 30, top: 10, bottom: 10),
      key: Key(item.id),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(quote: item)),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("“", textScaleFactor: 3.5),
              Transform(
                transform: Matrix4.translationValues(0.0, -12.0, 0.0),
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
          ),
        ),
      ),
    );
  }
}
