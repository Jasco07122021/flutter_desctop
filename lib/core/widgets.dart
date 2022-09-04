import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/viewModel/main/main_provider.dart';
import 'package:provider/provider.dart';

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
