import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/phone_number_screen.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import '../../../services/sign_in_view_model.dart';
import '../../main_screen/screens/main_screen_wrapper.dart';
import 'name_screen.dart';

class EmailSentScreen extends StatefulWidget {
  final String email;

  const EmailSentScreen({super.key, required this.email});

  @override
  State<EmailSentScreen> createState() => _EmailSentScreenState();
}

class _EmailSentScreenState extends State<EmailSentScreen>
    with SingleTickerProviderStateMixin {
  bool _hasTimedOut = false;
  late PendingDynamicLinkData dld;

  late final _timerController = CustomTimerController(
      vsync: this,
      begin: const Duration(minutes: 2),
      end: const Duration(),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds);

  @override
  void initState() {
    super.initState();
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      //TODO: to test the phone number then add email flow
      try {
        if (FirebaseAuth.instance
            .isSignInWithEmailLink(dynamicLinkData.link.toString())) {
          final user = FirebaseAuth.instance.currentUser;
          // logger.d(user.toString());
          if (user != null) {
            final credential = EmailAuthProvider.credentialWithLink(
                email: widget.email,
                emailLink: dynamicLinkData.link.toString());
            // logger.d(credential);
            await user.linkWithCredential(credential);
            await user.reload();

            // if (user.emailVerified) {
            await Hive.box(AppBoxes.appState)
                .put(BoxKeys.addedEmailToPhoneNumber, true);
            await navigatorKey.currentState!.push(
                MaterialPageRoute(builder: (context) => const NameScreen()));
            // }
            //  else {
            //   await showAppInfoDialog(navigatorKey.currentContext!,
            //       description:
            //           'Seems you used the wrong link to verify your email. Try again.');
            // }
          } else {
            await FirebaseAuth.instance
                .signInWithEmailLink(
                    email: widget.email,
                    emailLink: dynamicLinkData.link.toString())
                .then(
              (credential) async {
                await Hive.box(AppBoxes.appState).delete(BoxKeys.email);
                final userCredential = FirebaseAuth.instance.currentUser!;
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
                          builder: (context) => const MainScreenWrapper()),
                      (r) {
                    return false;
                  });
                } else {
                  await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const PhoneNumberScreen()));
                }
              },
              //  onError: (error) {
              //   showAppInfoDialog(navigatorKey.currentContext!,
              //       description: error.toString());
              // }
            );
          }
        } else {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await AppFunctions.getOnlineUserInfo();
            String udid = await FlutterUdid.consistentUdid;
            final deviceUsersDetails = await FirebaseFirestore.instance
                .collection(FirestoreCollections.devices)
                .doc(udid)
                .get();
            final userCredential = FirebaseAuth.instance.currentUser!;
            final deviceUserDetails =
                deviceUsersDetails.data()![userCredential.uid];
            deviceUserDetails['email'] = userCredential.email;
            await FirebaseFirestore.instance
                .collection(FirestoreCollections.devices)
                .doc(udid)
                .update({
              userCredential.uid: deviceUserDetails,
            }).then(
              (value) {
                showInfoToast(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    'Email updated',
                    context: navigatorKey.currentContext);
                if (context.mounted) {
                  navigatorKey.currentState!.pop(true);
                }
              },
            );
          }

          // else {
          // final user = FirebaseAuth.instance.currentUser;
          // if (user != null) {
          //   final credential = EmailAuthProvider.credentialWithLink(
          //       email: widget.email,
          //       emailLink: dynamicLinkData.link.toString());
          //   await user.linkWithCredential(credential);
          //   await user.reload();

          //   if (user.emailVerified) {
          //     await Hive.box(AppBoxes.appState)
          //         .put(BoxKeys.addedEmailToPhoneNumber, true);
          //     await navigatorKey.currentState!.push(
          //         MaterialPageRoute(builder: (context) => const NameScreen()));
          //   } else {
          //     await showAppInfoDialog(navigatorKey.currentContext!,
          //         description:
          //             'Seems you used the wrong link to verify your email. Try again.');
          //   }
          // }
          // }
        }
      } on FirebaseAuthException catch (e) {
        await showAppInfoDialog(navigatorKey.currentContext!,
            description: e.toString());
      }
    });
    _timerController.addListener(() {
      if (_timerController.remaining.value.duration == const Duration()) {
        setState(() {
          _hasTimedOut = true;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _timerController.start();
      },
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const AppText(
          text: 'Email Sent',
          weight: FontWeight.bold,
          size: AppSizes.heading6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: "An email has been sent to ",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '"${widget.email}"',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '. Follow the instructions to proceed.',
                          style: TextStyle(),
                        ),
                      ]),
                ),
                const Gap(10),
                Row(
                  children: [
                    const AppText(text: "Didn't find email?"),
                    InkWell(
                      onTap: _hasTimedOut
                          ? () async {
                              try {
                                await FirebaseAuth.instance
                                    .sendSignInLinkToEmail(
                                        email: widget.email,
                                        actionCodeSettings: ActionCodeSettings(
                                            // URL you want to redirect back to. The domain (www.example.com) for this
                                            // URL must be whitelisted in the Firebase Console.
                                            url:
                                                'https://ubereatsclone.page.link/email-link-login',
                                            // This must be true
                                            handleCodeInApp: true,
                                            iOSBundleId:
                                                'com.example.uberEatsClone',
                                            androidPackageName:
                                                'com.example.uber_eats_clone',
                                            // installIfNotAvailable
                                            androidInstallApp: true,
                                            // minimumVersion
                                            androidMinimumVersion: '12'))
                                    // .catchError((onError) => showAppInfoDialog(
                                    //       context,
                                    //       title: 'Error sending email',
                                    //       description: '$onError',
                                    //     ))
                                    .then((value) {
                                  setState(() {
                                    _hasTimedOut = false;
                                  });
                                  _timerController.start();
                                  showInfoToast(
                                      'Email has been resent. Please check your mail',
                                      context: navigatorKey.currentContext);
                                },
                                        onError: (onError) => showAppInfoDialog(
                                              navigatorKey.currentContext!,
                                              title: 'Error sending email',
                                              description: '$onError',
                                            ));
                              } on Exception catch (e) {
                                showInfoToast(e.toString(),
                                    context: navigatorKey.currentContext,
                                    seconds: 60);
                              }
                            }
                          : null,
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(
                              AppSizes.horizontalPaddingSmallest),
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                text: 'Resend email ',
                                size: 15,
                                decoration: _hasTimedOut
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                color: _hasTimedOut
                                    ? Colors.black
                                    : AppColors.neutral500,
                              ),
                              if (!_hasTimedOut) const Text('('),
                              if (!_hasTimedOut)
                                CustomTimer(
                                    controller: _timerController,
                                    builder: (state, time) {
                                      // Build the widget you want!🎉
                                      return AppText(
                                        text: "${time.minutes}:${time.seconds}",
                                        color: AppColors.neutral500,
                                      );
                                    }),
                              // TimerCountdown(
                              //   spacerWidth: 0,
                              //   enableDescriptions: false,
                              //   timeTextStyle: const TextStyle(
                              //       color: AppColors.neutral500),
                              //   format: CountDownTimerFormat.minutesSeconds,
                              //   endTime: DateTime.now().add(
                              //     const Duration(
                              //       minutes: 2,
                              //     ),
                              //   ),
                              //   onEnd: () {
                              //     setState(() {
                              //       _hasTimedOut = true;
                              //     });
                              //   },
                              // ),
                              if (!_hasTimedOut) const Text(')'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (navigatorKey.currentState!.canPop())
                      InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        onTap: () => navigatorKey.currentState!.pop(),
                        child: Ink(
                          child: Container(
                            padding:
                                const EdgeInsets.all(AppSizes.bodySmallest),
                            decoration: const BoxDecoration(
                              color: AppColors.neutral200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const Row(
                              children: [
                                Iconify(
                                  Ph.arrow_left,
                                  size: 15,
                                ),
                                AppText(text: '  Wrong email ?')
                              ],
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
