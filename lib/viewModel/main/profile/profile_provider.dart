import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/view/main/profile/local_widgets/bottom_sheet.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../main_provider.dart';

class ProfileProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController planController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController pinCodeEmail = TextEditingController();

  List<Map<String, TextEditingController>> list = [];

  bool loading = false;
  String deviceId = localDB.getString(LocalDBEnum.deviceId.name)!;

  ProfileProvider(BuildContext context) {
    checkData(context);
  }

  checkData(BuildContext context) async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    String? token = localDB.getString(LocalDBEnum.token.name);
    if (token != null) {
      emailController.text = userProvider.user!.email;
      loading = true;
      notifyListeners();
      final result = await subscriptionApi.getSubscription();
      if (result != null) {
        DateTime time = DateTime.parse(result.expiredAt!);
        DateTime newTime = DateTime(time.year, time.month, time.day + 3);
        String newDate = DateFormat("dd.MM.yyyy").format(newTime);

        planController.text = result.name!;
        dateController.text = newDate;
      } else {
        DateTime time = DateTime.parse(userProvider.user!.createdAt);
        DateTime newTime = DateTime(time.year, time.month, time.day + 3);
        String newDate = DateFormat("dd.MM.yyyy").format(newTime);

        planController.text = "Пробный период";
        dateController.text = newDate;
      }
      loading = false;
      notifyListeners();
    }
  }

  void initState(BuildContext context) async {
    final provider = context.read<ProfileProvider>();
    String? token = localDB.getString(LocalDBEnum.token.name);
    if (token == null) {
      Future.delayed(Duration.zero, () {
        BottomSheetProfileView(provider: provider).addBottomSheet(context).then(
          (value) {
            context.read<MainProvider>().updateBottomNavBar(0);
          },
        );
      });
    }
  }

  Future checkEmail() async {
    Map<String, dynamic> body = {"email": emailController.text.trim()};
    var response = await authApi.emailConfirmation(body);
    return response;
  }

  Future checkEmailCode(String response) async {
    Map<String, dynamic> body = {
      "verificationId": response,
      "code": pinCodeEmail.text.trim()
    };
    return await authApi.emailConfirmation(body, true);
  }

  Future checkEmailCodeSubmit(String response) async {
    Map<String, dynamic> body = {
      "verificationId": response,
      "deviceId": deviceId,
    };
    return await authApi.email(body);
  }

  Future setUserToDB() async {
    String? token = localDB.getString(LocalDBEnum.token.name);
    if (token != null) {
      return await userApi.getUserMe(token);
    } else {
      return null;
    }
  }

  Future<bool?> setUserGoogleAuth(String? email, String? credentialsId) async {
    Logger().i(deviceId.toString());
    Logger().i("deviceId => ${localDB.getString(LocalDBEnum.deviceId.name)}");
    if (email != null && credentialsId != null) {
      Map<String, dynamic> body = {
        "credentials": credentialsId,
        "email": email,
        "deviceId": deviceId
      };
      final json = await authApi.google(body);
      if (json != null) {
        localDB.setString(LocalDBEnum.deviceId.name, deviceId);
        localDB.setString(LocalDBEnum.token.name, json["token"]);
        localDB.setString(LocalDBEnum.refreshToken.name, json["refreshToken"]);
        return true;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  List<Map<String, TextEditingController>> updateList() {
    list.addAll([
      {"Email": emailController},
      {"Текущий план": planController},
      {"Дата оконачния плана": dateController},
    ]);
    return list;
  }

  @override
  void dispose() {
    emailController.dispose();
    pinCodeEmail.dispose();
    dateController.dispose();
    planController.dispose();
    super.dispose();
  }
}
