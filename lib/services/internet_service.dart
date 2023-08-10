import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  late ConnectivityResult checkConnectivity;

  InternetService() {
    initInternet();
  }

  Future<void> initInternet() async {
    checkConnectivity = await (Connectivity().checkConnectivity());
  }

  Future<bool> checkMobileConnectivity() async {
    return (checkConnectivity == ConnectivityResult.wifi);
  }

  Future<void> checkAndPrintConnectivityStatus() async {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.wifi) {
        print('Connected to Wi-Fi');
        //return true;
      } else if (result == ConnectivityResult.mobile) {
        print('Connected to mobile data');
        //return true;
      } else {
        print('No Internet connection');
        //return false;
      }
    });
  }
}
