import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/presentation/services/service_model.dart';

import '../../main.dart';

class AuthenticatoViewModel {
  const AuthenticatoViewModel();
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<ServiceResponse> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return ServiceResponse(response: Result.aborted);
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
      await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      // await Hive.box(AppBoxes.appState).put(  AccountDetails(
      //     uid: result.user!.uid,
      //     displayName: result.user?.displayName,
      //     email: result.user?.email,
      //     photoUrl: result.user?.photoURL,
      //     phoneNumber: result.user?.phoneNumber));
      // await Hive.box(AppBoxes.appState).put('currentUser', result.user!.uid);

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

  Future<ServiceResponse> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      final credential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
// Keep the authorization code returned from Apple platforms
      logger.d('hello');
      String? authCode = credential.additionalUserInfo?.authorizationCode;
      if (authCode == null) {
        return ServiceResponse(response: Result.aborted, payload: {});
      }
      // Revoke Apple auth token
      await FirebaseAuth.instance.revokeTokenWithAuthorizationCode(authCode);

      // // Create a new credential
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // await Hive.box(AppBoxes.appState).put(  AccountDetails(
      //     uid: result.user!.uid,
      //     displayName: result.user?.displayName,
      //     email: result.user?.email,
      //     photoUrl: result.user?.photoURL,
      //     phoneNumber: result.user?.phoneNumber));
      // await Hive.box(AppBoxes.appState).put('currentUser', result.user!.uid);

      return ServiceResponse(response: Result.success, payload: {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'web-context-canceled') {
        return ServiceResponse(response: Result.aborted);
      }
      if (e.code == 'invalid-password' || e.code == 'user-not-found') {
        return ServiceResponse(
            response: Result.failure, payload: 'Invalid credentials.');
      } else {
        return ServiceResponse(
            response: Result.failure, payload: '${e.code}\n\n${e.message}');
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
      await Hive.box(AppBoxes.appState).put(BoxKeys.authenticated, false);
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

      return ServiceResponse(response: Result.success);
    } catch (e) {
      // await showAppInfoDialog(navigatorKey.currentContext!, ref,
      //     title: e.toString());
      return ServiceResponse(response: Result.failure, payload: e.toString());
    }
  }
}

class FirestoreCollections {
  static String devices = 'devices';
  static String users = 'users';
  static String stores = 'stores';
  static String products = 'products';
  static String foodCategories = 'food categories';
  static String groceryCategories = 'grocery categories';
  static String favoriteStores = 'favorite stores';
  static String adverts = 'adverts';
  static String groupOrders = 'group orders';
  static String promotions = 'promotions';
  static String vouchers = 'vouchers';
  static String deals = 'deals';
  static String orderSchedules = 'order schedules';

  static String exploreVideos = 'browse videos';
  static String featuredStores = 'featured stores';
  static String giftCards = 'gift cards';
  static String giftCardCategories = 'gift card categories';
  static String giftCardsAnkasa = 'gift cards ankasa';
  static String individualOrders = 'individual orders';

  FirestoreCollections._();
}

class FirebaseStorageRefs {
  static String foodCategoryImages = '/food category images';
  // static String users = 'users';
  // static String stores = 'stores';
  // static String products = 'products';
  // static String foodCategories = 'food categories';

  FirebaseStorageRefs._();
}
