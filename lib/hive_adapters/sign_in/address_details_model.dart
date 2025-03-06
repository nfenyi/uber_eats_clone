import 'package:hive_flutter/hive_flutter.dart';

part 'address_details_model.g.dart';

@HiveType(typeId: 1, adapterName: 'AddressDetailsAdapter')
class HiveAddressDetails extends HiveObject {
  @HiveField(0)
  final String instruction;
  @HiveField(1)
  final String? apartment;
  @HiveField(2)
  final String? latLng;
  @HiveField(3)
  final String? addressLabel;
  @HiveField(4)
  final String? building;
  @HiveField(5)
  final String? dropoffOption;

  HiveAddressDetails(
      {required this.instruction,
      required this.apartment,
      required this.latLng,
      required this.addressLabel,
      required this.building,
      required this.dropoffOption});
}
