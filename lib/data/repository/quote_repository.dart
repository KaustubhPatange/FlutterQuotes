import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:quotes_app/data/fake_data.dart';
import 'package:quotes_app/data/model/quote.dart';
import 'package:http/http.dart' as http;
import 'package:quotes_app/data/quote_datasource.dart';
import '../injection.dart';

@Bind.toType(DevQuoteRepository, env: Env.dev)
@Bind.toType(ProdQuoteRepository, env: Env.prod)
@injectable
abstract class QuoteRepository {
  bool isNextPage();
  Future<Quotes> fetchQuotes();
}

@injectable
class DevQuoteRepository extends QuoteRepository {
  @override
  Future<Quotes> fetchQuotes() {
    return Future.delayed(Duration(seconds: 1), () {
      return Quotes.fromJson(jsonDecode(FakeQuotesData.data));
    });
  }

  @override
  bool isNextPage() => false;
}

@injectable
class ProdQuoteRepository extends QuoteRepository {
  QuoteDatasource _datasource;

  ProdQuoteRepository() {
    _datasource = GetIt.I.get<QuoteDatasource>();
  }

  @override
  Future<Quotes> fetchQuotes() async {
    return _datasource.fetchNextQuotes();
  }

  @override
  bool isNextPage() => _datasource.currentPage >= 1;
}
