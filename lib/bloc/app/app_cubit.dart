import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/preference/local_preference.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final UserLocalStorage storage;

  AppCubit(this.storage) : super(AppState()) {
    onLoadSetting();
  }

  void onLoadSetting() {
    emit(AppState(theme: storage.theme));
  }

  void onUpdateTheme(Brightness theme) {
    storage.updateTheme(theme);
    emit(AppState(theme: theme));
  }
}
