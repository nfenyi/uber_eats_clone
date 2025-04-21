// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupOrder _$GroupOrderFromJson(Map<String, dynamic> json) {
  return _GroupOrder.fromJson(json);
}

/// @nodoc
mixin _$GroupOrder {
  String get id => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime? get firstOrderSchedule => throw _privateConstructorUsedError;
  String? get frequency => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  Object get storeRef => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get placeDescription => throw _privateConstructorUsedError;
  DateTime? get orderByDeadline => throw _privateConstructorUsedError;
  String? get orderPlacementSetting => throw _privateConstructorUsedError;
  String? get whoPays => throw _privateConstructorUsedError;
  double? get spendingLimit => throw _privateConstructorUsedError;
  List<String> get persons => throw _privateConstructorUsedError;
  List<Object> get orderScheduleRefs => throw _privateConstructorUsedError;

  /// Serializes this GroupOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupOrderCopyWith<GroupOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupOrderCopyWith<$Res> {
  factory $GroupOrderCopyWith(
          GroupOrder value, $Res Function(GroupOrder) then) =
      _$GroupOrderCopyWithImpl<$Res, GroupOrder>;
  @useResult
  $Res call(
      {String id,
      DateTime? createdAt,
      String name,
      DateTime? firstOrderSchedule,
      String? frequency,
      DateTime? endDate,
      Object storeRef,
      String ownerId,
      String placeDescription,
      DateTime? orderByDeadline,
      String? orderPlacementSetting,
      String? whoPays,
      double? spendingLimit,
      List<String> persons,
      List<Object> orderScheduleRefs});
}

/// @nodoc
class _$GroupOrderCopyWithImpl<$Res, $Val extends GroupOrder>
    implements $GroupOrderCopyWith<$Res> {
  _$GroupOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? name = null,
    Object? firstOrderSchedule = freezed,
    Object? frequency = freezed,
    Object? endDate = freezed,
    Object? storeRef = null,
    Object? ownerId = null,
    Object? placeDescription = null,
    Object? orderByDeadline = freezed,
    Object? orderPlacementSetting = freezed,
    Object? whoPays = freezed,
    Object? spendingLimit = freezed,
    Object? persons = null,
    Object? orderScheduleRefs = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      firstOrderSchedule: freezed == firstOrderSchedule
          ? _value.firstOrderSchedule
          : firstOrderSchedule // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeRef: null == storeRef ? _value.storeRef : storeRef,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      orderByDeadline: freezed == orderByDeadline
          ? _value.orderByDeadline
          : orderByDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderPlacementSetting: freezed == orderPlacementSetting
          ? _value.orderPlacementSetting
          : orderPlacementSetting // ignore: cast_nullable_to_non_nullable
              as String?,
      whoPays: freezed == whoPays
          ? _value.whoPays
          : whoPays // ignore: cast_nullable_to_non_nullable
              as String?,
      spendingLimit: freezed == spendingLimit
          ? _value.spendingLimit
          : spendingLimit // ignore: cast_nullable_to_non_nullable
              as double?,
      persons: null == persons
          ? _value.persons
          : persons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      orderScheduleRefs: null == orderScheduleRefs
          ? _value.orderScheduleRefs
          : orderScheduleRefs // ignore: cast_nullable_to_non_nullable
              as List<Object>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupOrderImplCopyWith<$Res>
    implements $GroupOrderCopyWith<$Res> {
  factory _$$GroupOrderImplCopyWith(
          _$GroupOrderImpl value, $Res Function(_$GroupOrderImpl) then) =
      __$$GroupOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime? createdAt,
      String name,
      DateTime? firstOrderSchedule,
      String? frequency,
      DateTime? endDate,
      Object storeRef,
      String ownerId,
      String placeDescription,
      DateTime? orderByDeadline,
      String? orderPlacementSetting,
      String? whoPays,
      double? spendingLimit,
      List<String> persons,
      List<Object> orderScheduleRefs});
}

