import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  String email = "";
  String password = "";
  String name = "";
  Rx<PlatformFile?> profileImage = Rx<PlatformFile?>(null);

  void setEmail(String value) {
    email = value;
  }

  void setName(String value) {
    name = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void setProfileImage(PlatformFile value) {
    profileImage.value = value;
  }

  String getEmail() => email;
  String getPassword() => password;
  String getName() => name;

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
