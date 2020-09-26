import 'package:mobx/mobx.dart';
import 'package:quotes_app/data/model/quote.dart';
import 'package:quotes_app/data/quote_datasource.dart';
import 'package:quotes_app/data/repository/quote_repository.dart';

part 'quote_store.g.dart';

enum QuoteState { initial, loading, loaded, error }

class QuoteStore extends _QuoteStore with _$QuoteStore {
  QuoteStore(QuoteRepository quoteRepository) : super(quoteRepository);
}

abstract class _QuoteStore with Store {
  @observable
  ObservableFuture<Quotes> _quotesFuture;

  @observable
  Quotes quotes;

  @observable
  String errorMessage;

  @computed
  QuoteState get state {
    if (_quotesFuture == null ||
        _quotesFuture.status == FutureStatus.rejected) {
      return QuoteState.initial;
    }
    return _quotesFuture.status == FutureStatus.pending
        ? QuoteState.loading
        : QuoteState.loaded;
  }

  final QuoteRepository quoteRepository;

  _QuoteStore(this.quoteRepository);

  @action
  Future getQuotes() async {
    errorMessage = null;
    try {
      if (quoteRepository.isNextPage()) {
        quotes = await quoteRepository.fetchQuotes();
      } else {
        _quotesFuture = ObservableFuture(quoteRepository.fetchQuotes());
        quotes = await _quotesFuture;
      }
    } on InvalidPageException {
      // TODO: do something on no pages
    } on Error catch (ex) {
      errorMessage = ex.toString();
    }
  }
}
