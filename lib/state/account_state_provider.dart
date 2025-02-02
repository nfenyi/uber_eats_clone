import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_eats_clone/state/account_state_model.dart';

class AccountStateNotifier extends StateNotifier<AccountState> {
  AccountStateNotifier()
      : super(AccountState(name: 'Nana Fenyi', type: 'Personal'));
}

final accountStateProvider =
    StateNotifierProvider<AccountStateNotifier, AccountState>((ref) {
  return AccountStateNotifier();
});
