import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class BottomSheetProfileView extends StatelessWidget {
  const BottomSheetProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 40, right: 20, left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Авторизация",
            style: StyleTextCustom.setStyleByEnum(
              StyleTextEnum.bottomSheetHeaderText,
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            "assets/images/profile_bottom_sheet_header.png",
            height: 150,
            width: 150,
          ),
          Transform.translate(
            offset: const Offset(0, -10),
            child: const Text(
              "Авторизация необходима, что бы\n сохранять информацию о ваших\n подписках",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          _bottomSheetButtons(
            FontAwesomeIcons.apple,
            "Продолжить с Apple",
            context,
          ),
          _bottomSheetButtons(
            FontAwesomeIcons.google,
            "Продолжить с Google",
            context,
          ),
          _bottomSheetButtons(
            FontAwesomeIcons.envelope,
            "Продолжить с Email",
            context,
          ),
        ],
      ),
    );
  }

  Padding _bottomSheetButtons(
    IconData icon,
    String name,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
        elevation: 0,
        onPressed: () {
          Navigator.pop(context,true);
          context.read<UserProvider>().setLogin = true;
        },
        height: 55.0,
        highlightColor: Colors.white,
        focusColor: Colors.yellow,
        hoverColor: Colors.grey.withOpacity(0.1),
        hoverElevation: 0,
        minWidth: double.infinity,
        color: Colors.grey.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color.fromRGBO(255, 255, 255, 0.18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 17),
            const SizedBox(width: 10),
            Text(name),
          ],
        ),
      ),
    );
  }
}
