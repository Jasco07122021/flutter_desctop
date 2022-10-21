import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/view/main/home/local_views/server_view.dart';
import 'package:flutter_desctop/view/main/home/local_widgets/power_button.dart';
import 'package:flutter_desctop/view/main/home/local_widgets/speed_box.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

import '../../../core/enums.dart';
import '../../../viewModel/main/home/home_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin<HomeView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      builder: (context, _) => const _HomeView(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _HomeView extends StatelessWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: true,
    );
    Logger().i("token => ${localDB.getString(LocalDBEnum.token.name)}");
    Logger().i("deviceId => ${localDB.getString(LocalDBEnum.deviceId.name)}");
    return Selector<HomeProvider, bool>(
      selector: (_, bloc) => bloc.openServerView,
      builder: (context, openServerView, _) {
        return Navigator(
          pages: [
            MaterialPage(
              child: Selector<HomeProvider, bool>(
                selector: (context, provider) => provider.isLoading,
                builder: (context, value, _) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/logo.png",
                              height: 27.0,
                            ),
                            const SizedBox(height: 20),
                            if (value)
                              const LinearProgressIndicator(
                                color: Colors.blue,
                                backgroundColor: Colors.yellow,
                              ),
                            const SizedBox(height: 5),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  String? url = context
                                      .read<UserProvider>()
                                      .systemData
                                      ?.bannerRedirect;
                                  if (url != null) {
                                    url.launchWeb();
                                  }
                                },
                                child: OctoImage(
                                  image: const NetworkImage(
                                    "https://new.matreshkavpn.com/api/v1/system/ad-image",
                                  ),
                                  progressIndicatorBuilder:
                                      (context, progress) {
                                    return const SizedBox.shrink();
                                  },
                                  errorBuilder: (context, error, stacktrace) =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            SpeedBox(userProvider: userProvider),
                            const Spacer(),
                            const PowerButton(),
                            const Spacer(),
                            _city(context, userProvider),
                          ],
                        ),
                      ),
                      if (value)
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.transparent,
                        ),
                    ],
                  );
                },
              ),
            ),
            if (openServerView) const MaterialPage(child: ServerView()),
          ],
          onPopPage: (route, result) {
            context.read<HomeProvider>().updateNavigator(false);
            return route.didPop(result);
          },
        );
      },
    );
  }

  MouseRegion _city(BuildContext context, UserProvider userProvider) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (v) {
        context.read<HomeProvider>().updateHoverCityOrPowerButton(true, true);
      },
      onExit: (v) {
        context.read<HomeProvider>().updateHoverCityOrPowerButton(false, true);
      },
      child: GestureDetector(
        onTap: () {
          context.read<HomeProvider>().updateNavigator(true);
        },
        child: Selector<HomeProvider, bool>(
          selector: (_, bloc) => bloc.isHoverCity,
          builder: (context, state, _) => AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: state ? Colors.white : Colors.white.withOpacity(0.15),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                if (userProvider.server != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      radius: 15,
                      child: SvgPicture.asset(
                        "assets/flags/${userProvider.server!.countryCode}.svg",
                      ),
                    ),
                  ),
                Visibility(
                  visible: userProvider.server == null,
                  child: const SizedBox(width: 40),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProvider.server != null
                            ? userProvider.server!.city
                            : "no".tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(userProvider.server != null
                          ? userProvider.server!.country
                          : "select_server_text".tr(),
                      )],
                  ),
                ),
                 Text(
                  "connect_select_server_right".tr(),
                  style: const TextStyle(color: Colors.blue),
                ),
                const Icon(
                  CupertinoIcons.right_chevron,
                  size: 16,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
