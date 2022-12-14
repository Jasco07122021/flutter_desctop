import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/const.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/viewModel/main/main_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/widgets.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainProvider(),
      builder: (context, _) => const _MainView(),
    );
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {}
    super.onWindowClose();
  }
}

class _MainView extends StatelessWidget {
  const _MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger().i("token => ${localDB.getString(LocalDBEnum.token.name)}");
    Logger().i("deviceId => ${localDB.getString(LocalDBEnum.deviceId.name)}");
    return Scaffold(
      backgroundColor: mainColorBackground,
      body: Column(
        children: [
          const CustomTitleBarBox(),
          Expanded(
            child: Selector<MainProvider, int>(
              selector: (_, bloc) => bloc.index,
              builder: (context, state, _) {
                return PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: context.read<MainProvider>().pageController,
                  children: context.read<MainProvider>().listViews,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
