part of 'quote_bloc.dart';

abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object> get props => [];
}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final Quotes quotes;

  QuoteLoaded({this.quotes});

  @override
  List<Object> get props => [quotes];
}

class QuoteError extends QuoteState {
  final String message;

  QuoteError({this.message});

  @override
  List<Object> get props => [message];
}
