import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/models/chat_user.dart';
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
    logOut();
    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _databaseService.updateUserLastTime(_user.uid);
        _databaseService.getUser(_user.uid).then((snapshot) {
          Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

          data['user_id'] = _user.uid;
          chatUser = ChatUser.fromJSON({
            "user_id": data['user_id'],
            "name": data["name"],
            "email": data["email"],
            "last_active": data["last_active"].toDate(),
            "image": data["image"],
          });
          //print(chatUser.toMap());
          _navigationService.removeAndRoute('/home');
        });

        print('Logged in');
      } else {
        print('Not logged in');
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
      //print(_auth.currentUser);
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
