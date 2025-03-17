// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IndividualOrder _$IndividualOrderFromJson(Map<String, dynamic> json) {
  return _IndividualOrder.fromJson(json);
}

/// @nodoc
mixin _$IndividualOrder {
  Map<String, dynamic> get productsAndQuantities =>
      throw _privateConstructorUsedError;
  DateTime get deliveryDate => throw _privateConstructorUsedError;
  double? get tip => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get courier => throw _privateConstructorUsedError;
  Promotion? get promo => throw _privateConstructorUsedError;
  double get serviceFee => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double? get caDriverBenefits => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  double? get membershipBenefit => throw _privateConstructorUsedError;
  double get totalFee => throw _privateConstructorUsedError;
  List<Payment> get payments => throw _privateConstructorUsedError;
  Store get store => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this IndividualOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndividualOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndividualOrderCopyWith<IndividualOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndividualOrderCopyWith<$Res> {
  factory $IndividualOrderCopyWith(
          IndividualOrder value, $Res Function(IndividualOrder) then) =
      _$IndividualOrderCopyWithImpl<$Res, IndividualOrder>;
  @useResult
  $Res call(
      {Map<String, dynamic> productsAndQuantities,
      DateTime deliveryDate,
      double? tip,
      String orderNumber,
      String courier,
      Promotion? promo,
      double serviceFee,
      double tax,
      double? caDriverBenefits,
      double deliveryFee,
      double? membershipBenefit,
      double totalFee,
      List<Payment> payments,
      Store store,
      String status});

  $PromotionCopyWith<$Res>? get promo;
  $StoreCopyWith<$Res> get store;
}

/// @nodoc
class _$IndividualOrderCopyWithImpl<$Res, $Val extends IndividualOrder>
    implements $IndividualOrderCopyWith<$Res> {
  _$IndividualOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndividualOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productsAndQuantities = null,
    Object? deliveryDate = null,
    Object? tip = freezed,
    Object? orderNumber = null,
    Object? courier = null,
    Object? promo = freezed,
    Object? serviceFee = null,
    Object? tax = null,
    Object? caDriverBenefits = freezed,
    Object? deliveryFee = null,
    Object? membershipBenefit = freezed,
    Object? totalFee = null,
    Object? payments = null,
    Object? store = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      productsAndQuantities: null == productsAndQuantities
          ? _value.productsAndQuantities
          : productsAndQuantities // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tip: freezed == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double?,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      courier: null == courier
          ? _value.courier
          : courier // ignore: cast_nullable_to_non_nullable
              as String,
      promo: freezed == promo
          ? _value.promo
          : promo // ignore: cast_nullable_to_non_nullable
              as Promotion?,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      caDriverBenefits: freezed == caDriverBenefits
          ? _value.caDriverBenefits
          : caDriverBenefits // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      membershipBenefit: freezed == membershipBenefit
          ? _value.membershipBenefit
          : membershipBenefit // ignore: cast_nullable_to_non_nullable
              as double?,
      totalFee: null == totalFee
          ? _value.totalFee
          : totalFee // ignore: cast_nullable_to_non_nullable
              as double,
      payments: null == payments
          ? _value.payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<Payment>,
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as Store,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of IndividualOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PromotionCopyWith<$Res>? get promo {
    if (_value.promo == null) {
      return null;
    }

    return $PromotionCopyWith<$Res>(_value.promo!, (value) {
      return _then(_value.copyWith(promo: value) as $Val);
    });
  }

  /// Create a copy of IndividualOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoreCopyWith<$Res> get store {
    return $StoreCopyWith<$Res>(_value.store, (value) {
      return _then(_value.copyWith(store: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IndividualOrderImplCopyWith<$Res>
    implements $IndividualOrderCopyWith<$Res> {
  factory _$$IndividualOrderImplCopyWith(_$IndividualOrderImpl value,
          $Res Function(_$IndividualOrderImpl) then) =
      __$$IndividualOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, dynamic> productsAndQuantities,
      DateTime deliveryDate,
      double? tip,
      String orderNumber,
      String courier,
      Promotion? promo,
      double serviceFee,
      double tax,
      double? caDriverBenefits,
      double deliveryFee,
      double? membershipBenefit,
      double totalFee,
      List<Payment> payments,
      Store store,
      String status});

  @override
  $PromotionCopyWith<$Res>? get promo;
  @override
  $StoreCopyWith<$Res> get store;
}

/// @nodoc
class __$$IndividualOrderImplCopyWithImpl<$Res>
    extends _$IndividualOrderCopyWithImpl<$Res, _$IndividualOrderImpl>
    implements _$$IndividualOrderImplCopyWith<$Res> {
  __$$IndividualOrderImplCopyWithImpl(
      _$IndividualOrderImpl _value, $Res Function(_$IndividualOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndividualOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productsAndQuantities = null,
    Object? deliveryDate = null,
    Object? tip = freezed,
    Object? orderNumber = null,
    Object? courier = null,
    Object? promo = freezed,
    Object? serviceFee = null,
    Object? tax = null,
    Object? caDriverBenefits = freezed,
    Object? deliveryFee = null,
    Object? membershipBenefit = freezed,
    Object? totalFee = null,
    Object? payments = null,
    Object? store = null,
    Object? status = null,
  }) {
    return _then(_$IndividualOrderImpl(
      productsAndQuantities: null == productsAndQuantities
          ? _value._productsAndQuantities
          : productsAndQuantities // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tip: freezed == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double?,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      courier: null == courier
          ? _value.courier
          : courier // ignore: cast_nullable_to_non_nullable
              as String,
      promo: freezed == promo
          ? _value.promo
          : promo // ignore: cast_nullable_to_non_nullable
              as Promotion?,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      caDriverBenefits: freezed == caDriverBenefits
          ? _value.caDriverBenefits
          : caDriverBenefits // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      membershipBenefit: freezed == membershipBenefit
          ? _value.membershipBenefit
          : membershipBenefit // ignore: cast_nullable_to_non_nullable
              as double?,
      totalFee: null == totalFee
          ? _value.totalFee
          : totalFee // ignore: cast_nullable_to_non_nullable
              as double,
      payments: null == payments
          ? _value._payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<Payment>,
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as Store,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndividualOrderImpl
    with DiagnosticableTreeMixin
    implements _IndividualOrder {
  const _$IndividualOrderImpl(
      {required final Map<String, dynamic> productsAndQuantities,
      required this.deliveryDate,
      this.tip,
      required this.orderNumber,
      required this.courier,
      this.promo,
      required this.serviceFee,
      required this.tax,
      this.caDriverBenefits,
      required this.deliveryFee,
      this.membershipBenefit,
      required this.totalFee,
      required final List<Payment> payments,
      required this.store,
      required this.status})
      : _productsAndQuantities = productsAndQuantities,
        _payments = payments;

  factory _$IndividualOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndividualOrderImplFromJson(json);

  final Map<String, dynamic> _productsAndQuantities;
  @override
  Map<String, dynamic> get productsAndQuantities {
    if (_productsAndQuantities is EqualUnmodifiableMapView)
      return _productsAndQuantities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_productsAndQuantities);
  }

  @override
  final DateTime deliveryDate;
  @override
  final double? tip;
  @override
  final String orderNumber;
  @override
  final String courier;
  @override
  final Promotion? promo;
  @override
  final double serviceFee;
  @override
  final double tax;
  @override
  final double? caDriverBenefits;
  @override
  final double deliveryFee;
  @override
  final double? membershipBenefit;
  @override
  final double totalFee;
  final List<Payment> _payments;
  @override
  List<Payment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  final Store store;
  @override
  final String status;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IndividualOrder(productsAndQuantities: $productsAndQuantities, deliveryDate: $deliveryDate, tip: $tip, orderNumber: $orderNumber, courier: $courier, promo: $promo, serviceFee: $serviceFee, tax: $tax, caDriverBenefits: $caDriverBenefits, deliveryFee: $deliveryFee, membershipBenefit: $membershipBenefit, totalFee: $totalFee, payments: $payments, store: $store, status: $status)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'IndividualOrder'))
      ..add(DiagnosticsProperty('productsAndQuantities', productsAndQuantities))
      ..add(DiagnosticsProperty('deliveryDate', deliveryDate))
      ..add(DiagnosticsProperty('tip', tip))
      ..add(DiagnosticsProperty('orderNumber', orderNumber))
      ..add(DiagnosticsProperty('courier', courier))
      ..add(DiagnosticsProperty('promo', promo))
      ..add(DiagnosticsProperty('serviceFee', serviceFee))
      ..add(DiagnosticsProperty('tax', tax))
      ..add(DiagnosticsProperty('caDriverBenefits', caDriverBenefits))
      ..add(DiagnosticsProperty('deliveryFee', deliveryFee))
      ..add(DiagnosticsProperty('membershipBenefit', membershipBenefit))
      ..add(DiagnosticsProperty('totalFee', totalFee))
      ..add(DiagnosticsProperty('payments', payments))
      ..add(DiagnosticsProperty('store', store))
      ..add(DiagnosticsProperty('status', status));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndividualOrderImpl &&
            const DeepCollectionEquality()
                .equals(other._productsAndQuantities, _productsAndQuantities) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.tip, tip) || other.tip == tip) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.courier, courier) || other.courier == courier) &&
            (identical(other.promo, promo) || other.promo == promo) &&
            (identical(other.serviceFee, serviceFee) ||
                other.serviceFee == serviceFee) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.caDriverBenefits, caDriverBenefits) ||
                other.caDriverBenefits == caDriverBenefits) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.membershipBenefit, membershipBenefit) ||
                other.membershipBenefit == membershipBenefit) &&
            (identical(other.totalFee, totalFee) ||
                other.totalFee == totalFee) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_productsAndQuantities),
      deliveryDate,
      tip,
      orderNumber,
      courier,
      promo,
      serviceFee,
      tax,
      caDriverBenefits,
      deliveryFee,
      membershipBenefit,
      totalFee,
      const DeepCollectionEquality().hash(_payments),
      store,
      status);

  /// Create a copy of IndividualOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndividualOrderImplCopyWith<_$IndividualOrderImpl> get copyWith =>
      __$$IndividualOrderImplCopyWithImpl<_$IndividualOrderImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndividualOrderImplToJson(
      this,
    );
  }
}

