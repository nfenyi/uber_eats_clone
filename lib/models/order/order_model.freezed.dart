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
  List<CartProduct> get products => throw _privateConstructorUsedError;
  bool get isPriority => throw _privateConstructorUsedError;
  DateTime get deliveryDate => throw _privateConstructorUsedError;
  double get tip => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get placeDescription => throw _privateConstructorUsedError;
  String get courier => throw _privateConstructorUsedError;
  Object? get promoApplied => throw _privateConstructorUsedError;
  double get serviceFee => throw _privateConstructorUsedError;
  double? get promoDiscount => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get caDriverBenefits => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  double? get membershipBenefit => throw _privateConstructorUsedError;
  double get totalFee => throw _privateConstructorUsedError;
  List<Payment> get payments => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get userUid => throw _privateConstructorUsedError;

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
      {List<CartProduct> products,
      bool isPriority,
      DateTime deliveryDate,
      double tip,
      String orderNumber,
      String placeDescription,
      String courier,
      Object? promoApplied,
      double serviceFee,
      double? promoDiscount,
      double tax,
      double caDriverBenefits,
      double deliveryFee,
      double? membershipBenefit,
      double totalFee,
      List<Payment> payments,
      String storeId,
      String status,
      String userUid});
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
    Object? products = null,
    Object? isPriority = null,
    Object? deliveryDate = null,
    Object? tip = null,
    Object? orderNumber = null,
    Object? placeDescription = null,
    Object? courier = null,
    Object? promoApplied = freezed,
    Object? serviceFee = null,
    Object? promoDiscount = freezed,
    Object? tax = null,
    Object? caDriverBenefits = null,
    Object? deliveryFee = null,
    Object? membershipBenefit = freezed,
    Object? totalFee = null,
    Object? payments = null,
    Object? storeId = null,
    Object? status = null,
    Object? userUid = null,
  }) {
    return _then(_value.copyWith(
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<CartProduct>,
      isPriority: null == isPriority
          ? _value.isPriority
          : isPriority // ignore: cast_nullable_to_non_nullable
              as bool,
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tip: null == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      courier: null == courier
          ? _value.courier
          : courier // ignore: cast_nullable_to_non_nullable
              as String,
      promoApplied:
          freezed == promoApplied ? _value.promoApplied : promoApplied,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      promoDiscount: freezed == promoDiscount
          ? _value.promoDiscount
          : promoDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
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
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      userUid: null == userUid
          ? _value.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
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
      {List<CartProduct> products,
      bool isPriority,
      DateTime deliveryDate,
      double tip,
      String orderNumber,
      String placeDescription,
      String courier,
      Object? promoApplied,
      double serviceFee,
      double? promoDiscount,
      double tax,
      double caDriverBenefits,
      double deliveryFee,
      double? membershipBenefit,
      double totalFee,
      List<Payment> payments,
      String storeId,
      String status,
      String userUid});
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
    Object? products = null,
    Object? isPriority = null,
    Object? deliveryDate = null,
    Object? tip = null,
    Object? orderNumber = null,
    Object? placeDescription = null,
    Object? courier = null,
    Object? promoApplied = freezed,
    Object? serviceFee = null,
    Object? promoDiscount = freezed,
    Object? tax = null,
    Object? caDriverBenefits = null,
    Object? deliveryFee = null,
    Object? membershipBenefit = freezed,
    Object? totalFee = null,
    Object? payments = null,
    Object? storeId = null,
    Object? status = null,
    Object? userUid = null,
  }) {
    return _then(_$IndividualOrderImpl(
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<CartProduct>,
      isPriority: null == isPriority
          ? _value.isPriority
          : isPriority // ignore: cast_nullable_to_non_nullable
              as bool,
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tip: null == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      courier: null == courier
          ? _value.courier
          : courier // ignore: cast_nullable_to_non_nullable
              as String,
      promoApplied:
          freezed == promoApplied ? _value.promoApplied : promoApplied,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      promoDiscount: freezed == promoDiscount
          ? _value.promoDiscount
          : promoDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
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
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      userUid: null == userUid
          ? _value.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
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
      {required final List<CartProduct> products,
      required this.isPriority,
      required this.deliveryDate,
      this.tip = 0,
      required this.orderNumber,
      required this.placeDescription,
      this.courier = 'Jonathan',
      this.promoApplied,
      required this.serviceFee,
      this.promoDiscount,
      required this.tax,
      this.caDriverBenefits = 0,
      required this.deliveryFee,
      this.membershipBenefit,
      required this.totalFee,
      required final List<Payment> payments,
      required this.storeId,
      this.status = 'Ongoing',
      required this.userUid})
      : _products = products,
        _payments = payments;

  factory _$IndividualOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndividualOrderImplFromJson(json);

  final List<CartProduct> _products;
  @override
  List<CartProduct> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final bool isPriority;
  @override
  final DateTime deliveryDate;
  @override
  @JsonKey()
  final double tip;
  @override
  final String orderNumber;
  @override
  final String placeDescription;
  @override
  @JsonKey()
  final String courier;
  @override
  final Object? promoApplied;
  @override
  final double serviceFee;
  @override
  final double? promoDiscount;
  @override
  final double tax;
  @override
  @JsonKey()
  final double caDriverBenefits;
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
  final String storeId;
  @override
  @JsonKey()
  final String status;
  @override
  final String userUid;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IndividualOrder(products: $products, isPriority: $isPriority, deliveryDate: $deliveryDate, tip: $tip, orderNumber: $orderNumber, placeDescription: $placeDescription, courier: $courier, promoApplied: $promoApplied, serviceFee: $serviceFee, promoDiscount: $promoDiscount, tax: $tax, caDriverBenefits: $caDriverBenefits, deliveryFee: $deliveryFee, membershipBenefit: $membershipBenefit, totalFee: $totalFee, payments: $payments, storeId: $storeId, status: $status, userUid: $userUid)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'IndividualOrder'))
      ..add(DiagnosticsProperty('products', products))
      ..add(DiagnosticsProperty('isPriority', isPriority))
      ..add(DiagnosticsProperty('deliveryDate', deliveryDate))
      ..add(DiagnosticsProperty('tip', tip))
      ..add(DiagnosticsProperty('orderNumber', orderNumber))
      ..add(DiagnosticsProperty('placeDescription', placeDescription))
      ..add(DiagnosticsProperty('courier', courier))
      ..add(DiagnosticsProperty('promoApplied', promoApplied))
      ..add(DiagnosticsProperty('serviceFee', serviceFee))
      ..add(DiagnosticsProperty('promoDiscount', promoDiscount))
      ..add(DiagnosticsProperty('tax', tax))
      ..add(DiagnosticsProperty('caDriverBenefits', caDriverBenefits))
      ..add(DiagnosticsProperty('deliveryFee', deliveryFee))
      ..add(DiagnosticsProperty('membershipBenefit', membershipBenefit))
      ..add(DiagnosticsProperty('totalFee', totalFee))
      ..add(DiagnosticsProperty('payments', payments))
      ..add(DiagnosticsProperty('storeId', storeId))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('userUid', userUid));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndividualOrderImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.isPriority, isPriority) ||
                other.isPriority == isPriority) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.tip, tip) || other.tip == tip) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.placeDescription, placeDescription) ||
                other.placeDescription == placeDescription) &&
            (identical(other.courier, courier) || other.courier == courier) &&
            const DeepCollectionEquality()
                .equals(other.promoApplied, promoApplied) &&
            (identical(other.serviceFee, serviceFee) ||
                other.serviceFee == serviceFee) &&
            (identical(other.promoDiscount, promoDiscount) ||
                other.promoDiscount == promoDiscount) &&
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
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.userUid, userUid) || other.userUid == userUid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_products),
        isPriority,
        deliveryDate,
        tip,
        orderNumber,
        placeDescription,
        courier,
        const DeepCollectionEquality().hash(promoApplied),
        serviceFee,
        promoDiscount,
        tax,
        caDriverBenefits,
        deliveryFee,
        membershipBenefit,
        totalFee,
        const DeepCollectionEquality().hash(_payments),
        storeId,
        status,
        userUid
      ]);

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
      {required final List<CartProduct> products,
      required final bool isPriority,
      required final DateTime deliveryDate,
      final double tip,
      required final String orderNumber,
      required final String placeDescription,
      final String courier,
      final Object? promoApplied,
      required final double serviceFee,
      final double? promoDiscount,
      required final double tax,
      final double caDriverBenefits,
      required final double deliveryFee,
      final double? membershipBenefit,
      required final double totalFee,
      required final List<Payment> payments,
      required final String storeId,
      final String status,
      required final String userUid}) = _$IndividualOrderImpl;

  factory _IndividualOrder.fromJson(Map<String, dynamic> json) =
      _$IndividualOrderImpl.fromJson;

  @override
  List<CartProduct> get products;
  @override
  bool get isPriority;
  @override
  DateTime get deliveryDate;
  @override
  double get tip;
  @override
  String get orderNumber;
  @override
  String get placeDescription;
  @override
  String get courier;
  @override
  Object? get promoApplied;
  @override
  double get serviceFee;
  @override
  double? get promoDiscount;
  @override
  double get tax;
  @override
  double get caDriverBenefits;
  @override
  double get deliveryFee;
  @override
  double? get membershipBenefit;
  @override
  double get totalFee;
  @override
  List<Payment> get payments;
  @override
  String get storeId;
  @override
  String get status;
  @override
  String get userUid;

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
  dynamic get isLocked => throw _privateConstructorUsedError;
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  DateTime get orderDate => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  List<GroupOrderItem> get orderItems => throw _privateConstructorUsedError;
  List<String> get skippedBy => throw _privateConstructorUsedError;
  dynamic get totalFee => throw _privateConstructorUsedError;
  Object get storeRef => throw _privateConstructorUsedError;

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
      {dynamic isLocked,
      DateTime? deliveryDate,
      DateTime orderDate,
      String orderNumber,
      List<GroupOrderItem> orderItems,
      List<String> skippedBy,
      dynamic totalFee,
      Object storeRef});
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
    Object? isLocked = freezed,
    Object? deliveryDate = freezed,
    Object? orderDate = null,
    Object? orderNumber = null,
    Object? orderItems = null,
    Object? skippedBy = null,
    Object? totalFee = freezed,
    Object? storeRef = null,
  }) {
    return _then(_value.copyWith(
      isLocked: freezed == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as dynamic,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderDate: null == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderItems: null == orderItems
          ? _value.orderItems
          : orderItems // ignore: cast_nullable_to_non_nullable
              as List<GroupOrderItem>,
      skippedBy: null == skippedBy
          ? _value.skippedBy
          : skippedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalFee: freezed == totalFee
          ? _value.totalFee
          : totalFee // ignore: cast_nullable_to_non_nullable
              as dynamic,
      storeRef: null == storeRef ? _value.storeRef : storeRef,
    ) as $Val);
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
      {dynamic isLocked,
      DateTime? deliveryDate,
      DateTime orderDate,
      String orderNumber,
      List<GroupOrderItem> orderItems,
      List<String> skippedBy,
      dynamic totalFee,
      Object storeRef});
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
    Object? isLocked = freezed,
    Object? deliveryDate = freezed,
    Object? orderDate = null,
    Object? orderNumber = null,
    Object? orderItems = null,
    Object? skippedBy = null,
    Object? totalFee = freezed,
    Object? storeRef = null,
  }) {
    return _then(_$OrderScheduleImpl(
      isLocked: freezed == isLocked ? _value.isLocked! : isLocked,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderDate: null == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderItems: null == orderItems
          ? _value._orderItems
          : orderItems // ignore: cast_nullable_to_non_nullable
              as List<GroupOrderItem>,
      skippedBy: null == skippedBy
          ? _value._skippedBy
          : skippedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalFee: freezed == totalFee ? _value.totalFee! : totalFee,
      storeRef: null == storeRef ? _value.storeRef : storeRef,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderScheduleImpl
    with DiagnosticableTreeMixin
    implements _OrderSchedule {
  const _$OrderScheduleImpl(
      {this.isLocked = false,
      this.deliveryDate,
      required this.orderDate,
      required this.orderNumber,
      final List<GroupOrderItem> orderItems = const [],
      final List<String> skippedBy = const [],
      this.totalFee = 0,
      required this.storeRef})
      : _orderItems = orderItems,
        _skippedBy = skippedBy;

  factory _$OrderScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderScheduleImplFromJson(json);

  @override
  @JsonKey()
  final dynamic isLocked;
  @override
  final DateTime? deliveryDate;
  @override
  final DateTime orderDate;
  @override
  final String orderNumber;
  final List<GroupOrderItem> _orderItems;
  @override
  @JsonKey()
  List<GroupOrderItem> get orderItems {
    if (_orderItems is EqualUnmodifiableListView) return _orderItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderItems);
  }

  final List<String> _skippedBy;
  @override
  @JsonKey()
  List<String> get skippedBy {
    if (_skippedBy is EqualUnmodifiableListView) return _skippedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skippedBy);
  }

  @override
  @JsonKey()
  final dynamic totalFee;
  @override
  final Object storeRef;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderSchedule(isLocked: $isLocked, deliveryDate: $deliveryDate, orderDate: $orderDate, orderNumber: $orderNumber, orderItems: $orderItems, skippedBy: $skippedBy, totalFee: $totalFee, storeRef: $storeRef)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderSchedule'))
      ..add(DiagnosticsProperty('isLocked', isLocked))
      ..add(DiagnosticsProperty('deliveryDate', deliveryDate))
      ..add(DiagnosticsProperty('orderDate', orderDate))
      ..add(DiagnosticsProperty('orderNumber', orderNumber))
      ..add(DiagnosticsProperty('orderItems', orderItems))
      ..add(DiagnosticsProperty('skippedBy', skippedBy))
      ..add(DiagnosticsProperty('totalFee', totalFee))
      ..add(DiagnosticsProperty('storeRef', storeRef));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderScheduleImpl &&
            const DeepCollectionEquality().equals(other.isLocked, isLocked) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            const DeepCollectionEquality()
                .equals(other._orderItems, _orderItems) &&
            const DeepCollectionEquality()
                .equals(other._skippedBy, _skippedBy) &&
            const DeepCollectionEquality().equals(other.totalFee, totalFee) &&
            const DeepCollectionEquality().equals(other.storeRef, storeRef));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isLocked),
      deliveryDate,
      orderDate,
      orderNumber,
      const DeepCollectionEquality().hash(_orderItems),
      const DeepCollectionEquality().hash(_skippedBy),
      const DeepCollectionEquality().hash(totalFee),
      const DeepCollectionEquality().hash(storeRef));

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
      {final dynamic isLocked,
      final DateTime? deliveryDate,
      required final DateTime orderDate,
      required final String orderNumber,
      final List<GroupOrderItem> orderItems,
      final List<String> skippedBy,
      final dynamic totalFee,
      required final Object storeRef}) = _$OrderScheduleImpl;

  factory _OrderSchedule.fromJson(Map<String, dynamic> json) =
      _$OrderScheduleImpl.fromJson;

  @override
  dynamic get isLocked;
  @override
  DateTime? get deliveryDate;
  @override
  DateTime get orderDate;
  @override
  String get orderNumber;
  @override
  List<GroupOrderItem> get orderItems;
  @override
  List<String> get skippedBy;
  @override
  dynamic get totalFee;
  @override
  Object get storeRef;

  /// Create a copy of OrderSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderScheduleImplCopyWith<_$OrderScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupOrderItem _$GroupOrderItemFromJson(Map<String, dynamic> json) {
  return _GroupOrderItem.fromJson(json);
}

