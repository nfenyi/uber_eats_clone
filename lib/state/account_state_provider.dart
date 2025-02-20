import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/features/sign_in/views/sign_in/sign_in_provider.dart';

class AccountStateNotifier extends StateNotifier<AccountDetails> {
  AccountStateNotifier()
      : super(AccountDetails(
            userId: 'Unknown Id',
            name: 'Unknown Name',
            type: 'Personal',
            hasUberOne: true));
}

final accountStateProvider =
    StateNotifierProvider<AccountStateNotifier, AccountDetails>((ref) {
  return AccountStateNotifier();
});
