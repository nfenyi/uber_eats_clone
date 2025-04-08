// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Store _$StoreFromJson(Map<String, dynamic> json) {
  return _Store.fromJson(json);
}

/// @nodoc
mixin _$Store {
  bool get isUberOneShop => throw _privateConstructorUsedError;
  StoreLocation get location => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  List<StoreSchedule>? get storeSchedules => throw _privateConstructorUsedError;
  String? get dietary => throw _privateConstructorUsedError;
  List<Product>? get featuredItems => throw _privateConstructorUsedError;
  String get priceCategory => throw _privateConstructorUsedError;
  int? get groupSize => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  List<Offer>? get offers => throw _privateConstructorUsedError;
  List<Aisle>? get aisles => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get logo => throw _privateConstructorUsedError;
  bool get doesPickup => throw _privateConstructorUsedError;
  List<ProductCategory>? get productCategories =>
      throw _privateConstructorUsedError;
  Delivery get delivery => throw _privateConstructorUsedError;
  Rating get rating => throw _privateConstructorUsedError;
  String get cardImage => throw _privateConstructorUsedError;
  bool get bestOverall => throw _privateConstructorUsedError;
  int get visits => throw _privateConstructorUsedError;
  DateTime get openingTime => throw _privateConstructorUsedError;
  DateTime get closingTime => throw _privateConstructorUsedError;

  /// Serializes this Store to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreCopyWith<Store> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreCopyWith<$Res> {
  factory $StoreCopyWith(Store value, $Res Function(Store) then) =
      _$StoreCopyWithImpl<$Res, Store>;
  @useResult
  $Res call(
      {bool isUberOneShop,
      StoreLocation location,
      String id,
      List<StoreSchedule>? storeSchedules,
      String? dietary,
      List<Product>? featuredItems,
      String priceCategory,
      int? groupSize,
      String type,
      List<Offer>? offers,
      List<Aisle>? aisles,
      String name,
      String logo,
      bool doesPickup,
      List<ProductCategory>? productCategories,
      Delivery delivery,
      Rating rating,
      String cardImage,
      bool bestOverall,
      int visits,
      DateTime openingTime,
      DateTime closingTime});

  $StoreLocationCopyWith<$Res> get location;
  $DeliveryCopyWith<$Res> get delivery;
  $RatingCopyWith<$Res> get rating;
}

