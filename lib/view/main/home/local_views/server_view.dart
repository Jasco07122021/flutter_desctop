import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/model/network_model/server_list_model.dart';
import 'package:flutter_desctop/viewModel/main/home/server_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
    return Selector<ServerProvider, bool>(
      selector: (_, bloc) => bloc.isLoading,
      builder: (context, state, _) => LoadingView(
        loading: state,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Сервера"),
            centerTitle: true,
          ),
          body: Selector<ServerProvider, List<ServerItem>>(
            selector: (_, bloc) => bloc.servers,
            builder: (context, state, _) => ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: state.length,
              itemBuilder: (_, int index) {
                return _serverItem(context, state[index], index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding _serverItem(BuildContext context, ServerItem serverItem, int index) {
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
                  color:
                      isHover ? Colors.white : Colors.white.withOpacity(0.15),
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
                          context.read<UserProvider>().setServer = serverItem;
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
                  children: const [
                    Icon(
                      Icons.signal_cellular_alt,
                      size: 15,
                      color: Colors.green,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "120 мс",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
