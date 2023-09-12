import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalServices extends OneSignal {
  static void oneSignalInit() {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("6cbef5b5-f06b-4236-92a0-47433ced8ad5");
    OneSignal.Notifications.requestPermission(true);
  }
}
