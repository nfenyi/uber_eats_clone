import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../main.dart';
import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';
import '../address/screens/addresses_screen.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  final _searchController = TextEditingController();
  final List<Promotion> _promotions = [
    Promotion(
        applicableLocation: 'Accra',
        discount: 15,
        expirationDate: DateTime(2026),
        description:
            "For your first order. \$20 minimum order. Delivery orders only. Alcohol or other regulated items may not be eligible for this promotion"),
    Promotion(
        applicableLocation: 'Kumasi',
        discount: 2,
        expirationDate: DateTime(2025, 4),
        description:
            "At select stores. For 2 orders. \$15 minimum order. Alcohol or other regulated items may not be eligible for this promotion")
  ];

  bool _showSearchArea = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Promotions',
          size: AppSizes.heading5,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppTextFormField(
              onChanged: (value) {
                setState(() {
                  if (value != null && value.isNotEmpty) {
                    _showSearchArea = true;
                  } else {
                    _showSearchArea = false;
                  }
                });
              },
              prefixIcon: const Icon(Icons.tag),
              hintText: 'Enter promo code',
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        FontAwesomeIcons.circleXmark,
                      ),
                    )
                  : null,
            ),
          ),
          Expanded(
            child: Visibility(
              visible: _showSearchArea,
              replacement: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(40),
                    ListView.separated(
                      separatorBuilder: (context, index) => const Gap(10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _promotions.length,
                      itemBuilder: (context, index) {
                        final promo = _promotions[index];
                        return Container(
                            padding: const EdgeInsets.all(15),
                            width: Adaptive.w(90),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: AppColors.neutral300)),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text:
                                                '\$${promo.discount.toInt()} off',
                                            size: AppSizes.heading6,
                                            weight: FontWeight.w600,
                                          ),
                                          const Gap(20),
                                          AppText(
                                              text:
                                                  'Use by ${AppFunctions.formatDate(promo.expirationDate.toString(), format: r'M j, Y g A')} \n${promo.description}'),
                                          const Gap(10),
                                          Row(
                                            children: [
                                              AppButton2(
                                                callback: () {},
                                                text: 'Shop now',
                                              ),
                                              const Gap(10),
                                              AppTextButton(
                                                  text: 'Details',
                                                  callback: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        final List<String>
                                                            splitDetails = promo
                                                                .description
                                                                .split('. ');
                                                        late String
                                                            detailThatContainsMinimumOrder;
                                                        return Container(
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .all(
                                                                // horizontal:
                                                                AppSizes
                                                                    .horizontalPaddingSmall),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Center(
                                                                    child:
                                                                        AppText(
                                                                  text:
                                                                      'Enjoy \$${promo.discount.toInt()} off',
                                                                  size: AppSizes
                                                                      .body,
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                )),
                                                                const Gap(5),
                                                                const Divider(),
                                                                const Gap(5),
                                                                const AppText(
                                                                    text:
                                                                        'Expiration'),
                                                                AppText(
                                                                    color: AppColors
                                                                        .neutral500,
                                                                    text:
                                                                        '${AppFunctions.formatDate(promo.expirationDate.toString(), format: r'j M')} at ${AppFunctions.formatDate(promo.expirationDate.toString(), format: r'g:i A e')}'),
                                                                const Gap(5),
                                                                const Divider(),
                                                                const Gap(5),
                                                                const AppText(
                                                                    text:
                                                                        'Location'),
                                                                const Gap(5),
                                                                AppText(
                                                                  text: promo
                                                                      .applicableLocation,
                                                                  color: AppColors
                                                                      .neutral500,
                                                                ),
                                                                const Gap(15),
                                                                const AppText(
                                                                    text:
                                                                        'Details'),
                                                                const Gap(5),
                                                                ListView(
                                                                    shrinkWrap:
                                                                        true,
                                                                    children:
                                                                        splitDetails
                                                                            .map(
                                                                              (detail) => AppText(
                                                                                text: '• $detail',
                                                                                color: AppColors.neutral500,
                                                                              ),
                                                                            )
                                                                            .toList()),
                                                                const Gap(15),
                                                                AppText(
                                                                    text:
                                                                        "\$${promo.discount.toInt()} off your first order with uber Eats ${splitDetails.any(
                                                                  (detail) {
                                                                    detailThatContainsMinimumOrder =
                                                                        detail;
                                                                    return detail
                                                                        .contains(
                                                                            'minimum order');
                                                                  },
                                                                ) ? 'when you spend at least ${detailThatContainsMinimumOrder.split(' ').first}' : ''}. Terms and fees apply."),
                                                                const Gap(15),
                                                                AppButton(
                                                                  text:
                                                                      'Shop Now',
                                                                  callback: () =>
                                                                      navigatorKey
                                                                          .currentState!
                                                                          .pop(),
                                                                ),
                                                                const Gap(10),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          AppButton2(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                        text:
                                                                            'Got it',
                                                                        callback: () => navigatorKey
                                                                            .currentState!
                                                                            .pop(),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  })
                                            ],
                                          )
                                        ]),
                                  ),
                                  Image.asset(
                                    AssetNames.greenTag,
                                    width: 40,
                                  )
                                ]));
                      },
                    ),
                    const Gap(30),
                    SizedBox(
                      height: 142,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                              width: Adaptive.w(80),
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.brown,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  color: Colors.white,
                                                  text:
                                                      '\$0 Delivery Fee + up to 10% off with Uber One',
                                                ),
                                                Gap(10),
                                                AppText(
                                                  color: Colors.white,
                                                  text:
                                                      'Save on your next ride',
                                                ),
                                              ]),
                                          AppButton2(
                                              text: 'Try free for 4 weeks',
                                              callback: () {}),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        child: Image.asset(
                                          height: double.infinity,
                                          AssetNames.hamburger,
                                          fit: BoxFit.cover,
                                        ),
                                      ))
                                ],
                              )),
                          const Gap(10),
                          Container(
                              width: Adaptive.w(80),
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  color: Colors.white,
                                                  text:
                                                      '\$0 Delivery Fee + up to 10% off with Uber One',
                                                ),
                                              ]),
                                          AppButton2(
                                              text: 'Request ride',
                                              callback: () {}),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        child: Image.asset(
                                          height: double.infinity,
                                          AssetNames.whiteCar,
                                          fit: BoxFit.cover,
                                        ),
                                      ))
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                            text: 'Claim promo',
                            callback: () {
                              showInfoToast('Promo claimed', context: context);
                              setState(() {
                                _showSearchArea = false;
                              });
                            },
                          ),
                          const Gap(10)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Promotion {
  final double discount;
  final String description;
  final DateTime expirationDate;
  final String applicableLocation;

  Promotion(
      {required this.discount,
      required this.description,
      required this.applicableLocation,
      required this.expirationDate});
}
