import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/const.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/model/network_model/tariff_list_model.dart';
import 'package:flutter_desctop/view/main/profile/local_view/referral_system_view.dart';
import 'package:flutter_desctop/view/main/subscription/local_widgets/bottom_sheet.dart';
import 'package:flutter_desctop/viewModel/main/subscription/subscription_provider.dart';
import 'package:provider/provider.dart';

import '../../../../viewModel/main/main_provider.dart';

class PriceBox extends StatelessWidget {
  final TariffItem? tariffItem;

  const PriceBox({
    Key? key,
    required this.tariffItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            onTap: () {
              final isUser = context.read<SubscriptionProvider>().checkUser();
              if (isUser) {
                if (tariffItem != null) {
                  ChangeNotifierProvider.value(
                    value: SubscriptionProvider(false),
                    child: BottomSheetSubscriptionView(tariffItem: tariffItem!),
                  ).addBottomSheet(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReferallSystemView(),
                    ),
                  );
                }
              } else {
                context.read<MainProvider>().updateBottomNavBar(2);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: tariffItem == null ? Colors.teal : Colors.blue,
                width: 1.5,
              ),
            ),
            dense: tariffItem == null ? true : false,
            tileColor: tariffItem == null
                ? greenBoxBackgroundColor
                : const Color.fromRGBO(9, 152, 212, 0.1),
            leading: tariffItem == null
                ? const Icon(
                    Icons.favorite,
                    size: 18,
                  )
                : Image.asset(
                    "assets/icons/discount.png",
                    height: 20,
                    width: 20,
                  ),
            minLeadingWidth: 10,
            title: Text(
              tariffItem == null ? "Получить Бесплатно" : tariffItem!.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            trailing: Text(
              tariffItem == null ? "" : "${tariffItem!.enPrice}".priceDollar(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        if (tariffItem != null &&
            tariffItem!.discount != 0 &&
            tariffItem!.discount != null)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                "Скидка: ${tariffItem!.discount}%",
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
