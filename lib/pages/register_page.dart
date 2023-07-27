import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/controllers/register_controller.dart';
import 'package:real_time_chatify/providers/authentication_provider.dart';
import 'package:real_time_chatify/services/cloud_storage_service.dart';
import 'package:real_time_chatify/services/database_service.dart';
import 'package:real_time_chatify/services/media_service.dart';
import 'package:real_time_chatify/services/navigation_service.dart';
import 'package:real_time_chatify/widgets/input_fields.dart';
import 'package:real_time_chatify/widgets/rounded_button.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

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

  //final RegisterController registerController = Get.find();
  final registerFormKey = GlobalKey<FormState>();

  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    print('re-building register page');
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
          registerController.setProfileImage(file!);
        });
      },
      child: () {
        return Obx(() => AssetRoundedImage(
            profileImage: registerController.getProfileImage(),
            imageSize: _height * 0.15));
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
                  registerController.setName(value);
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
                  registerController.setEmail(value);
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
                  registerController.setPassword(value);
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
          if (registerFormKey.currentState!.validate()) {
            registerFormKey.currentState!.save();
            print(
                "Register: ${registerController.getEmail()}, ${registerController.getPassword()}");
            String? userId = await _authService.registerUser(
                registerController.getEmail(),
                registerController.getPassword());
            String? imgUrl = await _cloudStorageService.saveUserImgToStorage(
                userId!, registerController.getProfileImage());
            await _databaseService.createUser(
                userId,
                registerController.getEmail(),
                registerController.getName(),
                imgUrl!);
            await _authService.logOut();
            await _authService.loginUsingEmailAndPassword(
                registerController.getEmail(),
                registerController.getPassword());
            //_navigationService.routeBack();
          }
        });
  }
}
