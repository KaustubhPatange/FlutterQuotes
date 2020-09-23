import 'package:injectable/injectable.dart';
import 'package:quotes_app/data/injection.iconfig.dart';

@injectableInit
void configureInjection(String environment) =>
    $initGetIt(environment: environment);

abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}
