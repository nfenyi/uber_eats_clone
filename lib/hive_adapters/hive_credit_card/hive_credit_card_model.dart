import 'package:hive_flutter/hive_flutter.dart';

part 'hive_credit_card_model.g.dart';

@HiveType(typeId: 6, adapterName: 'HiveCreditCardAdapter')
class HiveCreditCard {
  @HiveField(0)
  final String obscuredNumber;
  @HiveField(1)
  final String cardType;

  HiveCreditCard({
    required this.obscuredNumber,
    required this.cardType,
  });
}
