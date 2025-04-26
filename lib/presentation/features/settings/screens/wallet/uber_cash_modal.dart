import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:uber_eats_clone/models/uber_cash/uber_cash_model.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/wallet/add_funds_screen.dart';

import '../../../../../main.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../core/app_colors.dart';

class UberCashModal extends StatefulWidget {
  const UberCashModal({super.key});

  @override
  State<UberCashModal> createState() => _UberCashModalState();
}

class _UberCashModalState extends State<UberCashModal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: const AppText(
            text: 'Uber Cash',
            size: AppSizes.bodySmall,
          ),
          leading: GestureDetector(
              onTap: navigatorKey.currentState!.pop,
              child: const Icon(Icons.close)),
        ),
        // const Gap(10),
        Center(
          child: ValueListenableBuilder(
              valueListenable: Hive.box(AppBoxes.appState)
                  .listenable(keys: [BoxKeys.userInfo]),
              builder: (context, appStateBox, child) {
                final userInfo = appStateBox.get(BoxKeys.userInfo);
                final double cashAmount = userInfo['uberCash']['balance'];

                return AppText(
                  text: '\$${cashAmount.toStringAsFixed(2)}',
                  weight: FontWeight.w600,
                  size: AppSizes.heading3,
                );
              }),
        ),
        const Gap(5),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisExtent: 140),
            children: [
              InkWell(
                onTap: () {
                  navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => const AddFundsScreen(),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 30,
                        ),
                        Gap(10),
                        AppText(
                          text: 'Add funds',
                          weight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // navigatorKey.currentState!.push(MaterialPageRoute(
                  //   builder: (context) => const WalletScreen(),
                  // ));
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Iconify(
                        Bi.arrow_repeat,
                        size: 30,
                      ),
                      Gap(10),
                      AppText(
                        text: 'Auto refill',
                        weight: FontWeight.bold,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Iconify(
                        MaterialSymbols.stars_outline_rounded,
                        size: 30,
                      ),
                      Gap(10),
                      AppText(
                        text: 'Deals & rewards',
                        size: AppSizes.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(10),
        const Divider(
          thickness: 4,
        ),
        const Gap(10),
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSizes.horizontalPaddingSmall),
          child: AppText(
            text: 'Monthly activity',
            weight: FontWeight.w600,
            size: AppSizes.bodySmall,
          ),
        ),
        const Gap(10),
        ValueListenableBuilder(
            valueListenable: Hive.box(AppBoxes.appState)
                .listenable(keys: [BoxKeys.userInfo]),
            builder: (context, appStateBox, child) {
              final userInfo = appStateBox.get(BoxKeys.userInfo);
              final UberCash uberCash = UberCash.fromJson(userInfo['uberCash']);
              return Column(
                children: [
                  ListTile(
                    leading: const Iconify(Mdi.arrow_bottom_right),
                    title: const AppText(
                      text: 'Uber Cash added',
                      size: AppSizes.bodySmall,
                    ),
                    trailing: AppText(
                      text: '\$${uberCash.cashAdded.toStringAsFixed(2)}',
                      color: Colors.green,
                      size: AppSizes.bodySmall,
                    ),
                  ),
                  ListTile(
                    leading: const Iconify(Mdi.arrow_top_right),
                    title: const AppText(
                      text: 'Uber Cash spent',
                      size: AppSizes.bodySmall,
                    ),
                    trailing: AppText(
                      text: '\$${uberCash.cashSpent.toStringAsFixed(2)}',
                      size: AppSizes.bodySmall,
                    ),
                  ),
                ],
              );
            }),
        const Divider(
          thickness: 4,
        ),
        const Gap(10),
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSizes.horizontalPaddingSmall),
          child: AppText(
            text: 'Deals and partner rewards',
            weight: FontWeight.w600,
            size: AppSizes.bodySmall,
          ),
        ),
        const Gap(20),
        CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.6,
              padEnds: false,
              enableInfiniteScroll: false,
              height: 250,
            ),
            // shrinkExtent: 400,

            // shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: AppColors.neutral200),
            //     borderRadius: BorderRadius.circular(10)),
            // backgroundColor: Colors.white,

            // itemExtent: 340,
            items: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                        width: 230,
                        height: 250,
                        fit: BoxFit.cover,
                        imageUrl:
                            'https://images.stockcake.com/public/0/2/8/0289ab21-6648-4d10-a201-b0b8f60717b5_large/busy-urban-street-stockcake.jpg'),
                    Container(
                      width: 230,
                      height: 250,
                      color: Colors.black45,
                    ),
                    SizedBox(
                      width: 230,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white),
                                    child: Image.asset(
                                      AssetNames.masterCardLogo,
                                      width: 50,
                                      height: 50,
                                    )),
                                const Gap(15),
                                const AppText(
                                  text: 'Earn points',
                                  color: Colors.white,
                                  size: AppSizes.heading6,
                                  weight: FontWeight.bold,
                                ),
                                const Gap(10),
                                const AppText(
                                  text:
                                      'Earn up to 3x Mastercard points when you s...',
                                  color: Colors.white,
                                  // size: AppSizes.heading6,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 100,
                              child: AppButton(
                                deactivateExpansion: true,
                                buttonColor: Colors.white,
                                isSecondary: true,
                                text: 'Enroll',
                                callback: () {},
                                // width: 30,
                                borderRadius: 30,
                                height: 40,
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                        width: 230,
                        height: 250,
                        fit: BoxFit.cover,
                        imageUrl:
                            'https://t3.ftcdn.net/jpg/04/65/82/36/360_F_465823640_ekCW3DlSFLiqgSmaV71mQvNYgtO44lgh.jpg'),
                    Container(
                      width: 230,
                      height: 250,
                      color: Colors.black45,
                    ),
                    SizedBox(
                      width: 230,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white),
                                      child: Image.asset(
                                        AssetNames.venmoLogo,
                                        width: 50,
                                        height: 50,
                                      )),
                                ),
                                const Gap(15),
                                const AppText(
                                  text: 'Platinum benefit',
                                  color: Colors.white,
                                  size: AppSizes.heading6,
                                  weight: FontWeight.bold,
                                ),
                                const Gap(10),
                                const AppText(
                                  text: 'Receive \$15 Uber Cash each month',
                                  color: Colors.white,
                                  // size: AppSizes.heading6,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 100,
                              child: AppButton(
                                deactivateExpansion: true,
                                buttonColor: Colors.white,
                                isSecondary: true,
                                text: 'Enroll',
                                callback: () {},
                                // width: 90,
                                borderRadius: 30,
                                height: 40,
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
        const Gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: AppButton(
            text: 'View more offers',
            isSecondary: true,
            callback: () {},
          ),
        )
      ],
    );
  }
}
