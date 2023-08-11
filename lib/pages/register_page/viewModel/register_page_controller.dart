import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:real_time_chatify/pages/register_page/model/register_page_model.dart';

class RegisterPageController extends GetxController {
  RegisterPageModel registerPageModel = RegisterPageModel();
  Rx<PlatformFile?> profileImage = Rx<PlatformFile?>(null);

  void setEmail(String value) {
    registerPageModel.email = value;
  }

  void setName(String value) {
    registerPageModel.name = value;
  }

  void setPassword(String value) {
    registerPageModel.password = value;
  }

  void setProfileImage(PlatformFile value) {
    profileImage.value = value;
  }

  String getEmail() => registerPageModel.email;
  String getPassword() => registerPageModel.password;
  String getName() => registerPageModel.name;

  PlatformFile getProfileImage() {
    if (profileImage.value == null) {
      return PlatformFile(
          name: "unknown_him.png",
          size: 0,
          path: "assets/images/unknown_him.png");
    } else {
      return profileImage.value!;
    }
  }
}
