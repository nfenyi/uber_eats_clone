import 'package:hive_flutter/hive_flutter.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 3, adapterName: 'CartItemAdapter')
class HiveCartItem extends HiveObject {
  @HiveField(0)
  final String storeId;
  @HiveField(1)
  final HiveList<HiveCartProduct> products;
  @HiveField(2)
  String placeDescription;
  @HiveField(3)
  DateTime? deliveryDate;
  @HiveField(4)
  double subtotal;

  HiveCartItem({
    required this.storeId,
    required this.products,
    required this.placeDescription,
    required this.deliveryDate,
    required this.subtotal,
  });
}

@HiveType(typeId: 4, adapterName: 'HiveOptionAdapter')
class HiveOption extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  List<HiveOption> options;
  @HiveField(3)
  String categoryName;

  HiveOption(
      {required this.name,
      this.quantity = 0,
      this.options = const [],
      required this.categoryName});
}

@HiveType(typeId: 5, adapterName: 'CartProductAdapter')
class HiveCartProduct extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  String note;
  @HiveField(3)
  String? productReplacementId;
  @HiveField(4)
  String? backupInstruction;
  @HiveField(5)
  final List<HiveOption> optionalOptions;
  @HiveField(6)
  final List<HiveOption> requiredOptions;
  @HiveField(7)
  final double purchasePrice;
  @HiveField(8)
  final String name;
  HiveCartProduct({
    this.optionalOptions = const [],
    this.requiredOptions = const [],
    required this.id,
    required this.quantity,
    required this.purchasePrice,
    required this.name,
    this.note = '',
    this.productReplacementId,
    this.backupInstruction,
  });
}