/// @nodoc
mixin _$GroupOrderItem {
  GroupOrderPerson get person => throw _privateConstructorUsedError;
  IndividualOrder get individualOrder => throw _privateConstructorUsedError;

  /// Serializes this GroupOrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupOrderItemCopyWith<GroupOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupOrderItemCopyWith<$Res> {
  factory $GroupOrderItemCopyWith(
          GroupOrderItem value, $Res Function(GroupOrderItem) then) =
      _$GroupOrderItemCopyWithImpl<$Res, GroupOrderItem>;
  @useResult
  $Res call({GroupOrderPerson person, IndividualOrder individualOrder});

  $GroupOrderPersonCopyWith<$Res> get person;
  $IndividualOrderCopyWith<$Res> get individualOrder;
}

/// @nodoc
class _$GroupOrderItemCopyWithImpl<$Res, $Val extends GroupOrderItem>
    implements $GroupOrderItemCopyWith<$Res> {
  _$GroupOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? person = null,
    Object? individualOrder = null,
  }) {
    return _then(_value.copyWith(
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as GroupOrderPerson,
      individualOrder: null == individualOrder
          ? _value.individualOrder
          : individualOrder // ignore: cast_nullable_to_non_nullable
              as IndividualOrder,
    ) as $Val);
  }

  /// Create a copy of GroupOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupOrderPersonCopyWith<$Res> get person {
    return $GroupOrderPersonCopyWith<$Res>(_value.person, (value) {
      return _then(_value.copyWith(person: value) as $Val);
    });
  }

  /// Create a copy of GroupOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndividualOrderCopyWith<$Res> get individualOrder {
    return $IndividualOrderCopyWith<$Res>(_value.individualOrder, (value) {
      return _then(_value.copyWith(individualOrder: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupOrderItemImplCopyWith<$Res>
    implements $GroupOrderItemCopyWith<$Res> {
  factory _$$GroupOrderItemImplCopyWith(_$GroupOrderItemImpl value,
          $Res Function(_$GroupOrderItemImpl) then) =
      __$$GroupOrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GroupOrderPerson person, IndividualOrder individualOrder});

  @override
  $GroupOrderPersonCopyWith<$Res> get person;
  @override
  $IndividualOrderCopyWith<$Res> get individualOrder;
}

/// @nodoc
class __$$GroupOrderItemImplCopyWithImpl<$Res>
    extends _$GroupOrderItemCopyWithImpl<$Res, _$GroupOrderItemImpl>
    implements _$$GroupOrderItemImplCopyWith<$Res> {
  __$$GroupOrderItemImplCopyWithImpl(
      _$GroupOrderItemImpl _value, $Res Function(_$GroupOrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? person = null,
    Object? individualOrder = null,
  }) {
    return _then(_$GroupOrderItemImpl(
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as GroupOrderPerson,
      individualOrder: null == individualOrder
          ? _value.individualOrder
          : individualOrder // ignore: cast_nullable_to_non_nullable
              as IndividualOrder,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupOrderItemImpl
    with DiagnosticableTreeMixin
    implements _GroupOrderItem {
  const _$GroupOrderItemImpl(
      {required this.person, required this.individualOrder});

  factory _$GroupOrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupOrderItemImplFromJson(json);

  @override
  final GroupOrderPerson person;
  @override
  final IndividualOrder individualOrder;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GroupOrderItem(person: $person, individualOrder: $individualOrder)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GroupOrderItem'))
      ..add(DiagnosticsProperty('person', person))
      ..add(DiagnosticsProperty('individualOrder', individualOrder));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupOrderItemImpl &&
            (identical(other.person, person) || other.person == person) &&
            (identical(other.individualOrder, individualOrder) ||
                other.individualOrder == individualOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, person, individualOrder);

  /// Create a copy of GroupOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupOrderItemImplCopyWith<_$GroupOrderItemImpl> get copyWith =>
      __$$GroupOrderItemImplCopyWithImpl<_$GroupOrderItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupOrderItemImplToJson(
      this,
    );
  }
}

abstract class _GroupOrderItem implements GroupOrderItem {
  const factory _GroupOrderItem(
      {required final GroupOrderPerson person,
      required final IndividualOrder individualOrder}) = _$GroupOrderItemImpl;

  factory _GroupOrderItem.fromJson(Map<String, dynamic> json) =
      _$GroupOrderItemImpl.fromJson;

  @override
  GroupOrderPerson get person;
  @override
  IndividualOrder get individualOrder;

  /// Create a copy of GroupOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupOrderItemImplCopyWith<_$GroupOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  String get storeId => throw _privateConstructorUsedError;
  List<CartProduct> get products => throw _privateConstructorUsedError;
  String get placeDescription => throw _privateConstructorUsedError;
  DateTime get deliveryDate => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get initialPricesTotal => throw _privateConstructorUsedError;

  /// Serializes this CartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call(
      {String storeId,
      List<CartProduct> products,
      String placeDescription,
      DateTime deliveryDate,
      double subtotal,
      double initialPricesTotal});
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? products = null,
    Object? placeDescription = null,
    Object? deliveryDate = null,
    Object? subtotal = null,
    Object? initialPricesTotal = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<CartProduct>,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      initialPricesTotal: null == initialPricesTotal
          ? _value.initialPricesTotal
          : initialPricesTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
          _$CartItemImpl value, $Res Function(_$CartItemImpl) then) =
      __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String storeId,
      List<CartProduct> products,
      String placeDescription,
      DateTime deliveryDate,
      double subtotal,
      double initialPricesTotal});
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
      _$CartItemImpl _value, $Res Function(_$CartItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? products = null,
    Object? placeDescription = null,
    Object? deliveryDate = null,
    Object? subtotal = null,
    Object? initialPricesTotal = null,
  }) {
    return _then(_$CartItemImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<CartProduct>,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      initialPricesTotal: null == initialPricesTotal
          ? _value.initialPricesTotal
          : initialPricesTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl with DiagnosticableTreeMixin implements _CartItem {
  const _$CartItemImpl(
      {required this.storeId,
      required final List<CartProduct> products,
      required this.placeDescription,
      required this.deliveryDate,
      required this.subtotal,
      required this.initialPricesTotal})
      : _products = products;

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  final String storeId;
  final List<CartProduct> _products;
  @override
  List<CartProduct> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final String placeDescription;
  @override
  final DateTime deliveryDate;
  @override
  final double subtotal;
  @override
  final double initialPricesTotal;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CartItem(storeId: $storeId, products: $products, placeDescription: $placeDescription, deliveryDate: $deliveryDate, subtotal: $subtotal, initialPricesTotal: $initialPricesTotal)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CartItem'))
      ..add(DiagnosticsProperty('storeId', storeId))
      ..add(DiagnosticsProperty('products', products))
      ..add(DiagnosticsProperty('placeDescription', placeDescription))
      ..add(DiagnosticsProperty('deliveryDate', deliveryDate))
      ..add(DiagnosticsProperty('subtotal', subtotal))
      ..add(DiagnosticsProperty('initialPricesTotal', initialPricesTotal));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.placeDescription, placeDescription) ||
                other.placeDescription == placeDescription) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.initialPricesTotal, initialPricesTotal) ||
                other.initialPricesTotal == initialPricesTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      const DeepCollectionEquality().hash(_products),
      placeDescription,
      deliveryDate,
      subtotal,
      initialPricesTotal);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(
      this,
    );
  }
}

