import 'package:country_ip/country_ip.dart';

abstract class CountryRepository {
  Future<CountryResponse?> get getUserCountryDetails;
  Future<void> getUserStarted();
}
