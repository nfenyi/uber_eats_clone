import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../presentation/constants/other_constants.dart';
import '../utils/enums.dart';
import '../utils/result.dart';

class FirebaseAuthServices {
  const FirebaseAuthServices._();
  static User? get user => FirebaseAuth.instance.currentUser;
  static String? get phoneNumber =>
      FirebaseAuth.instance.currentUser?.phoneNumber;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static bool get isAlreadyLoggedIn => userId != null;
  static String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? OtherConstants.na;
  static String? get email => FirebaseAuth.instance.currentUser?.email;
  static String? get photoURL => FirebaseAuth.instance.currentUser?.photoURL;

  static Future<Result<UserCredential>> signInWithGoogle(
      GoogleSignInAuthentication googleAuth) async {
    try {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      return Result.ok(userCredential);
    } on FirebaseException catch (e) {
      return Result.error('${e.code}: ${e.message}');
    }
  }

  static Future<Result<UserCredential>> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      final credential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);

      String? authCode = credential.additionalUserInfo?.authorizationCode;
      if (authCode == null) {
        return const Result.error('Login aborted');
      }
      return Result.ok(credential);
    } on FirebaseException catch (e) {
      return Result.error('${e.code}: ${e.message}');
    }
  }

  static Future<Result> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }

  static Future<Result<Map<PhoneNumberVerificationStatus, String?>>>
      verifyPhoneNumber(String phoneNumber) async {
    late PhoneNumberVerificationStatus verificationStatus;
    String? exceptionMessage;
    String? verificationId;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        verificationStatus = PhoneNumberVerificationStatus.verified;
      },
      verificationFailed: (FirebaseAuthException e) {
        verificationStatus = PhoneNumberVerificationStatus.failed;
        exceptionMessage = e.toString();
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationStatus = PhoneNumberVerificationStatus.pendingOTP;
        verificationId = verificationId;
      },
      timeout: const Duration(minutes: 2),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    switch (verificationStatus) {
      case PhoneNumberVerificationStatus.failed:
        return Result.error(exceptionMessage!);

      default:
        return Result.ok({verificationStatus: verificationId});
    }
  }

  static Future<Result<void>> signInWithPhoneNumberWithCode(
      {required String verificationId, required String smsCode}) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }

  static Future<Result<void>> updateDisplayName(String name) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }

  static Future<Result<void>> updatePhoneNumber(
      {required String verificationId, required String smsCode}) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      //WARNING: phone number change not implemented by firebase
      await FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }

  static Future<Result<void>> sendSignInLinkToEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendSignInLinkToEmail(
          email: email,
          actionCodeSettings: ActionCodeSettings(
              // URL you want to redirect back to. The domain (www.example.com) for this
              // URL must be whitelisted in the Firebase Console.
              url: 'https://ubereatsclone.page.link/email-link-login',
              // This must be true
              handleCodeInApp: true,
              iOSBundleId: 'com.example.uberEatsClone',
              androidPackageName: 'com.example.uber_eats_clone',
              // installIfNotAvailable
              androidInstallApp: true,
              // minimumVersion
              androidMinimumVersion: '12'));
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }
}
