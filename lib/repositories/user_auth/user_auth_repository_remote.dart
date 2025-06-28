import 'package:country_ip/country_ip.dart';
// import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uber_eats_clone/hive_adapters/country/country_ip_model.dart';

import 'package:uber_eats_clone/models/user/user_model.dart';
import 'package:uber_eats_clone/repositories/user_auth/user_auth_repository.dart';
import 'package:uber_eats_clone/services/country_ip_services.dart';
import 'package:uber_eats_clone/services/firestore_services.dart';
import 'package:uber_eats_clone/services/flutter_udid_services.dart';
import 'package:uber_eats_clone/utils/result.dart';

import '../../models/device_info/device_info_model.dart';
import '../../services/firebase_auth_services.dart';
import '../../services/google_sign_in_services.dart';
import '../../services/hive_services.dart';
import '../../utils/enums.dart';

class UserAuthRepositoryRemote extends UserAuthRepository {
  @override
  String? get userId => FirebaseAuthServices.userId;
  @override
  bool get isAlreadyLoggedIn => FirebaseAuthServices.isAlreadyLoggedIn;
  @override
  String get displayName => FirebaseAuthServices.displayName;
  @override
  String? get phoneNumber => FirebaseAuthServices.phoneNumber;
  @override
  String? get email => FirebaseAuthServices.email;
  @override
  String? get photoURL => FirebaseAuthServices.photoURL;

  CountryResponse? _country;

  @override
  Future<Result<void>> logOut() async {
    final result = await FirebaseAuthServices.logOut();
    if (result is Ok) {
      await HiveServices.setAuthenticated(false);
    }
    return result;
  }

  @override
  Future<Result<AuthState>> signInWithApple() async {
    final result = await FirebaseAuthServices.signInWithApple();
    if (result is RError) {
      return Result.error((result as RError).errorMessage);
    }
    return await _ensureDeviceInfoIsSet(federated: true);
  }

  @override
  Future<Result<AuthState>> signInWithGoogle() async {
    final result1 = await GoogleSignInServices.signIn();
    if (result1 is RError) {
      return Result.error((result1).errorMessage);
    }
    final googleAuth = result1.payload as GoogleSignInAuthentication;
    final result2 = await FirebaseAuthServices.signInWithGoogle(googleAuth);
    if (result2 is RError) {
      return Result.error((result2 as RError).errorMessage);
    }
    return await _ensureDeviceInfoIsSet(federated: true);
  }

  Future<Result<AuthState>> _ensureDeviceInfoIsSet(
      {required bool federated}) async {
    final userDetailsResult =
        await FirestoreServices.getUserDetails(FirebaseAuthServices.userId!);
    if (userDetailsResult is RError) {
      return Result.error((userDetailsResult as RError).errorMessage);
    }
    final userDetails = (userDetailsResult as Ok<UserDetails>).value;
    if (userDetails.onboarded == true) {
      String deviceId = await FlutterUdidServices.getDeviceId();
      final devicesInfoResult =
          await FirestoreServices.getDevicesInfo(deviceId);
      if (devicesInfoResult is RError) {
        return Result.error((devicesInfoResult as RError).errorMessage);
      }
      final deviceInfoFromFirestore =
          (devicesInfoResult as Ok<Map<String, DeviceUserInfo>>).value;
      if (deviceInfoFromFirestore.isEmpty ||
          deviceInfoFromFirestore[userId] == null) {
        final deviceInfo = <String, dynamic>{
          userId!: {
            'name': displayName,
            'profilePic': photoURL,
            "email": email,
            "phoneNumber": phoneNumber
          }
        };

        await FirestoreServices.storeDeviceInfo(deviceId, deviceInfo);
      }

      await HiveServices.setAuthenticated(true);
      return const Result.ok(AuthState.authenticated);
    } else {
      return Result.ok(federated
          ? AuthState.federatedRegistration
          : AuthState.registeringWithPhoneNumber);
    }
  }

