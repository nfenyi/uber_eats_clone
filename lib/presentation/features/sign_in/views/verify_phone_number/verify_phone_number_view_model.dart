import 'package:flutter/foundation.dart';
import 'package:uber_eats_clone/utils/enums.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uber_eats_clone/utils/enums.dart';

import '../../../../../repositories/user_auth/user_auth_repository_remote.dart';
import '../../../../../utils/result.dart';

class VerifyPhoneNumberViewModel extends ChangeNotifier {
  final _authenticator = UserAuthRepositoryRemote();

  Future<Result<AuthState>> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    return await _authenticator.signInWithPhoneNumberWithCode(
        verificationId: verificationId, smsCode: smsCode);
    // if (phoneAuthCredResult is RError) {
    //   state = _VerifyPhoneNumberViewModelState(false, AuthState.unAuthenticated,
    //       payload: (phoneAuthCredResult as RError).errorMessage.toString());
    // }

    // state = _VerifyPhoneNumberViewModelState(
    //     false, (phoneAuthCredResult as Ok<AuthState>).value);
  }

  Future<Result<void>> updatePhoneNumber(
      String verificationId, String smsCode) async {
    return await _authenticator.updatePhoneNumber(
        verificationId: verificationId, smsCode: smsCode);
  }
}

// class _VerifyPhoneNumberViewModelState {
//   final bool isLoading;
//   final AuthState status;
//   final String? payload;

//   _VerifyPhoneNumberViewModelState(this.isLoading, this.status, {this.payload});

//   _VerifyPhoneNumberViewModelState copiedWithIsLoading(bool isLoading) =>
//       _VerifyPhoneNumberViewModelState(isLoading, status, payload: payload);
// }
