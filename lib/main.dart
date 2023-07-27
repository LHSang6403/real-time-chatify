import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/pages/login_page.dart';
import 'package:real_time_chatify/pages/main_page.dart';
import 'package:real_time_chatify/pages/register_page.dart';
import 'package:real_time_chatify/providers/authentication_provider.dart';
import 'package:real_time_chatify/services/navigation_service.dart';

import 'pages/splash_page.dart';

void main() {
  runApp(SplashPage(
    onInitializationComplete: () {
      runApp(MainApp());
    },
  ));
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext context) => AuthenticationProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'RT Chatify',
          theme: ThemeData(
              colorScheme: const ColorScheme.light().copyWith(
                background: const Color.fromRGBO(36, 35, 49, 1.0),
                secondary: const Color.fromRGBO(36, 35, 49, 1.0),
              ),
              scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Color.fromRGBO(30, 29, 37, 1.0))),
          navigatorKey: NavigationService.navigatorKey,
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/main': (context) => MainPage(),
          }),
    );
  }
}