/// @nodoc
class __$$GroupOrderImplCopyWithImpl<$Res>
    extends _$GroupOrderCopyWithImpl<$Res, _$GroupOrderImpl>
    implements _$$GroupOrderImplCopyWith<$Res> {
  __$$GroupOrderImplCopyWithImpl(
      _$GroupOrderImpl _value, $Res Function(_$GroupOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? name = null,
    Object? firstOrderSchedule = freezed,
    Object? frequency = freezed,
    Object? endDate = freezed,
    Object? storeRef = null,
    Object? ownerId = null,
    Object? placeDescription = null,
    Object? orderByDeadline = freezed,
    Object? orderPlacementSetting = freezed,
    Object? whoPays = freezed,
    Object? spendingLimit = freezed,
    Object? persons = null,
    Object? orderScheduleRefs = null,
  }) {
    return _then(_$GroupOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      firstOrderSchedule: freezed == firstOrderSchedule
          ? _value.firstOrderSchedule
          : firstOrderSchedule // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeRef: null == storeRef ? _value.storeRef : storeRef,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      orderByDeadline: freezed == orderByDeadline
          ? _value.orderByDeadline
          : orderByDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderPlacementSetting: freezed == orderPlacementSetting
          ? _value.orderPlacementSetting
          : orderPlacementSetting // ignore: cast_nullable_to_non_nullable
              as String?,
      whoPays: freezed == whoPays
          ? _value.whoPays
          : whoPays // ignore: cast_nullable_to_non_nullable
              as String?,
      spendingLimit: freezed == spendingLimit
          ? _value.spendingLimit
          : spendingLimit // ignore: cast_nullable_to_non_nullable
              as double?,
      persons: null == persons
          ? _value._persons
          : persons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      orderScheduleRefs: null == orderScheduleRefs
          ? _value._orderScheduleRefs
          : orderScheduleRefs // ignore: cast_nullable_to_non_nullable
              as List<Object>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupOrderImpl with DiagnosticableTreeMixin implements _GroupOrder {
  _$GroupOrderImpl(
      {required this.id,
      required this.createdAt,
      required this.name,
      this.firstOrderSchedule,
      this.frequency,
      this.endDate,
      required this.storeRef,
      required this.ownerId,
      required this.placeDescription,
      this.orderByDeadline,
      this.orderPlacementSetting,
      required this.whoPays,
      this.spendingLimit,
      final List<String> persons = const [],
      final List<Object> orderScheduleRefs = const []})
      : _persons = persons,
        _orderScheduleRefs = orderScheduleRefs;

  factory _$GroupOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupOrderImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime? createdAt;
  @override
  final String name;
  @override
  final DateTime? firstOrderSchedule;
  @override
  final String? frequency;
  @override
  final DateTime? endDate;
  @override
  final Object storeRef;
  @override
  final String ownerId;
  @override
  final String placeDescription;
  @override
  final DateTime? orderByDeadline;
  @override
  final String? orderPlacementSetting;
  @override
  final String? whoPays;
  @override
  final double? spendingLimit;
  final List<String> _persons;
  @override
  @JsonKey()
  List<String> get persons {
    if (_persons is EqualUnmodifiableListView) return _persons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_persons);
  }

  final List<Object> _orderScheduleRefs;
  @override
  @JsonKey()
  List<Object> get orderScheduleRefs {
    if (_orderScheduleRefs is EqualUnmodifiableListView)
      return _orderScheduleRefs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderScheduleRefs);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GroupOrder(id: $id, createdAt: $createdAt, name: $name, firstOrderSchedule: $firstOrderSchedule, frequency: $frequency, endDate: $endDate, storeRef: $storeRef, ownerId: $ownerId, placeDescription: $placeDescription, orderByDeadline: $orderByDeadline, orderPlacementSetting: $orderPlacementSetting, whoPays: $whoPays, spendingLimit: $spendingLimit, persons: $persons, orderScheduleRefs: $orderScheduleRefs)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GroupOrder'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('firstOrderSchedule', firstOrderSchedule))
      ..add(DiagnosticsProperty('frequency', frequency))
      ..add(DiagnosticsProperty('endDate', endDate))
      ..add(DiagnosticsProperty('storeRef', storeRef))
      ..add(DiagnosticsProperty('ownerId', ownerId))
      ..add(DiagnosticsProperty('placeDescription', placeDescription))
      ..add(DiagnosticsProperty('orderByDeadline', orderByDeadline))
      ..add(DiagnosticsProperty('orderPlacementSetting', orderPlacementSetting))
      ..add(DiagnosticsProperty('whoPays', whoPays))
      ..add(DiagnosticsProperty('spendingLimit', spendingLimit))
      ..add(DiagnosticsProperty('persons', persons))
      ..add(DiagnosticsProperty('orderScheduleRefs', orderScheduleRefs));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.firstOrderSchedule, firstOrderSchedule) ||
                other.firstOrderSchedule == firstOrderSchedule) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other.storeRef, storeRef) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.placeDescription, placeDescription) ||
                other.placeDescription == placeDescription) &&
            (identical(other.orderByDeadline, orderByDeadline) ||
                other.orderByDeadline == orderByDeadline) &&
            (identical(other.orderPlacementSetting, orderPlacementSetting) ||
                other.orderPlacementSetting == orderPlacementSetting) &&
            (identical(other.whoPays, whoPays) || other.whoPays == whoPays) &&
            (identical(other.spendingLimit, spendingLimit) ||
                other.spendingLimit == spendingLimit) &&
            const DeepCollectionEquality().equals(other._persons, _persons) &&
            const DeepCollectionEquality()
                .equals(other._orderScheduleRefs, _orderScheduleRefs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      name,
      firstOrderSchedule,
      frequency,
      endDate,
      const DeepCollectionEquality().hash(storeRef),
      ownerId,
      placeDescription,
      orderByDeadline,
      orderPlacementSetting,
      whoPays,
      spendingLimit,
      const DeepCollectionEquality().hash(_persons),
      const DeepCollectionEquality().hash(_orderScheduleRefs));

  /// Create a copy of GroupOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupOrderImplCopyWith<_$GroupOrderImpl> get copyWith =>
      __$$GroupOrderImplCopyWithImpl<_$GroupOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupOrderImplToJson(
      this,
    );
  }
}

