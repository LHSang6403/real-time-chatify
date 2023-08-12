import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/pages/people_page/model/user.dart';
import 'package:real_time_chatify/services/database_service.dart';
import 'package:real_time_chatify/services/navigation_service.dart';
import 'package:real_time_chatify/services/shared_preference_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth auth;
  late final NavigationService navigationService;
  late final DatabaseService databaseService;
  late SharedPreference sharedPreference;
  bool autoLogIn = true;

  late ChatUser chatUser;

  AuthenticationProvider() {
    auth = FirebaseAuth.instance;
    sharedPreference = SharedPreference();
    navigationService = GetIt.instance<NavigationService>();
    databaseService = GetIt.instance<DatabaseService>();

    runAsAsync();
    if (autoLogIn == false) {
      logOut();
    }

    auth.authStateChanges().listen((user) {
      if (user != null) {
        databaseService.updateUserLastActiveTime(user.uid);

        chatUser = ChatUser.fromJSON(
          {
            "user_id": user.uid,
            "name": user.displayName,
            "email": user.email,
            "last_active": Timestamp.fromDate(user.metadata.lastSignInTime!),
            "imgUrl": user.photoURL,
          },
        );
        navigationService.removeAndRoute('/main');
        print('Logged in');
      } else {
        print('Not logged in');
        navigationService.removeAndRoute('/login');
      }
    });
  }

  Future<void> runAsAsync() async {
    autoLogIn = await sharedPreference.readBoolFormLocal('autoLogIn');
    print('autoLogIn: $autoLogIn');
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
      navigationService.routeBack();
      navigationService.removeAndRoute('/login');
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      print('Failed to sign in Firebase with Email & Password');
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print(e);
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
