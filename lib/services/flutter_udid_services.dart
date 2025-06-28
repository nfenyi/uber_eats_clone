import 'package:flutter_udid/flutter_udid.dart';

class FlutterUdidServices {
  const FlutterUdidServices._();
  static Future<String> getDeviceId() async {
    return await FlutterUdid.consistentUdid;
  }
}
