import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/phone_number_screen.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import '../../../services/sign_in_view_model.dart';
import '../../main_screen/screens/main_screen.dart';
import 'name_screen.dart';

class EmailSentScreen extends StatefulWidget {
  final String email;

  const EmailSentScreen({super.key, required this.email});

  @override
  State<EmailSentScreen> createState() => _EmailSentScreenState();
}

class _EmailSentScreenState extends State<EmailSentScreen> {
  bool _hasTimedOut = false;
  late PendingDynamicLinkData dld;
  @override
  void initState() {
    super.initState();
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      if (FirebaseAuth.instance
          .isSignInWithEmailLink(dynamicLinkData.link.toString())) {
        // The client SDK will parse the code from the link for you.
        await FirebaseAuth.instance
            .signInWithEmailLink(
                email: Hive.box(AppBoxes.appState).get('email'),
                emailLink: dynamicLinkData.link.toString())
            .then((credential) async {
          await Hive.box(AppBoxes.appState).delete('email');

          await Hive.box(AppBoxes.appState).put('isVerifiedViaLink', true);
          try {
            final snapshot = await FirebaseFirestore.instance
                .collection(FirestoreCollections.users)
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();

            if (snapshot.exists &&
                snapshot.data() != null &&
                snapshot.data()!['onboarded'] == true) {
              navigatorKey.currentState!.push(
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            } else {
              navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const PhoneNumberScreen()));
            }
          } catch (e) {
            showAppInfoDialog(context, description: e.toString());
          }
        }, onError: (error) {
          if (mounted) {
            showAppInfoDialog(context, description: error.toString());
          }
        });
      } else {
        showAppInfoDialog(navigatorKey.currentContext!,
            description:
                'Seems the link in the email has not been acknowledged.');
      }
    }).onError((error) {
      showAppInfoDialog(navigatorKey.currentContext!,
          description: error.toString());
    });
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
                                  showInfoToast(
                                      'Email has been resent. Please check your mail',
                                      context: context);
                                },
                                        onError: (onError) => showAppInfoDialog(
                                              context,
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
                                TimerCountdown(
                                  spacerWidth: 0,
                                  enableDescriptions: false,
                                  timeTextStyle: const TextStyle(
                                      color: AppColors.neutral500),
                                  format: CountDownTimerFormat.minutesSeconds,
                                  endTime: DateTime.now().add(
                                    const Duration(
                                      minutes: 2,
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
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      onTap: () => navigatorKey.currentState!.pop(),
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.bodySmallest),
                          decoration: const BoxDecoration(
                            color: AppColors.neutral200,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.arrowLeft,
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
