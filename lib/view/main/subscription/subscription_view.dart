import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/model/network_model/tariff_list_model.dart';
import 'package:flutter_desctop/view/main/subscription/local_widgets/price_box.dart';
import 'package:flutter_desctop/view/main/subscription/local_widgets/title_with_subtitle_box.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/main/subscription/subscription_provider.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubscriptionProvider(true),
      builder: (context, _) => const _SubscriptionView(),
    );
  }
}

class _SubscriptionView extends StatelessWidget {
  const _SubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SubscriptionProvider, bool>(
      selector: (_, bloc) => bloc.isLoading,
      builder: (context, state, _) => LoadingView(
        loading: state,
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/subscription_page_header.png",
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 15),
                 TitleWithSubTitleBox(
                  title: "sub_info_1_header".tr(),
                  subTitle: "sub_info_1_description".tr(),
                  icon: "assets/icons/shield.png",
                ),
                const SizedBox(height: 15),
                 TitleWithSubTitleBox(
                  title: "sub_info_3_header".tr(),
                  subTitle: "sub_info_3_description".tr(),
                  icon: "assets/icons/flash.png",
                ),
                const SizedBox(height: 15),
                 TitleWithSubTitleBox(
                  title: "sub_info_2_header".tr(),
                  subTitle: "sub_info_3_description".tr(),
                  icon: "assets/icons/flash.png",
                ),
                const SizedBox(height: 15),
                const PriceBox(tariffItem: null),
                Selector<SubscriptionProvider, List<TariffItem>>(
                    builder: (context, state, _) {
                      return Column(
                        children:
                            state.map((e) => PriceBox(tariffItem: e)).toList(),
                      );
                    },
                    selector: (_, bloc) => bloc.tariffs),
                _bottomTextButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _bottomTextButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _bottomTextButtonItem("sub_oferta".tr()),
        _bottomTextButtonItem("sub_conf".tr()),
      ],
    );
  }

  MouseRegion _bottomTextButtonItem(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
