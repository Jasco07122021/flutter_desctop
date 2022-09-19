import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/const.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/viewModel/main/profile/profile_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/enums.dart';
import 'local_view/referral_system_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(context),
      builder: (context, _) => Builder(builder: (context) {
        context.read<ProfileProvider>().initState(context);
        return const _ProfileView();
      }),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileProvider, bool>(
      selector: (_, bloc) => bloc.loading,
      builder: (context, state, _) => LoadingView(
        loading: state,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Профиль",
                      style: StyleTextCustom.setStyleByEnum(
                        StyleTextEnum.bodyHeaderText,
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          "https://matreshkavpn.com/support".launchWeb();
                        },
                        child: const Icon(CupertinoIcons.question_circle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Image.asset(
                  "assets/images/profile_page_header.png",
                  height: 150,
                  width: 150,
                ),
                Row(),
                const SizedBox(height: 30),
                for (int i = 0; i < 3; i++)
                  Visibility(
                    visible: context.watch<UserProvider>().isLogged,
                    child: _boxField(
                      context.read<ProfileProvider>().updateList()[i],
                      context,
                    ),
                  ),
                const Spacer(),
                Visibility(
                  visible: context.watch<UserProvider>().isLogged,
                  child: CustomMaterialButton(
                    text: "Реферальная система",
                    onPress: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReferallSystemView(),
                        ),
                      );
                    },
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _boxField(
    Map<String, TextEditingController> json,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            json.keys.first,
            style: StyleTextCustom.setStyleByEnum(
              StyleTextEnum.bodyMiddleHeaderText,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: json.values.first,
            decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.05),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: mainColorBackground),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