abstract class _GroupOrder implements GroupOrder {
  factory _GroupOrder(
      {required final String id,
      required final DateTime? createdAt,
      required final String name,
      final DateTime? firstOrderSchedule,
      final String? frequency,
      final DateTime? endDate,
      required final Object storeRef,
      required final String ownerId,
      required final String placeDescription,
      final DateTime? orderByDeadline,
      final String? orderPlacementSetting,
      required final String? whoPays,
      final double? spendingLimit,
      final List<String> persons,
      final List<Object> orderScheduleRefs}) = _$GroupOrderImpl;

  factory _GroupOrder.fromJson(Map<String, dynamic> json) =
      _$GroupOrderImpl.fromJson;

  @override
  String get id;
  @override
  DateTime? get createdAt;
  @override
  String get name;
  @override
  DateTime? get firstOrderSchedule;
  @override
  String? get frequency;
  @override
  DateTime? get endDate;
  @override
  Object get storeRef;
  @override
  String get ownerId;
  @override
  String get placeDescription;
  @override
  DateTime? get orderByDeadline;
  @override
  String? get orderPlacementSetting;
  @override
  String? get whoPays;
  @override
  double? get spendingLimit;
  @override
  List<String> get persons;
  @override
  List<Object> get orderScheduleRefs;

  /// Create a copy of GroupOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupOrderImplCopyWith<_$GroupOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