abstract class _CartItem implements CartItem {
  const factory _CartItem(
      {required final String storeId,
      required final List<CartProduct> products,
      required final String placeDescription,
      required final DateTime deliveryDate,
      required final double subtotal,
      required final double initialPricesTotal}) = _$CartItemImpl;

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  String get storeId;
  @override
  List<CartProduct> get products;
  @override
  String get placeDescription;
  @override
  DateTime get deliveryDate;
  @override
  double get subtotal;
  @override
  double get initialPricesTotal;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartProduct _$CartProductFromJson(Map<String, dynamic> json) {
  return _CartProduct.fromJson(json);
}

/// @nodoc
mixin _$CartProduct {
  List<CartProductOption> get optionalOptions =>
      throw _privateConstructorUsedError;
  List<CartProductOption> get requiredOptions =>
      throw _privateConstructorUsedError;
  double get purchasePrice => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  String get productReplacementId => throw _privateConstructorUsedError;
  String get backupInstruction => throw _privateConstructorUsedError;

  /// Serializes this CartProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartProductCopyWith<CartProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartProductCopyWith<$Res> {
  factory $CartProductCopyWith(
          CartProduct value, $Res Function(CartProduct) then) =
      _$CartProductCopyWithImpl<$Res, CartProduct>;
  @useResult
  $Res call(
      {List<CartProductOption> optionalOptions,
      List<CartProductOption> requiredOptions,
      double purchasePrice,
      String name,
      String id,
      int quantity,
      String note,
      String productReplacementId,
      String backupInstruction});
}

/// @nodoc
class _$CartProductCopyWithImpl<$Res, $Val extends CartProduct>
    implements $CartProductCopyWith<$Res> {
  _$CartProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optionalOptions = null,
    Object? requiredOptions = null,
    Object? purchasePrice = null,
    Object? name = null,
    Object? id = null,
    Object? quantity = null,
    Object? note = null,
    Object? productReplacementId = null,
    Object? backupInstruction = null,
  }) {
    return _then(_value.copyWith(
      optionalOptions: null == optionalOptions
          ? _value.optionalOptions
          : optionalOptions // ignore: cast_nullable_to_non_nullable
              as List<CartProductOption>,
      requiredOptions: null == requiredOptions
          ? _value.requiredOptions
          : requiredOptions // ignore: cast_nullable_to_non_nullable
              as List<CartProductOption>,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      productReplacementId: null == productReplacementId
          ? _value.productReplacementId
          : productReplacementId // ignore: cast_nullable_to_non_nullable
              as String,
      backupInstruction: null == backupInstruction
          ? _value.backupInstruction
          : backupInstruction // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartProductImplCopyWith<$Res>
    implements $CartProductCopyWith<$Res> {
  factory _$$CartProductImplCopyWith(
          _$CartProductImpl value, $Res Function(_$CartProductImpl) then) =
      __$$CartProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CartProductOption> optionalOptions,
      List<CartProductOption> requiredOptions,
      double purchasePrice,
      String name,
      String id,
      int quantity,
      String note,
      String productReplacementId,
      String backupInstruction});
}

/// @nodoc
class __$$CartProductImplCopyWithImpl<$Res>
    extends _$CartProductCopyWithImpl<$Res, _$CartProductImpl>
    implements _$$CartProductImplCopyWith<$Res> {
  __$$CartProductImplCopyWithImpl(
      _$CartProductImpl _value, $Res Function(_$CartProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optionalOptions = null,
    Object? requiredOptions = null,
    Object? purchasePrice = null,
    Object? name = null,
    Object? id = null,
    Object? quantity = null,
    Object? note = null,
    Object? productReplacementId = null,
    Object? backupInstruction = null,
  }) {
    return _then(_$CartProductImpl(
      optionalOptions: null == optionalOptions
          ? _value._optionalOptions
          : optionalOptions // ignore: cast_nullable_to_non_nullable
              as List<CartProductOption>,
      requiredOptions: null == requiredOptions
          ? _value._requiredOptions
          : requiredOptions // ignore: cast_nullable_to_non_nullable
              as List<CartProductOption>,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      productReplacementId: null == productReplacementId
          ? _value.productReplacementId
          : productReplacementId // ignore: cast_nullable_to_non_nullable
              as String,
      backupInstruction: null == backupInstruction
          ? _value.backupInstruction
          : backupInstruction // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartProductImpl with DiagnosticableTreeMixin implements _CartProduct {
  const _$CartProductImpl(
      {required final List<CartProductOption> optionalOptions,
      required final List<CartProductOption> requiredOptions,
      required this.purchasePrice,
      required this.name,
      required this.id,
      required this.quantity,
      required this.note,
      required this.productReplacementId,
      required this.backupInstruction})
      : _optionalOptions = optionalOptions,
        _requiredOptions = requiredOptions;

  factory _$CartProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartProductImplFromJson(json);

  final List<CartProductOption> _optionalOptions;
  @override
  List<CartProductOption> get optionalOptions {
    if (_optionalOptions is EqualUnmodifiableListView) return _optionalOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_optionalOptions);
  }

  final List<CartProductOption> _requiredOptions;
  @override
  List<CartProductOption> get requiredOptions {
    if (_requiredOptions is EqualUnmodifiableListView) return _requiredOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredOptions);
  }

  @override
  final double purchasePrice;
  @override
  final String name;
  @override
  final String id;
  @override
  final int quantity;
  @override
  final String note;
  @override
  final String productReplacementId;
  @override
  final String backupInstruction;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CartProduct(optionalOptions: $optionalOptions, requiredOptions: $requiredOptions, purchasePrice: $purchasePrice, name: $name, id: $id, quantity: $quantity, note: $note, productReplacementId: $productReplacementId, backupInstruction: $backupInstruction)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CartProduct'))
      ..add(DiagnosticsProperty('optionalOptions', optionalOptions))
      ..add(DiagnosticsProperty('requiredOptions', requiredOptions))
      ..add(DiagnosticsProperty('purchasePrice', purchasePrice))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('quantity', quantity))
      ..add(DiagnosticsProperty('note', note))
      ..add(DiagnosticsProperty('productReplacementId', productReplacementId))
      ..add(DiagnosticsProperty('backupInstruction', backupInstruction));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartProductImpl &&
            const DeepCollectionEquality()
                .equals(other._optionalOptions, _optionalOptions) &&
            const DeepCollectionEquality()
                .equals(other._requiredOptions, _requiredOptions) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.productReplacementId, productReplacementId) ||
                other.productReplacementId == productReplacementId) &&
            (identical(other.backupInstruction, backupInstruction) ||
                other.backupInstruction == backupInstruction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_optionalOptions),
      const DeepCollectionEquality().hash(_requiredOptions),
      purchasePrice,
      name,
      id,
      quantity,
      note,
      productReplacementId,
      backupInstruction);

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartProductImplCopyWith<_$CartProductImpl> get copyWith =>
      __$$CartProductImplCopyWithImpl<_$CartProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartProductImplToJson(
      this,
    );
  }
}

