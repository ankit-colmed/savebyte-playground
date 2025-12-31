import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/auth/login_register_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/search/search_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.home,
        name: Routes.homeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.loginName,
        builder: (context, state) => const LoginRegisterScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        name: Routes.profileName,
        builder: (context, state) {
          final userId = state.pathParameters['userId'];
          return ProfileScreen(userId: userId ?? '');
        },
      ),
      GoRoute(
        path: Routes.search,
        name: Routes.searchName,
        builder: (context, state) => const SearchScreen(),
      ),
    ],
    redirect: (context, state) {
      // Add auth guard logic here
      return null;
    },
  );
}


class Routes {
  // Route paths
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String profile = '/profile/:userId';
  static const String search = '/search';

  // Route names (for named navigation)
  static const String homeName = 'home';
  static const String loginName = 'login';
  static const String profileName = 'profile';
  static const String searchName = 'search';
}

class AppNavigation {
  static void goToHome(BuildContext context) {
    context.goNamed(Routes.homeName);
  }

  static void goToLogin(BuildContext context) {
    context.go(Routes.login);
  }

  static void goToProfile(BuildContext context, String userId) {
    context.go(Routes.profile.replaceFirst(':userId', userId));
  }

  static void goToSearch(BuildContext context) {
    context.goNamed(Routes.searchName);
  }

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}