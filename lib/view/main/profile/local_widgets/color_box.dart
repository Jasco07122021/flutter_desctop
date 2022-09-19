import 'package:flutter/material.dart';

class CustomColorBox extends StatelessWidget {
  final Widget child;
  final Color border;
  final Color color;

  const CustomColorBox({
    Key? key,
    required this.child,
    required this.border,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: border,
          width: 2,
        ),
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: child,
    );
  }
}
