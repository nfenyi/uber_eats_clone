// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressDetailsAdapter extends TypeAdapter<HiveAddressDetails> {
  @override
  final int typeId = 0;

  @override
  HiveAddressDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAddressDetails(
      instruction: fields[0] as String,
      apartment: fields[1] as String?,
      latLng: fields[2] as String?,
      addressLabel: fields[3] as String?,
      building: fields[4] as String?,
      dropoffOption: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveAddressDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.instruction)
      ..writeByte(1)
      ..write(obj.apartment)
      ..writeByte(2)
      ..write(obj.latLng)
      ..writeByte(3)
      ..write(obj.addressLabel)
      ..writeByte(4)
      ..write(obj.building)
      ..writeByte(5)
      ..write(obj.dropoffOption);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
