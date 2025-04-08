import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/email_address_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/name_screen.dart';

import '../../../../main.dart';
import '../../../core/app_colors.dart';
import '../../../services/sign_in_view_model.dart';
import '../../main_screen/screens/main_screen_wrapper_screen.dart';

class VerifyPhoneNumberScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final bool signedInWithEmail;
  final String phoneNumber;
  const VerifyPhoneNumberScreen(
      {super.key,
      this.signedInWithEmail = false,
      required this.verificationId,
      required this.phoneNumber});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends ConsumerState<VerifyPhoneNumberScreen> {
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
                    try {
                      final credential = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: value);

                      if (widget.signedInWithEmail) {
                        await FirebaseAuth.instance.currentUser!
                            .updatePhoneNumber(credential);
                        await navigatorKey.currentState!
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const NameScreen(),
                        ));
                      } else {
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        final userCredential =
                            FirebaseAuth.instance.currentUser!;
                        final snapshot = await FirebaseFirestore.instance
                            .collection(FirestoreCollections.users)
                            .doc(userCredential.uid)
                            .get();
                        if (snapshot.exists &&
                            snapshot.data() != null &&
                            snapshot.data()!['onboarded'] == true) {
                          String udid = await FlutterUdid.consistentUdid;
                          var deviceRef = FirebaseFirestore.instance
                              .collection(FirestoreCollections.devices)
                              .doc(udid);
                          var deviceSnapshot = await deviceRef.get();
                          final info = <String, dynamic>{
                            userCredential.uid: {
                              'name': userCredential.displayName,
                              'profilePic': userCredential.photoURL,
                              "email": userCredential.email,
                              "phoneNumber": userCredential.phoneNumber
                            }
                          };
                          if (!deviceSnapshot.exists) {
                            await deviceRef.set(info);
                          } else {
                            if (deviceSnapshot[userCredential.uid] == null) {
                              await deviceRef.update(info);
                            }
                          }
                          await Hive.box(AppBoxes.appState)
                              .put(BoxKeys.authenticated, true);
                          await navigatorKey.currentState!.pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MainScreenWrapperScreen()), (r) {
                            return false;
                          });
                        } else {
                          await navigatorKey.currentState!.pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EmailAddressScreen()));
                        }
                      }
                    } on FirebaseAuthException catch (e) {
                      await showAppInfoDialog(
                          description: e.code, navigatorKey.currentContext!);
                    } on Exception catch (e) {
                      await showAppInfoDialog(
                          description: e.toString(),
                          navigatorKey.currentContext!);
                    }
                  },
                ),
                const Gap(50),
                InkWell(
                  onTap: _hasTimedOut
                      ? () async {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: widget.phoneNumber,
                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                              await Hive.box(AppBoxes.appState)
                                  .put(BoxKeys.authenticated, true);
                              await navigatorKey.currentState!
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainScreenWrapperScreen()),
                                      (r) {
                                return false;
                              });
                            },
                            // autoRetrievedSmsCodeForTesting: '',
                            verificationFailed: (FirebaseAuthException e) {
                              showAppInfoDialog(
                                context,
                                description: '${e.code}${e.message}',
                              );
                            },
                            codeSent:
                                (String verificationId, int? resendToken) {
                              showInfoToast('Code resent', context: context);
                              setState(() {
                                _hasTimedOut = false;
                              });
                            },
                            timeout: const Duration(minutes: 2),
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
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
