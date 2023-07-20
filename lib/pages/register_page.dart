import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/providers/authentication_provider.dart';
import 'package:real_time_chatify/services/cloud_storage_service.dart';
import 'package:real_time_chatify/services/database_service.dart';
import 'package:real_time_chatify/services/media_service.dart';
import 'package:real_time_chatify/services/navigation_service.dart';
import 'package:real_time_chatify/widgets/input_fields.dart';
import 'package:real_time_chatify/widgets/rounded_button.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _height;
  late double _width;

  late AuthenticationProvider _authService;
  late DatabaseService _databaseService;
  late CloudStorageService _cloudStorageService;
  late NavigationService _navigationService;

  String? _email;
  String? _password;
  String? _name;
  PlatformFile? profileImage;

  final registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthenticationProvider>(context);
    _databaseService = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _navigationService = GetIt.instance.get<NavigationService>();

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return buildUI(context);
  }

  Widget buildUI(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            profileImageField(),
            SizedBox(
              height: _height * 0.0005,
            ),
            registerForm(),
            SizedBox(
              height: _height * 0.0005,
            ),
            registerButton(),
          ],
        ),
      ),
    );
  }

  Widget profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().getImgFromLibrary().then((file) {
          setState(() {
            profileImage = file;
          });
        });
      },
      child: () {
        if (profileImage != null) {
          return AssetRoundedImage(
              profileImage: profileImage!, imageSize: _height * 0.15);
        }
        return NetworkRoundedImage(
            imagePath:
                "https://cdn-icons-png.flaticon.com/512/5024/5024509.png",
            imageSize: _height * 0.15);
      }(),
    );
  }

  Widget registerForm() {
    return SizedBox(
      height: _height * 0.35,
      child: Form(
          key: registerFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                onSaved: (value) {
                  setState(() {
                    _name = value;
                    print(_name);
                  });
                },
                regEx: r'^[a-zA-ZÀ-ÿ\s]{1,50}$',
                hintText: "Enter your name",
                obscureText: false,
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              CustomTextField(
                onSaved: (value) {
                  setState(() {
                    _email = value;
                    print(_email);
                  });
                },
                regEx: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                hintText: "Enter your email",
                obscureText: false,
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              CustomTextField(
                onSaved: (value) {
                  setState(() {
                    _password = value;
                    print(_password);
                  });
                },
                regEx: r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
                hintText: "Enter your password",
                obscureText: true,
              ),
            ],
          )),
    );
  }

  Widget registerButton() {
    return RoundedButton(
        buttonName: 'Register',
        height: _height * 0.065,
        width: _width * 0.65,
        onPressed: () async {
          if (registerFormKey.currentState!.validate() &&
              profileImage != null) {
            print("Register: $_email, $_name");
            String? userId =
                await _authService.registerUser(_email!, _password!);
            String? imgUrl = await _cloudStorageService.saveUserImgToStorage(
                userId!, profileImage!);
            await _databaseService.createUser(userId, _email!, _name!, imgUrl!);
            _navigationService.routeBack();
          }
        });
  }
}
