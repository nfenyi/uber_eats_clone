import 'package:google_sign_in/google_sign_in.dart';
import 'package:uber_eats_clone/utils/result.dart';
import 'package:uber_eats_clone/utils/operation_response.dart';

class GoogleSignInServices {
  static Future<OperationResponse> signIn() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return OperationResponse(
            result: Result.aborted, payload: 'Sign in aborted by user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      return OperationResponse(result: Result.success, payload: googleAuth);
    } on Exception catch (e) {
      return OperationResponse(result: Result.failure, payload: e.toString());
    }
  }

  static Future<OperationResponse> signOut() async {
    try {
      await GoogleSignIn().signOut();
      return OperationResponse(result: Result.success, payload: null);
    } on Exception catch (e) {
      return OperationResponse(result: Result.failure, payload: e.toString());
    }
  }
}
