// lib/core/navigation/app_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/bloc/home/home_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/profile/profile_bloc.dart';
import '../../presentation/bloc/search/search_bloc.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/auth/login_register_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../core/di/service_locator.dart';
import 'routes.dart';

/// Navigation callbacks that define all navigation actions
class NavigationCallbacks {
  final BuildContext context;

  NavigationCallbacks({required this.context});

  void toHome() {
    context.go(Routes.home);
  }

  void toLogin() {
    context.go(Routes.login);
  }

  void toProfile(String userId) {
    context.go(Routes.profile.replaceFirst(':userId', userId));
  }

  void toSearch() {
    context.goNamed(Routes.searchName);
  }

  void toSplash() {
    context.go(Routes.splash);
  }

  void pop() {
    if (context.canPop()) {
      context.pop();
    }
  }

  void popUntil(String routeName) {
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void replaceRoute(String routePath) {
    context.go(routePath);
  }
}

class _HomeScreenWithBloc extends StatelessWidget {
  final NavigationCallbacks navigationCallbacks;

  const _HomeScreenWithBloc({required this.navigationCallbacks});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>.value(
      value: getIt<HomeBloc>(),
      child: HomeScreen(
        onNavigateToProfile: (userId) => navigationCallbacks.toProfile(userId),
        onNavigateToSearch: () => navigationCallbacks.toSearch(),
        onNavigateToLogin: () => navigationCallbacks.toLogin(),
      ),
    );
  }
}

class _LoginScreenWithBloc extends StatelessWidget {
  final NavigationCallbacks navigationCallbacks;

  const _LoginScreenWithBloc({required this.navigationCallbacks});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: getIt<AuthBloc>(),  // ✅ Uses existing singleton
      child: LoginRegisterScreen(
        onNavigateToHome: () => navigationCallbacks.toHome()
      ),
    );
  }
}

class _ProfileScreenWithBloc extends StatelessWidget {
  final String userId;
  final NavigationCallbacks navigationCallbacks;

  const _ProfileScreenWithBloc({
    required this.userId,
    required this.navigationCallbacks,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>.value(
      value: getIt<ProfileBloc>(),
      child: ProfileScreen(
        userId: userId,
        onNavigateBack: () => navigationCallbacks.pop(),
        onNavigateToHome: () => navigationCallbacks.toHome(),
      ),
    );
  }
}

class _SearchScreenWithBloc extends StatelessWidget {
  final NavigationCallbacks navigationCallbacks;

  const _SearchScreenWithBloc({required this.navigationCallbacks});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>.value(
      value: getIt<SearchBloc>(),
      child: SearchScreen(
        onNavigateToDetail: (id) => navigationCallbacks.toProfile(id),
        onNavigateBack: () => navigationCallbacks.pop(),
      ),
    );
  }
}

class _SplashScreenWithBloc extends StatelessWidget {
  final NavigationCallbacks navigationCallbacks;

  const _SplashScreenWithBloc({required this.navigationCallbacks});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: getIt<AuthBloc>(),
      child: SplashScreen(
        onNavigateToHome: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigationCallbacks.toHome();
          });
        },
        onNavigateToLogin: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigationCallbacks.toLogin();
          });
        },
      ),
    );
  }
}

/// Central AppNavigation - Similar to Jetpack Compose AppNavigation
class AppNavigation {
  static final AppNavigation _instance = AppNavigation._internal();

  factory AppNavigation() {
    return _instance;
  }

  AppNavigation._internal();

  static GoRouter buildRouter() {
    final rootNavigatorKey = GlobalKey<NavigatorState>();

    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: Routes.splash,
      redirect: (context, state) {
        return null;
      },
      routes: [
        GoRoute(
          path: Routes.splash,
          builder: (context, state) {
            final navigationCallbacks = NavigationCallbacks(context: context);
            return _SplashScreenWithBloc(
                navigationCallbacks: navigationCallbacks);
          },
        ),
        GoRoute(
          path: Routes.home,
          name: Routes.homeName,
          builder: (context, state) {
            final navigationCallbacks = NavigationCallbacks(context: context);
            return _HomeScreenWithBloc(
                navigationCallbacks: navigationCallbacks);
          },
        ),
        GoRoute(
          path: Routes.login,
          name: Routes.loginName,
          builder: (context, state) {
            final navigationCallbacks = NavigationCallbacks(context: context);
            return _LoginScreenWithBloc(
                navigationCallbacks: navigationCallbacks);
          },
        ),
        GoRoute(
          path: Routes.profile,
          name: Routes.profileName,
          builder: (context, state) {
            final userId = state.pathParameters['userId'] ?? '';
            final navigationCallbacks = NavigationCallbacks(context: context);
            return _ProfileScreenWithBloc(
              userId: userId,
              navigationCallbacks: navigationCallbacks,
            );
          },
        ),
        GoRoute(
          path: Routes.search,
          name: Routes.searchName,
          builder: (context, state) {
            final navigationCallbacks = NavigationCallbacks(context: context);
            return _SearchScreenWithBloc(
                navigationCallbacks: navigationCallbacks);
          },
        ),
      ],
    );

    return router;
  }
}
