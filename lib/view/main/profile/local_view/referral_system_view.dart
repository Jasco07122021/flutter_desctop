import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/const.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/model/network_model/system_data_model.dart';
import 'package:flutter_desctop/model/network_model/user_registration_model.dart';
import 'package:flutter_desctop/view/main/profile/local_view/history_qestion_view.dart';
import 'package:flutter_desctop/view/main/profile/local_widgets/bottom_sheet.dart';
import 'package:flutter_desctop/view/main/profile/local_widgets/color_box.dart';
import 'package:flutter_desctop/view/main/profile/local_widgets/procent_box.dart';
import 'package:flutter_desctop/viewModel/main/profile/referall_system_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums.dart';
import '../../../../core/style.dart';
import '../../../../core/widgets.dart';
import '../../../../model/network_model/tariff_list_model.dart';
import '../local_widgets/big_box_referall_system.dart';

class ReferallSystemView extends StatelessWidget {
  const ReferallSystemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: true,
    );
    UserRegister userRegister = userProvider.user!;
    SystemData systemData = userProvider.systemData!;
    Logger().i(userRegister.primaryReferral.toString());
    return ChangeNotifierProvider(
      create: (_) => ReferallSystemProvider(),
      builder: (context, _) => ReferallSystemViewChild(
        userRegister: userRegister,
        systemData: systemData,
      ),
    );
  }
}

class ReferallSystemViewChild extends StatelessWidget {
  final UserRegister userRegister;
  final SystemData systemData;

  const ReferallSystemViewChild({
    Key? key,
    required this.userRegister,
    required this.systemData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ReferallSystemProvider, bool>(
      selector: (_, bloc) => bloc.isLoading,
      builder: (context, state, _) => LoadingView(
        loading: state,
        child: Scaffold(
          body: Column(
            children: [
              const CustomTitleBarBox(),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "referral_header".tr(),
                              style: StyleTextCustom.setStyleByEnum(
                                StyleTextEnum.bodyHeaderText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          BigBoxReferallSystem(
                            userRegister: userRegister,
                            systemData: systemData,
                          ),
                          const SizedBox(height: 30),
                          CustomColorBox(
                            border: Colors.transparent,
                            color: Colors.white.withOpacity(0.05),
                            child: RichText(
                              text: TextSpan(
                                text:
                                    "share_the_promo_code_for_a_discount_with_your_friends_and_get".tr(),
                                style: const TextStyle(fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: userRegister
                                                .personalPromocodeOwnerBallEarn ==
                                            0
                                        ? "${systemData.promocodeOwnerBallEarn}"
                                        : "${userRegister.personalPromocodeOwnerBallEarn}",
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                   TextSpan(text: "points_for".tr()),
                                   TextSpan(
                                    text: "everyone".tr(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                   TextSpan(text: "invited_friend".tr())
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "referral_code_label".tr(),
                              style: StyleTextCustom.setStyleByEnum(
                                StyleTextEnum.bodyMiddleHeaderText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomColorBox(
                            border: Colors.transparent,
                            color: Colors.white.withOpacity(0.05),
                            child: Text("${userRegister.balance.toInt()}"),
                          ),
                          const SizedBox(height: 30),
                          Selector<ReferallSystemProvider, List<TariffItem>>(
                            builder: (context, state, _) => Column(
                              children: [
                                for (int i = 0; i < state.length; i++)
                                  PercentBox(tariffItem: state[i]),
                              ],
                            ),
                            selector: (_, bloc) => bloc.tariffBonuses,
                          ),
                          const SizedBox(height: 20),
                          Visibility(
                            visible: userRegister.primaryReferral,
                            child: CustomMaterialButton(
                              text: "withdrawals".tr(),
                              onPress: () {
                                final provider =
                                    context.read<ReferallSystemProvider>();
                                BottomSheetForQuestions(provider: provider)
                                    .addBottomSheet(context)
                                    .then(
                                  (value) {
                                    provider.clear();
                                  },
                                );
                              },
                              color: Colors.blue.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: userRegister.primaryReferral,
                            child: CustomMaterialButton(
                              text: "withdrawal_history".tr(),
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HistoryQuestionView(),
                                  ),
                                );
                              },
                              color: Colors.blue.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: mainColorBackground,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: CustomMaterialButton(
                        text: "referral_back".tr(),
                        onPress: () {
                          Navigator.pop(context, 0);
                        },
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
