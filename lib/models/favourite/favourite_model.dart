import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'favourite_model.freezed.dart';
part 'favourite_model.g.dart';

@freezed
class FavouriteStore with _$FavouriteStore {
  const factory FavouriteStore({
    required String id,
    required DateTime dateFavorited,
  }) = _FavouriteStore;

  factory FavouriteStore.fromJson(Map<String, Object?> json) =>
      _$FavouriteStoreFromJson(json);
}
