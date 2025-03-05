import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/weblinks.dart';
import '../../../core/widgets.dart';
import '../../../services/sign_in_view_model.dart';
import '../../main_screen/screens/main_screen.dart';
import '../../webview/webview_screen.dart';

class UberOneScreen extends StatelessWidget {
  const UberOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final webViewcontroller = WebViewControllerPlus();
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      AssetNames.uberOne1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8),
                      child: GestureDetector(
                        onTap: () async {
                          await Hive.box(AppBoxes.appState)
                              .delete('isVerifiedViaLink');
                          await Hive.box(AppBoxes.appState)
                              .delete(BoxKeys.addedEmailToPhoneNumber);
                          await Hive.box(AppBoxes.appState)
                              .delete(BoxKeys.addressDetailsSaved);
                          final userCredential =
                              FirebaseAuth.instance.currentUser;
                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.users)
                              .doc(userCredential!.uid)
                              .update({
                            'hasUberOne': false,
                            'type': "Personal",
                            "onboarded": true,
                            "redeemedPromos": []
                          });

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
                          final info = <String, dynamic>{
                            'name': userCredential.displayName,
                            'profilePic': userCredential.photoURL,
                            "email": userCredential.email,
                            "phoneNumber": userCredential.phoneNumber
                          };
                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.devices)
                              .doc(deviceId)
                              .set(info);
                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.favoriteStores)
                              .doc(userCredential.uid)
                              .set({});
                          navigatorKey.currentState!.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ), (r) {
                            return false;
                          });
                          await Hive.box(AppBoxes.appState)
                              .put(BoxKeys.authenticated, true);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(Icons.close),
                        ),
                      ),
                    )
                  ],
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                          text: "You've got \$0 Delivery Fees with Uber One!"),
                      const Gap(10),
                      const AppText(
                        text:
                            'Enjoy our membership free for I week, Joshua - no payment method required- Choose if you want to join at anytime.',
                      ),
                      const Gap(20),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.shopping_bag,
                        ),
                        title: AppText(
                          text:
                              'SC Delivery Fee on eligible food, groceries, and more',
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          FontAwesomeIcons.tag,
                        ),
                        title: AppText(
                          text:
                              'Up to 10% off eligible deliveries and pickup orders',
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          FontAwesomeIcons.car,
                        ),
                        title: AppText(
                          text:
                              'Earn 6% Uber Cash and get top-rated drivers on eligible rides',
                        ),
                      ),
                      const Gap(20),
                      RichText(
                        text: TextSpan(
                            text:
                                "*If you choose to join, Uber One is \$9.99/mo after free trials. Benefits available only for eligible stores and rides marked with the Uber One icon. Participating restaurants and non-grocery stores: \$15.00 minimum order to receive \$0 Delivery Fee and up to 10% Off, Participating grocery stores: \$35 minimum order to receive \$0 Delivery Fee and 5% Off. Membership savings applied as a reduction to service fees. 6% Uber Cash earned after completion of eligible rides. Taxes and similar fees, as applicable, do not apply towards order minimums or Uber Cash back benefits. Other fees and exclusions may apply. ",
                            style: const TextStyle(
                              fontSize: AppSizes.bodySmallest,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'View terms and conditions',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) => WebViewScreen(
                                        controller: webViewcontroller,
                                        link: Weblinks.uberOneTerms,
                                      ),
                                    ));
                                  },
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
            child: AppButton(
              text: 'Got it',
              callback: () async {
                await Hive.box(AppBoxes.appState).delete('isVerifiedViaLink');
                await Hive.box(AppBoxes.appState)
                    .delete(BoxKeys.addedEmailToPhoneNumber);
                await Hive.box(AppBoxes.appState)
                    .delete(BoxKeys.addressDetailsSaved);
                final userCredential = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance
                    .collection(FirestoreCollections.users)
                    .doc(userCredential!.uid)
                    .update({
                  'hasUberOne': false,
                  'type': "Personal",
                  "onboarded": true,
                  "redeemedPromos": []
                });

                late String deviceId;
                DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                if (Platform.isAndroid) {
                  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
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
                await Hive.box(AppBoxes.appState).put('authenticated', true);
                final info = <String, dynamic>{
                  'name': userCredential.displayName,
                  'profilePic': userCredential.photoURL,
                  "email": userCredential.email,
                  "phoneNumber": userCredential.phoneNumber
                };
                await FirebaseFirestore.instance
                    .collection(FirestoreCollections.devices)
                    .doc(deviceId)
                    .set(info);

                await FirebaseFirestore.instance
                    .collection(FirestoreCollections.favoriteStores)
                    .doc(userCredential.uid)
                    .set({});
                navigatorKey.currentState!.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ), (r) {
                  return false;
                });
                await Hive.box(AppBoxes.appState)
                    .put(BoxKeys.authenticated, true);
              },
            ),
          )
        ],
      )),
    );
  }
}
