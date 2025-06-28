import 'package:country_ip/country_ip.dart';
import 'package:flutter/foundation.dart';
import '../../../../../models/device_info/device_info_model.dart';
import '../../../../../repositories/user_auth/user_auth_repository_remote.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/result.dart';

class SignInViewModel extends ChangeNotifier {
  final _authenticator = UserAuthRepositoryRemote();

  Future<Result<void>> logOut() async {
    return await _authenticator.logOut();
  }

  Future<Result<dynamic>> verifyPhoneNumber(String phoneNumber) async {
    return await _authenticator.verifyPhoneNumber(phoneNumber);
  }

  Future<Result<AuthState>> signInWithGoogle() async {
    return await _authenticator.signInWithGoogle();
  }

  Future<Result<AuthState>> signInWithApple() async {
    return await _authenticator.signInWithApple();
  }

  Future<Result<Map<String, DeviceUserInfo>>> findMyAccount() async {
    return await _authenticator.findMyDevice();
  }

  Future<Result<void>> sendSignInLinkToEmail(String email) async {
    return await _authenticator.sendSignInLinkToEmail(email);
  }

  Future<Result<CountryResponse>> getCountry() async {
    return await _authenticator.getCountry();
  }
}

// class _AuthViewModelState {
//   final bool isLoading;
//   final AuthState authState;
//   final dynamic payload;

//   const _AuthViewModelState(
//       {required this.isLoading, required this.authState, this.payload});

//   const _AuthViewModelState.loggedOut()
//       : isLoading = false,
//         payload = null,
//         authState = AuthState.unAuthenticated;

//   _AuthViewModelState copiedWithIsLoading(bool isLoading) =>
//       _AuthViewModelState(
//         isLoading: isLoading,
//         authState: authState,
//       );
// }
