import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/pages/login_page/model/login_page_model.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/login_page_controller.dart';
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

  late AuthenticationProvider auth;
  late NavigationService nav;

  late LoginPageModel loginPageModel;
  late LoginPageController loginPageController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loginPageModel = LoginPageModel();
    loginPageController = LoginPageController();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    nav = GetIt.instance.get<NavigationService>();
    return buildLoginForm();
  }

  Widget buildLoginForm() {
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
            titleWidget(),
            SizedBox(height: height * 0.04),
            loginForm(),
            SizedBox(height: height * 0.04),
            buttonLogin(),
            SizedBox(height: height * 0.04),
            registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget titleWidget() {
    return SizedBox(
      height: height * 0.1,
      child: const Text(
        'RT Chatify',
        style: TextStyle(
            fontSize: 40, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget loginForm() {
    return SizedBox(
      height: height * 0.18,
      child: Form(
          key: loginPageController.loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomTextField(
                onSaved: (value) {
                  loginPageModel.email = value;
                },
                regEx: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                hintText: 'Email',
                obscureText: false,
              ),
              CustomTextField(
                onSaved: (value) {
                  loginPageModel.password = value;
                },
                regEx: r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
                hintText: 'Password',
                obscureText: true,
              ),
            ],
          )),
    );
  }

  Widget buttonLogin() {
    return RoundedButton(
        buttonName: "Login",
        height: height * 0.055,
        width: width * 0.4,
        onPressed: () {
          if (loginPageController.loginFormKey.currentState!.validate()) {
            loginPageController.loginFormKey.currentState!.save();
            auth.loginUsingEmailAndPassword(
                loginPageModel.email!, loginPageModel.password!);
          }
        });
  }

  Widget registerAccountLink() {
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
