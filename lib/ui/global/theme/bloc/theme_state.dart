part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;
  final AppTheme theme;

  ThemeState({@required this.themeData, @required this.theme});

  @override
  List<Object> get props => [themeData, theme];
}
