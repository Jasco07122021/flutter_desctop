import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/data/repository/auth_api_repository.dart';
import 'package:flutter_desctop/data/repository/billing_api_repository.dart';
import 'package:flutter_desctop/data/repository/qrCode_api_repository.dart';
import 'package:flutter_desctop/data/repository/server_api_repository.dart';
import 'package:flutter_desctop/data/repository/subscription_api_repository.dart';
import 'package:flutter_desctop/data/repository/system_api_repository.dart';
import 'package:flutter_desctop/data/repository/tariff_api_repository.dart';
import 'package:flutter_desctop/data/repository/user_api_repository.dart';

import 'package:flutter_desctop/view/splash/splash_view.dart';
import 'package:flutter_desctop/viewModel/user_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/const.dart';
import 'data/api.dart';

import 'package:oktoast/oktoast.dart';

import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await registerSingletons();
  await GoogleSignInDart.register(clientId: AuthType.Google.clientId);

  String? locale = localDB.getString(LocalDBEnum.locale.name);
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale("zh", 'CN'),
        Locale("ru", 'RU'),
        Locale("en", 'US'),
      ],
      path: 'assets/languages',
      fallbackLocale: locale == null || locale == "en"
          ? const Locale('en', 'US')
          : locale == "ru"
              ? const Locale("ru", 'RU')
              : const Locale("zh", 'CN'),
      child: const MyApp(),
    ),
  );
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: OKToast(
        child: MaterialApp(
          useInheritedMediaQuery: true,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
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
              child: const CheckUserView(),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> registerSingletons() async {
  // Top level app controller
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(sharedPref);

  GetIt.I.registerLazySingleton<Session>(() => Session());
  GetIt.I.registerLazySingleton<AuthApiRepository>(() => AuthApiRepository());
  GetIt.I.registerLazySingleton<BillingApiRepository>(
      () => BillingApiRepository());
  GetIt.I
      .registerLazySingleton<ServerApiRepository>(() => ServerApiRepository());
  GetIt.I.registerLazySingleton<SubscriptionApiRepository>(
      () => SubscriptionApiRepository());
  GetIt.I
      .registerLazySingleton<SystemApiRepository>(() => SystemApiRepository());
  GetIt.I
      .registerLazySingleton<TariffApiRepository>(() => TariffApiRepository());
  GetIt.I.registerLazySingleton<UserApiRepository>(() => UserApiRepository());
  GetIt.I
      .registerLazySingleton<QrCodeApiRepository>(() => QrCodeApiRepository());
  Logger().i("registerSingletons");
}

Session get sessionApi => GetIt.I.get<Session>();

AuthApiRepository get authApi => GetIt.I.get<AuthApiRepository>();

BillingApiRepository get billingApi => GetIt.I.get<BillingApiRepository>();

QrCodeApiRepository get qrCodeApi => GetIt.I.get<QrCodeApiRepository>();

ServerApiRepository get serverApi => GetIt.I.get<ServerApiRepository>();

SubscriptionApiRepository get subscriptionApi =>
    GetIt.I.get<SubscriptionApiRepository>();

SystemApiRepository get systemApi => GetIt.I.get<SystemApiRepository>();

TariffApiRepository get tariffApi => GetIt.I.get<TariffApiRepository>();

UserApiRepository get userApi => GetIt.I.get<UserApiRepository>();

SharedPreferences get localDB => GetIt.I.get<SharedPreferences>();
