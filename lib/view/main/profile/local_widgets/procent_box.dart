import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/viewModel/main/profile/referall_system_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../core/const.dart';
import '../../../../model/network_model/tariff_list_model.dart';
import 'color_box.dart';

class PercentBox extends StatelessWidget {
  final TariffItem tariffItem;

  const PercentBox({
    Key? key,
    required this.tariffItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: true,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CustomColorBox(
        border: Colors.teal,
        color: greenBoxBackgroundColor,
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/icons/discount.png",
                  height: 15,
                  width: 15,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tariffItem.name,
                    style: GoogleFonts.varelaRound(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "${userProvider.user!.balance.toInt()}",
                  style: GoogleFonts.varelaRound(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "/",
                  style: GoogleFonts.varelaRound(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${tariffItem.ballCost}",
                  style: GoogleFonts.varelaRound(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            (userProvider.user!.balance / tariffItem.ballCost) < 0.5
                ? LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width - 70,
                    animation: true,
                    lineHeight: 10.0,
                    animationDuration: 1000,
                    percent: (userProvider.user!.balance / tariffItem.ballCost),
                    barRadius: const Radius.circular(50),
                    progressColor: const Color(0xFF00B593),
                    backgroundColor: Colors.black.withOpacity(0.3),
                  )
                : CustomMaterialButton(
                    text: 'Получить',
                    onPress: () {
                      context
                          .read<ReferallSystemProvider>()
                          .getBonus(tariffItem.id)
                          .then(
                        (value) {
                          if (value != null) {
                            context.read<UserProvider>().setUser = value;
                          }
                        },
                      );
                    },
                    color: Colors.teal,
                  ),
          ],
        ),
      ),
    );
  }
}
