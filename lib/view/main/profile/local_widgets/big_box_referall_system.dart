import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/const.dart';
import '../../../../core/enums.dart';
import '../../../../core/style.dart';
import '../../../../model/network_model/system_data_model.dart';
import '../../../../model/network_model/user_registration_model.dart';

class BigBoxReferallSystem extends StatelessWidget {
  final UserRegister userRegister;
  final SystemData systemData;

  const BigBoxReferallSystem({
    Key? key,
    required this.userRegister,
    required this.systemData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.blue.shade200,
            const Color(0xFF3813bd),
          ],
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: mainColorBackground,
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.center,
            colors: [
              const Color(0xFF1c294d),
              mainColorBackground,
            ],
          ),
        ),
        padding: const EdgeInsets.only(
          top: 15,
          left: 20,
          right: 20,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "discount".tr(),
                  style: StyleTextCustom.setStyleByEnum(
                    StyleTextEnum.bottomSheetBodyText,
                  ),
                ),
                Text(
                  userRegister.personalPromocodeDiscount == 0
                      ? "${systemData.discount}%"
                      : "30%",
                  style: GoogleFonts.varelaRound(
                    fontSize: 40,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "by_pomocode".tr(),
                  style: StyleTextCustom.setStyleByEnum(
                    StyleTextEnum.bottomSheetBodyText,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF05021c),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Text(userRegister.promocode),
                      const SizedBox(width: 10),
                      MouseRegion(
                        onEnter: (v) {},
                        onExit: (v) {},
                        cursor: SystemMouseCursors.click,
                        child: Image.asset(
                          "assets/icons/copy.png",
                          height: 17,
                          width: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
