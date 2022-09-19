import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/viewModel/main/main_provider.dart';
import 'package:provider/provider.dart';

import 'enums.dart';

class CustomTitleBarButtons extends StatelessWidget {
  final bool isCloseButton;

  const CustomTitleBarButtons({Key? key, required this.isCloseButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCloseButton
        ? CloseWindowButton(
            colors: WindowButtonColors(
              normal: Colors.transparent,
              mouseDown: Colors.white.withOpacity(0.2),
              iconNormal: Colors.white,
              mouseOver: Colors.white.withOpacity(0.2),
              iconMouseDown: Colors.white,
              iconMouseOver: Colors.white,
            ),
          )
        : MinimizeWindowButton(
            colors: WindowButtonColors(
              normal: Colors.transparent,
              mouseDown: Colors.white.withOpacity(0.2),
              iconNormal: Colors.white,
              mouseOver: Colors.white.withOpacity(0.2),
              iconMouseDown: Colors.white,
              iconMouseOver: Colors.white,
            ),
          );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          BottomNavBarItem(
            img: "assets/icons/bottomNav1.png",
            text: "Главная",
            index: 0,
          ),
          BottomNavBarItem(
            img: "assets/icons/bottomNav2.png",
            text: "Подписка",
            index: 1,
          ),
          BottomNavBarItem(
            img: "assets/icons/bottomNav3.png",
            text: "Профиль",
            index: 2,
          ),
        ],
      ),
    );
  }
}

class BottomNavBarItem extends StatelessWidget {
  final String img;
  final String text;
  final int index;

  const BottomNavBarItem({
    Key? key,
    required this.img,
    required this.text,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<MainProvider>().updateBottomNavBar(index),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (v) {
          context.read<MainProvider>().updateHoverBottomNavBarItem(index, true);
        },
        onExit: (v) {
          context
              .read<MainProvider>()
              .updateHoverBottomNavBarItem(index, false);
        },
        child: Consumer<MainProvider>(
          builder: (context, provider, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                img,
                color: provider.index == index
                    ? Colors.white.withOpacity(0.9)
                    : provider.bottomNavBarHover["index"] == index &&
                            provider.bottomNavBarHover["isHover"]
                        ? Colors.white.withOpacity(0.6)
                        : Colors.white.withOpacity(0.4),
                colorBlendMode: BlendMode.modulate,
                height: 25,
                width: 25,
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  color: provider.index == index
                      ? Colors.white
                      : provider.bottomNavBarHover["index"] == index &&
                              provider.bottomNavBarHover["isHover"]
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMaterialButton extends StatelessWidget {
  final String text;
  final Function()? onPress;
  final Color color;

  const CustomMaterialButton({
    Key? key,
    required this.text,
    required this.onPress,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      height: 55.0,
      minWidth: double.infinity,
      color: color,
      elevation: color == Colors.transparent ? 0 : 2,
      hoverElevation: color == Colors.transparent ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color:
              color == Colors.transparent ? Colors.white54 : Colors.transparent,
        ),
      ),
      child: Text(text),
    );
  }
}

class LoadingView extends StatelessWidget {
  final Widget child;
  final bool loading;

  const LoadingView({
    Key? key,
    required this.child,
    required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        loading
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10.0,
                  sigmaY: 10.0,
                ),
                child: Container(
                  color: Colors.transparent,
                  child: const Center(
                    child: LoaderBox(),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class LoaderBox extends StatelessWidget {
  const LoaderBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF181623),
        ),
        width: 100,
        height: 100,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Color(0xFFEFF3F8)),
      ),
    );
  }
}

class CustomTitleBarBox extends StatelessWidget {
  const CustomTitleBarBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        children: [
          Expanded(child: MoveWindow()),
          const CustomTitleBarButtons(isCloseButton: false),
          const CustomTitleBarButtons(isCloseButton: true),
        ],
      ),
    );
  }
}

class CustomBottomSheetHeaderWithCloseButton extends StatelessWidget {
  final String headerText;

  const CustomBottomSheetHeaderWithCloseButton({
    Key? key,
    required this.headerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Expanded(
          child: Text(
            headerText,
            style: StyleTextCustom.setStyleByEnum(
              StyleTextEnum.bottomSheetHeaderText,
            ),
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
    );
  }
}
