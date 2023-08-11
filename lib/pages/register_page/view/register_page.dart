import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/pages/register_page/viewModel/register_page_controller.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/services/cloud_storage_service.dart';
import 'package:real_time_chatify/services/database_service.dart';
import 'package:real_time_chatify/services/media_service.dart';
import 'package:real_time_chatify/services/navigation_service.dart';
import 'package:real_time_chatify/widgets/custom_input_fields.dart';
import 'package:real_time_chatify/widgets/rounded_button.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double height;
  late double width;

  late AuthenticationProvider authService;
  late DatabaseService databaseService;
  late CloudStorageService cloudStorageService;
  late NavigationService navigationService;

  final registerPageController = Get.put(RegisterPageController());

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthenticationProvider>(context);
    databaseService = GetIt.instance.get<DatabaseService>();
    cloudStorageService = GetIt.instance.get<CloudStorageService>();
    navigationService = GetIt.instance.get<NavigationService>();

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return buildUI(context);
  }

  Widget buildUI(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            profileImageField(),
            SizedBox(
              height: height * 0.0005,
            ),
            registerForm(),
            SizedBox(
              height: height * 0.0005,
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
          registerPageController.setProfileImage(file!);
        });
      },
      child: () {
        return Obx(() => AssetRoundedImage(
            profileImage: registerPageController.getProfileImage(),
            imageSize: height * 0.15));
      }(),
    );
  }

  Widget registerForm() {
    return SizedBox(
      height: height * 0.35,
      child: Form(
          key: registerPageController.registerPageModel.registerFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                onSaved: (value) {
                  registerPageController.setName(value);
                },
                regEx: r'^[a-zA-ZÀ-ÿ\s]{1,50}$',
                hintText: "Enter your name",
                obscureText: false,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                onSaved: (value) {
                  registerPageController.setEmail(value);
                },
                regEx: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                hintText: "Enter your email",
                obscureText: false,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                onSaved: (value) {
                  registerPageController.setPassword(value);
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
        height: height * 0.065,
        width: width * 0.65,
        onPressed: () async {
          if (registerPageController
              .registerPageModel.registerFormKey.currentState!
              .validate()) {
            registerPageController
                .registerPageModel.registerFormKey.currentState!
                .save();

            String? userId = await authService.registerUser(
                registerPageController.getEmail(),
                registerPageController.getPassword());
            String? imgUrl = await cloudStorageService.saveUserImgToStorage(
                userId!, registerPageController.getProfileImage());
            await databaseService.createUser(
                userId,
                registerPageController.getEmail(),
                registerPageController.getName(),
                imgUrl!);
            await authService.logOut();
            await authService.loginUsingEmailAndPassword(
                registerPageController.getEmail(),
                registerPageController.getPassword());
            navigationService.routeBack();
          }
        });
  }
}
