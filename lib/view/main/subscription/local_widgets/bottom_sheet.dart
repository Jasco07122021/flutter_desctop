import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/model/local_model/bank_card_model.dart';
import 'package:flutter_desctop/model/network_model/tariff_list_model.dart';
import 'package:flutter_desctop/viewModel/main/subscription/subscription_provider.dart';
import 'package:provider/provider.dart';

import '../../../../viewModel/user_provider.dart';

class BottomSheetSubscriptionView extends StatelessWidget {
  final TariffItem tariffItem;

  const BottomSheetSubscriptionView({Key? key, required this.tariffItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 40, right: 20, left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBottomSheetHeaderWithCloseButton(
            headerText: tariffItem.name.tr() + " premium".tr(),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text("select_plan_price_title".tr()),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ColoredBox(
                  color: Colors.grey.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    child: Text(
                      "${tariffItem.enPrice}".priceDollar(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (BankCard bankCard in listBankCard)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (v) {
                  context.read<SubscriptionProvider>().updateHover(true);
                },
                onExit: (v) {
                  context.read<SubscriptionProvider>().updateHover(false);
                },
                child: Selector<SubscriptionProvider, bool>(
                  selector: (_, bloc) => bloc.isHover,
                  builder: (context, isHover, _) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: isHover
                            ? Colors.white
                            : Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        UserProvider userProvider = Provider.of<UserProvider>(
                          context,
                          listen: false,
                        );
                        String email = userProvider.user!.email;
                        context.read<SubscriptionProvider>().clickBankCard(
                              email,
                              tariffItem.id,
                            );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: bankCard.color,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(bankCard.img),
                      ),
                      hoverColor: Colors.transparent,
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(
                        bankCard.title.tr(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(bankCard.subtitle.tr()),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 130),
          Selector<SubscriptionProvider, TextEditingController>(
            selector: (_, bloc) => bloc.promoCodeController,
            builder: (context, state, _) => TextField(
              controller: state,
              decoration:
                  StyleTextField.setStyleByTextField("enter_promo_code".tr()),
            ),
          ),
        ],
      ),
    );
  }
}
