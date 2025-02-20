import 'package:hive_flutter/hive_flutter.dart';

part 'country_ip_model.g.dart';

@HiveType(typeId: 0, adapterName: 'CountryResponseAdapter')
class HiveCountryResponse extends HiveObject {
  @HiveField(0)
  final String? ip;
  @HiveField(1)
  final String? code;
  @HiveField(2)
  final String? country;

  HiveCountryResponse(
      {required this.ip, required this.code, required this.country});
}
