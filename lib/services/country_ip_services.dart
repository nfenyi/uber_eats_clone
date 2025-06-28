import 'package:country_ip/country_ip.dart';

import '../utils/result.dart';

class CountryIpServices {
  const CountryIpServices._();
  static Future<Result<CountryResponse?>> getCountry() async {
    try {
      return Result.ok(await CountryIp.find());
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }
}