  @override
  Future<Result<dynamic>> verifyPhoneNumber(String phoneNumber) async {
    final result = await FirebaseAuthServices.verifyPhoneNumber(phoneNumber);

    if (result is RError) {
      return Result.error((result as RError).errorMessage);
    }
    final resultValue =
        (result as Ok<Map<PhoneNumberVerificationStatus, String?>>).value;

    if (resultValue.keys.first == PhoneNumberVerificationStatus.verified) {
      final userDetailsResult =
          await FirestoreServices.getUserDetails(FirebaseAuthServices.userId!);
      if (userDetailsResult is RError) {
        return Result.error((userDetailsResult as RError).errorMessage);
      } else {
        return await _ensureDeviceInfoIsSet(federated: false);
      }
    } else {
      return Result.ok(resultValue.values.first!);
    }
  }

  @override
  AuthState get authenticationState {
    if (HiveServices.shouldShowGetStarted) {
      return AuthState.gettingStarted;
    } else if (HiveServices.userIsRegisteringWithEmail) {
      return AuthState.registeringWithEmail;
    } else if (HiveServices.userAddedEmailToPhoneNumber) {
      return AuthState.addedEmailToPhoneNumber;
    } else if (HiveServices.isUserAddressDetailsSaved) {
      return AuthState.addressDetailsSaved;
    } else if (HiveServices.isUserAuthenticated) {
      return AuthState.authenticated;
    } else {
      return AuthState.federatedRegistration;
    }
  }

  Future<Result<AuthState>> signInWithPhoneNumberWithCode(
      {required String verificationId, required String smsCode}) async {
    final result = await FirebaseAuthServices.signInWithPhoneNumberWithCode(
        verificationId: verificationId, smsCode: smsCode);
    if (result is RError) {
      return Result.error(result.errorMessage);
    }
    return await _ensureDeviceInfoIsSet(federated: false);
  }

  @override
  Future<Result<Map<String, DeviceUserInfo>>> findMyDevice() async {
    String deviceId = await FlutterUdidServices.getDeviceId();
    final devicesInfoResult = await FirestoreServices.getDevicesInfo(deviceId);
    return devicesInfoResult;
  }

  @override
  Future<Result<Null>> sendSignInLinkToEmail(String email) async {
    final result = await FirebaseAuthServices.sendSignInLinkToEmail(email);
    if (result is RError) {
      return Result.error(result.errorMessage);
    }
    await HiveServices.storeEmaiForRegistration(email);
    return const Result.ok(null);
  }

  @override
  Future<Result<CountryResponse>> getCountry() async {
    if (_country != null) {
      return Result.ok(_country!);
    } else if (HiveServices.getCountry != null) {
      final countryFromHive = HiveServices.getCountry;
      _country = CountryResponse(
          countryCode:
              countryFromHive?.code ?? _CountryCodeDefaults.countryCode,
          ip: countryFromHive?.ip ?? _CountryCodeDefaults.ip);
      return Result.ok(CountryResponse(
          countryCode: _country!.countryCode, ip: _country!.ip));
    } else {
      final countryFromServiceResult = await CountryIpServices.getCountry();
      if (countryFromServiceResult is RError) {
        return Result.error((countryFromServiceResult as RError).errorMessage);
      }
      countryFromServiceResult as Ok<CountryResponse?>;
      _country = CountryResponse(
          countryCode: countryFromServiceResult.value?.countryCode ??
              _CountryCodeDefaults.countryCode,
          ip: countryFromServiceResult.value?.ip ?? _CountryCodeDefaults.ip);
      await HiveServices.storeCountry(HiveCountryResponse(
          ip: _country!.ip,
          code: _country!.countryCode,
          country: _country!.country));
      return Result.ok(_country!);
    }
  }

  @override
  Future<Result<void>> updateDisplayName(String name) async {
    final result = await FirebaseAuthServices.updateDisplayName(name);
    if (result is RError) {
      return Result.error(result.errorMessage);
    }
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> updatePhoneNumber(
      {required String smsCode, required String verificationId}) async {
    final result = await FirebaseAuthServices.updatePhoneNumber(
        smsCode: smsCode, verificationId: verificationId);
    if (result is RError) {
      return Result.error(result.errorMessage);
    }
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> getStarted() async {
    final result = await getCountry();
    if (result is RError) {
      return Result.error((result as RError).errorMessage);
    }
    await HiveServices.hideGetStarted();
    return const Result.ok(null);
  }
}

class _CountryCodeDefaults {
  static String countryCode = '1';
  static String ip = '9.9.9.9';
}
