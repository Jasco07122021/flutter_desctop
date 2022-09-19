import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'const.dart';
import 'enums.dart';

class StyleTextCustom {
  static TextStyle setStyleByEnum(StyleTextEnum styleCode) {
    switch (styleCode) {
      case StyleTextEnum.bottomSheetHeaderText:
        return const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        );
      case StyleTextEnum.bodyHeaderText:
        return  GoogleFonts.varelaRound(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        );
      case StyleTextEnum.bottomSheetHeaderText2:
        return const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
        );
      case StyleTextEnum.bottomSheetBodyText:
        return const TextStyle(color: Colors.grey);
      case StyleTextEnum.bodyMiddleHeaderText:
        return const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        );
      case StyleTextEnum.bodyMiddleBodyText:
        return  GoogleFonts.varelaRound(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );
    }
  }
}

class StyleTextField {
  static InputDecoration setStyleByTextField(String hintText) {
    return InputDecoration(
      hintText: hintText,
      fillColor: Colors.white.withOpacity(0.05),
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: mainColorBackground),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 10,
      ),
      isDense: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }
}
