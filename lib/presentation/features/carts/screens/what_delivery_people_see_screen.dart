import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../../core/app_colors.dart';

class WhatDeliveryPeopleSeeScreen extends StatefulWidget {
  const WhatDeliveryPeopleSeeScreen({super.key});

  @override
  State<WhatDeliveryPeopleSeeScreen> createState() =>
      _WhatDeliveryPeopleSeeScreenState();
}

class _WhatDeliveryPeopleSeeScreenState
    extends State<WhatDeliveryPeopleSeeScreen> {
  double _sliderProgress = 0;
  final _carouselController = CarouselSliderController();

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'What delivery people see about you',
                    weight: FontWeight.w600,
                    size: AppSizes.heading3,
                  ),
                  const Gap(10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: Colors.black,
                        width: 5,
                        height: 5,
                      ),
                      Expanded(
                        child: Slider.adaptive(
                            thumbColor: Colors.white,
                            min: 0,
                            max: 2,
                            divisions: 2,
                            value: _sliderProgress,
                            onChanged: (value) {
                              setState(() {
                                _sliderProgress = value;
                                _carouselController
                                    .animateToPage(value.toInt());
                              });
                            }),
                      ),
                      Container(
                        color: Colors.black,
                        width: 5,
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _sliderProgress = index.toDouble();
                    });
                  },
                  height: 400,
                ),
                // shrinkExtent: 400,

                // shape: RoundedRectangleBorder(
                //     side: const BorderSide(color: AppColors.neutral200),
                //     borderRadius: BorderRadius.circular(10)),
                // backgroundColor: Colors.white,

                // itemExtent: 340,
                items: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.neutral200)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          child: Image.asset(
                            AssetNames.whatDelivSee1,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Gap(10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Requesting a delivery',
                                weight: FontWeight.w600,
                                size: AppSizes.bodySmaller,
                              ),
                              AppText(
                                  text:
                                      'Delivery person sees your approximate delivery location.'),
                              ListTile(
                                leading: Icon(Icons.pin_drop),
                                title: AppText(text: 'University Dr'),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.neutral200)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          child: Image.asset(
                            AssetNames.whatDelivSee2,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Gap(10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Your delivery is on the way',
                                weight: FontWeight.w600,
                                size: AppSizes.bodySmaller,
                              ),
                              AppText(
                                  text:
                                      'Delivery person sees your first name, last initial, delivery location and notes.'),
                              ListTile(
                                leading: Icon(Icons.person),
                                title: AppText(text: 'Nana M.'),
                              ),
                              ListTile(
                                leading: Icon(Icons.pin_drop),
                                title: AppText(text: '1226 University Dr'),
                              ),
                              ListTile(
                                leading: Icon(Icons.message),
                                title: AppText(
                                    text: 'This is a testing order. You...'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.neutral200)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          child: Image.asset(
                            AssetNames.whatDelivSee3,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Gap(10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'After your delivery',
                                weight: FontWeight.w600,
                                size: AppSizes.bodySmaller,
                              ),
                              AppText(
                                  text:
                                      'Delivery person sees your delivery location but not the house number and unit number.'),
                              ListTile(
                                leading: Icon(Icons.pin_drop),
                                title: AppText(text: 'University Dr'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
            const Gap(15),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                children: [
                  const AppText(
                    text:
                        'Uber never shows your delivery person the following information',
                    weight: FontWeight.w600,
                    size: AppSizes.heading3,
                  ),
                  const Gap(20),
                  Image.asset(
                    AssetNames.neverShowDelivInformation,
                    width: 230,
                  ),
                  const Gap(20),
                  const ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPadding),
                    leading: Icon(Icons.credit_card),
                    title: AppText(text: 'Your payment method'),
                    children: [
                      AppText(
                          text:
                              "Your payment method or credit card information isn't shared with the delivery person.")
                    ],
                  ),
                  const ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPadding),
                    leading: Icon(Icons.phone_iphone),
                    title: AppText(text: 'Your phone number'),
                  ),
                  const ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPadding),
                    leading: Icon(Icons.star),
                    title:
                        AppText(text: 'Rating you give your delivery person'),
                  ),
                  const ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPadding),
                    leading: Icon(Icons.person),
                    title: AppText(text: 'Your profile photo'),
                  ),
                  const ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPadding),
                    leading: Icon(Icons.person),
                    title: AppText(text: 'Your last name'),
                    children: [
                      AppText(text: 'Last name required for alcohol purchases.')
                    ],
                  ),
                  const Gap(20),
                  const AppText(
                    text:
                        'Uber removes your information when delivery is complete',
                    weight: FontWeight.w600,
                    size: AppSizes.heading3,
                  ),
                  const Gap(20),
                  const ExpansionTile(
                    leading: Icon(Icons.contact_emergency_sharp),
                    title: AppText(text: 'Your ID info for alcohol deliveries'),
                  ),
                  const ExpansionTile(
                    leading: Icon(Icons.camera_alt),
                    title: AppText(text: 'Photo of delivery at your door'),
                  ),
                  Image.asset(
                    AssetNames.neverShareInfoBag,
                    height: 250,
                  ),
                  const Gap(40),
                  const Center(
                      child: AppText(
                          size: AppSizes.bodySmall,
                          text: 'Want to learn more about your privacy?')),
                  const Gap(10),
                  GestureDetector(
                      onTap: () {},
                      child: const AppText(
                        text: 'Explore Privacy Center →',
                        decoration: TextDecoration.underline,
                        size: AppSizes.bodySmall,
                      )),
                  const Gap(30)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
