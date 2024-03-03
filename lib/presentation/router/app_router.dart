import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/story/camera_screen.dart';
import '../../presentation/screens/story/detail_screen.dart';
import '../../presentation/screens/story/map_screen.dart';
import '../../presentation/screens/story/upload_screen.dart';
import '../../presentation/screens/splash/splash.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/onboard/onboard_screen.dart';

import '../../services/service.dart';

import '../../utils/router.dart';

class AppRouter {
  AppService appService;

  AppRouter(this.appService);

  get router => _router;

  late final _router = GoRouter(
    refreshListenable: appService,
    initialLocation: APP_PAGE.home.toPath,
    routerNeglect: true,
    routes: [
      GoRoute(
        path: APP_PAGE.splash.toPath,
        name: APP_PAGE.splash.toName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: APP_PAGE.onBoarding.toPath,
        name: APP_PAGE.onBoarding.toName,
        builder: (context, state) => const OnboardScreen(),
      ),
      GoRoute(
        path: APP_PAGE.register.toPath,
        name: APP_PAGE.register.toName,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(seconds: 3),
            key: state.pageKey,
            child: const RegisterScreen(),
            transitionsBuilder:
                ((context, animation, secondaryAnimation, child) {
              return FadeTransition(
                key: state.pageKey,
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            }),
          );
        },
      ),
      GoRoute(
        path: APP_PAGE.login.toPath,
        name: APP_PAGE.login.toName,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(seconds: 3),
            key: state.pageKey,
            child: const LoginScreen(),
            transitionsBuilder:
                ((context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            }),
          );
        },
      ),
      GoRoute(
        path: APP_PAGE.home.toPath,
        name: APP_PAGE.home.toName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: ((context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          }),
        ),
        routes: [
          GoRoute(
            path: "detail/:id",
            name: "DETAIL",
            pageBuilder: (context, state) {
              String id = state.pathParameters["id"] ?? "no id";
              return CustomTransitionPage(
                key: state.pageKey,
                child: DetailScreen(id: id),
                transitionsBuilder:
                    ((context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                }),
              );
            },
          ),
          GoRoute(
            path: APP_PAGE.upload.toPath,
            name: APP_PAGE.upload.toName,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const UploadScreen(),
                transitionsBuilder:
                    ((context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                }),
              );
            },
            routes: [
              GoRoute(
                path: APP_PAGE.camera.toPath,
                name: APP_PAGE.camera.toName,
                builder: (context, state) {
                  return CameraScreen(
                    cameras: state.extra! as List<CameraDescription>,
                  );
                },
              ),
              GoRoute(
                path: APP_PAGE.map.toPath,
                name: APP_PAGE.map.toName,
                builder: (context, state) {
                  return MapScreen(
                    lat: state.pathParameters["lat"] ?? "0.0",
                    long: state.pathParameters["long"] ?? "0.0",
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final loginLocation = state.namedLocation(APP_PAGE.login.toName);
      final homeLocation = state.namedLocation(APP_PAGE.home.toName);
      final splashLocation = state.namedLocation(APP_PAGE.splash.toName);
      final onboardLocation = state.namedLocation(APP_PAGE.onBoarding.toName);
      final registerLocation = state.namedLocation(APP_PAGE.register.toName);

      final isLogedIn = appService.loginState;
      final isInitialized = appService.initialized;
      final isOnboarded = appService.onboarding;

      final isGoingToLogin = state.matchedLocation == loginLocation;
      final isGoingToInit = state.matchedLocation == splashLocation;
      final isGoingToOnboard = state.matchedLocation == onboardLocation;
      final isGoingToRegister = state.matchedLocation == registerLocation;

      if (!isInitialized && !isGoingToInit) {
        return splashLocation;
      } else if (isInitialized && !isOnboarded && !isGoingToOnboard) {
        return onboardLocation;
      } else if (isInitialized &&
          isOnboarded &&
          !isLogedIn &&
          !isGoingToLogin &&
          !isGoingToRegister) {
        return loginLocation;
      } else if ((isLogedIn && isGoingToLogin) ||
          (isInitialized && isGoingToInit) ||
          (isOnboarded && isGoingToOnboard)) {
        return homeLocation;
      } else {
        return null;
      }
    },
  );
}
