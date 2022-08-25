import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';

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
