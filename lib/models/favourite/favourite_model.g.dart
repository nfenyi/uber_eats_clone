// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavouriteStoreImpl _$$FavouriteStoreImplFromJson(Map<String, dynamic> json) =>
    _$FavouriteStoreImpl(
      id: json['id'] as String,
      dateFavorited: DateTime.parse(json['dateFavorited'] as String),
    );

Map<String, dynamic> _$$FavouriteStoreImplToJson(
        _$FavouriteStoreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateFavorited': instance.dateFavorited.toIso8601String(),
    };
