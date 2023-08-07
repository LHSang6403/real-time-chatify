import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/models/user.dart';
import 'package:real_time_chatify/services/database_service.dart';
import 'package:real_time_chatify/services/navigation_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth auth;
  late final NavigationService navigationService;
  late final DatabaseService databaseService;

  late ChatUser chatUser;

  AuthenticationProvider() {
    auth = FirebaseAuth.instance;
    navigationService = GetIt.instance<NavigationService>();
    databaseService = GetIt.instance<DatabaseService>();
    //logOut();
    auth.authStateChanges().listen((user) {
      if (user != null) {
        databaseService.updateUserLastSeenTime(user.uid);

        chatUser = ChatUser.fromJSON(
          {
            "user_id": user.uid,
            "name": user.providerData.first.displayName,
            "email": user.providerData.first.email,
            "last_active": Timestamp.fromDate(user.metadata.lastSignInTime!),
            "image": user.providerData.first.photoURL,
          },
        );
        navigationService.route('/main');
        print('Logged in');
      } else {
        print('Not logged in');
        navigationService.removeAndRoute('/login');
      }
    });
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await auth.signInWithEmailAndPassword(email: _email, password: _password);
      print(auth.currentUser);
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
