import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/features/sign_in/views/sign_in/sign_in_view_models.dart';

class AccountStateNotifier extends StateNotifier<AccountDetails> {
  AccountStateNotifier()
      : super(AccountDetails(
            userId: '6646516331',
            name: 'Nana Fenyi',
            type: 'Personal',
            hasUberOne: true));
}

final accountStateProvider =
    StateNotifierProvider<AccountStateNotifier, AccountDetails>((ref) {
  return AccountStateNotifier();
});
