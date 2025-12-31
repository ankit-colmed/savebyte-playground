import 'package:flutter/material.dart';

class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('Pushed route: ${route.settings.name}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('Popped route: ${route.settings.name}');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print('Replaced route: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}