abstract class _CartProduct implements CartProduct {
  const factory _CartProduct(
      {required final List<CartProductOption> optionalOptions,
      required final List<CartProductOption> requiredOptions,
      required final double purchasePrice,
      required final String name,
      required final String id,
      required final int quantity,
      required final String note,
      required final String productReplacementId,
      required final String backupInstruction}) = _$CartProductImpl;

  factory _CartProduct.fromJson(Map<String, dynamic> json) =
      _$CartProductImpl.fromJson;

  @override
  List<CartProductOption> get optionalOptions;
  @override
  List<CartProductOption> get requiredOptions;
  @override
  double get purchasePrice;
  @override
  String get name;
  @override
  String get id;
  @override
  int get quantity;
  @override
  String get note;
  @override
  String get productReplacementId;
  @override
  String get backupInstruction;

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartProductImplCopyWith<_$CartProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartProductOption _$CartProductOptionFromJson(Map<String, dynamic> json) {
  return _CartProductOption.fromJson(json);
}

/// @nodoc
mixin _$CartProductOption {
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  List<CartProductOption> get options => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;

  /// Serializes this CartProductOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartProductOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartProductOptionCopyWith<CartProductOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartProductOptionCopyWith<$Res> {
  factory $CartProductOptionCopyWith(
          CartProductOption value, $Res Function(CartProductOption) then) =
      _$CartProductOptionCopyWithImpl<$Res, CartProductOption>;
  @useResult
  $Res call(
      {String name,
      int quantity,
      List<CartProductOption> options,
      String categoryName});
}

/// @nodoc
class _$CartProductOptionCopyWithImpl<$Res, $Val extends CartProductOption>
    implements $CartProductOptionCopyWith<$Res> {
  _$CartProductOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartProductOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? options = null,
    Object? categoryName = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<CartProductOption>,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartProductOptionImplCopyWith<$Res>
    implements $CartProductOptionCopyWith<$Res> {
  factory _$$CartProductOptionImplCopyWith(_$CartProductOptionImpl value,
          $Res Function(_$CartProductOptionImpl) then) =
      __$$CartProductOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      int quantity,
      List<CartProductOption> options,
      String categoryName});
}

