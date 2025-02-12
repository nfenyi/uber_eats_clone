import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/sign_in/sign_in_view_models.dart';
import 'package:uber_eats_clone/presentation/services/service_model.dart';

import '../../main.dart';
import '../core/widgets.dart';

class AuthenticatorRepository {
  const AuthenticatorRepository();
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<ServiceResponse> logInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return ServiceResponse(response: Result.aborted, payload: {});
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final result = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      // await Hive.box(AppBoxes.appState).put(  AccountDetails(
      //     uid: result.user!.uid,
      //     displayName: result.user?.displayName,
      //     email: result.user?.email,
      //     photoUrl: result.user?.photoURL,
      //     phoneNumber: result.user?.phoneNumber));
      // await Hive.box(AppBoxes.appState).put('currentUser', result.user!.uid);
      await Hive.box(AppBoxes.appState).put('authenticated', true);
      return ServiceResponse(response: Result.success, payload: {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-password' || e.code == 'user-not-found') {
        return ServiceResponse(
            response: Result.failure, payload: 'Invalid credentials.');
      } else {
        return ServiceResponse(response: Result.failure, payload: e.code);
      }
    } catch (e) {
      // await showAppInfoDialog(navigatorKey.currentContext!, ref,
      //     title: e.toString());
      return ServiceResponse(response: Result.failure, payload: e.toString());
    }
  }

  Future<ServiceResponse> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      // await FacebookAuth.instance.logOut();
      await Hive.box(AppBoxes.appState).put('authenticated', false);
      return ServiceResponse(response: Result.success, payload: {});
    } on Exception catch (e) {
      return ServiceResponse(response: Result.failure, payload: e.toString());
    }
  }

  Future<ServiceResponse> verifyPhoneNumber(String phoneNumber) async {
    try {
      FirebaseAuthException? exception;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          logger.d('verification complete');
        },
        verificationFailed: (FirebaseAuthException e) {
          exception = e;
          logger.d(exception);
          logger.d('helloworld');
        },
        codeSent: (String verificationId, int? resendToken) {
          logger.d('code sent');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          logger.d('timeout');
        },
      );

      return ServiceResponse(response: Result.success, payload: {});
    } catch (e) {
      // await showAppInfoDialog(navigatorKey.currentContext!, ref,
      //     title: e.toString());
      return ServiceResponse(response: Result.failure, payload: e.toString());
    }
  }
}
