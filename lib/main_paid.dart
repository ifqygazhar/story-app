import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/provider/locale_provider.dart';

import '../data/api/auth.dart';
import '../data/api/story.dart';

import '../presentation/screens/story/provider/location_provider.dart';
import '../presentation/router/app_router.dart';
import '../presentation/screens/auth/provider/auth_provider.dart';
import '../presentation/screens/home/provider/home_provider.dart';
import '../presentation/screens/story/provider/story_provider.dart';
import '../presentation/screens/story/provider/story_image_provider.dart';

import 'services/auth_service.dart';
import 'services/service.dart';
import 'utils/locale.dart';
import '../utils/flavor/flavor_config.dart';
import '../utils/flavor/flavor_mode_config.dart';

Future<void> main() async {
  FlavorConfig(flavor: FlavorType.paid);

  kFreeMode = false;
  kPaidMode = true;

  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  runApp(MyApp(prefs: sharedPreferences));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppService appService;
  late AuthService authService;
  late StreamSubscription<bool> authSubscription;

  final Dio _dio = Dio();

  @override
  void initState() {
    appService = AppService(widget.prefs);
    authService = AuthService();

    authSubscription = authService.onAuthStateChange.listen(onAuthStateChange);
    super.initState();
  }

  void onAuthStateChange(bool login) {
    appService.loginState = login;
  }

  @override
  void dispose() {
    super.dispose();
    authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(
          create: (_) => appService,
        ),
        Provider<AppRouter>(
          create: (_) => AppRouter(appService),
        ),
        Provider<AuthService>(create: (_) => authService),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            AuthApi(
              dio: _dio,
            ),
          ),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(
            StoryApi(dio: _dio),
          ),
        ),
        ChangeNotifierProvider<StoryProvider>(
          create: (_) => StoryProvider(
            StoryApi(dio: _dio),
          ),
        ),
        ChangeNotifierProvider<ImageStoryProvider>(
          create: (context) => ImageStoryProvider(),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (context) => LocationProvider(),
        ),
        ChangeNotifierProvider<LocalizationProvider>(
          create: (context) => LocalizationProvider(),
        ),
      ],
      child: Builder(builder: (context) {
        final localeProvider = Provider.of<LocalizationProvider>(context);
        final GoRouter router = Provider.of<AppRouter>(context).router;
        return MaterialApp.router(
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      }),
    );
  }
}
