// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreImpl _$$StoreImplFromJson(Map<String, dynamic> json) => _$StoreImpl(
      isUberOneShop: json['isUberOneShop'] as bool? ?? false,
      location:
          StoreLocation.fromJson(json['location'] as Map<String, dynamic>),
      id: json['id'] as String,
      storeSchedules: (json['storeSchedules'] as List<dynamic>?)
          ?.map((e) => StoreSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      dietary: json['dietary'] as String?,
      featuredItems: (json['featuredItems'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceCategory: json['priceCategory'] as String,
      isGroupFriendly: json['isGroupFriendly'] as bool,
      type: json['type'] as String,
      offers: (json['offers'] as List<dynamic>?)
          ?.map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList(),
      aisles: (json['aisles'] as List<dynamic>?)
          ?.map((e) => Aisle.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      logo: json['logo'] as String,
      doesPickup: json['doesPickup'] as bool,
      productCategories: (json['productCategories'] as List<dynamic>?)
          ?.map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      delivery: Delivery.fromJson(json['delivery'] as Map<String, dynamic>),
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      cardImage: json['cardImage'] as String,
      visits: (json['visits'] as num?)?.toInt() ?? 0,
      openingTime: DateTime.parse(json['openingTime'] as String),
      closingTime: DateTime.parse(json['closingTime'] as String),
    );

Map<String, dynamic> _$$StoreImplToJson(_$StoreImpl instance) =>
    <String, dynamic>{
      'isUberOneShop': instance.isUberOneShop,
      'location': instance.location.toJson(),
      'id': instance.id,
      'storeSchedules':
          instance.storeSchedules?.map((e) => e.toJson()).toList(),
      'dietary': instance.dietary,
      'featuredItems': instance.featuredItems?.map((e) => e.toJson()).toList(),
      'priceCategory': instance.priceCategory,
      'isGroupFriendly': instance.isGroupFriendly,
      'type': instance.type,
      'offers': instance.offers?.map((e) => e.toJson()).toList(),
      'aisles': instance.aisles?.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'logo': instance.logo,
      'doesPickup': instance.doesPickup,
      'productCategories':
          instance.productCategories?.map((e) => e.toJson()).toList(),
      'delivery': instance.delivery.toJson(),
      'rating': instance.rating.toJson(),
      'cardImage': instance.cardImage,
      'visits': instance.visits,
      'openingTime': instance.openingTime.toIso8601String(),
      'closingTime': instance.closingTime.toIso8601String(),
    };

_$StoreScheduleImpl _$$StoreScheduleImplFromJson(Map<String, dynamic> json) =>
    _$StoreScheduleImpl(
      name: json['name'] as String,
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$$StoreScheduleImplToJson(_$StoreScheduleImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration': instance.duration,
    };

_$AisleImpl _$$AisleImplFromJson(Map<String, dynamic> json) => _$AisleImpl(
      name: json['name'] as String,
      productCategories: (json['productCategories'] as List<dynamic>)
          .map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AisleImplToJson(_$AisleImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'productCategories':
          instance.productCategories.map((e) => e.toJson()).toList(),
    };

_$RatingImpl _$$RatingImplFromJson(Map<String, dynamic> json) => _$RatingImpl(
      averageRating: (json['averageRating'] as num).toDouble(),
      ratings: (json['ratings'] as num).toInt(),
    );

Map<String, dynamic> _$$RatingImplToJson(_$RatingImpl instance) =>
    <String, dynamic>{
      'averageRating': instance.averageRating,
      'ratings': instance.ratings,
    };

_$StoreLocationImpl _$$StoreLocationImplFromJson(Map<String, dynamic> json) =>
    _$StoreLocationImpl(
      countryOfOrigin: json['countryOfOrigin'] as String,
      streetAddress: json['streetAddress'] as String,
      latlng: json['latlng'],
    );

Map<String, dynamic> _$$StoreLocationImplToJson(_$StoreLocationImpl instance) =>
    <String, dynamic>{
      'countryOfOrigin': instance.countryOfOrigin,
      'streetAddress': instance.streetAddress,
      'latlng': instance.latlng,
    };

_$ProductCategoryImpl _$$ProductCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductCategoryImpl(
      name: json['name'] as String,
      productsAndQuantities: (json['productsAndQuantities'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$ProductCategoryImplToJson(
        _$ProductCategoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'productsAndQuantities': instance.productsAndQuantities,
    };

_$DeliveryImpl _$$DeliveryImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryImpl(
      canDeliver: json['canDeliver'] as bool,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] as String,
      fee: (json['fee'] as num).toDouble(),
    );

Map<String, dynamic> _$$DeliveryImplToJson(_$DeliveryImpl instance) =>
    <String, dynamic>{
      'canDeliver': instance.canDeliver,
      'estimatedDeliveryTime': instance.estimatedDeliveryTime,
      'fee': instance.fee,
    };

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      name: json['name'] as String,
      id: json['id'] as String,
      initialPrice: (json['initialPrice'] as num).toDouble(),
      promoPrice: (json['promoPrice'] as num?)?.toDouble(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      frequentlyBoughtTogether:
          (json['frequentlyBoughtTogether'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList(),
      nutritionFacts: (json['nutritionFacts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      ingredients: json['ingredients'] as String?,
      directions: json['directions'] as String?,
      quantity: json['quantity'] as String?,
      description: json['description'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectOptionRequired: json['selectOptionRequired'] as bool? ?? false,
      calories: (json['calories'] as num?)?.toDouble(),
      isSoldOut: json['isSoldOut'] as bool?,
      isSponsored: json['isSponsored'] as bool?,
      noInStock: (json['noInStock'] as num?)?.toInt(),
      similarProducts: (json['similarProducts'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'initialPrice': instance.initialPrice,
      'promoPrice': instance.promoPrice,
      'imageUrls': instance.imageUrls,
      'frequentlyBoughtTogether': instance.frequentlyBoughtTogether,
      'nutritionFacts': instance.nutritionFacts,
      'ingredients': instance.ingredients,
      'directions': instance.directions,
      'quantity': instance.quantity,
      'description': instance.description,
      'options': instance.options?.map((e) => e.toJson()).toList(),
      'selectOptionRequired': instance.selectOptionRequired,
      'calories': instance.calories,
      'isSoldOut': instance.isSoldOut,
      'isSponsored': instance.isSponsored,
      'noInStock': instance.noInStock,
      'similarProducts':
          instance.similarProducts?.map((e) => e.toJson()).toList(),
    };

_$OptionImpl _$$OptionImplFromJson(Map<String, dynamic> json) => _$OptionImpl(
      name: json['name'] as String,
      price: (json['price'] as num?)?.toDouble(),
      isExclusive: json['isExclusive'] as bool? ?? true,
      subOptions: (json['subOptions'] as List<dynamic>?)
          ?.map((e) => SubOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      calories: (json['calories'] as num?)?.toDouble(),
      canBeMultiple: json['canBeMultiple'] as bool? ?? false,
      canBeMultipleLimit: (json['canBeMultipleLimit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$OptionImplToJson(_$OptionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'isExclusive': instance.isExclusive,
      'subOptions': instance.subOptions?.map((e) => e.toJson()).toList(),
      'calories': instance.calories,
      'canBeMultiple': instance.canBeMultiple,
      'canBeMultipleLimit': instance.canBeMultipleLimit,
    };

_$SubOptionImpl _$$SubOptionImplFromJson(Map<String, dynamic> json) =>
    _$SubOptionImpl(
      name: json['name'] as String,
      canBeMultiple: json['canBeMultiple'] as bool,
      calories: (json['calories'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      canBeMultipleLimit: (json['canBeMultipleLimit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SubOptionImplToJson(_$SubOptionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'canBeMultiple': instance.canBeMultiple,
      'calories': instance.calories,
      'price': instance.price,
      'canBeMultipleLimit': instance.canBeMultipleLimit,
    };

_$FoodCategoryImpl _$$FoodCategoryImplFromJson(Map<String, dynamic> json) =>
    _$FoodCategoryImpl(
      json['name'] as String,
      json['image'] as String,
    );

Map<String, dynamic> _$$FoodCategoryImplToJson(_$FoodCategoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
    };
