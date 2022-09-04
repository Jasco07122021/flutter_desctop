import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/viewModel/main/home/server_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Сервера"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                context.read<ServerProvider>().updateSwitch(true, true);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.18),
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 5, right: 15),
              minVerticalPadding: 10,
              leading: Transform.scale(
                scale: 0.8,
                child: Selector<ServerProvider, bool>(
                  selector: (_, bloc) => bloc.switcherServer,
                  builder: (context, state, _) {
                    return CupertinoSwitch(
                        value: state,
                        onChanged: (v) {
                          context.read<ServerProvider>().updateSwitch(v);
                        });
                  },
                ),
              ),
              title: Row(
                children: [
                  const CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage("assets/images/germany.png"),
                  ),
                  const SizedBox(width: 10),
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
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
