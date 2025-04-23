import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String paymentMethodName,
    required double amountPaid,
    required String creditCardType,
    required String? cardNumber,
    required DateTime datePaid,
  }) = _Payment;

  factory Payment.fromJson(Map<String, Object?> json) =>
      _$PaymentFromJson(json);
}
