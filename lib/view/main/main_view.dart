import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as icons;
import 'package:flutter_desctop/view/main/home/home_view.dart';
import 'package:flutter_desctop/view/main/profile/profile_view.dart';
import 'package:flutter_desctop/view/main/setting/setting_view.dart';
import 'package:window_manager/window_manager.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with WindowListener {
  int index = 0;
  final viewKey = GlobalKey();

  List<Widget> listViews = const [
    HomeView(),
    ProfileView(),
    SettingView(),
  ];

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
    return NavigationView(
      key: viewKey,
      pane: NavigationPane(
        selected: index,
        onChanged: (v) {
          setState(() => index = v);
        },
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text("Home"),
          ),
          PaneItem(
            icon: const Icon(icons.FluentIcons.person_16_regular),
            title: const Text("Profile"),
          ),
          PaneItem(
            icon: const Icon(icons.FluentIcons.settings_16_filled),
            title: const Text("Setting"),
          ),
        ],
        displayMode: PaneDisplayMode.compact,
      ),
      content: NavigationBody.builder(
        index: index,
        itemBuilder: (context, index) {
          return listViews[index];
        },
      ),
    );
  }

  @override
  void onWindowClose() async{
     bool _isPreventClose = await windowManager.isPreventClose();
     if(_isPreventClose){

     }
    super.onWindowClose();
  }
}
