import 'package:country_ip/country_ip.dart';
// import 'package:dartz/dartz.dart';

import '../../models/device_info/device_info_model.dart';
import '../../utils/enums.dart';
import '../../utils/result.dart';

abstract class UserAuthRepository {
  String? get userId;
  bool get isAlreadyLoggedIn;
  String get displayName;
  String? get email;
  String? get photoURL;
  String? get phoneNumber;
  AuthState get authenticationState;
  Future<Result<CountryResponse>> getCountry();
  Future<Result<void>> getStarted();
  Future<Result<AuthState>> signInWithGoogle();
  Future<Result<AuthState>> signInWithApple();
  Future<Result<void>> sendSignInLinkToEmail(String email);
  Future<Result<void>> updateDisplayName(String name);
  Future<Result<void>> updatePhoneNumber(
      {required String smsCode, required String verificationId});
  Future<Result<Map<String, DeviceUserInfo>>> findMyDevice();
  Future<Result<void>> logOut();
  Future<Result<dynamic>> verifyPhoneNumber(String phoneNumber);
}
