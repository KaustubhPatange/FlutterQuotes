import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/data/model/quote.dart';
import 'package:quotes_app/data/state/quote_store.dart';
import 'package:quotes_app/data/state/theme_store.dart';
import 'package:quotes_app/ui/global/strings.dart';
import 'package:quotes_app/ui/global/theme/app_themes.dart';
import 'package:quotes_app/ui/home/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ThemeStore _themeStore;
  QuoteStore _quoteStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeStore = Provider.of<ThemeStore>(context);
    _quoteStore = Provider.of<QuoteStore>(context)..getQuotes();
  }

  void changeTheme(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (_themeStore.current == AppTheme.LIGHT) {
      _themeStore.changeTheme(AppTheme.DARK);
      prefs.setInt(AppStrings.PREF_THEME, AppTheme.DARK.index);
    } else {
      _themeStore.changeTheme(AppTheme.LIGHT);
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
      body: Observer(
        builder: (_) => _scaffoldBody(context),
      ),
    );
  }

  Widget _scaffoldBody(BuildContext context) {
    switch (_quoteStore.state) {
      case QuoteState.loading:
        return buildForLoading();
      case QuoteState.loaded:
        return buildForQuoteLoaded();
      case QuoteState.error:
        return buildForError();
      default:
        return Text("Hello world");
    }
  }

  Widget buildForLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildForError() {
    return Text(_quoteStore.errorMessage);
  }

  Widget buildForQuoteLoaded() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return false;
      },
      child: LazyLoadScrollView(
        onEndOfPage: () {
          if (int.parse(_quoteStore.quotes.currentPage) <
              _quoteStore.quotes.totalPages) {
            print("Loading page: ${_quoteStore.quotes.currentPage}");
            _quoteStore.getQuotes();
          }
        },
        scrollOffset: 100,
        child: ListView.builder(
          itemCount: _calculateListItemCount(),
          itemBuilder: (context, index) {
            return index >= _quoteStore.quotes.quoteList.length
                ? Padding(padding: EdgeInsets.all(10), child: buildForLoading())
                : buildForCardItem(_quoteStore.quotes.quoteList[index]);
          },
        ),
      ),
    );
  }

  int _calculateListItemCount() {
    if (int.parse(_quoteStore.quotes.currentPage) >=
        _quoteStore.quotes.totalPages) {
      return _quoteStore.quotes.quoteList.length;
    } else {
      // + 1 for the loading indicator
      return _quoteStore.quotes.quoteList.length + 1;
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
