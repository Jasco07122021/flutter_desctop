import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/view/splash/splash_view.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:provider/provider.dart';

import 'core/const.dart';

void main() {
  registerSingletons();
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(350, 720);
    const maxSize = Size(350, 720);
    win.maxSize = maxSize;
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: mainColorBackground,
          appBarTheme: AppBarTheme(
            backgroundColor: mainColorBackground,
            elevation: 0,
          ),
        ),
        home: Scaffold(
          body: WindowBorder(
            color: mainColorBackground,
            width: 1,
            child: const SplashView(),
          ),
        ),
      ),
    );
  }
}

void registerSingletons() {
  // Top level app controller
  // GetIt.I.registerLazySingleton<StyleTextCustom>(() => StyleTextCustom());
}

// StyleTextCustom get styleTextCustom => GetIt.I.get<StyleTextCustom>();
