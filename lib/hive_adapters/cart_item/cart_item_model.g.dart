// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemAdapter extends TypeAdapter<HiveCartItem> {
  @override
  final int typeId = 3;

  @override
  HiveCartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCartItem(
      storeId: fields[0] as String,
      products: (fields[1] as HiveList).castHiveList(),
      placeDescription: fields[2] as String,
      deliveryDate: fields[3] as DateTime?,
      subtotal: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCartItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.storeId)
      ..writeByte(1)
      ..write(obj.products)
      ..writeByte(2)
      ..write(obj.placeDescription)
      ..writeByte(3)
      ..write(obj.deliveryDate)
      ..writeByte(4)
      ..write(obj.subtotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveOptionAdapter extends TypeAdapter<HiveOption> {
  @override
  final int typeId = 4;

  @override
  HiveOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveOption(
      name: fields[0] as String,
      quantity: fields[1] as int,
      options: (fields[2] as List).cast<HiveOption>(),
      categoryName: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveOption obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.categoryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CartProductAdapter extends TypeAdapter<HiveCartProduct> {
  @override
  final int typeId = 5;

  @override
  HiveCartProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCartProduct(
      optionalOptions: (fields[5] as List).cast<HiveOption>(),
      requiredOptions: (fields[6] as List).cast<HiveOption>(),
      id: fields[0] as String,
      quantity: fields[1] as int,
      purchasePrice: fields[7] as double,
      name: fields[8] as String,
      note: fields[2] as String,
      productReplacementId: fields[3] as String?,
      backupInstruction: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCartProduct obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.productReplacementId)
      ..writeByte(4)
      ..write(obj.backupInstruction)
      ..writeByte(5)
      ..write(obj.optionalOptions)
      ..writeByte(6)
      ..write(obj.requiredOptions)
      ..writeByte(7)
      ..write(obj.purchasePrice)
      ..writeByte(8)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
