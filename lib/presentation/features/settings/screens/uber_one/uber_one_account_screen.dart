import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/constants/other_constants.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/uber_one_all_set_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/uber_one_screen2.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../../app_functions.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/weblinks.dart';
import '../../../../core/widgets.dart';
import '../../../webview/webview_screen.dart';

class UberOneAccountScreen extends StatefulWidget {
  const UberOneAccountScreen({super.key});

  @override
  State<UberOneAccountScreen> createState() => _UberOneAccountScreenState();
}

class _UberOneAccountScreenState extends State<UberOneAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        AssetNames.uberOneSmall,
                        width: 40,
                      ),
                      const AppText(
                        text: 'Uber One',
                        size: AppSizes.heading4,
                        weight: FontWeight.w600,
                      )
                    ],
                  ),
                  const Row(
                    children: [
                      AppText(
                        text: '\$9.99/mo',
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.neutral500,
                      ),
                      AppText(
                        text: ' 4 weeks free',
                        color: Colors.brown,
                      ),
                    ],
                  ),
                  const Gap(10),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: OtherConstants.benefits.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 205,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final benefit = OtherConstants.benefits[index];
                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.neutral300)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              benefit.assetImage,
                              height: 50,
                            ),
                            const Gap(15),
                            AppText(
                              text: benefit.title,
                              size: AppSizes.bodySmall,
                              weight: FontWeight.w600,
                            ),
                            const Gap(5),
                            AppText(
                              text: benefit.message,
                              color: AppColors.neutral500,
                              // size: AppSizes.bodySmall,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const UberOneScreen2(),
                ));
              },
              title: const AppText(
                text: 'See terms and benefit details',
                weight: FontWeight.bold,
              ),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            const Divider(
              thickness: 4,
            ),
            Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Image.asset(
                      AssetNames.uberOneSmall,
                      width: 50,
                    ),
                    const Gap(5),
                    const AppText(
                      text: 'Save \$25 every month',
                      color: Colors.brown,
                      size: AppSizes.bodySmall,
                    ),
                    const Gap(10),
                    const AppText(
                      text:
                          "That's how much people save on average from Uber One and promos in your country",
                      color: AppColors.neutral500, textAlign: TextAlign.center,
                      // size: AppSizes.bodySmall,
                    ),
                    const Gap(20)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      persistentFooterButtons: [
        AppButton(
            text: 'Join Uber One',
            callback: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  final billings = <Plan>[
                    Plan(period: 'Monthly', bill: 9.99),
                    Plan(period: 'Annual', bill: 8)
                  ];

                  Plan? selectedBilling = billings.first;
                  final webViewcontroller = WebViewControllerPlus();
                  return StatefulBuilder(builder: (context, setState) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(15),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Center(
                              child: AppText(
                                text: 'Join Uber One',
                                size: AppSizes.heading6,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Gap(5),
                          const Divider(),
                          const Gap(5),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color:
                                              selectedBilling == billings.first
                                                  ? Colors.black
                                                  : AppColors.neutral300)),
                                  child: RadioListTile.adaptive(
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AppText(
                                          text: '4 weeks free',
                                          color: Colors.brown,
                                        ),
                                        Row(
                                          children: [
                                            AppText(
                                                text:
                                                    '\$${billings.first.bill.toStringAsFixed(2)}/mo'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    title: AppText(
                                      text: billings.first.period,
                                      size: AppSizes.bodySmall,
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: billings.first,
                                    groupValue: selectedBilling,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBilling = value;
                                      });

                                      // showInfoToast('Switched to $_selectedBilling',
                                      //     icon: const Icon(
                                      //       Icons.person,
                                      //       size: 18,
                                      //       color: Colors.white,
                                      //     ),
                                      //     context: context);
                                    },
                                  ),
                                ),
                                const Gap(10),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 5, bottom: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color:
                                              selectedBilling == billings.last
                                                  ? Colors.black
                                                  : AppColors.neutral300)),
                                  child: Column(
                                    children: [
                                      RadioListTile.adaptive(
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const AppText(
                                              text: '4 weeks free',
                                              color: Colors.brown,
                                            ),
                                            Row(
                                              children: [
                                                AppText(
                                                    text:
                                                        '\$${billings.last.bill.toStringAsFixed(2)}/mo'),
                                                AppText(
                                                    text:
                                                        'billed at \$${(billings.last.bill * 12).toStringAsFixed(2)}/yr')
                                              ],
                                            ),
                                          ],
                                        ),
                                        title: AppText(
                                          text: billings.last.period,
                                          size: AppSizes.bodySmall,
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        value: billings.last,
                                        groupValue: selectedBilling,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedBilling = value;
                                          });

                                          // showInfoToast('Switched to $_selectedBilling',
                                          //     icon: const Icon(
                                          //       Icons.person,
                                          //       size: 18,
                                          //       color: Colors.white,
                                          //     ),
                                          //     context: context);
                                        },
                                      ),
                                      ListTile(
                                        leading:
                                            Image.asset(AssetNames.uberOneTag),
                                        title: const AppText(
                                          text:
                                              'Save an extra 20% each year compared to a monthly plan',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(10),
                                AppText(
                                    text:
                                        'Billing starts ${AppFunctions.formatDate(DateTime.now().add(const Duration(days: 28)).toString(), format: 'M j, Y')} for \$${selectedBilling?.bill.toStringAsFixed(2)}/mo. Cancel without fees or penalties.'),
                                RichText(
                                  text: TextSpan(
                                      text:
                                          "By joining Uber One, you authorize Uber to charge \$${selectedBilling?.bill.toStringAsFixed(2)} on any payment method on your account, and monthly thereafter, based on the terms, until you cancel. To avoid charges cancel up to 48 hours before ${AppFunctions.formatDate(DateTime.now().add(const Duration(days: 28)).toString(), format: 'M j, Y')} in the app. ",
                                      style: const TextStyle(
                                        fontSize: AppSizes.bodySmallest,
                                        color: AppColors.neutral500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'View terms and conditions',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              navigatorKey.currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    WebViewScreen(
                                                  controller: webViewcontroller,
                                                  link: Weblinks.uberOneTerms,
                                                ),
                                              ));
                                            },
                                        ),
                                      ]),
                                ),
                                ListTile(
                                  leading: Image.asset(
                                    AssetNames.masterCardLogo,
                                    width: 10,
                                  ),
                                  title: const AppText(text: '••••4320'),
                                  trailing: AppButton2(
                                      text: 'Switch', callback: () {}),
                                ),
                                const Gap(10),
                                AppButton(
                                  text: 'Try for free',
                                  callback: () {
                                    navigatorKey.currentState!.pop();
                                    navigatorKey.currentState!
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          const UberOneAllSetScreen(),
                                    ));
                                  },
                                ),
                                const Gap(20),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
                },
              );
            })
      ],
    );
  }
}

class Plan {
  final String period;
  final double bill;
  // final DateTime?

  Plan({required this.period, required this.bill});
}
