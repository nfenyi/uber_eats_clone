import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';

import '../../../../../models/offer/offer_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import '../../../home/home_screen.dart';
import '../../../main_screen/screens/main_screen.dart';

class ExclusiveOffersScreen extends StatefulWidget {
  const ExclusiveOffersScreen({super.key});

  @override
  State<ExclusiveOffersScreen> createState() => _ExclusiveOffersScreenState();
}

class _ExclusiveOffersScreenState extends State<ExclusiveOffersScreen> {
  final List<Offer> _offers = [
    Offer(
        id: '456465',
        product: products.entries.first.value,
        store: allStores[2],
        title: "Buy 1 get 1 free"),
    Offer(
        id: '4453543',
        product: products.entries.first.value,
        store: allStores[2],
        title: "Buy 1 get 1 free"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const AppText(
        text: 'Exclusive Offers',
        size: AppSizes.heading6,
      )),
      body: CustomScrollView(
        slivers: [
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
                size: AppSizes.heading4,
              ),
            ),
          ),
          const SliverGap(15),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => const Gap(20),
              itemCount: _offers.length,
              itemBuilder: (context, index) {
                final offer = _offers[index];
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          // CachedNetworkImage(
                          //   imageUrl: offer.store.cardImage,
                          //   width: double.infinity,
                          //   fit: BoxFit.cover,
                          //   height: 170,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: const BoxDecoration(
                                      color: Colors.brown,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          bottomRight: Radius.circular(50))),
                                  // child: AppText(
                                  //   text:
                                  //       '${offer.noOfOffersAvailable} Offers Available',
                                  //   color: Colors.white,
                                  // ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(right: 8.0),
                                //   child: Icon(
                                //     favoriteStores.any((element) =>
                                //             element.id == offer.store.id)
                                //         ? Icons.favorite
                                //         : Icons.favorite_outline,
                                //     color: AppColors.neutral300,
                                //   ),
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AppText(
                            //   size: AppSizes.bodySmall,
                            //   text: offer.store.name,
                            //   overflow: TextOverflow.ellipsis,
                            //   weight: FontWeight.bold,
                            // ),
                            // Row(
                            //   children: [
                            //     AppText(
                            //       text:
                            //           '\$${offer.store.delivery.fee.toStringAsFixed(2)} Delivery Fee • ${offer.store.delivery.estimatedDeliveryTime} min',
                            //       size: AppSizes.bodySmall,
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                        // Container(
                        //     decoration: BoxDecoration(
                        //         color: AppColors.neutral200,
                        //         borderRadius: BorderRadius.circular(20)),
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 5, vertical: 5),
                        //     child: AppText(
                        //         text: offer.store.rating.averageRating
                        //             .toString()))
                      ],
                    )
                  ],
                );
              },
            ),
          ),
          const SliverGap(50)
        ],
      ),
    );
  }
}
