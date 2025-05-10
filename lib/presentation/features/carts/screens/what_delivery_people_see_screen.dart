import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dh_slider/dh_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/octicon.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'dart:ui' as ui;
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/constants/weblinks.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late final Map _userInfo;

  Future<ui.Image> getImageFuture(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) {
    //new Completer
    Completer<ui.Image> completer = Completer<ui.Image>();
    ImageStreamListener? listener;
    //获取图片流
    ImageStream stream = provider.resolve(config);
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      //stream 流监听
      final ui.Image image = frame.image;
      //完成事件
      completer.complete(image);
      //移除监听
      stream.removeListener(listener!);
    });
    //添加监听
    stream.addListener(listener);
    //返回image
    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    _userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
  }

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
                    size: AppSizes.heading4,
                  ),
                  const Gap(10),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall - 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.black,
                              ),
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.black,
                              ),
                              width: 10,
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: getImageFuture(
                              const AssetImage(AssetNames.bowlOfFood)),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DHSlider(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                inactiveTrackColor: AppColors.neutral100,
                                enabledThumbRadius: 20,
                                trackImage: null,
                                value: _sliderProgress,
                                thumbImage: snapshot.data,
                                trackHeight: 3,
                                onChanged: (value) {
                                  setState(() {
                                    _sliderProgress = value;
                                    _carouselController
                                        .animateToPage(value.toInt());
                                  });
                                },
                                divisions: 2,
                                min: 0,
                                max: 2,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  padEnds: false,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _sliderProgress = index.toDouble();
                    });
                  },
                  height: 400,
                ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: 'Requesting a delivery',
                                weight: FontWeight.w600,
                                size: AppSizes.bodySmaller,
                              ),
                              const AppText(
                                  text:
                                      'Delivery person sees your approximate delivery location.'),
                              ListTile(
                                leading: const Icon(Icons.pin_drop),
                                title: AppText(
                                    text: AppFunctions.formatPlaceDescription(
                                        _userInfo['selectedAddress']
                                                ['placeDescription']
                                            .split(', ')[1])),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: 'Your delivery is on the way',
                                weight: FontWeight.w600,
                                size: AppSizes.bodySmaller,
                              ),
                              const AppText(
                                  text:
                                      'Delivery person sees your first name, last initial, delivery location and notes.'),
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: AppText(
                                    text: AppFunctions.formatPlaceDescription(
                                        _userInfo['displayName'])),
                              ),
                              ListTile(
                                  leading: const Icon(Icons.pin_drop),
                                  title: AppText(
                                    text: AppFunctions.formatPlaceDescription(
                                        _userInfo['selectedAddress']
                                            ['placeDescription']),
                                  )),
                              const ListTile(
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: 'After your delivery',
                                weight: FontWeight.w600,
                                size: AppSizes.bodySmaller,
                              ),
                              const AppText(
                                  text:
                                      'Delivery person sees your delivery location but not the house number and unit number.'),
                              ListTile(
                                leading: const Icon(Icons.pin_drop),
                                title: AppText(
                                    text: AppFunctions.formatPlaceDescription(
                                        _userInfo['selectedAddress']
                                                ['placeDescription']
                                            .split(', ')[1])),
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
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: Column(
                  children: [
                    const AppText(
                      text:
                          'Uber never shows your delivery person the following information',
                      weight: FontWeight.w600,
                      size: AppSizes.heading4,
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
                      leading: Iconify(Octicon.feed_person_16),
                      title: AppText(text: 'Your last name'),
                      children: [
                        AppText(
                            text: 'Last name required for alcohol purchases.')
                      ],
                    ),
                    const Gap(20),
                    const AppText(
                      text:
                          'Uber removes your information when delivery is complete',
                      weight: FontWeight.w600,
                      size: AppSizes.heading4,
                    ),
                    const Gap(20),
                    const ExpansionTile(
                      leading: Icon(Icons.contact_emergency_sharp),
                      title:
                          AppText(text: 'Your ID info for alcohol deliveries'),
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
                      text: 'Want to learn more about your privacy?',
                      color: AppColors.neutral500,
                    )),
                    const Gap(10),
                    GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(Weblinks.privacyPolicy));
                        },
                        child: const AppText(
                          text: 'Explore Privacy Center →',
                          decoration: TextDecoration.underline,
                        )),
                    const Gap(30)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
