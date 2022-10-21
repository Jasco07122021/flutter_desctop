import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';

import '../../../../core/const.dart';

class SpeedBox extends StatelessWidget {
  final UserProvider userProvider;

  const SpeedBox({Key? key, required this.userProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        SpeedBoxItem(
          header: "traffic_download".tr(),
          speed: "0 ГБ",
          color: Colors.red,
        ),
      const  SizedBox(width: 30),
        SpeedBoxItem(
          header: "traffic_upload".tr(),
          speed: "0 МБ",
          color: Colors.green,
        ),
      ],
    );
  }
}

class SpeedBoxItem extends StatelessWidget {
  final String header;
  final String speed;
  final Color color;

  const SpeedBoxItem({
    Key? key,
    required this.header,
    required this.speed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: mainColorBackground,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: color,
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
            BoxShadow(
              color: mainColorBackground,
              offset: const Offset(0, -5),
              blurRadius: 0.5,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              header,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Text(
                speed,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_compact_down,
              size: 40,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
