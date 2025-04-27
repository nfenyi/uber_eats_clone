import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import '../../../home/home_screen.dart';

class ExclusiveOffersScreen extends StatefulWidget {
  const ExclusiveOffersScreen({super.key});

  @override
  State<ExclusiveOffersScreen> createState() => _ExclusiveOffersScreenState();
}

class _ExclusiveOffersScreenState extends State<ExclusiveOffersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: Colors.black26,
        leading: GestureDetector(
            onTap: navigatorKey.currentState!.pop,
            child: const Icon(
              Icons.keyboard_arrow_down,
              // color: Colors.white,
            )),
        //     title: const AppText(
        //   text: 'Exclusive Offers',
        //   size: AppSizes.heading6,
        // )
      ),
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: Container(
          //     height: 50,
          //     color: Colors.white,
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Image.asset(
              AssetNames.exclusiveOffers,
              width: double.infinity,
            ),
          ),
          const SliverGap(15),
          const SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            sliver: SliverToBoxAdapter(
              child: AppText(
                text: "Today's exclusive offers",
                weight: FontWeight.bold,
                size: AppSizes.heading5,
              ),
            ),
          ),
          const SliverGap(15),
          FutureBuilder(
              future: AppFunctions.getOffers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final offers = snapshot.data!;
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    sliver: SliverList.separated(
                      separatorBuilder: (context, index) => const Gap(20),
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final offer = offers[index];
                        return FutureBuilder(
                            future: AppFunctions.loadStoreReference(
                                offer.store as DocumentReference),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final store = snapshot.data!;
                                return InkWell(
                                  onTap: () async {
                                    await AppFunctions.navigateToStoreScreen(
                                        store);
                                  },
                                  child: Ink(
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Stack(
                                            alignment: Alignment.topLeft,
                                            children: [
                                              AppFunctions.displayNetworkImage(
                                                store.cardImage,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                height: 170,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                        decoration: const BoxDecoration(
                                                            color: Colors.brown,
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        50),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        50))),
                                                        child: StoreOffersText(
                                                            store)),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: FavouriteButton(
                                                            store: store)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Gap(10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  size: AppSizes.bodySmall,
                                                  text: store.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  weight: FontWeight.bold,
                                                ),
                                                Row(
                                                  children: [
                                                    if (store.isUberOneShop)
                                                      Image.asset(
                                                        AssetNames.uberOneSmall,
                                                        width: 20,
                                                      ),
                                                    AppText(
                                                      text:
                                                          ' \$${store.delivery.fee.toStringAsFixed(2)} Delivery Fee',
                                                      color:
                                                          store.delivery.fee < 1
                                                              ? AppColors
                                                                  .uberOneGold
                                                              : null,
                                                    ),
                                                    AppText(
                                                      text:
                                                          ' • ${store.delivery.estimatedDeliveryTime} min',
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors.neutral200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                                child: AppText(
                                                    size: AppSizes.bodySmallest,
                                                    text: store
                                                        .rating.averageRating
                                                        .toString()))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return AppText(text: snapshot.error.toString());
                              } else {
                                return Skeletonizer(
                                  enabled: true,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          color: AppColors.neutral100,
                                          width: double.infinity,
                                          height: 170,
                                        ),
                                      ),
                                      const Gap(10),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: 'anjnalmla',
                                              ),
                                              AppText(
                                                text:
                                                    'ks Delivery Fee • akljklamin',
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                            });
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: AppText(
                      text: snapshot.error.toString(),
                    ),
                  );
                } else {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    sliver: SliverList.separated(
                      separatorBuilder: (context, index) => const Gap(20),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Skeletonizer(
                          enabled: true,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: AppColors.neutral100,
                                  width: double.infinity,
                                  height: 170,
                                ),
                              ),
                              const Gap(10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        size: AppSizes.bodySmall,
                                        text: 'hkjahkjasskfs',
                                      ),
                                      Row(
                                        children: [
                                          AppText(
                                            text: 'Delivery Fee •jakljla min',
                                            size: AppSizes.bodySmall,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.neutral200,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: const AppText(text: 'aljkalmsm'))
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
