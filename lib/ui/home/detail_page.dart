import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdi/mdi.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/data/model/quote.dart';
import 'package:quotes_app/data/state/theme_store.dart';
import 'package:quotes_app/ui/global/strings.dart';
import 'package:quotes_app/ui/global/theme/app_themes.dart';
import 'package:share/share.dart';

class DetailPage extends StatefulWidget {
  final Quote quote;

  DetailPage({Key key, @required this.quote}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  ThemeStore _themeStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeStore = Provider.of<ThemeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
      ),
      body: _scaffoldBody(context),
      extendBodyBehindAppBar: true,
    );
  }

  Widget _scaffoldBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_centerItem(context)],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: _bottomItem(context),
            )
          ],
        )
      ],
    );
  }

  Widget _centerItem(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () {
          Clipboard.setData(new ClipboardData(text: widget.quote.text));
          displayToast(context, AppStrings.COPY_CLIPBOARD);
        },
        child: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              Text("“", textScaleFactor: 4),
              Text(
                widget.quote.text,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(widget.quote.author)
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomItem(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      width: 180,
      height: 110,
      child: Container(
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            _bottomListItem(Mdi.contentCopy, "Copy", () {
              Clipboard.setData(new ClipboardData(text: widget.quote.text));
              displayToast(context, AppStrings.COPY_CLIPBOARD);
            }),
            SizedBox(width: 30),
            _bottomListItem(Mdi.shareVariant, "Share", () {
              Share.share("${widget.quote.text}\n\n- ${widget.quote.author}");
            }),
          ],
        ),
      ),
    );
  }

  Widget _bottomListItem(MdiIconData icon, String text, Function() onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(icon),
              SizedBox(height: 10),
              Text(text.toUpperCase(),
                  style: TextStyle(fontSize: 10, letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }

  void displayToast(BuildContext context, String text) {
    showToast(text,
        position: ToastPosition.bottom,
        backgroundColor: _themeStore.current == AppTheme.DARK
            ? Colors.grey[400]
            : Colors.grey[850],
        textStyle: TextStyle(
            color: _themeStore.current == AppTheme.DARK
                ? Colors.black
                : Colors.white));
  }
}
