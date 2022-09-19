import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/const.dart';
import 'package:flutter_desctop/model/network_model/server_list_model.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../viewModel/main/home/home_provider.dart';

class PowerButton extends StatefulWidget {
  const PowerButton({Key? key}) : super(key: key);

  @override
  State<PowerButton> createState() => _PowerButtonState();
}

class _PowerButtonState extends State<PowerButton>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward()
          ..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (v) {
        context.read<HomeProvider>().updateHoverCityOrPowerButton(true, false);
      },
      onExit: (v) {
        context.read<HomeProvider>().updateHoverCityOrPowerButton(false, false);
      },
      child: Selector<HomeProvider, bool>(
        selector: (_, bloc) => bloc.isHoverPowerButton,
        builder: (context, state, _) {
          return AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Container(
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: const CircleBorder(),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0 * animationController.value),
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onTap: () async {
                final userProvider = context.read<UserProvider>();
                ServerItem? server = userProvider.server;
                if (server == null) {
                  return;
                }
                context.read<HomeProvider>().connection(
                      server,
                      userProvider.user == null
                          ? userProvider.deviceId!
                          : userProvider.user!.email,
                    );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mainColorBackground,
                  border: Border.all(
                    color:
                        state ? Colors.white : Colors.white.withOpacity(0.15),
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.power,
                  size: 30,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
