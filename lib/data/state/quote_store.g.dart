// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuoteStore on _QuoteStore, Store {
  Computed<QuoteState> _$stateComputed;

  @override
  QuoteState get state =>
      (_$stateComputed ??= Computed<QuoteState>(() => super.state)).value;

  final _$_quotesFutureAtom = Atom(name: '_QuoteStore._quotesFuture');

  @override
  ObservableFuture<Quotes> get _quotesFuture {
    _$_quotesFutureAtom.context.enforceReadPolicy(_$_quotesFutureAtom);
    _$_quotesFutureAtom.reportObserved();
    return super._quotesFuture;
  }

  @override
  set _quotesFuture(ObservableFuture<Quotes> value) {
    _$_quotesFutureAtom.context.conditionallyRunInAction(() {
      super._quotesFuture = value;
      _$_quotesFutureAtom.reportChanged();
    }, _$_quotesFutureAtom, name: '${_$_quotesFutureAtom.name}_set');
  }

  final _$quotesAtom = Atom(name: '_QuoteStore.quotes');

  @override
  Quotes get quotes {
    _$quotesAtom.context.enforceReadPolicy(_$quotesAtom);
    _$quotesAtom.reportObserved();
    return super.quotes;
  }

  @override
  set quotes(Quotes value) {
    _$quotesAtom.context.conditionallyRunInAction(() {
      super.quotes = value;
      _$quotesAtom.reportChanged();
    }, _$quotesAtom, name: '${_$quotesAtom.name}_set');
  }

  final _$errorMessageAtom = Atom(name: '_QuoteStore.errorMessage');

  @override
  String get errorMessage {
    _$errorMessageAtom.context.enforceReadPolicy(_$errorMessageAtom);
    _$errorMessageAtom.reportObserved();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.context.conditionallyRunInAction(() {
      super.errorMessage = value;
      _$errorMessageAtom.reportChanged();
    }, _$errorMessageAtom, name: '${_$errorMessageAtom.name}_set');
  }

  final _$getQuotesAsyncAction = AsyncAction('getQuotes');

  @override
  Future getQuotes() {
    return _$getQuotesAsyncAction.run(() => super.getQuotes());
  }
}
