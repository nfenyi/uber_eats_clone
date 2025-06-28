import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../repositories/user_auth/user_auth_repository_remote.dart';
import '../../../../../utils/result.dart';

class NameNotifier extends StateNotifier<_NameNotifierState> {
  NameNotifier() : super(_NameNotifierState(false, null));
  final _authenticator = UserAuthRepositoryRemote();

  Future<void> updateName(String name) async {
    state = _NameNotifierState(true, null);
    final result = await _authenticator.updateDisplayName(name);
    state = _NameNotifierState(false, result);
  }
}

class _NameNotifierState {
  final bool isLoading;
  final Result<void>? result;

  _NameNotifierState(this.isLoading, this.result);
}

final nameProvider = StateNotifierProvider<NameNotifier, _NameNotifierState>(
  (ref) => NameNotifier(),
);
