import 'package:freezed_annotation/freezed_annotation.dart';

part 'uber_cash_model.freezed.dart';
part 'uber_cash_model.g.dart';

@freezed
class UberCash with _$UberCash {
  const factory UberCash({
    @Default(false) bool isActive,
    @Default(0.00) double balance,
    @Default(0) double cashAdded,
    @Default(0) double cashSpent,
  }) = _UberCash;

  factory UberCash.fromJson(Map<String, Object?> json) =>
      _$UberCashFromJson(json);
}