abstract class _IndividualOrder implements IndividualOrder {
  const factory _IndividualOrder(
      {required final Map<String, dynamic> productsAndQuantities,
      required final DateTime deliveryDate,
      final double? tip,
      required final String orderNumber,
      required final String courier,
      final Promotion? promo,
      required final double serviceFee,
      required final double tax,
      final double? caDriverBenefits,
      required final double deliveryFee,
      final double? membershipBenefit,
      required final double totalFee,
      required final List<Payment> payments,
      required final Store store,
      required final String status}) = _$IndividualOrderImpl;

  factory _IndividualOrder.fromJson(Map<String, dynamic> json) =
      _$IndividualOrderImpl.fromJson;

  @override
  Map<String, dynamic> get productsAndQuantities;
  @override
  DateTime get deliveryDate;
  @override
  double? get tip;
  @override
  String get orderNumber;
  @override
  String get courier;
  @override
  Promotion? get promo;
  @override
  double get serviceFee;
  @override
  double get tax;
  @override
  double? get caDriverBenefits;
  @override
  double get deliveryFee;
  @override
  double? get membershipBenefit;
  @override
  double get totalFee;
  @override
  List<Payment> get payments;
  @override
  Store get store;
  @override
  String get status;

  /// Create a copy of IndividualOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndividualOrderImplCopyWith<_$IndividualOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderSchedule _$OrderScheduleFromJson(Map<String, dynamic> json) {
  return _OrderSchedule.fromJson(json);
}

