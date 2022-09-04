
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/view/main/home/local_views/server_view.dart';
import 'package:flutter_desctop/view/main/home/local_widgets/power_button.dart';
import 'package:flutter_desctop/view/main/home/local_widgets/speed_box.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/main/home/home_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      builder: (context, _) => const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<HomeProvider, bool>(
      selector: (_, bloc) => bloc.openServerView,
      builder: (context, openServerView, _) {
        return Navigator(
          pages: [
            MaterialPage(
              child: Padding(
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
                    const SizedBox(height: 60),
                    const SpeedBox(),
                    const Spacer(),
                    const PowerButton(),
                    const Spacer(),
                    _city(context),
                  ],
                ),
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

  MouseRegion _city(BuildContext context) {
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
                  color: state ? Colors.white : Colors.white.withOpacity(0.15)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage("assets/images/germany.png"),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Берлин",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text("Германия"),
                    ],
                  ),
                ),
                const Text(
                  "Поменять",
                  style: TextStyle(color: Colors.blue),
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
