import 'package:country_ip/country_ip.dart';

import '../../hive_adapters/country/country_ip_model.dart';
import '../../main.dart';
import '../../services/country_ip_services.dart';
import '../../services/hive_services.dart';
import 'country_repository.dart';

class CountryRepositoryStorage implements CountryRepository {
  CountryResponse? _userCountryDetails;

  @override
  Future<CountryResponse?> get getUserCountryDetails async =>
      _userCountryDetails ?? await CountryIpServices.getCountry();

  @override
  Future<void> getUserStarted() async {
    final countryResponse = await getUserCountryDetails;
    await HiveServices.putData(
        boxName: _AppBoxes.appState, key: _BoxKeys.showGetStarted, data: false);
    await HiveServices.putData(
        boxName: _AppBoxes.appState,
        key: _BoxKeys.country,
        data: HiveCountryResponse(
            ip: countryResponse?.ip,
            code: countryResponse?.countryCode,
            country: countryResponse?.country));
  }
}
