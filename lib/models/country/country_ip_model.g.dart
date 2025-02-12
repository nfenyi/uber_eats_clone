// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_ip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryResponseAdapter extends TypeAdapter<HiveCountryResponse> {
  @override
  final int typeId = 0;

  @override
  HiveCountryResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCountryResponse(
      ip: fields[0] as String?,
      code: fields[1] as String?,
      country: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCountryResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.ip)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
