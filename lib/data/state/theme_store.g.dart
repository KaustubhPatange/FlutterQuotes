// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ThemeStore on _ThemeStore, Store {
  final _$currentAtom = Atom(name: '_ThemeStore.current');

  @override
  AppTheme get current {
    _$currentAtom.context.enforceReadPolicy(_$currentAtom);
    _$currentAtom.reportObserved();
    return super.current;
  }

  @override
  set current(AppTheme value) {
    _$currentAtom.context.conditionallyRunInAction(() {
      super.current = value;
      _$currentAtom.reportChanged();
    }, _$currentAtom, name: '${_$currentAtom.name}_set');
  }

  final _$themeDataAtom = Atom(name: '_ThemeStore.themeData');

  @override
  ThemeData get themeData {
    _$themeDataAtom.context.enforceReadPolicy(_$themeDataAtom);
    _$themeDataAtom.reportObserved();
    return super.themeData;
  }

  @override
  set themeData(ThemeData value) {
    _$themeDataAtom.context.conditionallyRunInAction(() {
      super.themeData = value;
      _$themeDataAtom.reportChanged();
    }, _$themeDataAtom, name: '${_$themeDataAtom.name}_set');
  }
}
