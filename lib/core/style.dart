import 'package:flutter/material.dart';

enum StyleTextEnum {
  bodyHeaderText,
  bottomSheetHeaderText,
}

class StyleTextCustom {
  static TextStyle setStyleByEnum(StyleTextEnum styleCode) {
    switch (styleCode) {
      case StyleTextEnum.bottomSheetHeaderText:
        return const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        );
      case StyleTextEnum.bodyHeaderText:
        return const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        );
    }
  }
}
