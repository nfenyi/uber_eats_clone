import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/other_constants.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/manage_membership_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../../main.dart';
import '../../../../../models/offer/offer_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../constants/weblinks.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import '../../../home/home_screen.dart';
import '../../../webview/webview_screen.dart';

class UberOneScreen2 extends StatefulWidget {
  const UberOneScreen2({super.key});

  @override
  State<UberOneScreen2> createState() => _UberOneScreen2State();
}

class _UberOneScreen2State extends State<UberOneScreen2> {
  final List<Offer> _offers = [
    Offer(
        id: '456343432',
        product: products.entries.first.value,
        store: stores[2],
        title: "Buy 1 get 1 free"),
    Offer(
        id: '764534',
        product: products.entries.first.value,
        store: stores[2],
        title: "Buy 1 get 1 free"),
  ];

  final _webViewcontroller = WebViewControllerPlus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'Money saved',
                          size: AppSizes.bodySmall,
                        ),
                        AppText(
                          text: '\$0.00',
                          color: Colors.brown,
                          size: AppSizes.heading6,
                        )
                      ],
                    ),
                  ),
                  const Gap(15),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.neutral300,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: const AppText(
                          text: 'Save 20% each year with an annual plan',
                          weight: FontWeight.bold,
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.neutral500,
                        ),
                        leading: Image.asset(
                          AssetNames.uberOneTag,
                          width: 30,
                        ),
                      ))
                ],
              ),
            ),
            const Divider(
              thickness: 4,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Exclusive offers',
                    size: AppSizes.heading6,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  AppText(
                    text: 'From stores',
                    size: AppSizes.bodySmall,
                    color: AppColors.neutral500,
                  ),
                ],
              ),
            ),
            const Gap(10),
            SizedBox(
              height: 80,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                separatorBuilder: (context, index) => const Gap(20),
                itemCount: _offers.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final offer = _offers[index];
                  return Row(
                    children: [
                      // CachedNetworkImage(
                      //   imageUrl: offer.product.imageUrls.first,
                      //   width: 80,
                      //   height: 80,
                      //   fit: BoxFit.cover,
                      // ),

                      const Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   width: 250,
                          //   child:
                          //   AppText(
                          //     text: offer.product.name,
                          //     weight: FontWeight.bold,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          // ),
                          Row(
                            children: [
                              Image.asset(
                                AssetNames.uberOneSmall,
                                height: 10,
                              ),
                              AppText(
                                text:
                                    '\$${offer.store.delivery.fee} Delivery Fee',
                              ),
                            ],
                          ),
                          AppText(
                              text:
                                  '${offer.store.delivery.estimatedDeliveryTime} min'),
                          // AppText(
                          //   text:
                          //       '${offer.noOfOffersAvailable} offers available',
                          //   color: Colors.brown,
                          // )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const Gap(5),
            ListTile(
              onTap: () {},
              title: const AppText(
                text: 'See more',
                size: AppSizes.bodySmall,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
            ),
            const Divider(
              thickness: 4,
            ),
            const Gap(5),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                text: 'Benefits',
                weight: FontWeight.bold,
                size: AppSizes.heading6,
              ),
            ),
            const Gap(15),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Gap(10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final benefit = OtherConstants.benefits[index];
                return ListTile(
                  leading: Image.asset(
                    benefit.assetImage,
                    width: 50,
                  ),
                  title: AppText(
                    text: benefit.message,
                    // size: AppSizes.bodySmall,
                  ),
                );
              },
              itemCount: 4,
            ),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const ManageMembershipScreen(),
                ));
              },
              title: const AppText(
                text: 'Manage membership',
                size: AppSizes.bodySmall,
              ),
            ),
            const Divider(),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                children: [
                  const AppText(
                      color: AppColors.neutral500,
                      text:
                          '*Benefits available only for eligible stores and rides marked with the Uber One icon. Participating restaurants and non-grocery stores: \$15 minimum order to receive \$0 Delivery Fee and up to 10% off. Participating grocery stores: \$35 minimum order to receive \$0 Delivery Fee and 5% off. Membership savings applied as a reduction to service fees. 6% Uber Cash earned after completion of eligible rides. Taxes and similar fees, as applicable, do not apply towards order minimums or Uber Cash back benefits. Other fees and exclusions may apply.'),
                  const Gap(10),
                  RichText(
                    text: TextSpan(
                        text:
                            "Estimated savings do not include subscription price. Actual savings may vary. ",
                        style: const TextStyle(
                          fontSize: AppSizes.bodySmallest,
                          color: AppColors.neutral500,
                        ),
                        children: [
                          TextSpan(
                            text: 'View terms and conditions',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
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
                ],
              ),
            ),
            const Gap(30)
          ],
        ),
      ),
    );
  }
}
