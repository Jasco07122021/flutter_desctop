import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/const.dart';
import '../../../../core/enums.dart';
import '../../../../core/style.dart';
import '../../../../core/widgets.dart';

class ProfileAlertDialog extends StatelessWidget {
  final String title;
  final String topContent;
  final String textFieldHintText;
  final TextEditingController controllerTextField;
  final Function()? onPress;
  final String bottomContent;

  const ProfileAlertDialog({
    Key? key,
    required this.title,
    required this.topContent,
    required this.textFieldHintText,
    required this.controllerTextField,
    required this.onPress,
    required this.bottomContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topContent.isNotEmpty)
            Text(
              topContent,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 25),
          TextField(
            controller: controllerTextField,
            decoration: StyleTextField.setStyleByTextField(textFieldHintText),
          ),
          const SizedBox(height: 20),
          CustomMaterialButton(
            text: "proceed".tr(),
            onPress: onPress,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          if (bottomContent.isNotEmpty)
            Text(
              bottomContent,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
