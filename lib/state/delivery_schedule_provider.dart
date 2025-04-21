import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_eats_clone/models/credit_card_details/credit_card_details_model.dart';

import '../presentation/features/sign_in/states/onboarding_state_model.dart';

final deliveryScheduleProvider = StateProvider<DateTime?>((ref) {
  return null;
});

final deliveryScheduleProviderForRecipient = StateProvider<DateTime?>((ref) {
  return null;
});

final tempAddressForRecipient = StateProvider<AddressDetails?>((ref) {
  return null;
});

final paymentOptionProvider = StateProvider<CreditCardDetails?>((ref) {
  return null;
});
