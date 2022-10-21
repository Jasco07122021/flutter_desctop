import 'package:dart_ping/dart_ping.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/model/network_model/server_list_model.dart';
import 'package:flutter_desctop/viewModel/main/home/server_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ServerView extends StatelessWidget {
  const ServerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServerProvider(),
      builder: (context, _) => const _ServerView(),
    );
  }
}

class _ServerView extends StatelessWidget {
  const _ServerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("servers_header".tr()),
        centerTitle: true,
      ),
      body: Selector<ServerProvider, bool>(
        selector: (context, provider) => provider.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [for (int i = 0; i < 10; i++) _shimmerItem()],
              ),
            );
          }
          return Selector<ServerProvider, List<ServerItem>>(
            selector: (_, bloc) => bloc.servers,
            builder: (context, state, _) => SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  for (int i = 0; i < state.length; i++)
                    _serverItem(context, state[i], i)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Shimmer _shimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 48.0,
              height: 48.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  Container(
                    width: 100,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  StreamBuilder _serverItem(
    BuildContext context,
    ServerItem serverItem,
    int index,
  ) {
    return StreamBuilder<PingData>(
        stream: Ping(serverItem.address).stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _shimmerItem();
          }
          if (snapshot.hasError) {
            return ListTile(
              title: Text(snapshot.error.toString()),
            );
          }
          int? ping = snapshot.data!.response?.time?.inMilliseconds;
          Logger().i(serverItem.address.toString());
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (v) {
                context.read<ServerProvider>().updateHover(index);
              },
              onExit: (v) {
                context.read<ServerProvider>().updateHover(-1);
              },
              child: Consumer<ServerProvider>(
                builder: (context, provider, _) {
                  bool isHover = provider.hoverIndex == index;
                  return AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isHover
                            ? Colors.white
                            : Colors.white.withOpacity(0.15),
                      ),
                    ),
                    duration: const Duration(milliseconds: 500),
                    child: ListTile(
                      onTap: () {
                        if (context.read<UserProvider>().server?.id !=
                            serverItem.id) {
                          context.read<UserProvider>().setServer = serverItem;
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      hoverColor: Colors.transparent,
                      contentPadding: const EdgeInsets.only(left: 5, right: 15),
                      minVerticalPadding: 10,
                      leading: Transform.scale(
                        scale: 0.8,
                        child: Selector<UserProvider, String?>(
                          selector: (_, bloc) => bloc.server?.id,
                          builder: (context, state, _) => CupertinoSwitch(
                            value: state == serverItem.id,
                            onChanged: (v) {
                              if (state != serverItem.id) {
                                context.read<UserProvider>().setServer =
                                    serverItem;
                              }
                            },
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            child: SvgPicture.asset(
                              "assets/flags/${serverItem.countryCode}.svg",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  serverItem.city,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(serverItem.country),
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            ping != null
                                ? (ping < 40
                                    ? Icons.signal_cellular_alt_outlined
                                    : (ping > 40 && ping < 100)
                                        ? Icons.signal_cellular_alt_2_bar
                                        : Icons.signal_cellular_alt)
                                : Icons
                                    .signal_cellular_connected_no_internet_0_bar,
                            size: 15,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${ping ?? 0} server_tick",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
