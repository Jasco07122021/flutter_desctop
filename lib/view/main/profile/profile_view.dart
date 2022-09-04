import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/const.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/viewModel/main/profile/profile_provider.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      builder: (context, _) {
        return Builder(builder: (context) {
          log("init");
          Provider.of<ProfileProvider>(context).initState(context);
          return const _ProfileView();
        });
      },
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Профиль",
                style: StyleTextCustom.setStyleByEnum(
                  StyleTextEnum.bodyHeaderText,
                ),
              ),
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
              context.watch<UserProvider>().isLogged
                  ? _boxField(context.read<ProfileProvider>().updateList()[i])
                  : const SizedBox.shrink(),
            const Spacer(),
            MaterialButton(
              height: 55.0,
              minWidth: double.infinity,
              onPressed: () {},
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Авторизоваться"),
            ),
          ],
        ),
      ),
    );
  }

  _boxField(Map<String, TextEditingController> json) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            json.keys.first,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
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
