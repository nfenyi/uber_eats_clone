import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/manage_membership_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../../app_functions.dart';
import '../../../../../main.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../constants/weblinks.dart';
import '../../../../core/app_colors.dart';
import '../../../webview/webview_screen.dart';

class SwitchToAnnualPlanScreen extends StatefulWidget {
  final MembershipDetails membershipDetails;
  const SwitchToAnnualPlanScreen({super.key, required this.membershipDetails});

  @override
  State<SwitchToAnnualPlanScreen> createState() =>
      _SwitchToAnnualPlanScreenState();
}

class _SwitchToAnnualPlanScreenState extends State<SwitchToAnnualPlanScreen> {
  final webViewcontroller = WebViewControllerPlus();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        //   statusBarIconBrightness: Brightness.dark,
        //   statusBarColor: Colors.white,
        // ));
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Image.asset(
                  AssetNames.switchToAnnual,
                  width: double.infinity,
                ),
                GestureDetector(
                  onTap: () {
                    navigatorKey.currentState!.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: AppSizes.horizontalPaddingSmall),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const AppText(
                          text: 'Save 20% with an Uber One annual plan',
                          size: AppSizes.heading4,
                          color: Colors.white,
                          weight: FontWeight.bold,
                        ),
                        const Row(
                          children: [
                            AppText(
                              text: '\$9.99/mo',
                              color: AppColors.neutral500,
                              decoration: TextDecoration.lineThrough,
                            ),
                            AppText(
                              text: ' \$8.00/mo (billed at \$96.00/yr)',
                              color: Colors.white,
                            )
                          ],
                        ),
                        const Gap(20),
                        const AppText(
                            size: AppSizes.bodySmall,
                            color: Colors.white,
                            text:
                                "Switch plans and pay 20% less than what monthly plan members pay each year. That's like getting 2 months free!"),
                        const Gap(20),
                        RichText(
                          text: TextSpan(
                              text:
                                  "You agree to be charged \$96.00 today. Your plan will switch on ${AppFunctions.formatDate(widget.membershipDetails.dateRenewed.add(const Duration(days: 30)).toString(), format: 'M j, Y')} and you will be charged yearly until you cancel. ",
                              style: const TextStyle(
                                fontSize: AppSizes.bodySmallest,
                                color: AppColors.neutral300,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms apply',
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppColors.neutral100),
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
                    Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(
                            widget.membershipDetails.paymentMethod.assetImage,
                            width: 30,
                            height: 30,
                          ),
                          subtitle: const AppText(
                            text: 'Any Uber Cash will be applied',
                            color: Colors.white,
                          ),
                          trailing: AppButton2(text: 'Switch', callback: () {}),
                          title: AppText(
                              color: Colors.white,
                              text:
                                  '•••• ${widget.membershipDetails.paymentMethod.cardNumber!.substring(5)}'),
                        ),
                        AppButton(
                          buttonColor: AppColors.uberOneGold,
                          text: 'Switch to annual plan',
                          callback: () {
                            navigatorKey.currentState!.pop();
                            showInfoToast(
                              'Switched to annual plan',
                              icon: const Icon(
                                Icons.celebration,
                                color: Colors.white,
                              ),
                              context: context,
                            );
                          },
                        ),
                        const Gap(10)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
