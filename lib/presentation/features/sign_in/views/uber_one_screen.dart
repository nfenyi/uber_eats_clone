import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/weblinks.dart';
import '../../../core/widgets.dart';
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
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(Icons.close),
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
                navigatorKey.currentState!.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ), (r) {
                  return false;
                });
              },
            ),
          )
        ],
      )),
    );
  }
}
