import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/screens/main_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../../main.dart';
import '../../../../constants/weblinks.dart';
import '../../../../services/sign_in_view_model.dart';
import '../../../webview/webview_screen.dart';

class TermsForFamilyProfilesScreen extends StatefulWidget {
  final String familyMemberName;
  const TermsForFamilyProfilesScreen(
      {super.key, required this.familyMemberName});

  @override
  State<TermsForFamilyProfilesScreen> createState() =>
      _TermsForFamilyProfilesScreenState();
}

class _TermsForFamilyProfilesScreenState
    extends State<TermsForFamilyProfilesScreen> {
  bool? _hasAgreed = false;

  final _webViewcontroller = WebViewControllerPlus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Terms for Family Profiles',
          size: AppSizes.heading6,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppText(
                text:
                    'To maintain a Family profile and add your teen, you must:'),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text:
                  "Understand that members you add may request rides and place orders, and you may revoke members' access by removing them",
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text:
                  "Accept responsibility for all rides and orders for members of your Family profile",
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text:
                  "Provide a payment method that will be used for all charges to the Family profile",
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text:
                  "Agree to prevent unauthorized minors from using the Family profile",
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text:
                  "Obtain permission to share members' personal information with Uber",
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text: "Have legal authority to act on your teen's behalf",
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text: "Agree Uber may communicate directly with your teen",
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                CheckboxListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _hasAgreed = value;
                    });
                  },
                  value: _hasAgreed,
                  title: RichText(
                    text: TextSpan(
                        text:
                            "By checking the box, I have reviewed and agree to these Family Terms of Use, ",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: 'Teen Account Terms of Use,',
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    controller: _webViewcontroller,
                                    link: Weblinks.uberOneTerms,
                                  ),
                                ));
                              },
                          ),
                          const TextSpan(
                            text: ' and acknowledge the ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'Privacy Notice',
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    controller: _webViewcontroller,
                                    link: Weblinks.uberOneTerms,
                                  ),
                                ));
                              },
                          ),
                        ]),
                  ),
                ),
                const Gap(40),
                AppButton(
                  text: 'Send invite',
                  callback: (_hasAgreed == true)
                      ? () async {
                          showInfoToast(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              'Invite sent to ${widget.familyMemberName} ',
                              context: context);
                          final userCredential =
                              FirebaseAuth.instance.currentUser;
                          late String deviceId;
                          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                          if (Platform.isAndroid) {
                            AndroidDeviceInfo androidInfo =
                                await deviceInfo.androidInfo;
                            deviceId = androidInfo.id;
                            // Unique ID on Android (may not persist across factory resets)
                            // Other potentially useful properties on AndroidDeviceInfo:
                            // androidInfo.androidId; // More likely to persist, but not guaranteed
                            // androidInfo.imei;       // International Mobile Equipment Identity (if available) - requires permissions
                            // androidInfo.meid;       // Mobile Equipment Identifier (if available) - requires permissions
                          } else if (Platform.isIOS) {
                            IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                            deviceId = iosInfo
                                .identifierForVendor!; // A unique ID for the *vendor* (your app developer), persists across app reinstalls, but changes if all apps by the vendor are uninstalled.
                            // iosInfo.utsname.machine; // This could be used, but it's not a unique identifier.
                          }
                          await Hive.box(AppBoxes.appState)
                              .put('authenticated', true);
                          final device = <String, dynamic>{
                            "deviceId": deviceId,
                            "email": userCredential?.email,
                            "phoneNumber": userCredential?.phoneNumber
                          };
                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.devices)
                              .add(device);

                          navigatorKey.currentState!.pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()),
                              (r) {
                            return false;
                          });
                        }
                      : null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
