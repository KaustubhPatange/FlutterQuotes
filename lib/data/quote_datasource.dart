import 'dart:convert';

import 'package:injectable/injectable.dart';

import 'model/quote.dart';
import 'package:http/http.dart' as http;

@injectable
class QuoteDatasource {
  int _totalPages = 0;
  int currentPage = 0;

  Quotes _old;

  Future<Quotes> fetchNextQuotes() async {
    if (_totalPages != 0 && currentPage >= _totalPages) {
      throw InvalidPageException();
    }

    currentPage++;

    final response = await http.get(
        "https://quote-garden.herokuapp.com/api/v3/quotes?page=$currentPage&limit=10");

    if (response.statusCode == 200) {
      final quotes = Quotes.fromJson(jsonDecode((response.body)));

      _totalPages = quotes.totalPages;

      if (_old == null) {
        _old = quotes;
        return quotes;
      }
      final mergeQuotes = Quotes.mergeQuotes(_old, quotes);
      _old = mergeQuotes;
      return mergeQuotes;
    } else {
      throw Exception("Response not sucessful");
    }
  }
}

class InvalidPageException implements Exception {}
