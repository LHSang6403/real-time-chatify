import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/providers/authentication_provider.dart';
import 'package:real_time_chatify/services/navigation_service.dart';
import 'package:real_time_chatify/widgets/input_fields.dart';
import 'package:real_time_chatify/widgets/rounded_button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _height;
  late double _width;
  final _loginFormKey = GlobalKey<FormState>();

  late AuthenticationProvider _auth;
  late NavigationService _nav;

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _nav = GetIt.instance.get<NavigationService>();
    return _buildLoginForm();
  }

  Widget _buildLoginForm() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _width * 0.03, vertical: _height * 0.02),
        height: _height * 0.98,
        width: _width * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _titleWidget(),
            SizedBox(height: _height * 0.04),
            _loginForm(),
            SizedBox(height: _height * 0.04),
            _buttonLogin(),
            SizedBox(height: _height * 0.04),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return SizedBox(
      height: _height * 0.1,
      child: const Text(
        'RT Chatify',
        style: TextStyle(
            fontSize: 40, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _loginForm() {
    return SizedBox(
      height: _height * 0.18,
      child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomTextField(
                onSaved: (value) {
                  _email = value;
                },
                regEx: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                hintText: 'Email',
                obscureText: false,
              ),
              CustomTextField(
                onSaved: (value) {
                  _password = value;
                },
                regEx: r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
                hintText: 'Password',
                obscureText: true,
              ),
            ],
          )),
    );
  }

  Widget _buttonLogin() {
    return RoundedButton(
        buttonName: "Login",
        height: _height * 0.055,
        width: _width * 0.4,
        onPressed: () {
          if (_loginFormKey.currentState!.validate()) {
            _loginFormKey.currentState!.save();
            //print('Email: $_email, Password: $_password');
            _auth.loginUsingEmailAndPassword(_email!, _password!);
          }
        });
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => _nav.route('/register'),
      child: const SizedBox(
        child: Text(
          'Don have an account?',
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