/// @nodoc
class _$StoreCopyWithImpl<$Res, $Val extends Store>
    implements $StoreCopyWith<$Res> {
  _$StoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isUberOneShop = null,
    Object? location = null,
    Object? id = null,
    Object? storeSchedules = freezed,
    Object? dietary = freezed,
    Object? featuredItems = freezed,
    Object? priceCategory = null,
    Object? groupSize = freezed,
    Object? type = null,
    Object? offers = freezed,
    Object? aisles = freezed,
    Object? name = null,
    Object? logo = null,
    Object? doesPickup = null,
    Object? productCategories = freezed,
    Object? delivery = null,
    Object? rating = null,
    Object? cardImage = null,
    Object? bestOverall = null,
    Object? visits = null,
    Object? openingTime = null,
    Object? closingTime = null,
  }) {
    return _then(_value.copyWith(
      isUberOneShop: null == isUberOneShop
          ? _value.isUberOneShop
          : isUberOneShop // ignore: cast_nullable_to_non_nullable
              as bool,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as StoreLocation,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeSchedules: freezed == storeSchedules
          ? _value.storeSchedules
          : storeSchedules // ignore: cast_nullable_to_non_nullable
              as List<StoreSchedule>?,
      dietary: freezed == dietary
          ? _value.dietary
          : dietary // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredItems: freezed == featuredItems
          ? _value.featuredItems
          : featuredItems // ignore: cast_nullable_to_non_nullable
              as List<Product>?,
      priceCategory: null == priceCategory
          ? _value.priceCategory
          : priceCategory // ignore: cast_nullable_to_non_nullable
              as String,
      groupSize: freezed == groupSize
          ? _value.groupSize
          : groupSize // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      offers: freezed == offers
          ? _value.offers
          : offers // ignore: cast_nullable_to_non_nullable
              as List<Offer>?,
      aisles: freezed == aisles
          ? _value.aisles
          : aisles // ignore: cast_nullable_to_non_nullable
              as List<Aisle>?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
      doesPickup: null == doesPickup
          ? _value.doesPickup
          : doesPickup // ignore: cast_nullable_to_non_nullable
              as bool,
      productCategories: freezed == productCategories
          ? _value.productCategories
          : productCategories // ignore: cast_nullable_to_non_nullable
              as List<ProductCategory>?,
      delivery: null == delivery
          ? _value.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as Delivery,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as Rating,
      cardImage: null == cardImage
          ? _value.cardImage
          : cardImage // ignore: cast_nullable_to_non_nullable
              as String,
      bestOverall: null == bestOverall
          ? _value.bestOverall
          : bestOverall // ignore: cast_nullable_to_non_nullable
              as bool,
      visits: null == visits
          ? _value.visits
          : visits // ignore: cast_nullable_to_non_nullable
              as int,
      openingTime: null == openingTime
          ? _value.openingTime
          : openingTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      closingTime: null == closingTime
          ? _value.closingTime
          : closingTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoreLocationCopyWith<$Res> get location {
    return $StoreLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliveryCopyWith<$Res> get delivery {
    return $DeliveryCopyWith<$Res>(_value.delivery, (value) {
      return _then(_value.copyWith(delivery: value) as $Val);
    });
  }

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RatingCopyWith<$Res> get rating {
    return $RatingCopyWith<$Res>(_value.rating, (value) {
      return _then(_value.copyWith(rating: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoreImplCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$$StoreImplCopyWith(
          _$StoreImpl value, $Res Function(_$StoreImpl) then) =
      __$$StoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isUberOneShop,
      StoreLocation location,
      String id,
      List<StoreSchedule>? storeSchedules,
      String? dietary,
      List<Product>? featuredItems,
      String priceCategory,
      int? groupSize,
      String type,
      List<Offer>? offers,
      List<Aisle>? aisles,
      String name,
      String logo,
      bool doesPickup,
      List<ProductCategory>? productCategories,
      Delivery delivery,
      Rating rating,
      String cardImage,
      bool bestOverall,
      int visits,
      DateTime openingTime,
      DateTime closingTime});

  @override
  $StoreLocationCopyWith<$Res> get location;
  @override
  $DeliveryCopyWith<$Res> get delivery;
  @override
  $RatingCopyWith<$Res> get rating;
}

/// @nodoc
class __$$StoreImplCopyWithImpl<$Res>
    extends _$StoreCopyWithImpl<$Res, _$StoreImpl>
    implements _$$StoreImplCopyWith<$Res> {
  __$$StoreImplCopyWithImpl(
      _$StoreImpl _value, $Res Function(_$StoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isUberOneShop = null,
    Object? location = null,
    Object? id = null,
    Object? storeSchedules = freezed,
    Object? dietary = freezed,
    Object? featuredItems = freezed,
    Object? priceCategory = null,
    Object? groupSize = freezed,
    Object? type = null,
    Object? offers = freezed,
    Object? aisles = freezed,
    Object? name = null,
    Object? logo = null,
    Object? doesPickup = null,
    Object? productCategories = freezed,
    Object? delivery = null,
    Object? rating = null,
    Object? cardImage = null,
    Object? bestOverall = null,
    Object? visits = null,
    Object? openingTime = null,
    Object? closingTime = null,
  }) {
    return _then(_$StoreImpl(
      isUberOneShop: null == isUberOneShop
          ? _value.isUberOneShop
          : isUberOneShop // ignore: cast_nullable_to_non_nullable
              as bool,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as StoreLocation,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeSchedules: freezed == storeSchedules
          ? _value._storeSchedules
          : storeSchedules // ignore: cast_nullable_to_non_nullable
              as List<StoreSchedule>?,
      dietary: freezed == dietary
          ? _value.dietary
          : dietary // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredItems: freezed == featuredItems
          ? _value._featuredItems
          : featuredItems // ignore: cast_nullable_to_non_nullable
              as List<Product>?,
      priceCategory: null == priceCategory
          ? _value.priceCategory
          : priceCategory // ignore: cast_nullable_to_non_nullable
              as String,
      groupSize: freezed == groupSize
          ? _value.groupSize
          : groupSize // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      offers: freezed == offers
          ? _value._offers
          : offers // ignore: cast_nullable_to_non_nullable
              as List<Offer>?,
      aisles: freezed == aisles
          ? _value._aisles
          : aisles // ignore: cast_nullable_to_non_nullable
              as List<Aisle>?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
      doesPickup: null == doesPickup
          ? _value.doesPickup
          : doesPickup // ignore: cast_nullable_to_non_nullable
              as bool,
      productCategories: freezed == productCategories
          ? _value._productCategories
          : productCategories // ignore: cast_nullable_to_non_nullable
              as List<ProductCategory>?,
      delivery: null == delivery
          ? _value.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as Delivery,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as Rating,
      cardImage: null == cardImage
          ? _value.cardImage
          : cardImage // ignore: cast_nullable_to_non_nullable
              as String,
      bestOverall: null == bestOverall
          ? _value.bestOverall
          : bestOverall // ignore: cast_nullable_to_non_nullable
              as bool,
      visits: null == visits
          ? _value.visits
          : visits // ignore: cast_nullable_to_non_nullable
              as int,
      openingTime: null == openingTime
          ? _value.openingTime
          : openingTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      closingTime: null == closingTime
          ? _value.closingTime
          : closingTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreImpl with DiagnosticableTreeMixin implements _Store {
  _$StoreImpl(
      {this.isUberOneShop = false,
      required this.location,
      required this.id,
      final List<StoreSchedule>? storeSchedules,
      this.dietary,
      final List<Product>? featuredItems,
      required this.priceCategory,
      this.groupSize,
      required this.type,
      final List<Offer>? offers,
      final List<Aisle>? aisles,
      required this.name,
      required this.logo,
      required this.doesPickup,
      final List<ProductCategory>? productCategories,
      required this.delivery,
      required this.rating,
      required this.cardImage,
      this.bestOverall = false,
      this.visits = 0,
      required this.openingTime,
      required this.closingTime})
      : _storeSchedules = storeSchedules,
        _featuredItems = featuredItems,
        _offers = offers,
        _aisles = aisles,
        _productCategories = productCategories;

  factory _$StoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreImplFromJson(json);

  @override
  @JsonKey()
  final bool isUberOneShop;
  @override
  final StoreLocation location;
  @override
  final String id;
  final List<StoreSchedule>? _storeSchedules;
  @override
  List<StoreSchedule>? get storeSchedules {
    final value = _storeSchedules;
    if (value == null) return null;
    if (_storeSchedules is EqualUnmodifiableListView) return _storeSchedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? dietary;
  final List<Product>? _featuredItems;
  @override
  List<Product>? get featuredItems {
    final value = _featuredItems;
    if (value == null) return null;
    if (_featuredItems is EqualUnmodifiableListView) return _featuredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String priceCategory;
  @override
  final int? groupSize;
  @override
  final String type;
  final List<Offer>? _offers;
  @override
  List<Offer>? get offers {
    final value = _offers;
    if (value == null) return null;
    if (_offers is EqualUnmodifiableListView) return _offers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Aisle>? _aisles;
  @override
  List<Aisle>? get aisles {
    final value = _aisles;
    if (value == null) return null;
    if (_aisles is EqualUnmodifiableListView) return _aisles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String name;
  @override
  final String logo;
  @override
  final bool doesPickup;
  final List<ProductCategory>? _productCategories;
  @override
  List<ProductCategory>? get productCategories {
    final value = _productCategories;
    if (value == null) return null;
    if (_productCategories is EqualUnmodifiableListView)
      return _productCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Delivery delivery;
  @override
  final Rating rating;
  @override
  final String cardImage;
  @override
  @JsonKey()
  final bool bestOverall;
  @override
  @JsonKey()
  final int visits;
  @override
  final DateTime openingTime;
  @override
  final DateTime closingTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Store(isUberOneShop: $isUberOneShop, location: $location, id: $id, storeSchedules: $storeSchedules, dietary: $dietary, featuredItems: $featuredItems, priceCategory: $priceCategory, groupSize: $groupSize, type: $type, offers: $offers, aisles: $aisles, name: $name, logo: $logo, doesPickup: $doesPickup, productCategories: $productCategories, delivery: $delivery, rating: $rating, cardImage: $cardImage, bestOverall: $bestOverall, visits: $visits, openingTime: $openingTime, closingTime: $closingTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Store'))
      ..add(DiagnosticsProperty('isUberOneShop', isUberOneShop))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('storeSchedules', storeSchedules))
      ..add(DiagnosticsProperty('dietary', dietary))
      ..add(DiagnosticsProperty('featuredItems', featuredItems))
      ..add(DiagnosticsProperty('priceCategory', priceCategory))
      ..add(DiagnosticsProperty('groupSize', groupSize))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('offers', offers))
      ..add(DiagnosticsProperty('aisles', aisles))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('logo', logo))
      ..add(DiagnosticsProperty('doesPickup', doesPickup))
      ..add(DiagnosticsProperty('productCategories', productCategories))
      ..add(DiagnosticsProperty('delivery', delivery))
      ..add(DiagnosticsProperty('rating', rating))
      ..add(DiagnosticsProperty('cardImage', cardImage))
      ..add(DiagnosticsProperty('bestOverall', bestOverall))
      ..add(DiagnosticsProperty('visits', visits))
      ..add(DiagnosticsProperty('openingTime', openingTime))
      ..add(DiagnosticsProperty('closingTime', closingTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreImpl &&
            (identical(other.isUberOneShop, isUberOneShop) ||
                other.isUberOneShop == isUberOneShop) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._storeSchedules, _storeSchedules) &&
            (identical(other.dietary, dietary) || other.dietary == dietary) &&
            const DeepCollectionEquality()
                .equals(other._featuredItems, _featuredItems) &&
            (identical(other.priceCategory, priceCategory) ||
                other.priceCategory == priceCategory) &&
            (identical(other.groupSize, groupSize) ||
                other.groupSize == groupSize) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._offers, _offers) &&
            const DeepCollectionEquality().equals(other._aisles, _aisles) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.doesPickup, doesPickup) ||
                other.doesPickup == doesPickup) &&
            const DeepCollectionEquality()
                .equals(other._productCategories, _productCategories) &&
            (identical(other.delivery, delivery) ||
                other.delivery == delivery) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.cardImage, cardImage) ||
                other.cardImage == cardImage) &&
            (identical(other.bestOverall, bestOverall) ||
                other.bestOverall == bestOverall) &&
            (identical(other.visits, visits) || other.visits == visits) &&
            (identical(other.openingTime, openingTime) ||
                other.openingTime == openingTime) &&
            (identical(other.closingTime, closingTime) ||
                other.closingTime == closingTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isUberOneShop,
        location,
        id,
        const DeepCollectionEquality().hash(_storeSchedules),
        dietary,
        const DeepCollectionEquality().hash(_featuredItems),
        priceCategory,
        groupSize,
        type,
        const DeepCollectionEquality().hash(_offers),
        const DeepCollectionEquality().hash(_aisles),
        name,
        logo,
        doesPickup,
        const DeepCollectionEquality().hash(_productCategories),
        delivery,
        rating,
        cardImage,
        bestOverall,
        visits,
        openingTime,
        closingTime
      ]);

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      __$$StoreImplCopyWithImpl<_$StoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreImplToJson(
      this,
    );
  }
}

abstract class _Store implements Store {
  factory _Store(
      {final bool isUberOneShop,
      required final StoreLocation location,
      required final String id,
      final List<StoreSchedule>? storeSchedules,
      final String? dietary,
      final List<Product>? featuredItems,
      required final String priceCategory,
      final int? groupSize,
      required final String type,
      final List<Offer>? offers,
      final List<Aisle>? aisles,
      required final String name,
      required final String logo,
      required final bool doesPickup,
      final List<ProductCategory>? productCategories,
      required final Delivery delivery,
      required final Rating rating,
      required final String cardImage,
      final bool bestOverall,
      final int visits,
      required final DateTime openingTime,
      required final DateTime closingTime}) = _$StoreImpl;

  factory _Store.fromJson(Map<String, dynamic> json) = _$StoreImpl.fromJson;

  @override
  bool get isUberOneShop;
  @override
  StoreLocation get location;
  @override
  String get id;
  @override
  List<StoreSchedule>? get storeSchedules;
  @override
  String? get dietary;
  @override
  List<Product>? get featuredItems;
  @override
  String get priceCategory;
  @override
  int? get groupSize;
  @override
  String get type;
  @override
  List<Offer>? get offers;
  @override
  List<Aisle>? get aisles;
  @override
  String get name;
  @override
  String get logo;
  @override
  bool get doesPickup;
  @override
  List<ProductCategory>? get productCategories;
  @override
  Delivery get delivery;
  @override
  Rating get rating;
  @override
  String get cardImage;
  @override
  bool get bestOverall;
  @override
  int get visits;
  @override
  DateTime get openingTime;
  @override
  DateTime get closingTime;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreSchedule _$StoreScheduleFromJson(Map<String, dynamic> json) {
  return _StoreSchedule.fromJson(json);
}

/// @nodoc
mixin _$StoreSchedule {
  String get name => throw _privateConstructorUsedError;
  String get duration => throw _privateConstructorUsedError;

  /// Serializes this StoreSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreScheduleCopyWith<StoreSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreScheduleCopyWith<$Res> {
  factory $StoreScheduleCopyWith(
          StoreSchedule value, $Res Function(StoreSchedule) then) =
      _$StoreScheduleCopyWithImpl<$Res, StoreSchedule>;
  @useResult
  $Res call({String name, String duration});
}

/// @nodoc
class _$StoreScheduleCopyWithImpl<$Res, $Val extends StoreSchedule>
    implements $StoreScheduleCopyWith<$Res> {
  _$StoreScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? duration = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreScheduleImplCopyWith<$Res>
    implements $StoreScheduleCopyWith<$Res> {
  factory _$$StoreScheduleImplCopyWith(
          _$StoreScheduleImpl value, $Res Function(_$StoreScheduleImpl) then) =
      __$$StoreScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String duration});
}

/// @nodoc
class __$$StoreScheduleImplCopyWithImpl<$Res>
    extends _$StoreScheduleCopyWithImpl<$Res, _$StoreScheduleImpl>
    implements _$$StoreScheduleImplCopyWith<$Res> {
  __$$StoreScheduleImplCopyWithImpl(
      _$StoreScheduleImpl _value, $Res Function(_$StoreScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? duration = null,
  }) {
    return _then(_$StoreScheduleImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreScheduleImpl
    with DiagnosticableTreeMixin
    implements _StoreSchedule {
  _$StoreScheduleImpl({required this.name, required this.duration});

  factory _$StoreScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreScheduleImplFromJson(json);

  @override
  final String name;
  @override
  final String duration;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StoreSchedule(name: $name, duration: $duration)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'StoreSchedule'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('duration', duration));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreScheduleImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, duration);

  /// Create a copy of StoreSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreScheduleImplCopyWith<_$StoreScheduleImpl> get copyWith =>
      __$$StoreScheduleImplCopyWithImpl<_$StoreScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreScheduleImplToJson(
      this,
    );
  }
}

abstract class _StoreSchedule implements StoreSchedule {
  factory _StoreSchedule(
      {required final String name,
      required final String duration}) = _$StoreScheduleImpl;

  factory _StoreSchedule.fromJson(Map<String, dynamic> json) =
      _$StoreScheduleImpl.fromJson;

  @override
  String get name;
  @override
  String get duration;

  /// Create a copy of StoreSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreScheduleImplCopyWith<_$StoreScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Aisle _$AisleFromJson(Map<String, dynamic> json) {
  return _Aisle.fromJson(json);
}

/// @nodoc
mixin _$Aisle {
  String get name => throw _privateConstructorUsedError;
  List<ProductCategory> get productCategories =>
      throw _privateConstructorUsedError;

  /// Serializes this Aisle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Aisle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AisleCopyWith<Aisle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AisleCopyWith<$Res> {
  factory $AisleCopyWith(Aisle value, $Res Function(Aisle) then) =
      _$AisleCopyWithImpl<$Res, Aisle>;
  @useResult
  $Res call({String name, List<ProductCategory> productCategories});
}

/// @nodoc
class _$AisleCopyWithImpl<$Res, $Val extends Aisle>
    implements $AisleCopyWith<$Res> {
  _$AisleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Aisle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? productCategories = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      productCategories: null == productCategories
          ? _value.productCategories
          : productCategories // ignore: cast_nullable_to_non_nullable
              as List<ProductCategory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AisleImplCopyWith<$Res> implements $AisleCopyWith<$Res> {
  factory _$$AisleImplCopyWith(
          _$AisleImpl value, $Res Function(_$AisleImpl) then) =
      __$$AisleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<ProductCategory> productCategories});
}

/// @nodoc
class __$$AisleImplCopyWithImpl<$Res>
    extends _$AisleCopyWithImpl<$Res, _$AisleImpl>
    implements _$$AisleImplCopyWith<$Res> {
  __$$AisleImplCopyWithImpl(
      _$AisleImpl _value, $Res Function(_$AisleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Aisle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? productCategories = null,
  }) {
    return _then(_$AisleImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      productCategories: null == productCategories
          ? _value._productCategories
          : productCategories // ignore: cast_nullable_to_non_nullable
              as List<ProductCategory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AisleImpl with DiagnosticableTreeMixin implements _Aisle {
  _$AisleImpl(
      {required this.name,
      required final List<ProductCategory> productCategories})
      : _productCategories = productCategories;

  factory _$AisleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AisleImplFromJson(json);

  @override
  final String name;
  final List<ProductCategory> _productCategories;
  @override
  List<ProductCategory> get productCategories {
    if (_productCategories is EqualUnmodifiableListView)
      return _productCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productCategories);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Aisle(name: $name, productCategories: $productCategories)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Aisle'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('productCategories', productCategories));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AisleImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._productCategories, _productCategories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name,
      const DeepCollectionEquality().hash(_productCategories));

  /// Create a copy of Aisle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AisleImplCopyWith<_$AisleImpl> get copyWith =>
      __$$AisleImplCopyWithImpl<_$AisleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AisleImplToJson(
      this,
    );
  }
}

abstract class _Aisle implements Aisle {
  factory _Aisle(
      {required final String name,
      required final List<ProductCategory> productCategories}) = _$AisleImpl;

  factory _Aisle.fromJson(Map<String, dynamic> json) = _$AisleImpl.fromJson;

  @override
  String get name;
  @override
  List<ProductCategory> get productCategories;

  /// Create a copy of Aisle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AisleImplCopyWith<_$AisleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Rating _$RatingFromJson(Map<String, dynamic> json) {
  return _Rating.fromJson(json);
}

/// @nodoc
mixin _$Rating {
  double get averageRating => throw _privateConstructorUsedError;
  int get ratings => throw _privateConstructorUsedError;

  /// Serializes this Rating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RatingCopyWith<Rating> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingCopyWith<$Res> {
  factory $RatingCopyWith(Rating value, $Res Function(Rating) then) =
      _$RatingCopyWithImpl<$Res, Rating>;
  @useResult
  $Res call({double averageRating, int ratings});
}

/// @nodoc
class _$RatingCopyWithImpl<$Res, $Val extends Rating>
    implements $RatingCopyWith<$Res> {
  _$RatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? ratings = null,
  }) {
    return _then(_value.copyWith(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RatingImplCopyWith<$Res> implements $RatingCopyWith<$Res> {
  factory _$$RatingImplCopyWith(
          _$RatingImpl value, $Res Function(_$RatingImpl) then) =
      __$$RatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double averageRating, int ratings});
}

/// @nodoc
class __$$RatingImplCopyWithImpl<$Res>
    extends _$RatingCopyWithImpl<$Res, _$RatingImpl>
    implements _$$RatingImplCopyWith<$Res> {
  __$$RatingImplCopyWithImpl(
      _$RatingImpl _value, $Res Function(_$RatingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? ratings = null,
  }) {
    return _then(_$RatingImpl(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RatingImpl with DiagnosticableTreeMixin implements _Rating {
  _$RatingImpl({required this.averageRating, required this.ratings});

  factory _$RatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$RatingImplFromJson(json);

  @override
  final double averageRating;
  @override
  final int ratings;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Rating(averageRating: $averageRating, ratings: $ratings)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Rating'))
      ..add(DiagnosticsProperty('averageRating', averageRating))
      ..add(DiagnosticsProperty('ratings', ratings));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatingImpl &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.ratings, ratings) || other.ratings == ratings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, averageRating, ratings);

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RatingImplCopyWith<_$RatingImpl> get copyWith =>
      __$$RatingImplCopyWithImpl<_$RatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RatingImplToJson(
      this,
    );
  }
}

abstract class _Rating implements Rating {
  factory _Rating(
      {required final double averageRating,
      required final int ratings}) = _$RatingImpl;

  factory _Rating.fromJson(Map<String, dynamic> json) = _$RatingImpl.fromJson;

  @override
  double get averageRating;
  @override
  int get ratings;

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RatingImplCopyWith<_$RatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreLocation _$StoreLocationFromJson(Map<String, dynamic> json) {
  return _StoreLocation.fromJson(json);
}

/// @nodoc
mixin _$StoreLocation {
  String get countryOfOrigin => throw _privateConstructorUsedError;
  String get streetAddress =>
      throw _privateConstructorUsedError; // @GeoPointConverter() required GeoPoint latlng,
  Object get latlng => throw _privateConstructorUsedError;

  /// Serializes this StoreLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreLocationCopyWith<StoreLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreLocationCopyWith<$Res> {
  factory $StoreLocationCopyWith(
          StoreLocation value, $Res Function(StoreLocation) then) =
      _$StoreLocationCopyWithImpl<$Res, StoreLocation>;
  @useResult
  $Res call({String countryOfOrigin, String streetAddress, Object latlng});
}

/// @nodoc
class _$StoreLocationCopyWithImpl<$Res, $Val extends StoreLocation>
    implements $StoreLocationCopyWith<$Res> {
  _$StoreLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryOfOrigin = null,
    Object? streetAddress = null,
    Object? latlng = null,
  }) {
    return _then(_value.copyWith(
      countryOfOrigin: null == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String,
      streetAddress: null == streetAddress
          ? _value.streetAddress
          : streetAddress // ignore: cast_nullable_to_non_nullable
              as String,
      latlng: null == latlng ? _value.latlng : latlng,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreLocationImplCopyWith<$Res>
    implements $StoreLocationCopyWith<$Res> {
  factory _$$StoreLocationImplCopyWith(
          _$StoreLocationImpl value, $Res Function(_$StoreLocationImpl) then) =
      __$$StoreLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String countryOfOrigin, String streetAddress, Object latlng});
}

/// @nodoc
class __$$StoreLocationImplCopyWithImpl<$Res>
    extends _$StoreLocationCopyWithImpl<$Res, _$StoreLocationImpl>
    implements _$$StoreLocationImplCopyWith<$Res> {
  __$$StoreLocationImplCopyWithImpl(
      _$StoreLocationImpl _value, $Res Function(_$StoreLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryOfOrigin = null,
    Object? streetAddress = null,
    Object? latlng = null,
  }) {
    return _then(_$StoreLocationImpl(
      countryOfOrigin: null == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String,
      streetAddress: null == streetAddress
          ? _value.streetAddress
          : streetAddress // ignore: cast_nullable_to_non_nullable
              as String,
      latlng: null == latlng ? _value.latlng : latlng,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreLocationImpl
    with DiagnosticableTreeMixin
    implements _StoreLocation {
  _$StoreLocationImpl(
      {required this.countryOfOrigin,
      required this.streetAddress,
      required this.latlng});

  factory _$StoreLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreLocationImplFromJson(json);

  @override
  final String countryOfOrigin;
  @override
  final String streetAddress;
// @GeoPointConverter() required GeoPoint latlng,
  @override
  final Object latlng;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StoreLocation(countryOfOrigin: $countryOfOrigin, streetAddress: $streetAddress, latlng: $latlng)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'StoreLocation'))
      ..add(DiagnosticsProperty('countryOfOrigin', countryOfOrigin))
      ..add(DiagnosticsProperty('streetAddress', streetAddress))
      ..add(DiagnosticsProperty('latlng', latlng));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreLocationImpl &&
            (identical(other.countryOfOrigin, countryOfOrigin) ||
                other.countryOfOrigin == countryOfOrigin) &&
            (identical(other.streetAddress, streetAddress) ||
                other.streetAddress == streetAddress) &&
            const DeepCollectionEquality().equals(other.latlng, latlng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, countryOfOrigin, streetAddress,
      const DeepCollectionEquality().hash(latlng));

  /// Create a copy of StoreLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreLocationImplCopyWith<_$StoreLocationImpl> get copyWith =>
      __$$StoreLocationImplCopyWithImpl<_$StoreLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreLocationImplToJson(
      this,
    );
  }
}

abstract class _StoreLocation implements StoreLocation {
  factory _StoreLocation(
      {required final String countryOfOrigin,
      required final String streetAddress,
      required final Object latlng}) = _$StoreLocationImpl;

  factory _StoreLocation.fromJson(Map<String, dynamic> json) =
      _$StoreLocationImpl.fromJson;

  @override
  String get countryOfOrigin;
  @override
  String get streetAddress; // @GeoPointConverter() required GeoPoint latlng,
  @override
  Object get latlng;

  /// Create a copy of StoreLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreLocationImplCopyWith<_$StoreLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) {
  return _ProductCategory.fromJson(json);
}

/// @nodoc
mixin _$ProductCategory {
  String get name => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get productsAndQuantities =>
      throw _privateConstructorUsedError;

  /// Serializes this ProductCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCategoryCopyWith<ProductCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCategoryCopyWith<$Res> {
  factory $ProductCategoryCopyWith(
          ProductCategory value, $Res Function(ProductCategory) then) =
      _$ProductCategoryCopyWithImpl<$Res, ProductCategory>;
  @useResult
  $Res call({String name, List<Map<String, dynamic>> productsAndQuantities});
}

/// @nodoc
class _$ProductCategoryCopyWithImpl<$Res, $Val extends ProductCategory>
    implements $ProductCategoryCopyWith<$Res> {
  _$ProductCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? productsAndQuantities = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      productsAndQuantities: null == productsAndQuantities
          ? _value.productsAndQuantities
          : productsAndQuantities // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductCategoryImplCopyWith<$Res>
    implements $ProductCategoryCopyWith<$Res> {
  factory _$$ProductCategoryImplCopyWith(_$ProductCategoryImpl value,
          $Res Function(_$ProductCategoryImpl) then) =
      __$$ProductCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<Map<String, dynamic>> productsAndQuantities});
}

/// @nodoc
class __$$ProductCategoryImplCopyWithImpl<$Res>
    extends _$ProductCategoryCopyWithImpl<$Res, _$ProductCategoryImpl>
    implements _$$ProductCategoryImplCopyWith<$Res> {
  __$$ProductCategoryImplCopyWithImpl(
      _$ProductCategoryImpl _value, $Res Function(_$ProductCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? productsAndQuantities = null,
  }) {
    return _then(_$ProductCategoryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      productsAndQuantities: null == productsAndQuantities
          ? _value._productsAndQuantities
          : productsAndQuantities // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductCategoryImpl
    with DiagnosticableTreeMixin
    implements _ProductCategory {
  _$ProductCategoryImpl(
      {required this.name,
      required final List<Map<String, dynamic>> productsAndQuantities})
      : _productsAndQuantities = productsAndQuantities;

  factory _$ProductCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductCategoryImplFromJson(json);

  @override
  final String name;
  final List<Map<String, dynamic>> _productsAndQuantities;
  @override
  List<Map<String, dynamic>> get productsAndQuantities {
    if (_productsAndQuantities is EqualUnmodifiableListView)
      return _productsAndQuantities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productsAndQuantities);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductCategory(name: $name, productsAndQuantities: $productsAndQuantities)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductCategory'))
      ..add(DiagnosticsProperty('name', name))
      ..add(
          DiagnosticsProperty('productsAndQuantities', productsAndQuantities));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductCategoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._productsAndQuantities, _productsAndQuantities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name,
      const DeepCollectionEquality().hash(_productsAndQuantities));

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductCategoryImplCopyWith<_$ProductCategoryImpl> get copyWith =>
      __$$ProductCategoryImplCopyWithImpl<_$ProductCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductCategoryImplToJson(
      this,
    );
  }
}

abstract class _ProductCategory implements ProductCategory {
  factory _ProductCategory(
          {required final String name,
          required final List<Map<String, dynamic>> productsAndQuantities}) =
      _$ProductCategoryImpl;

  factory _ProductCategory.fromJson(Map<String, dynamic> json) =
      _$ProductCategoryImpl.fromJson;

  @override
  String get name;
  @override
  List<Map<String, dynamic>> get productsAndQuantities;

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductCategoryImplCopyWith<_$ProductCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Delivery _$DeliveryFromJson(Map<String, dynamic> json) {
  return _Delivery.fromJson(json);
}

/// @nodoc
mixin _$Delivery {
  bool get canDeliver => throw _privateConstructorUsedError;
  String get estimatedDeliveryTime => throw _privateConstructorUsedError;
  double get fee => throw _privateConstructorUsedError;

  /// Serializes this Delivery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryCopyWith<Delivery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryCopyWith<$Res> {
  factory $DeliveryCopyWith(Delivery value, $Res Function(Delivery) then) =
      _$DeliveryCopyWithImpl<$Res, Delivery>;
  @useResult
  $Res call({bool canDeliver, String estimatedDeliveryTime, double fee});
}

/// @nodoc
class _$DeliveryCopyWithImpl<$Res, $Val extends Delivery>
    implements $DeliveryCopyWith<$Res> {
  _$DeliveryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canDeliver = null,
    Object? estimatedDeliveryTime = null,
    Object? fee = null,
  }) {
    return _then(_value.copyWith(
      canDeliver: null == canDeliver
          ? _value.canDeliver
          : canDeliver // ignore: cast_nullable_to_non_nullable
              as bool,
      estimatedDeliveryTime: null == estimatedDeliveryTime
          ? _value.estimatedDeliveryTime
          : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
              as String,
      fee: null == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryImplCopyWith<$Res>
    implements $DeliveryCopyWith<$Res> {
  factory _$$DeliveryImplCopyWith(
          _$DeliveryImpl value, $Res Function(_$DeliveryImpl) then) =
      __$$DeliveryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool canDeliver, String estimatedDeliveryTime, double fee});
}

/// @nodoc
class __$$DeliveryImplCopyWithImpl<$Res>
    extends _$DeliveryCopyWithImpl<$Res, _$DeliveryImpl>
    implements _$$DeliveryImplCopyWith<$Res> {
  __$$DeliveryImplCopyWithImpl(
      _$DeliveryImpl _value, $Res Function(_$DeliveryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canDeliver = null,
    Object? estimatedDeliveryTime = null,
    Object? fee = null,
  }) {
    return _then(_$DeliveryImpl(
      canDeliver: null == canDeliver
          ? _value.canDeliver
          : canDeliver // ignore: cast_nullable_to_non_nullable
              as bool,
      estimatedDeliveryTime: null == estimatedDeliveryTime
          ? _value.estimatedDeliveryTime
          : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
              as String,
      fee: null == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryImpl with DiagnosticableTreeMixin implements _Delivery {
  _$DeliveryImpl(
      {required this.canDeliver,
      required this.estimatedDeliveryTime,
      required this.fee});

  factory _$DeliveryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryImplFromJson(json);

  @override
  final bool canDeliver;
  @override
  final String estimatedDeliveryTime;
  @override
  final double fee;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Delivery(canDeliver: $canDeliver, estimatedDeliveryTime: $estimatedDeliveryTime, fee: $fee)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Delivery'))
      ..add(DiagnosticsProperty('canDeliver', canDeliver))
      ..add(DiagnosticsProperty('estimatedDeliveryTime', estimatedDeliveryTime))
      ..add(DiagnosticsProperty('fee', fee));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryImpl &&
            (identical(other.canDeliver, canDeliver) ||
                other.canDeliver == canDeliver) &&
            (identical(other.estimatedDeliveryTime, estimatedDeliveryTime) ||
                other.estimatedDeliveryTime == estimatedDeliveryTime) &&
            (identical(other.fee, fee) || other.fee == fee));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, canDeliver, estimatedDeliveryTime, fee);

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryImplCopyWith<_$DeliveryImpl> get copyWith =>
      __$$DeliveryImplCopyWithImpl<_$DeliveryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryImplToJson(
      this,
    );
  }
}

abstract class _Delivery implements Delivery {
  factory _Delivery(
      {required final bool canDeliver,
      required final String estimatedDeliveryTime,
      required final double fee}) = _$DeliveryImpl;

  factory _Delivery.fromJson(Map<String, dynamic> json) =
      _$DeliveryImpl.fromJson;

  @override
  bool get canDeliver;
  @override
  String get estimatedDeliveryTime;
  @override
  double get fee;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryImplCopyWith<_$DeliveryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get name => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  double get initialPrice => throw _privateConstructorUsedError;
  double? get promoPrice => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  List<Object>? get frequentlyBoughtTogether =>
      throw _privateConstructorUsedError;
  Map<String, String>? get nutritionFacts => throw _privateConstructorUsedError;
  String? get ingredients => throw _privateConstructorUsedError;
  String? get directions => throw _privateConstructorUsedError;
  String? get quantity => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<Option>? get options => throw _privateConstructorUsedError;
  bool get selectOptionRequired => throw _privateConstructorUsedError;
  double? get calories => throw _privateConstructorUsedError;
  bool? get isSoldOut => throw _privateConstructorUsedError;
  bool? get isSponsored => throw _privateConstructorUsedError;
  Object? get offer => throw _privateConstructorUsedError;
  List<Object>? get stores => throw _privateConstructorUsedError;
  List<Object> get similarProducts => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String name,
      String id,
      double initialPrice,
      double? promoPrice,
      List<String> imageUrls,
      List<Object>? frequentlyBoughtTogether,
      Map<String, String>? nutritionFacts,
      String? ingredients,
      String? directions,
      String? quantity,
      String? description,
      List<Option>? options,
      bool selectOptionRequired,
      double? calories,
      bool? isSoldOut,
      bool? isSponsored,
      Object? offer,
      List<Object>? stores,
      List<Object> similarProducts});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? initialPrice = null,
    Object? promoPrice = freezed,
    Object? imageUrls = null,
    Object? frequentlyBoughtTogether = freezed,
    Object? nutritionFacts = freezed,
    Object? ingredients = freezed,
    Object? directions = freezed,
    Object? quantity = freezed,
    Object? description = freezed,
    Object? options = freezed,
    Object? selectOptionRequired = null,
    Object? calories = freezed,
    Object? isSoldOut = freezed,
    Object? isSponsored = freezed,
    Object? offer = freezed,
    Object? stores = freezed,
    Object? similarProducts = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      initialPrice: null == initialPrice
          ? _value.initialPrice
          : initialPrice // ignore: cast_nullable_to_non_nullable
              as double,
      promoPrice: freezed == promoPrice
          ? _value.promoPrice
          : promoPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      frequentlyBoughtTogether: freezed == frequentlyBoughtTogether
          ? _value.frequentlyBoughtTogether
          : frequentlyBoughtTogether // ignore: cast_nullable_to_non_nullable
              as List<Object>?,
      nutritionFacts: freezed == nutritionFacts
          ? _value.nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as String?,
      directions: freezed == directions
          ? _value.directions
          : directions // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<Option>?,
      selectOptionRequired: null == selectOptionRequired
          ? _value.selectOptionRequired
          : selectOptionRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      isSoldOut: freezed == isSoldOut
          ? _value.isSoldOut
          : isSoldOut // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSponsored: freezed == isSponsored
          ? _value.isSponsored
          : isSponsored // ignore: cast_nullable_to_non_nullable
              as bool?,
      offer: freezed == offer ? _value.offer : offer,
      stores: freezed == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<Object>?,
      similarProducts: null == similarProducts
          ? _value.similarProducts
          : similarProducts // ignore: cast_nullable_to_non_nullable
              as List<Object>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String id,
      double initialPrice,
      double? promoPrice,
      List<String> imageUrls,
      List<Object>? frequentlyBoughtTogether,
      Map<String, String>? nutritionFacts,
      String? ingredients,
      String? directions,
      String? quantity,
      String? description,
      List<Option>? options,
      bool selectOptionRequired,
      double? calories,
      bool? isSoldOut,
      bool? isSponsored,
      Object? offer,
      List<Object>? stores,
      List<Object> similarProducts});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? initialPrice = null,
    Object? promoPrice = freezed,
    Object? imageUrls = null,
    Object? frequentlyBoughtTogether = freezed,
    Object? nutritionFacts = freezed,
    Object? ingredients = freezed,
    Object? directions = freezed,
    Object? quantity = freezed,
    Object? description = freezed,
    Object? options = freezed,
    Object? selectOptionRequired = null,
    Object? calories = freezed,
    Object? isSoldOut = freezed,
    Object? isSponsored = freezed,
    Object? offer = freezed,
    Object? stores = freezed,
    Object? similarProducts = null,
  }) {
    return _then(_$ProductImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      initialPrice: null == initialPrice
          ? _value.initialPrice
          : initialPrice // ignore: cast_nullable_to_non_nullable
              as double,
      promoPrice: freezed == promoPrice
          ? _value.promoPrice
          : promoPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      frequentlyBoughtTogether: freezed == frequentlyBoughtTogether
          ? _value._frequentlyBoughtTogether
          : frequentlyBoughtTogether // ignore: cast_nullable_to_non_nullable
              as List<Object>?,
      nutritionFacts: freezed == nutritionFacts
          ? _value._nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as String?,
      directions: freezed == directions
          ? _value.directions
          : directions // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<Option>?,
      selectOptionRequired: null == selectOptionRequired
          ? _value.selectOptionRequired
          : selectOptionRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      isSoldOut: freezed == isSoldOut
          ? _value.isSoldOut
          : isSoldOut // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSponsored: freezed == isSponsored
          ? _value.isSponsored
          : isSponsored // ignore: cast_nullable_to_non_nullable
              as bool?,
      offer: freezed == offer ? _value.offer : offer,
      stores: freezed == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<Object>?,
      similarProducts: null == similarProducts
          ? _value._similarProducts
          : similarProducts // ignore: cast_nullable_to_non_nullable
              as List<Object>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl with DiagnosticableTreeMixin implements _Product {
  _$ProductImpl(
      {required this.name,
      required this.id,
      required this.initialPrice,
      this.promoPrice,
      required final List<String> imageUrls,
      final List<Object>? frequentlyBoughtTogether,
      final Map<String, String>? nutritionFacts,
      this.ingredients,
      this.directions,
      this.quantity,
      this.description,
      final List<Option>? options,
      this.selectOptionRequired = false,
      this.calories,
      this.isSoldOut,
      this.isSponsored,
      this.offer,
      final List<Object>? stores,
      final List<Object> similarProducts = const []})
      : _imageUrls = imageUrls,
        _frequentlyBoughtTogether = frequentlyBoughtTogether,
        _nutritionFacts = nutritionFacts,
        _options = options,
        _stores = stores,
        _similarProducts = similarProducts;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String name;
  @override
  final String id;
  @override
  final double initialPrice;
  @override
  final double? promoPrice;
  final List<String> _imageUrls;
  @override
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  final List<Object>? _frequentlyBoughtTogether;
  @override
  List<Object>? get frequentlyBoughtTogether {
    final value = _frequentlyBoughtTogether;
    if (value == null) return null;
    if (_frequentlyBoughtTogether is EqualUnmodifiableListView)
      return _frequentlyBoughtTogether;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, String>? _nutritionFacts;
  @override
  Map<String, String>? get nutritionFacts {
    final value = _nutritionFacts;
    if (value == null) return null;
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? ingredients;
  @override
  final String? directions;
  @override
  final String? quantity;
  @override
  final String? description;
  final List<Option>? _options;
  @override
  List<Option>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool selectOptionRequired;
  @override
  final double? calories;
  @override
  final bool? isSoldOut;
  @override
  final bool? isSponsored;
  @override
  final Object? offer;
  final List<Object>? _stores;
  @override
  List<Object>? get stores {
    final value = _stores;
    if (value == null) return null;
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Object> _similarProducts;
  @override
  @JsonKey()
  List<Object> get similarProducts {
    if (_similarProducts is EqualUnmodifiableListView) return _similarProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_similarProducts);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Product(name: $name, id: $id, initialPrice: $initialPrice, promoPrice: $promoPrice, imageUrls: $imageUrls, frequentlyBoughtTogether: $frequentlyBoughtTogether, nutritionFacts: $nutritionFacts, ingredients: $ingredients, directions: $directions, quantity: $quantity, description: $description, options: $options, selectOptionRequired: $selectOptionRequired, calories: $calories, isSoldOut: $isSoldOut, isSponsored: $isSponsored, offer: $offer, stores: $stores, similarProducts: $similarProducts)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Product'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('initialPrice', initialPrice))
      ..add(DiagnosticsProperty('promoPrice', promoPrice))
      ..add(DiagnosticsProperty('imageUrls', imageUrls))
      ..add(DiagnosticsProperty(
          'frequentlyBoughtTogether', frequentlyBoughtTogether))
      ..add(DiagnosticsProperty('nutritionFacts', nutritionFacts))
      ..add(DiagnosticsProperty('ingredients', ingredients))
      ..add(DiagnosticsProperty('directions', directions))
      ..add(DiagnosticsProperty('quantity', quantity))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('options', options))
      ..add(DiagnosticsProperty('selectOptionRequired', selectOptionRequired))
      ..add(DiagnosticsProperty('calories', calories))
      ..add(DiagnosticsProperty('isSoldOut', isSoldOut))
      ..add(DiagnosticsProperty('isSponsored', isSponsored))
      ..add(DiagnosticsProperty('offer', offer))
      ..add(DiagnosticsProperty('stores', stores))
      ..add(DiagnosticsProperty('similarProducts', similarProducts));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.initialPrice, initialPrice) ||
                other.initialPrice == initialPrice) &&
            (identical(other.promoPrice, promoPrice) ||
                other.promoPrice == promoPrice) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality().equals(
                other._frequentlyBoughtTogether, _frequentlyBoughtTogether) &&
            const DeepCollectionEquality()
                .equals(other._nutritionFacts, _nutritionFacts) &&
            (identical(other.ingredients, ingredients) ||
                other.ingredients == ingredients) &&
            (identical(other.directions, directions) ||
                other.directions == directions) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.selectOptionRequired, selectOptionRequired) ||
                other.selectOptionRequired == selectOptionRequired) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.isSoldOut, isSoldOut) ||
                other.isSoldOut == isSoldOut) &&
            (identical(other.isSponsored, isSponsored) ||
                other.isSponsored == isSponsored) &&
            const DeepCollectionEquality().equals(other.offer, offer) &&
            const DeepCollectionEquality().equals(other._stores, _stores) &&
            const DeepCollectionEquality()
                .equals(other._similarProducts, _similarProducts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        id,
        initialPrice,
        promoPrice,
        const DeepCollectionEquality().hash(_imageUrls),
        const DeepCollectionEquality().hash(_frequentlyBoughtTogether),
        const DeepCollectionEquality().hash(_nutritionFacts),
        ingredients,
        directions,
        quantity,
        description,
        const DeepCollectionEquality().hash(_options),
        selectOptionRequired,
        calories,
        isSoldOut,
        isSponsored,
        const DeepCollectionEquality().hash(offer),
        const DeepCollectionEquality().hash(_stores),
        const DeepCollectionEquality().hash(_similarProducts)
      ]);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  factory _Product(
      {required final String name,
      required final String id,
      required final double initialPrice,
      final double? promoPrice,
      required final List<String> imageUrls,
      final List<Object>? frequentlyBoughtTogether,
      final Map<String, String>? nutritionFacts,
      final String? ingredients,
      final String? directions,
      final String? quantity,
      final String? description,
      final List<Option>? options,
      final bool selectOptionRequired,
      final double? calories,
      final bool? isSoldOut,
      final bool? isSponsored,
      final Object? offer,
      final List<Object>? stores,
      final List<Object> similarProducts}) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get name;
  @override
  String get id;
  @override
  double get initialPrice;
  @override
  double? get promoPrice;
  @override
  List<String> get imageUrls;
  @override
  List<Object>? get frequentlyBoughtTogether;
  @override
  Map<String, String>? get nutritionFacts;
  @override
  String? get ingredients;
  @override
  String? get directions;
  @override
  String? get quantity;
  @override
  String? get description;
  @override
  List<Option>? get options;
  @override
  bool get selectOptionRequired;
  @override
  double? get calories;
  @override
  bool? get isSoldOut;
  @override
  bool? get isSponsored;
  @override
  Object? get offer;
  @override
  List<Object>? get stores;
  @override
  List<Object> get similarProducts;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Option _$OptionFromJson(Map<String, dynamic> json) {
  return _Option.fromJson(json);
}

/// @nodoc
mixin _$Option {
  String get name => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  bool get isExclusive => throw _privateConstructorUsedError;
  List<SubOption>? get subOptions => throw _privateConstructorUsedError;
  double? get calories => throw _privateConstructorUsedError;
  bool get canBeMultiple => throw _privateConstructorUsedError;
  int? get canBeMultipleLimit => throw _privateConstructorUsedError;

  /// Serializes this Option to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Option
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptionCopyWith<Option> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptionCopyWith<$Res> {
  factory $OptionCopyWith(Option value, $Res Function(Option) then) =
      _$OptionCopyWithImpl<$Res, Option>;
  @useResult
  $Res call(
      {String name,
      double? price,
      bool isExclusive,
      List<SubOption>? subOptions,
      double? calories,
      bool canBeMultiple,
      int? canBeMultipleLimit});
}

/// @nodoc
class _$OptionCopyWithImpl<$Res, $Val extends Option>
    implements $OptionCopyWith<$Res> {
  _$OptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Option
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? price = freezed,
    Object? isExclusive = null,
    Object? subOptions = freezed,
    Object? calories = freezed,
    Object? canBeMultiple = null,
    Object? canBeMultipleLimit = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      isExclusive: null == isExclusive
          ? _value.isExclusive
          : isExclusive // ignore: cast_nullable_to_non_nullable
              as bool,
      subOptions: freezed == subOptions
          ? _value.subOptions
          : subOptions // ignore: cast_nullable_to_non_nullable
              as List<SubOption>?,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      canBeMultiple: null == canBeMultiple
          ? _value.canBeMultiple
          : canBeMultiple // ignore: cast_nullable_to_non_nullable
              as bool,
      canBeMultipleLimit: freezed == canBeMultipleLimit
          ? _value.canBeMultipleLimit
          : canBeMultipleLimit // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OptionImplCopyWith<$Res> implements $OptionCopyWith<$Res> {
  factory _$$OptionImplCopyWith(
          _$OptionImpl value, $Res Function(_$OptionImpl) then) =
      __$$OptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      double? price,
      bool isExclusive,
      List<SubOption>? subOptions,
      double? calories,
      bool canBeMultiple,
      int? canBeMultipleLimit});
}

/// @nodoc
class __$$OptionImplCopyWithImpl<$Res>
    extends _$OptionCopyWithImpl<$Res, _$OptionImpl>
    implements _$$OptionImplCopyWith<$Res> {
  __$$OptionImplCopyWithImpl(
      _$OptionImpl _value, $Res Function(_$OptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Option
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? price = freezed,
    Object? isExclusive = null,
    Object? subOptions = freezed,
    Object? calories = freezed,
    Object? canBeMultiple = null,
    Object? canBeMultipleLimit = freezed,
  }) {
    return _then(_$OptionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      isExclusive: null == isExclusive
          ? _value.isExclusive
          : isExclusive // ignore: cast_nullable_to_non_nullable
              as bool,
      subOptions: freezed == subOptions
          ? _value._subOptions
          : subOptions // ignore: cast_nullable_to_non_nullable
              as List<SubOption>?,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      canBeMultiple: null == canBeMultiple
          ? _value.canBeMultiple
          : canBeMultiple // ignore: cast_nullable_to_non_nullable
              as bool,
      canBeMultipleLimit: freezed == canBeMultipleLimit
          ? _value.canBeMultipleLimit
          : canBeMultipleLimit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OptionImpl with DiagnosticableTreeMixin implements _Option {
  _$OptionImpl(
      {required this.name,
      this.price,
      this.isExclusive = true,
      final List<SubOption>? subOptions,
      this.calories,
      this.canBeMultiple = false,
      this.canBeMultipleLimit})
      : _subOptions = subOptions;

  factory _$OptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$OptionImplFromJson(json);

  @override
  final String name;
  @override
  final double? price;
  @override
  @JsonKey()
  final bool isExclusive;
  final List<SubOption>? _subOptions;
  @override
  List<SubOption>? get subOptions {
    final value = _subOptions;
    if (value == null) return null;
    if (_subOptions is EqualUnmodifiableListView) return _subOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? calories;
  @override
  @JsonKey()
  final bool canBeMultiple;
  @override
  final int? canBeMultipleLimit;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Option(name: $name, price: $price, isExclusive: $isExclusive, subOptions: $subOptions, calories: $calories, canBeMultiple: $canBeMultiple, canBeMultipleLimit: $canBeMultipleLimit)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Option'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('price', price))
      ..add(DiagnosticsProperty('isExclusive', isExclusive))
      ..add(DiagnosticsProperty('subOptions', subOptions))
      ..add(DiagnosticsProperty('calories', calories))
      ..add(DiagnosticsProperty('canBeMultiple', canBeMultiple))
      ..add(DiagnosticsProperty('canBeMultipleLimit', canBeMultipleLimit));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isExclusive, isExclusive) ||
                other.isExclusive == isExclusive) &&
            const DeepCollectionEquality()
                .equals(other._subOptions, _subOptions) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.canBeMultiple, canBeMultiple) ||
                other.canBeMultiple == canBeMultiple) &&
            (identical(other.canBeMultipleLimit, canBeMultipleLimit) ||
                other.canBeMultipleLimit == canBeMultipleLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      price,
      isExclusive,
      const DeepCollectionEquality().hash(_subOptions),
      calories,
      canBeMultiple,
      canBeMultipleLimit);

  /// Create a copy of Option
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptionImplCopyWith<_$OptionImpl> get copyWith =>
      __$$OptionImplCopyWithImpl<_$OptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OptionImplToJson(
      this,
    );
  }
}

abstract class _Option implements Option {
  factory _Option(
      {required final String name,
      final double? price,
      final bool isExclusive,
      final List<SubOption>? subOptions,
      final double? calories,
      final bool canBeMultiple,
      final int? canBeMultipleLimit}) = _$OptionImpl;

  factory _Option.fromJson(Map<String, dynamic> json) = _$OptionImpl.fromJson;

  @override
  String get name;
  @override
  double? get price;
  @override
  bool get isExclusive;
  @override
  List<SubOption>? get subOptions;
  @override
  double? get calories;
  @override
  bool get canBeMultiple;
  @override
  int? get canBeMultipleLimit;

  /// Create a copy of Option
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptionImplCopyWith<_$OptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubOption _$SubOptionFromJson(Map<String, dynamic> json) {
  return _SubOption.fromJson(json);
}

/// @nodoc
mixin _$SubOption {
  String get name => throw _privateConstructorUsedError;
  bool get canBeMultiple => throw _privateConstructorUsedError;
  double? get calories => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  int? get canBeMultipleLimit => throw _privateConstructorUsedError;

  /// Serializes this SubOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubOptionCopyWith<SubOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubOptionCopyWith<$Res> {
  factory $SubOptionCopyWith(SubOption value, $Res Function(SubOption) then) =
      _$SubOptionCopyWithImpl<$Res, SubOption>;
  @useResult
  $Res call(
      {String name,
      bool canBeMultiple,
      double? calories,
      double? price,
      int? canBeMultipleLimit});
}

/// @nodoc
class _$SubOptionCopyWithImpl<$Res, $Val extends SubOption>
    implements $SubOptionCopyWith<$Res> {
  _$SubOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? canBeMultiple = null,
    Object? calories = freezed,
    Object? price = freezed,
    Object? canBeMultipleLimit = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      canBeMultiple: null == canBeMultiple
          ? _value.canBeMultiple
          : canBeMultiple // ignore: cast_nullable_to_non_nullable
              as bool,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      canBeMultipleLimit: freezed == canBeMultipleLimit
          ? _value.canBeMultipleLimit
          : canBeMultipleLimit // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubOptionImplCopyWith<$Res>
    implements $SubOptionCopyWith<$Res> {
  factory _$$SubOptionImplCopyWith(
          _$SubOptionImpl value, $Res Function(_$SubOptionImpl) then) =
      __$$SubOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      bool canBeMultiple,
      double? calories,
      double? price,
      int? canBeMultipleLimit});
}

/// @nodoc
class __$$SubOptionImplCopyWithImpl<$Res>
    extends _$SubOptionCopyWithImpl<$Res, _$SubOptionImpl>
    implements _$$SubOptionImplCopyWith<$Res> {
  __$$SubOptionImplCopyWithImpl(
      _$SubOptionImpl _value, $Res Function(_$SubOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? canBeMultiple = null,
    Object? calories = freezed,
    Object? price = freezed,
    Object? canBeMultipleLimit = freezed,
  }) {
    return _then(_$SubOptionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      canBeMultiple: null == canBeMultiple
          ? _value.canBeMultiple
          : canBeMultiple // ignore: cast_nullable_to_non_nullable
              as bool,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      canBeMultipleLimit: freezed == canBeMultipleLimit
          ? _value.canBeMultipleLimit
          : canBeMultipleLimit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubOptionImpl with DiagnosticableTreeMixin implements _SubOption {
  _$SubOptionImpl(
      {required this.name,
      required this.canBeMultiple,
      this.calories,
      this.price,
      this.canBeMultipleLimit});

  factory _$SubOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubOptionImplFromJson(json);

  @override
  final String name;
  @override
  final bool canBeMultiple;
  @override
  final double? calories;
  @override
  final double? price;
  @override
  final int? canBeMultipleLimit;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SubOption(name: $name, canBeMultiple: $canBeMultiple, calories: $calories, price: $price, canBeMultipleLimit: $canBeMultipleLimit)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SubOption'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('canBeMultiple', canBeMultiple))
      ..add(DiagnosticsProperty('calories', calories))
      ..add(DiagnosticsProperty('price', price))
      ..add(DiagnosticsProperty('canBeMultipleLimit', canBeMultipleLimit));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubOptionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.canBeMultiple, canBeMultiple) ||
                other.canBeMultiple == canBeMultiple) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.canBeMultipleLimit, canBeMultipleLimit) ||
                other.canBeMultipleLimit == canBeMultipleLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, canBeMultiple, calories, price, canBeMultipleLimit);

  /// Create a copy of SubOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubOptionImplCopyWith<_$SubOptionImpl> get copyWith =>
      __$$SubOptionImplCopyWithImpl<_$SubOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubOptionImplToJson(
      this,
    );
  }
}

abstract class _SubOption implements SubOption {
  factory _SubOption(
      {required final String name,
      required final bool canBeMultiple,
      final double? calories,
      final double? price,
      final int? canBeMultipleLimit}) = _$SubOptionImpl;

  factory _SubOption.fromJson(Map<String, dynamic> json) =
      _$SubOptionImpl.fromJson;

  @override
  String get name;
  @override
  bool get canBeMultiple;
  @override
  double? get calories;
  @override
  double? get price;
  @override
  int? get canBeMultipleLimit;

  /// Create a copy of SubOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubOptionImplCopyWith<_$SubOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodCategory _$FoodCategoryFromJson(Map<String, dynamic> json) {
  return _FoodCategory.fromJson(json);
}

/// @nodoc
mixin _$FoodCategory {
  String get name => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;

  /// Serializes this FoodCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodCategoryCopyWith<FoodCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodCategoryCopyWith<$Res> {
  factory $FoodCategoryCopyWith(
          FoodCategory value, $Res Function(FoodCategory) then) =
      _$FoodCategoryCopyWithImpl<$Res, FoodCategory>;
  @useResult
  $Res call({String name, String image});
}

/// @nodoc
class _$FoodCategoryCopyWithImpl<$Res, $Val extends FoodCategory>
    implements $FoodCategoryCopyWith<$Res> {
  _$FoodCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? image = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodCategoryImplCopyWith<$Res>
    implements $FoodCategoryCopyWith<$Res> {
  factory _$$FoodCategoryImplCopyWith(
          _$FoodCategoryImpl value, $Res Function(_$FoodCategoryImpl) then) =
      __$$FoodCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String image});
}

