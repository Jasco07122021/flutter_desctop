import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/view/main/profile/local_widgets/bottom_sheet.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../main_provider.dart';

class ProfileProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController planController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController pinCodeEmail = TextEditingController();

  StompClient? stompClient;
  Timer? timer;

  String? getUserToken;

  List<Map<String, TextEditingController>> list = [];
  int hoverBox = 0;
  bool showCancellationBox = false;

  String navigateItem = "";
  String? qrImage;

  bool loading = false;
  bool loadingQrCode = false;
  String deviceId = localDB.getString(LocalDBEnum.deviceId.name)!;

  ProfileProvider(BuildContext context, bool isUpdate) {
    if (isUpdate) {
      openQrCode(context);
    } else {
      checkData(context);
    }
  }

  openQrCode(BuildContext context) async {
    String id = localDB.getString(LocalDBEnum.deviceId.name) ?? "";
    loadingQrCode = true;
    notifyListeners();
    final response = await qrCodeApi.qrStart({"id": id});
    if (response != null) {
      qrImage = response["id"];
      notifyListeners();
    }
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://new.matreshkavpn.com/ws',
        onConnect: onConnected,
        onWebSocketError: (e) => Logger().e(e.toString()),
        onStompError: (d) => Logger().e('error stomp'),
        onDisconnect: (f) => Logger().w('disconnected'),
      ),
    );
    stompClient!.activate();
    loadingQrCode = false;
    notifyListeners();
    Logger().i(response.toString());
  }

  void onConnected(StompFrame frame) {
    Logger().i(qrImage.toString());
    stompClient!.subscribe(
      destination: '/topic/qrauth/response/$qrImage',
      callback: (frame) {
        if (frame.body != null) {
          final token = json.decode(frame.body!)["token"];
          print(frame.body.toString());
          getUserToken = token;
          if (timer != null) {
            timer!.cancel();
          }
          notifyListeners();
        }
        Logger().i("response");
      },
    );

    timer = Timer.periodic(const Duration(seconds: 10), (_) {
      stompClient!.send(
        destination: '/topic/qrauth/response/$qrImage',
      );
      if (getUserToken != null) {
        timer!.cancel();
      }
    });
  }

  void checkData(BuildContext context) async {
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
        showCancellationBox = true;
        notifyListeners();

        DateTime time = DateTime.parse(result.expiredAt!);
        DateTime newTime = DateTime(time.year, time.month, time.day + 3);
        String newDate = DateFormat("dd.MM.yyyy").format(newTime);

        planController.text = result.name ?? "";
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
        await localDB.setString(LocalDBEnum.deviceId.name, deviceId);
        await localDB.setString(LocalDBEnum.token.name, json["token"]);
        await localDB.setString(
            LocalDBEnum.refreshToken.name, json["refreshToken"]);
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
      {"profile_email_label": emailController},
      {"profile_plan_label": planController},
      {"profile_plan_date_label": dateController},
    ]);
    return list;
  }

  void updateHover(int index) {
    if (hoverBox != index) {
      hoverBox = index;
      notifyListeners();
    }
  }

  void updateNavigate(String data) {
    navigateItem = data;
    notifyListeners();
  }

  Future<bool> deleteUser() async {
    loading = true;
    notifyListeners();
    final token = localDB.getString(LocalDBEnum.token.name);
    if (token != null) {
      final response = await userApi.deleteUser(token);
      if (response) {
        await localDB.clear();
      }
      loading = false;
      notifyListeners();
      return response;
    }
    loading = false;
    notifyListeners();
    return false;
  }

  @override
  void dispose() {
    emailController.dispose();
    pinCodeEmail.dispose();
    dateController.dispose();
    planController.dispose();
    if (timer != null) timer!.cancel();
    if (stompClient != null) stompClient!.deactivate();
    super.dispose();
  }
}
