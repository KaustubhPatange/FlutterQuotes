import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String id;
  final String text;
  final String author;

  Quote({this.id, this.text, this.author});

  @override
  List<Object> get props => [id, text, author];

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      text: json['quoteText'],
      author: json['quoteAuthor'],
    );
  }
}

class Quotes extends Equatable {
  final int statusCode;
  final String message;
  final int totalPages;
  final String currentPage;
  final List<Quote> quoteList;

  Quotes(
      {this.statusCode,
      this.message,
      this.totalPages,
      this.currentPage,
      this.quoteList});

  @override
  List<Object> get props => [statusCode, message, totalPages, currentPage];

  static Quotes mergeQuotes(Quotes pre, Quotes increment) {
    return Quotes(
      currentPage: increment.currentPage,
      message: increment.message,
      statusCode: increment.statusCode,
      totalPages: increment.totalPages,
      quoteList: pre.quoteList..addAll(increment.quoteList),
    );
  }

  factory Quotes.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonArray = json["quotes"];
    var quoteList = jsonArray.map((e) => Quote.fromJson(e)).toList();
    return Quotes(
        statusCode: json["statusCode"],
        message: json["message"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        quoteList: quoteList);
  }
}
