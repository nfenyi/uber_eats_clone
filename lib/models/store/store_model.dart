import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../offer/offer_model.dart';

part 'store_model.freezed.dart';
part 'store_model.g.dart';

@freezed
class Store with _$Store {
  factory Store({
    @Default(false) bool isUberOneShop,
    required StoreLocation location,
    required String id,
    List<StoreSchedule>? storeSchedules,
    String? dietary,
    List<Product>? featuredItems,
    required String priceCategory,
    int? groupSize,
    required String type,
    List<Offer>? offers,
    List<Aisle>? aisles,
    required String name,
    required String logo,
    required bool doesPickup,
    List<ProductCategory>? productCategories,
    required Delivery delivery,
    required Rating rating,
    required String cardImage,
    @Default(false) bool bestOverall,
    @Default(0) int visits,
    required DateTime openingTime,
    required DateTime closingTime,
  }) = _Store;

  factory Store.fromJson(Map<String, Object?> json) => _$StoreFromJson(json);
}

@freezed
class StoreSchedule with _$StoreSchedule {
  factory StoreSchedule({
    required String name,
    required String duration,
  }) = _StoreSchedule;
  factory StoreSchedule.fromJson(Map<String, Object?> json) =>
      _$StoreScheduleFromJson(json);
}

@freezed
class Aisle with _$Aisle {
  factory Aisle({
    required String name,
    required List<ProductCategory> productCategories,
  }) = _Aisle;

  factory Aisle.fromJson(Map<String, Object?> json) => _$AisleFromJson(json);
}

@freezed
class Rating with _$Rating {
  factory Rating({
    required double averageRating,
    required int ratings,
  }) = _Rating;

  factory Rating.fromJson(Map<String, Object?> json) => _$RatingFromJson(json);
}

@freezed
class StoreLocation with _$StoreLocation {
  factory StoreLocation({
    required String countryOfOrigin,
    required String streetAddress,
    // @GeoPointConverter() required GeoPoint latlng,
    required Object latlng,
  }) = _StoreLocation;

  factory StoreLocation.fromJson(Map<String, Object?> json) =>
      _$StoreLocationFromJson(json);
}

class GeoPointConverter
    implements JsonConverter<GeoPoint, Map<String, dynamic>> {
  const GeoPointConverter();

  @override
  GeoPoint fromJson(Map<String, dynamic> json) {
    return GeoPoint(json['latitude'] as double, json['longitude'] as double);
  }

  @override
  Map<String, dynamic> toJson(GeoPoint geoPoint) {
    return {'latitude': geoPoint.latitude, 'longitude': geoPoint.longitude};
  }
}

@freezed
class ProductCategory with _$ProductCategory {
  factory ProductCategory({
    required String name,
    required List<Map<String, dynamic>> productsAndQuantities,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Map<String, Object?> json) =>
      _$ProductCategoryFromJson(json);
}

@freezed
class Delivery with _$Delivery {
  factory Delivery({
    required bool canDeliver,
    required String estimatedDeliveryTime,
    required double fee,
  }) = _Delivery;

  factory Delivery.fromJson(Map<String, Object?> json) =>
      _$DeliveryFromJson(json);
}

@freezed
class Product with _$Product {
  factory Product({
    required String name,
    required String id,
    required double initialPrice,
    double? promoPrice,
    required List<String> imageUrls,
    List<Object>? frequentlyBoughtTogether,
    Map<String, String>? nutritionFacts,
    String? ingredients,
    String? directions,
    String? quantity,
    String? description,
    @Default([]) List<Option> optionalOptions,
    @Default([]) List<Option> requiredOptions,
    double? calories,
    bool? isSoldOut,
    bool? isSponsored,
    Object? offer,
    List<Object>? stores,
    @Default([]) List<Object> similarProducts,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);
}

@freezed
class Option with _$Option {
  factory Option({
    required String name,
    int? canBeMultipleLimit,
    @Default(true) bool isExclusive,
    @Default([]) List<SubOption> subOptions,
  }) = _Option;

  factory Option.fromJson(Map<String, Object?> json) => _$OptionFromJson(json);
}

@freezed
class SubOption with _$SubOption {
  factory SubOption({
    required String name,
    required bool canBeMultiple,
    @Default(true) bool isExclusive,
    double? calories,
    double? price,
    @Default([]) List<Option> options,
  }) = _SubOption;

  factory SubOption.fromJson(Map<String, Object?> json) =>
      _$SubOptionFromJson(json);
}

@freezed
class FoodCategory with _$FoodCategory {
  factory FoodCategory(String name, String image) = _FoodCategory;

  factory FoodCategory.fromJson(Map<String, Object?> json) =>
      _$FoodCategoryFromJson(json);
}
