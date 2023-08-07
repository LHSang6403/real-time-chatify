import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/services/cloud_storage_service.dart';
import 'package:real_time_chatify/services/database_service.dart';
import 'package:real_time_chatify/services/media_service.dart';
import 'package:real_time_chatify/services/navigation_service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({Key? key, required this.onInitializationComplete})
      : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then(
      (_) {
        setUp().then(
          (_) => widget.onInitializationComplete(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Time Chatify',
      home: Scaffold(
        body: Center(
            child: Container(
                height: 120,
                width: 120,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/app_logo.png'),
                  fit: BoxFit.contain,
                )))),
      ),
    );
  }

  Future<void> setUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    registerServices();
  }

  void registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance
        .registerSingleton<CloudStorageService>(CloudStorageService());
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
  }
}
