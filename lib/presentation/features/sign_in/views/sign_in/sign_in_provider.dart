import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/services/service_model.dart';

import '../../../../services/sign_in_view_model.dart';

class SignInNotifier extends StateNotifier<AuthState> {
  final _authenticator = const AuthenticatoViewModel();

  SignInNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = const AuthState(
        isLoading: false,
        status: AuthStatus.success,
        // details: AccountDetails(
        //     userId: _authenticator.userId,
        //     name: _authenticator.displayName,
        //     type: 'Account',
        //     hasUberOne: false)
      );
    }
  }
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
    await Hive.box(AppBoxes.appState).put('authenticated', false);
  }

  Future<ServiceResponse> verifyPhoneNumber(String phoneNumber) async {
    return await _authenticator.verifyPhoneNumber(phoneNumber);
  }

  Future<void> signInWithGoogle() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.signInWithGoogle();
    // final userId = _authenticator.userId;

    switch (result.response) {
      case Result.success:
        state = const AuthState(
          isLoading: false,
          status: AuthStatus.success,
        );
      case Result.failure:
        state = AuthState(
            isLoading: false,
            status: AuthStatus.failure,
            payload: result.payload);
      case Result.aborted:
        state = const AuthState(
          isLoading: false,
          status: AuthStatus.aborted,
        );
    }
    // if (result == AuthResult.success && userId != null) {
    //   await saveUserInfo(userId: userId);
    // }
  }

  Future<void> signInApple() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.signInWithApple();
    // final userId = _authenticator.userId;

    switch (result.response) {
      case Result.success:
        state = const AuthState(
          isLoading: false,
          status: AuthStatus.success,
        );
      case Result.failure:
        state = AuthState(
            isLoading: false,
            status: AuthStatus.failure,
            payload: result.payload);
      case Result.aborted:
        state = const AuthState(
          isLoading: false,
          status: AuthStatus.aborted,
        );
    }
    // if (result == AuthResult.success && userId != null) {
    //   await saveUserInfo(userId: userId);
    // }
  }
}

class AuthState {
  final bool isLoading;
  final AuthStatus? status;
  final dynamic payload;
  // final AccountDetails? details;

  const AuthState({required this.isLoading, required this.status, this.payload
      // required this.details
      });

  const AuthState.unknown()
      : status = null,
        isLoading = false,
        payload = null;

  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        isLoading: isLoading,
        status: status,
        // details: details,
      );

  // @override
  // bool operator ==(covariant AuthState other) =>
  //     identical(this, other) ||
  //     (result == other.result &&
  //         isLoading == other.isLoading &&
  //         details == other.details
  //         );

  // @override
  // int get hashCode => Object.hash(
  //       result,
  //       isLoading,
  //       details,
  //     );
}

enum AuthStatus {
  aborted,
  success,
  failure,
}

class AccountDetails {
  final String? userId;
  final String name;
  final bool hasUberOne;
  final String type;

  AccountDetails({
    required this.userId,
    required this.name,
    required this.type,
    required this.hasUberOne,
  });
}

final signInProvider = StateNotifierProvider<SignInNotifier, AuthState>((ref) {
  return SignInNotifier();
});