/// @nodoc
mixin _$OrderSchedule {
  DateTime get deliveryDate => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  List<OrderItem> get orderItems => throw _privateConstructorUsedError;
  double get tip => throw _privateConstructorUsedError;
  String get courier => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Promotion? get promo => throw _privateConstructorUsedError;
  double get serviceFee => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get caDriverBenefits => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  double get membershipBenefit => throw _privateConstructorUsedError;
  List<Payment> get payments => throw _privateConstructorUsedError;
  double get totalFee => throw _privateConstructorUsedError;

  /// Serializes this OrderSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderScheduleCopyWith<OrderSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderScheduleCopyWith<$Res> {
  factory $OrderScheduleCopyWith(
          OrderSchedule value, $Res Function(OrderSchedule) then) =
      _$OrderScheduleCopyWithImpl<$Res, OrderSchedule>;
  @useResult
  $Res call(
      {DateTime deliveryDate,
      String storeId,
      String orderNumber,
      List<OrderItem> orderItems,
      double tip,
      String courier,
      String status,
      Promotion? promo,
      double serviceFee,
      double tax,
      double caDriverBenefits,
      double deliveryFee,
      double membershipBenefit,
      List<Payment> payments,
      double totalFee});

  $PromotionCopyWith<$Res>? get promo;
}

