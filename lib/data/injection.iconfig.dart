// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:quotes_app/data/quote_datasource.dart';
import 'package:quotes_app/data/repository/quote_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void $initGetIt({String environment}) {
  getIt
    ..registerFactory<QuoteDatasource>(() => QuoteDatasource())
    ..registerFactory<DevQuoteRepository>(() => DevQuoteRepository())
    ..registerFactory<ProdQuoteRepository>(() => ProdQuoteRepository());
  if (environment == 'dev') {
    _registerDevDependencies();
  }
  if (environment == 'prod') {
    _registerProdDependencies();
  }
}

void _registerDevDependencies() {
  getIt..registerFactory<QuoteRepository>(() => DevQuoteRepository());
}

void _registerProdDependencies() {
  getIt..registerFactory<QuoteRepository>(() => ProdQuoteRepository());
}
