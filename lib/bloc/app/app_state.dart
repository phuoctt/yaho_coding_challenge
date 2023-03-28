import 'package:flutter/material.dart';

class AppState  {
  final Brightness? theme;

  const AppState({this.theme});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AppState && o.theme == theme;
  }

  @override
  int get hashCode => theme.hashCode;
}