/// @nodoc
class _$OrderScheduleCopyWithImpl<$Res, $Val extends OrderSchedule>
    implements $OrderScheduleCopyWith<$Res> {
  _$OrderScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deliveryDate = null,
    Object? storeId = null,
    Object? orderNumber = null,
    Object? orderItems = null,
    Object? tip = null,
    Object? courier = null,
    Object? status = null,
    Object? promo = freezed,
    Object? serviceFee = null,
    Object? tax = null,
    Object? caDriverBenefits = null,
    Object? deliveryFee = null,
    Object? membershipBenefit = null,
    Object? payments = null,
    Object? totalFee = null,
  }) {
    return _then(_value.copyWith(
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderItems: null == orderItems
          ? _value.orderItems
          : orderItems // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      tip: null == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double,
      courier: null == courier
          ? _value.courier
          : courier // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      promo: freezed == promo
          ? _value.promo
          : promo // ignore: cast_nullable_to_non_nullable
              as Promotion?,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      caDriverBenefits: null == caDriverBenefits
          ? _value.caDriverBenefits
          : caDriverBenefits // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      membershipBenefit: null == membershipBenefit
          ? _value.membershipBenefit
          : membershipBenefit // ignore: cast_nullable_to_non_nullable
              as double,
      payments: null == payments
          ? _value.payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<Payment>,
      totalFee: null == totalFee
          ? _value.totalFee
          : totalFee // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of OrderSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PromotionCopyWith<$Res>? get promo {
    if (_value.promo == null) {
      return null;
    }

    return $PromotionCopyWith<$Res>(_value.promo!, (value) {
      return _then(_value.copyWith(promo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderScheduleImplCopyWith<$Res>
    implements $OrderScheduleCopyWith<$Res> {
  factory _$$OrderScheduleImplCopyWith(
          _$OrderScheduleImpl value, $Res Function(_$OrderScheduleImpl) then) =
      __$$OrderScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime deliveryDate,
      String storeId,
      String orderNumber,
      List<OrderItem> orderItems,
      double tip,
      String courier,
      String status,
      Promotion? promo,
      double serviceFee,
      double tax,
      double caDriverBenefits,
      double deliveryFee,
      double membershipBenefit,
      List<Payment> payments,
      double totalFee});

  @override
  $PromotionCopyWith<$Res>? get promo;
}

/// @nodoc
class __$$OrderScheduleImplCopyWithImpl<$Res>
    extends _$OrderScheduleCopyWithImpl<$Res, _$OrderScheduleImpl>
    implements _$$OrderScheduleImplCopyWith<$Res> {
  __$$OrderScheduleImplCopyWithImpl(
      _$OrderScheduleImpl _value, $Res Function(_$OrderScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deliveryDate = null,
    Object? storeId = null,
    Object? orderNumber = null,
    Object? orderItems = null,
    Object? tip = null,
    Object? courier = null,
    Object? status = null,
    Object? promo = freezed,
    Object? serviceFee = null,
    Object? tax = null,
    Object? caDriverBenefits = null,
    Object? deliveryFee = null,
    Object? membershipBenefit = null,
    Object? payments = null,
    Object? totalFee = null,
  }) {
    return _then(_$OrderScheduleImpl(
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderItems: null == orderItems
          ? _value._orderItems
          : orderItems // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      tip: null == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double,
      courier: null == courier
          ? _value.courier
          : courier // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      promo: freezed == promo
          ? _value.promo
          : promo // ignore: cast_nullable_to_non_nullable
              as Promotion?,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      caDriverBenefits: null == caDriverBenefits
          ? _value.caDriverBenefits
          : caDriverBenefits // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      membershipBenefit: null == membershipBenefit
          ? _value.membershipBenefit
          : membershipBenefit // ignore: cast_nullable_to_non_nullable
              as double,
      payments: null == payments
          ? _value._payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<Payment>,
      totalFee: null == totalFee
          ? _value.totalFee
          : totalFee // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderScheduleImpl
    with DiagnosticableTreeMixin
    implements _OrderSchedule {
  const _$OrderScheduleImpl(
      {required this.deliveryDate,
      required this.storeId,
      required this.orderNumber,
      final List<OrderItem> orderItems = const [],
      this.tip = 0,
      this.courier = 'Bernard',
      this.status = 'Processing',
      this.promo,
      this.serviceFee = 0,
      this.tax = 0,
      this.caDriverBenefits = 0,
      this.deliveryFee = 0,
      this.membershipBenefit = 0,
      final List<Payment> payments = const [],
      this.totalFee = 0})
      : _orderItems = orderItems,
        _payments = payments;

  factory _$OrderScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderScheduleImplFromJson(json);

  @override
  final DateTime deliveryDate;
  @override
  final String storeId;
  @override
  final String orderNumber;
  final List<OrderItem> _orderItems;
  @override
  @JsonKey()
  List<OrderItem> get orderItems {
    if (_orderItems is EqualUnmodifiableListView) return _orderItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderItems);
  }

  @override
  @JsonKey()
  final double tip;
  @override
  @JsonKey()
  final String courier;
  @override
  @JsonKey()
  final String status;
  @override
  final Promotion? promo;
  @override
  @JsonKey()
  final double serviceFee;
  @override
  @JsonKey()
  final double tax;
  @override
  @JsonKey()
  final double caDriverBenefits;
  @override
  @JsonKey()
  final double deliveryFee;
  @override
  @JsonKey()
  final double membershipBenefit;
  final List<Payment> _payments;
  @override
  @JsonKey()
  List<Payment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  @JsonKey()
  final double totalFee;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderSchedule(deliveryDate: $deliveryDate, storeId: $storeId, orderNumber: $orderNumber, orderItems: $orderItems, tip: $tip, courier: $courier, status: $status, promo: $promo, serviceFee: $serviceFee, tax: $tax, caDriverBenefits: $caDriverBenefits, deliveryFee: $deliveryFee, membershipBenefit: $membershipBenefit, payments: $payments, totalFee: $totalFee)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderSchedule'))
      ..add(DiagnosticsProperty('deliveryDate', deliveryDate))
      ..add(DiagnosticsProperty('storeId', storeId))
      ..add(DiagnosticsProperty('orderNumber', orderNumber))
      ..add(DiagnosticsProperty('orderItems', orderItems))
      ..add(DiagnosticsProperty('tip', tip))
      ..add(DiagnosticsProperty('courier', courier))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('promo', promo))
      ..add(DiagnosticsProperty('serviceFee', serviceFee))
      ..add(DiagnosticsProperty('tax', tax))
      ..add(DiagnosticsProperty('caDriverBenefits', caDriverBenefits))
      ..add(DiagnosticsProperty('deliveryFee', deliveryFee))
      ..add(DiagnosticsProperty('membershipBenefit', membershipBenefit))
      ..add(DiagnosticsProperty('payments', payments))
      ..add(DiagnosticsProperty('totalFee', totalFee));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderScheduleImpl &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            const DeepCollectionEquality()
                .equals(other._orderItems, _orderItems) &&
            (identical(other.tip, tip) || other.tip == tip) &&
            (identical(other.courier, courier) || other.courier == courier) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.promo, promo) || other.promo == promo) &&
            (identical(other.serviceFee, serviceFee) ||
                other.serviceFee == serviceFee) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.caDriverBenefits, caDriverBenefits) ||
                other.caDriverBenefits == caDriverBenefits) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.membershipBenefit, membershipBenefit) ||
                other.membershipBenefit == membershipBenefit) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.totalFee, totalFee) ||
                other.totalFee == totalFee));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      deliveryDate,
      storeId,
      orderNumber,
      const DeepCollectionEquality().hash(_orderItems),
      tip,
      courier,
      status,
      promo,
      serviceFee,
      tax,
      caDriverBenefits,
      deliveryFee,
      membershipBenefit,
      const DeepCollectionEquality().hash(_payments),
      totalFee);

  /// Create a copy of OrderSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderScheduleImplCopyWith<_$OrderScheduleImpl> get copyWith =>
      __$$OrderScheduleImplCopyWithImpl<_$OrderScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderScheduleImplToJson(
      this,
    );
  }
}

