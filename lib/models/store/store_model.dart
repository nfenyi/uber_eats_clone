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
    required Location location,
    required String id,
    required String priceCategory,
    required bool isGroupFriendly,
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
    // required bool isFavorite,
    required DateTime openingTime,
    required DateTime closingTime,
  }) = _Store;

  factory Store.fromJson(Map<String, Object?> json) => _$StoreFromJson(json);
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
class Location with _$Location {
  factory Location({
    required String countryOfOrigin,
    required String streetAddress,
  }) = _Location;

  factory Location.fromJson(Map<String, Object?> json) =>
      _$LocationFromJson(json);
}

@freezed
class ProductCategory with _$ProductCategory {
  factory ProductCategory({
    required String name,
    // List<Object>? products,
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
    List<String>? frequentlyBoughtTogether,
    Map<String, String>? nutritionFacts,
    String? ingredients,
    String? directions,
    String? quantity,
    String? description,
    List<Option>? options,
    @Default(false) bool selectOptionRequired,
    double? calories,
    bool? isSoldOut,
    bool? isSponsored,
    int? noInStock,
    List<Product>? similarProducts,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);
}

@freezed
class Option with _$Option {
  factory Option({
    required String name,
    double? price,
    @Default(true) bool isExclusive,
    List<SubOption>? subOptions,
    double? calories,
  }) = _Option;

  factory Option.fromJson(Map<String, Object?> json) => _$OptionFromJson(json);
}

@freezed
class SubOption with _$SubOption {
  factory SubOption({
    required String name,
    required bool canBeMultiple,
    double? price,
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
