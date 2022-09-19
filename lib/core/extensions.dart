import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

extension PriceRubl on String {
  String priceRuble() {
    return "${this}₽";
  }

  String priceDollar() {
    return "${this}\$";
  }

  void launchWeb() async {
    await canLaunch(this) ? await launch(this) : throw 'Could not lauch $this';
  }

  dynamic showCustomToast() {
    return showToast(
      this,
      backgroundColor: Colors.red,
      position: ToastPosition.top,
      margin: const EdgeInsets.only(top: 0),
      textPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
    );
  }
}

extension LoginProviderExtension on AuthType {
  String get key {
    switch (this) {
      case AuthType.Apple:
        return 'apple';
      case AuthType.Google:
        return 'google';
      case AuthType.Email:
        return 'email';
    }
  }

  String get authorizationEndpoint {
    switch (this) {
      case AuthType.Apple:
        return "";

      case AuthType.Google:
        return "https://accounts.google.com/o/oauth2/v2/auth";
        break;
      case AuthType.Email:
        return "";
    }
  }

  String get tokenEndpoint {
    switch (this) {
      case AuthType.Apple:
        return "";
      case AuthType.Google:
        return "https://oauth2.googleapis.com/token";
      case AuthType.Email:
        return "";
    }
  }

  String get clientId {
    switch (this) {
      case AuthType.Apple:
        return "";
      case AuthType.Google:
        return "703763335359-vi0ai78lu0d550evue3cf6jis55a9aj2.apps.googleusercontent.com";
      case AuthType.Email:
        return "";
    }
  }

  String? get clientSecret {
    switch (this) {
      case AuthType.Apple:
        return "";
      case AuthType.Google:
        return "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";
      case AuthType.Email:
        return "";
    }
  }

  List<String> get scopes {
    return ['openid', 'email'];
  }
}

extension CustomBottomSheetWidget on Widget {
  Future addBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: const Color(0xFF131A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35),
        ),
      ),
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black26,
      builder: (_) {
        return this;
      },
    );
  }
}