/// @nodoc
class __$$CartProductOptionImplCopyWithImpl<$Res>
    extends _$CartProductOptionCopyWithImpl<$Res, _$CartProductOptionImpl>
    implements _$$CartProductOptionImplCopyWith<$Res> {
  __$$CartProductOptionImplCopyWithImpl(_$CartProductOptionImpl _value,
      $Res Function(_$CartProductOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartProductOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? options = null,
    Object? categoryName = null,
  }) {
    return _then(_$CartProductOptionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<CartProductOption>,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartProductOptionImpl
    with DiagnosticableTreeMixin
    implements _CartProductOption {
  const _$CartProductOptionImpl(
      {required this.name,
      required this.quantity,
      required final List<CartProductOption> options,
      required this.categoryName})
      : _options = options;

  factory _$CartProductOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartProductOptionImplFromJson(json);

  @override
  final String name;
  @override
  final int quantity;
  final List<CartProductOption> _options;
  @override
  List<CartProductOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final String categoryName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CartProductOption(name: $name, quantity: $quantity, options: $options, categoryName: $categoryName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CartProductOption'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('quantity', quantity))
      ..add(DiagnosticsProperty('options', options))
      ..add(DiagnosticsProperty('categoryName', categoryName));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartProductOptionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, quantity,
      const DeepCollectionEquality().hash(_options), categoryName);

  /// Create a copy of CartProductOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartProductOptionImplCopyWith<_$CartProductOptionImpl> get copyWith =>
      __$$CartProductOptionImplCopyWithImpl<_$CartProductOptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartProductOptionImplToJson(
      this,
    );
  }
}

abstract class _CartProductOption implements CartProductOption {
  const factory _CartProductOption(
      {required final String name,
      required final int quantity,
      required final List<CartProductOption> options,
      required final String categoryName}) = _$CartProductOptionImpl;

  factory _CartProductOption.fromJson(Map<String, dynamic> json) =
      _$CartProductOptionImpl.fromJson;

  @override
  String get name;
  @override
  int get quantity;
  @override
  List<CartProductOption> get options;
  @override
  String get categoryName;

  /// Create a copy of CartProductOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartProductOptionImplCopyWith<_$CartProductOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
