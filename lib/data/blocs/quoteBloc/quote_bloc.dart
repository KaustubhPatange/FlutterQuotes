import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:quotes_app/data/model/quote.dart';
import 'package:quotes_app/data/quote_datasource.dart';
import 'package:quotes_app/data/repository/quote_repository.dart';

part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteRepository quoteRepository;

  QuoteBloc(this.quoteRepository) : super(QuoteInitial());

  @override
  Stream<QuoteState> mapEventToState(
    QuoteEvent event,
  ) async* {
    if (event is GetQuotes) {
      try {
        if (!quoteRepository.isNextPage()) {
          yield QuoteLoading();
        }
        var quotes = await quoteRepository.fetchQuotes();
        yield QuoteLoaded(quotes: quotes);
      } on InvalidPageException catch (ex) {
        // TODO: do something on no pages
      } on Error catch (ex) {
        yield QuoteError(message: ex.toString());
      }
    }
  }
}