/// @nodoc
class __$$FoodCategoryImplCopyWithImpl<$Res>
    extends _$FoodCategoryCopyWithImpl<$Res, _$FoodCategoryImpl>
    implements _$$FoodCategoryImplCopyWith<$Res> {
  __$$FoodCategoryImplCopyWithImpl(
      _$FoodCategoryImpl _value, $Res Function(_$FoodCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? image = null,
  }) {
    return _then(_$FoodCategoryImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodCategoryImpl with DiagnosticableTreeMixin implements _FoodCategory {
  _$FoodCategoryImpl(this.name, this.image);

  factory _$FoodCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodCategoryImplFromJson(json);

  @override
  final String name;
  @override
  final String image;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FoodCategory(name: $name, image: $image)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FoodCategory'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('image', image));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodCategoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, image);

  /// Create a copy of FoodCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodCategoryImplCopyWith<_$FoodCategoryImpl> get copyWith =>
      __$$FoodCategoryImplCopyWithImpl<_$FoodCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodCategoryImplToJson(
      this,
    );
  }
}

abstract class _FoodCategory implements FoodCategory {
  factory _FoodCategory(final String name, final String image) =
      _$FoodCategoryImpl;

  factory _FoodCategory.fromJson(Map<String, dynamic> json) =
      _$FoodCategoryImpl.fromJson;

  @override
  String get name;
  @override
  String get image;

  /// Create a copy of FoodCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodCategoryImplCopyWith<_$FoodCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
