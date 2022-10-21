import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/style.dart';

import 'const.dart';
import 'enums.dart';

class Utils {
  showAlertDialogCustom({
    required String title,
    required BuildContext context,
    required Widget body,
  })  {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      contentPadding: const EdgeInsets.all(15.0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: mainColorBackground,
      contentTextStyle: StyleTextCustom.setStyleByEnum(
        StyleTextEnum.bottomSheetBodyText,
      ),
      titleTextStyle: StyleTextCustom.setStyleByEnum(
        StyleTextEnum.bottomSheetHeaderText2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.withOpacity(0.2),
                child: const Icon(
                  Icons.close,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      content: body,
    );
  }
}
