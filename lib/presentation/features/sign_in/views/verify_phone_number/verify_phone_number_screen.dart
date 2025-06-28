import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/email_address/email_address_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/name/name_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/sign_in/sign_in_view_model.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/verify_phone_number/verify_phone_number_view_model.dart';
import 'package:uber_eats_clone/utils/result.dart';

import '../../../../../main.dart';
import '../../../../../utils/enums.dart';
import '../../../../core/app_colors.dart';
import '../../../main_screen/screens/main_screen_wrapper.dart';

class VerifyPhoneNumberScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final bool signedInWithEmail;
  final String phoneNumber;
  final bool justUpdatingPhoneNumber;

  const VerifyPhoneNumberScreen(
      {super.key,
      this.signedInWithEmail = false,
      this.justUpdatingPhoneNumber = false,
      required this.verificationId,
      required this.phoneNumber});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends ConsumerState<VerifyPhoneNumberScreen> {
  late String _verificationId;
  final TextEditingController _pinController = TextEditingController();
  final _defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: AppColors.neutral300,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
  final _followingPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: AppColors.neutral100,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  late final _focusedPinTheme = _defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary));

  bool _hasTimedOut = false;

  final _viewModel = VerifyPhoneNumberViewModel();

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  size: AppSizes.heading6,
                  text:
                      'Enter the 6-digit code sent to you at ${widget.phoneNumber}',
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                if (!widget.justUpdatingPhoneNumber)
                  GestureDetector(
                    onTap: () => navigatorKey.currentState!.pop(),
                    child: const AppText(
                      text: 'Changed your mobile number?',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                const Gap(30),
                Pinput(
                  length: 6,
                  followingPinTheme: _followingPinTheme,
                  defaultPinTheme: _defaultPinTheme,
                  focusedPinTheme: _focusedPinTheme,
                  submittedPinTheme: _followingPinTheme,
                  controller: _pinController,
                  onCompleted: (value) async {
                    if (widget.justUpdatingPhoneNumber) {
                      await _viewModel.updatePhoneNumber(
                          _verificationId, value);
                      if (context.mounted) {
                        navigatorKey.currentState!.pop(true);
                      }
                      return;
                    }

                    if (widget.signedInWithEmail) {
                      await _viewModel.updatePhoneNumber(
                          _verificationId, value);
                      await navigatorKey.currentState!
                          .pushReplacement(MaterialPageRoute(
                        builder: (context) => const NameScreen(),
                      ));
                    } else {
                      final signInResult =
                          await _viewModel.signInWithPhoneNumber(
                              _verificationId, _pinController.text);

                      if (signInResult is RError) {
                        await showAppInfoDialog(
                            description: (signInResult as RError).errorMessage,
                            navigatorKey.currentContext!);
                      } else {
                        signInResult as Ok<AuthState>;
                        if (signInResult.value == AuthState.authenticated) {
                          await navigatorKey.currentState!.pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MainScreenWrapper()), (r) {
                            return false;
                          });
                        } else if (signInResult.value ==
                            AuthState.registeringWithPhoneNumber) {
                          await navigatorKey.currentState!.pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EmailAddressScreen()));
                        }
                      }
                    }
                  },
                ),
                const Gap(50),
                InkWell(
                  onTap: _hasTimedOut
                      ? () async {
                          final signInViewModel = SignInViewModel();
                          final signInResult = await signInViewModel
                              .verifyPhoneNumber(widget.phoneNumber);
                          if (signInResult is RError) {
                            await showAppInfoDialog(
                                description: signInResult.errorMessage,
                                navigatorKey.currentContext!);
                            return;
                          } else if ((signInResult as Ok).value ==
                              AuthState.authenticated) {
                            await navigatorKey.currentState!
                                .push(MaterialPageRoute(
                              builder: (context) => const MainScreenWrapper(),
                            ));
                          } else {
                            if (signInResult.value == AuthState.authenticated) {
                              await navigatorKey.currentState!
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainScreenWrapper()), (r) {
                                return false;
                              });
                            } else {
                              await showAppInfoDialog(
                                navigatorKey.currentContext!,
                                description: 'Code resent',
                              );
                              _verificationId = signInResult.value;
                            }
                          }
                        }
                      : null,
                  child: Ink(
                    child: Container(
                      padding: const EdgeInsets.all(
                          AppSizes.horizontalPaddingSmallest),
                      decoration: const BoxDecoration(
                          color: AppColors.neutral100,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            text: 'Resend code via SMS  ',
                            size: 15,
                            color: _hasTimedOut
                                ? Colors.black
                                : AppColors.neutral500,
                          ),
                          if (!_hasTimedOut) const Text('('),
                          if (!_hasTimedOut)
                            TimerCountdown(
                              spacerWidth: 0,
                              enableDescriptions: false,
                              timeTextStyle:
                                  const TextStyle(color: AppColors.neutral500),
                              format: CountDownTimerFormat.minutesSeconds,
                              endTime: DateTime.now().add(
                                const Duration(
                                  minutes: 4,
                                ),
                              ),
                              onEnd: () {
                                setState(() {
                                  _hasTimedOut = true;
                                });
                              },
                            ),
                          if (!_hasTimedOut) const Text(')'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => navigatorKey.currentState!.pop(),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.bodySmallest),
                          decoration: const BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: const Icon(
                            FontAwesomeIcons.arrowLeft,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(10)
              ],
            )
          ],
        ),
      ),
    );
  }
}
