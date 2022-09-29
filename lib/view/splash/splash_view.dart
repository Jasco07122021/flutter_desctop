import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/model/network_model/user_registration_model.dart';
import 'package:flutter_desctop/view/main/main_view.dart';
import 'package:flutter_desctop/viewModel/splash/splash_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../core/const.dart';

class CheckUserView extends StatelessWidget {
  const CheckUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashProvider(),
      builder: (context, _) => const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _a = false;

  @override
  void initState() {
    Timer(const Duration(milliseconds: 700), () {
      setState(() {
        _a = !_a;
      });
    });
    Timer(
      const Duration(milliseconds: 700),
      () async {
        context.read<SplashProvider>().checkSystemData().then((value) {
          if (value != null) {
            context.read<UserProvider>().setSystemData = value;
          }
        });
        context.read<SplashProvider>().checkUserAuth().then(
          (value) {
            if (value.runtimeType == UserRegister) {
              context.read<UserProvider>().setUser = value;
              context.read<UserProvider>().setLogin = true;
            } else if (value.runtimeType == String) {
              context.read<UserProvider>().setDevice = value;
              context.read<UserProvider>().setLogin = false;
            }
            Navigator.of(context).pushReplacement(
              SlideTransitionAnimation(const MainView()),
            );
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Logger().i("SplashView");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.fastLinearToSlowEaseIn,
            width: _a ? size.width : 0,
            height: size.height,
            color: mainColorBackground,
          ),
          Center(
            child: Image.asset(
              "assets/icons/logo.png",
              height: 35.0,
            ),
          ),
        ],
      ),
    );
  }
}

class SlideTransitionAnimation extends PageRouteBuilder {
  final Widget page;

  SlideTransitionAnimation(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
            );
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              child: page,
            );
          },
        );
}
