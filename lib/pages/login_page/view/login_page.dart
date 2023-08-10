import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/services/navigation_service.dart';
import 'package:real_time_chatify/widgets/custom_input_fields.dart';
import 'package:real_time_chatify/widgets/rounded_button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double height;
  late double width;
  final loginFormKey = GlobalKey<FormState>();

  late AuthenticationProvider auth;
  late NavigationService nav;

  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    nav = GetIt.instance.get<NavigationService>();
    return _buildLoginForm();
  }

  Widget _buildLoginForm() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.02),
        height: height * 0.98,
        width: width * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _titleWidget(),
            SizedBox(height: height * 0.04),
            _loginForm(),
            SizedBox(height: height * 0.04),
            _buttonLogin(),
            SizedBox(height: height * 0.04),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return SizedBox(
      height: height * 0.1,
      child: const Text(
        'RT Chatify',
        style: TextStyle(
            fontSize: 40, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _loginForm() {
    return SizedBox(
      height: height * 0.18,
      child: Form(
          key: loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomTextField(
                onSaved: (value) {
                  email = value;
                },
                regEx: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                hintText: 'Email',
                obscureText: false,
              ),
              CustomTextField(
                onSaved: (value) {
                  password = value;
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
        height: height * 0.055,
        width: width * 0.4,
        onPressed: () {
          if (loginFormKey.currentState!.validate()) {
            loginFormKey.currentState!.save();
            //print('Email: $_email, Password: $_password');
            auth.loginUsingEmailAndPassword(email!, password!);
          }
        });
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => nav.route('/register'),
      child: const SizedBox(
        child: Text(
          'Don have an account?',
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
