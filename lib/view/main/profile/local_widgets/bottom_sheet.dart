import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/core/utils.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/view/main/profile/local_widgets/alert_dialog.dart';
import 'package:flutter_desctop/viewModel/main/profile/profile_provider.dart';
import 'package:flutter_desctop/viewModel/main/profile/referall_system_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
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
            "otp_subheader".tr(),
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
            child:  Text(
              "otp_subheader_description".tr(),
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          _bottomSheetButtons(
            FontAwesomeIcons.google,
            context,
            AuthType.Google,
            "otp_google".tr(),
          ),
          _bottomSheetButtons(
            FontAwesomeIcons.envelope,
            context,
            AuthType.Email,
            "otp_email".tr()
          ),
          _bottomSheetButtons(
            FontAwesomeIcons.qrcode,
            context,
            null,
            "otp_email".tr(),
          ),
        ],
      ),
    );
  }

  Padding _bottomSheetButtons(
    IconData icon,
    BuildContext context,
    AuthType? authType,
    String authName,
  ) {
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
            Text(authType == null
                ? "use_qr_code".tr()
                : "${"proceed_with".tr()}${authType.name}"),
          ],
        ),
      ),
    );
  }

  onPressMainBottomSheetButtons(BuildContext context, AuthType? authType) {
    if (authType == null) {
      showDialog(
        context: context,
        builder: (_) {
          return ChangeNotifierProvider.value(
            value: ProfileProvider(context, true),
            builder: (context, _) => Utils().showAlertDialogCustom(
              title: "authorization_using_a_qr_code".tr(),
              context: context,
              body: Selector<ProfileProvider, String?>(
                selector: (context, provider) => provider.getUserToken,
                builder: (context, value, child) {
                  if (value != null) {
                    localDB
                        .setString(LocalDBEnum.token.name, value)
                        .then((value) {
                      Navigator.pop(context, true);
                    });
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Selector<ProfileProvider, String?>(
                          selector: (context, provider) => provider.qrImage,
                          builder: (context, image, child) {
                            if (image != null) {
                              image.showCustomToast();
                              return OctoImage(
                                image: NetworkImage(
                                  "https://new.matreshkavpn.com/api/v1/auth/qr/image/$image",
                                ),
                                progressIndicatorBuilder: (context, progress) {
                                  return  Center(
                                    child: Text("loading...".tr()),
                                  );
                                },
                                errorBuilder: (context, error, stacktrace) =>
                                     Center(
                                  child: Text("sorry_didn't_load_image(".tr()),
                                ),
                                fit: BoxFit.cover,
                              );
                            }
                            return  Center(
                              child: Text("loading...".tr()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "if_you_have_previously_used_the_mobile".tr(),
                        style: StyleTextCustom.setStyleByEnum(
                          StyleTextEnum.bodySubTitleText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ).then((value) {
        if (value != null && value) {
          provider.setUserToDB().then((value) {
            if (value != null) {
              context.read<UserProvider>().setUser = value;
              context.read<UserProvider>().isLogged = true;
            }
            Navigator.pop(context);
          });
        }
      });
    } else if (authType == AuthType.Email) {
      return showDialog(
        context: context,
        builder: (_) {
          return ProfileAlertDialog(
            title: "enter_email".tr(),
            topContent:
                "a_confirmation_code_will_be_sent_to_the_specified_email_address".tr(),
            textFieldHintText: "example@mail.ru",
            controllerTextField: provider.emailController,
            onPress: () => onPressEmailAddress(context),
            bottomContent: "",
          );
        },
      );
    } else {
      return onPressGoogleAddress(context);
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
          title: "enter_code".tr(),
          topContent: "",
          textFieldHintText: "enter_code".tr(),
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
              "the_code_has_been_sent_to_the_specified_email_address".tr(),
        );
      },
    ).then((value) {
      if (value != null && value) {
        provider.setUserToDB().then((value) {
          if (value != null) {
            context.read<UserProvider>().setUser = value;
            context.read<UserProvider>().isLogged = true;
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
              context.read<UserProvider>().setUser = value;
              context.read<UserProvider>().isLogged = true;
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
           CustomBottomSheetHeaderWithCloseButton(
              headerText: "withdrawals".tr()),
          const SizedBox(height: 30),
          for (int i = 0; i < 3; i++)
            _fieldBox(
              provider.updateList(context.read<UserProvider>().user!.email)[i],
            ),
          const SizedBox(height: 20),
          CustomMaterialButton(
            text: "send_request".tr(),
            onPress: () async {
              double balance = context.read<UserProvider>().user!.balance;
              int balanceInt = balance.toInt();
              await provider.sendQuestion(balanceInt).then((value) {
                if (value != null) {
                  context.read<UserProvider>().setUser = value;
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
