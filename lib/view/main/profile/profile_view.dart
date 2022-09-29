import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/const.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/view/splash/splash_view.dart';
import 'package:flutter_desctop/viewModel/main/profile/profile_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/enums.dart';
import 'local_view/qr_code_view.dart';
import 'local_view/referral_system_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(context),
      builder: (context, _) => Builder(builder: (context) {
        context.read<ProfileProvider>().initState(context);
        return const _ProfileView();
      }),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileProvider, String>(
      selector: (_, bloc) => bloc.navigateItem,
      builder: (context, state, _) => Navigator(
        pages: [
          const MaterialPage(child: _ProfileViewBody()),
          if (state == "QrCodeView") const MaterialPage(child: QrCodeView()),
        ],
        onPopPage: (route, result) {
          context.read<ProfileProvider>().updateNavigate("");
          return route.didPop(result);
        },
      ),
    );
  }
}

class _ProfileViewBody extends StatelessWidget {
  const _ProfileViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileProvider, bool>(
      selector: (_, bloc) => bloc.loading,
      builder: (context, state, _) => LoadingView(
        loading: state,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Профиль",
                      style: StyleTextCustom.setStyleByEnum(
                        StyleTextEnum.bodyHeaderText,
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          "https://matreshkavpn.com/support".launchWeb();
                        },
                        child: const Icon(CupertinoIcons.question_circle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Flexible(
                  child: Image.asset(
                    "assets/images/profile_page_header.png",
                  ),
                ),
                const SizedBox(height: 30),
                for (int i = 0; i < 3; i++)
                  Visibility(
                    visible: context.watch<UserProvider>().isLogged,
                    child: _boxField(
                      context.read<ProfileProvider>().updateList()[i],
                      context,
                    ),
                  ),
                const SizedBox(height: 20),
                Visibility(
                  visible: context.watch<UserProvider>().isLogged,
                  child: Wrap(
                    runSpacing: 15,
                    spacing: 10,
                    children: [
                      _boxColor(
                        color: Colors.blue,
                        index: 0,
                        text: "Сканировать QR код",
                        context: context,
                      ),
                      _boxColor(
                        color: Colors.yellow,
                        index: 1,
                        text: "Реферальная программа",
                        context: context,
                      ),
                      if (context.select(
                          (ProfileProvider bloc) => bloc.showCancellationBox))
                        _boxColor(
                          color: Colors.green,
                          index: 2,
                          text: "Отмена подписки",
                          context: context,
                        ),
                      _boxColor(
                        color: Colors.red,
                        index: 3,
                        text: "Удалить аккаунт",
                        context: context,
                      ),
                      _boxColor(
                        color: Colors.purple,
                        index: 4,
                        text: "Выйти\n",
                        context: context,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MouseRegion _boxColor({
    required Color color,
    required int index,
    required String text,
    required BuildContext context,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (v) {
        context.read<ProfileProvider>().updateHover(index);
      },
      onExit: (v) {
        context.read<ProfileProvider>().updateHover(0);
      },
      child: GestureDetector(
        onTap: () async {
          if(index == 0){
            context.read<ProfileProvider>().updateNavigate("QrCodeView");
            return;
          }
          if (index == 3) {
            await context.read<ProfileProvider>().deleteUser().then(
              (value) {
                if (value) {
                  context.read<UserProvider>().setUser = null;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CheckUserView(),
                    ),
                    (route) => false,
                  );
                }
              },
            );
          }
        },
        child: Selector<ProfileProvider, int>(
          selector: (_, bloc) => bloc.hoverBox,
          builder: (context, hoverBox, _) {
            bool isHover = hoverBox == index;
            return Container(
              height: 80,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                color: mainColorBackground,
                gradient: const LinearGradient(
                  transform: GradientRotation(pi / 2),
                  colors: [
                    Color.fromRGBO(152, 232, 168, 0.0001),
                    Color.fromRGBO(105, 204, 95, 0.0531305),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color,
                    offset: isHover
                        ? const Offset(-1, -1)
                        : const Offset(-0.5, -0.5),
                  ),
                  BoxShadow(
                    color: color,
                    offset:
                        isHover ? const Offset(1, -1) : const Offset(0.5, -0.5),
                  ),
                  BoxShadow(
                    color: mainColorBackground,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  color: color.withOpacity(0.009),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Image.asset(
                        "assets/icons/profile_view_${index}_icon.png",
                      ),
                    ),
                    const Spacer(),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _boxField(
    Map<String, TextEditingController> json,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            json.keys.first,
            style: StyleTextCustom.setStyleByEnum(
              StyleTextEnum.bodyMiddleHeaderText,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: json.values.first,
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white.withOpacity(0.05),
              filled: true,
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
