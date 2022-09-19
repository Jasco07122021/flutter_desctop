import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/view/main/profile/local_widgets/alert_dialog.dart';
import 'package:flutter_desctop/viewModel/main/profile/profile_provider.dart';
import 'package:flutter_desctop/viewModel/main/profile/referall_system_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/const.dart';
import '../../../../core/enums.dart';

class BottomSheetProfileView extends StatelessWidget {
  final ProfileProvider provider;

  const BottomSheetProfileView({
    Key? key,
    required this.provider,
  }) : super(key: key);

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
            context,
            AuthType.Apple,
          ),
          _bottomSheetButtons(
            FontAwesomeIcons.google,
            context,
            AuthType.Google,
          ),
          _bottomSheetButtons(
            FontAwesomeIcons.envelope,
            context,
            AuthType.Email,
          ),
        ],
      ),
    );
  }

  Padding _bottomSheetButtons(IconData icon,
      BuildContext context,
      AuthType authType,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
        elevation: 0,
        onPressed: () => onPressMainBottomSheetButtons(context, authType),
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
            Text("Продолжить с ${authType.name}"),
          ],
        ),
      ),
    );
  }

  onPressMainBottomSheetButtons(BuildContext context, AuthType authType) {
    if (authType == AuthType.Email) {
      return showDialog(
        context: context,
        builder: (_) {
          return ProfileAlertDialog(
            title: "Введите Email",
            topContent:
            "На указанный адрес электронной почты будет отправлен код подтверждения",
            textFieldHintText: "example@mail.ru",
            controllerTextField: provider.emailController,
            onPress: () => onPressEmailAddress(context),
            bottomContent: "",
          );
        },
      );
    } else if (authType == AuthType.Google) {
      return onPressGoogleAddress(context);
    } else {
      return;
    }
  }

  Future onPressEmailAddress(BuildContext context) async {
    Navigator.pop(context);
    final response = await provider.checkEmail();
    if (response.runtimeType != String) return;
    showDialog(
      context: context,
      builder: (context) {
        return ProfileAlertDialog(
          title: "Введите Код",
          topContent: "",
          textFieldHintText: "Введите Код",
          controllerTextField: provider.pinCodeEmail,
          onPress: () async {
            provider.checkEmailCode(response).then(
                  (id) async {
                provider.checkEmailCodeSubmit(id).then(
                      (json) {
                    if (json == null) {
                      return;
                    }

                    localDB.setString(LocalDBEnum.token.name, json["token"]);
                    localDB.setString(
                      LocalDBEnum.refreshToken.name,
                      json["refreshToken"],
                    );
                    Navigator.pop(context, true);
                  },
                );
              },
            );
          },
          bottomContent:
          "Код был отправлен на указанный адрес электронный почты",
        );
      },
    ).then((value) {
      if (value != null && value) {
        provider.setUserToDB().then((value) {
          if (value != null) {
            context
                .read<UserProvider>()
                .setUser = value;
            context
                .read<UserProvider>()
                .isLogged = true;
          }
          Navigator.pop(context);
        });
      }
    });
  }

  Future onPressGoogleAddress(BuildContext context) async {
    final GoogleSignIn account = GoogleSignIn();
    try {
      await account.signOut();
      var googleSignIn = await account.signIn();
      String? email = googleSignIn?.email;
      String? credentialsId = googleSignIn?.id;
      Logger().i(email.toString());
      Logger().i(credentialsId.toString());
      await provider.setUserGoogleAuth(email, credentialsId).then((value) {
        if (value != null && value) {
          provider.setUserToDB().then((value) {
            if (value != null) {
              context
                  .read<UserProvider>()
                  .setUser = value;
              context
                  .read<UserProvider>()
                  .isLogged = true;
            }
            Navigator.pop(context);
          });
        }
      });
    } catch (e) {
      Logger().i("aa => $e");
    }
  }
}

class BottomSheetForQuestions extends StatelessWidget {
  final ReferallSystemProvider provider;

  const BottomSheetForQuestions({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 40, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomBottomSheetHeaderWithCloseButton(
              headerText: "Вывод средств"),
          const SizedBox(height: 30),
          for (int i = 0; i < 3; i++)
            _fieldBox(
              provider.updateList(context
                  .read<UserProvider>()
                  .user!
                  .email)[i],
            ),
          const SizedBox(height: 20),
          CustomMaterialButton(
            text: "Отвравить запрос",
            onPress: () async {
              double balance = context
                  .read<UserProvider>()
                  .user!
                  .balance;
              int balanceInt = balance.toInt();
              await provider.sendQuestion(balanceInt).then((value) {
                if (value != null) {
                  context
                      .read<UserProvider>()
                      .setUser = value;
                  Navigator.pop(context);
                } else {}
              });
            },
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Padding _fieldBox(Map<String, dynamic> value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.keys.first,
            style: StyleTextCustom.setStyleByEnum(
              StyleTextEnum.bodyMiddleHeaderText,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: value.values.first,
            decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.05),
              filled: true,
              hintText: value["hintText"],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: mainColorBackground),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
