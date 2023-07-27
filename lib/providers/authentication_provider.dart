import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/models/user.dart';
import 'package:real_time_chatify/services/database_service.dart';
import 'package:real_time_chatify/services/navigation_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUser chatUser;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance<NavigationService>();
    _databaseService = GetIt.instance<DatabaseService>();
    //logOut();
    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _databaseService.updateUserLastTime(_user.uid);

        chatUser = ChatUser.fromJSON(
          {
            "user_id": _user.uid,
            "name": _user.providerData.first.displayName,
            "email": _user.providerData.first.email,
            "last_active": _user.metadata.lastSignInTime,
            "image": _user.providerData.first.photoURL,
          },
        );
        _navigationService.route('/main');
        print('Logged in');
      } else {
        print('Not logged in');
        _navigationService.removeAndRoute('/login');
      }
    });
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print(_auth.currentUser);
    } on FirebaseAuthException {
      print('Failed to sign in Firebase with Email & Password');
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUser(String _email, String _password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);
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
  }
}