abstract class _OrderSchedule implements OrderSchedule {
  const factory _OrderSchedule(
      {required final DateTime deliveryDate,
      required final String storeId,
      required final String orderNumber,
      final List<OrderItem> orderItems,
      final double tip,
      final String courier,
      final String status,
      final Promotion? promo,
      final double serviceFee,
      final double tax,
      final double caDriverBenefits,
      final double deliveryFee,
      final double membershipBenefit,
      final List<Payment> payments,
      final double totalFee}) = _$OrderScheduleImpl;

  factory _OrderSchedule.fromJson(Map<String, dynamic> json) =
      _$OrderScheduleImpl.fromJson;

  @override
  DateTime get deliveryDate;
  @override
  String get storeId;
  @override
  String get orderNumber;
  @override
  List<OrderItem> get orderItems;
  @override
  double get tip;
  @override
  String get courier;
  @override
  String get status;
  @override
  Promotion? get promo;
  @override
  double get serviceFee;
  @override
  double get tax;
  @override
  double get caDriverBenefits;
  @override
  double get deliveryFee;
  @override
  double get membershipBenefit;
  @override
  List<Payment> get payments;
  @override
  double get totalFee;

  /// Create a copy of OrderSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderScheduleImplCopyWith<_$OrderScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get person => throw _privateConstructorUsedError;
  Map<String, dynamic> get productsAndQuantities =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({String person, Map<String, dynamic> productsAndQuantities});
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? person = null,
    Object? productsAndQuantities = null,
  }) {
    return _then(_value.copyWith(
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as String,
      productsAndQuantities: null == productsAndQuantities
          ? _value.productsAndQuantities
          : productsAndQuantities // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
          _$OrderItemImpl value, $Res Function(_$OrderItemImpl) then) =
      __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String person, Map<String, dynamic> productsAndQuantities});
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
      _$OrderItemImpl _value, $Res Function(_$OrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? person = null,
    Object? productsAndQuantities = null,
  }) {
    return _then(_$OrderItemImpl(
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as String,
      productsAndQuantities: null == productsAndQuantities
          ? _value._productsAndQuantities
          : productsAndQuantities // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl with DiagnosticableTreeMixin implements _OrderItem {
  const _$OrderItemImpl(
      {required this.person,
      required final Map<String, dynamic> productsAndQuantities})
      : _productsAndQuantities = productsAndQuantities;

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String person;
  final Map<String, dynamic> _productsAndQuantities;
  @override
  Map<String, dynamic> get productsAndQuantities {
    if (_productsAndQuantities is EqualUnmodifiableMapView)
      return _productsAndQuantities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_productsAndQuantities);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderItem(person: $person, productsAndQuantities: $productsAndQuantities)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderItem'))
      ..add(DiagnosticsProperty('person', person))
      ..add(
          DiagnosticsProperty('productsAndQuantities', productsAndQuantities));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.person, person) || other.person == person) &&
            const DeepCollectionEquality()
                .equals(other._productsAndQuantities, _productsAndQuantities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, person,
      const DeepCollectionEquality().hash(_productsAndQuantities));

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(
      this,
    );
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem(
          {required final String person,
          required final Map<String, dynamic> productsAndQuantities}) =
      _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get person;
  @override
  Map<String, dynamic> get productsAndQuantities;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
