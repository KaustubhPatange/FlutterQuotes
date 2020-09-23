import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:quotes_app/data/model/quote.dart';
import 'package:quotes_app/data/repository/quote_repository.dart';

part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteRepository quoteRepository;

  QuoteBloc({@required this.quoteRepository}) : super(QuoteInitial());

  @override
  Stream<QuoteState> mapEventToState(
    QuoteEvent event,
  ) async* {
    yield QuoteLoading();
    if (event is GetQuotes) {
      try {
        var quotes = await quoteRepository.fetchQuotes();
        if (quotes.statusCode != 200) {
          yield QuoteError(message: quotes.message);
          return;
        }
        yield QuoteLoaded(quotes: quotes);
      } on Error catch (ex) {
        yield QuoteError(message: ex.toString());
      }
    }
  }
}
