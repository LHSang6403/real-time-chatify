import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void removeAndRoute(String route) {
    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void route(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }

  void routeToPage(Widget page) {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (BuildContext context) => page));
  }

  void routeBack() {
    navigatorKey.currentState?.pop();
  }
}
