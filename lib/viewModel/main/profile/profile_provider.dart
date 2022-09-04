
import 'package:flutter/material.dart';
import 'package:flutter_desctop/view/main/profile/local_widgets/bottom_sheet.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:provider/provider.dart';

import '../main_provider.dart';

class ProfileProvider extends ChangeNotifier {
  TextEditingController emailController =
      TextEditingController(text: "jasurbekmominov7@gmail.com");
  TextEditingController planController = TextEditingController(text: "Нет");
  TextEditingController dateController = TextEditingController(text: "Нет");

  List<Map<String, TextEditingController>> list = [];

  void initState(BuildContext context) {
    bool isLogged = context.select((UserProvider bloc) => bloc.isLogged);
    Future.delayed(
      Duration.zero,
      () {
        if (!isLogged) {
          showModalBottomSheet(
            backgroundColor: const Color(0xFF131A2E),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(35),
              ),
            ),
            context: context,
            isScrollControlled: true,
            barrierColor: Colors.black26,
            builder: (context) {
              return const BottomSheetProfileView();
            },
          ).then(
            (value) {
              context.read<MainProvider>().updateBottomNavBar(0);
            },
          );
        }
      },
    );
  }

  List<Map<String, TextEditingController>> updateList() {
    list.addAll([
      {"Email": emailController},
      {"Текущий план": planController},
      {"Дата оконачния плана": dateController},
    ]);
    return list;
  }
}
