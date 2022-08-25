import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_desctop/view/main/main_view.dart';
import 'package:window_manager/window_manager.dart';

import 'core/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle("Danil & Jasco");
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setBackgroundColor(Colors.transparent);
    await windowManager.setSize(const Size(670, 560));
    await windowManager.setMinimumSize(const Size(670, 560));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: mainColorBackground,
        navigationPaneTheme: NavigationPaneThemeData(
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: navigationViewBackground,
          iconPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        ),
      ),
      home: const MainView(),
    );
  }
}
