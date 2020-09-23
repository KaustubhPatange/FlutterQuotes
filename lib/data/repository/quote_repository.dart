import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:quotes_app/data/fake_data.dart';
import 'package:quotes_app/data/model/quote.dart';
import '../injection.dart';

@Bind.toType(DevQuoteRepository, env: Env.dev)
@Bind.toType(ProdQuoteRepository, env: Env.prod)
@injectable
abstract class QuoteRepository {
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
}

@injectable
class ProdQuoteRepository extends QuoteRepository {
  @override
  Future<Quotes> fetchQuotes() {
    return Future.delayed(Duration(seconds: 1), () {
      return Quotes.fromJson(jsonDecode(FakeQuotesData.data));
    });
  }
}
