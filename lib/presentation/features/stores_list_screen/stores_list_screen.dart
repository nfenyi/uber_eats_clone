import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';

import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/features/store/store_screen.dart';

import '../../../main.dart';
import '../../../models/store/store_model.dart';
import '../../constants/asset_names.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../home/home_screen.dart';

class StoresListScreen extends StatefulWidget {
  final List<Store> stores;
  final String screenTitle;
  const StoresListScreen(
      {super.key, required this.stores, required this.screenTitle});

  @override
  State<StoresListScreen> createState() => _StoresListScreenState();
}

class _StoresListScreenState extends State<StoresListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: widget.screenTitle,
          size: AppSizes.heading6,
          // weight: FontWeight.w600,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        separatorBuilder: (context, index) => const Gap(25),
        itemBuilder: (context, index) {
          final store = widget.stores[index];

          return InkWell(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => StoreScreen(store),
              ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: store.cardImage,
                        width: double.infinity,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (store.offers != null && store.offers!.isNotEmpty)
                      Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green.shade900,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Iconify(
                                  AntDesign.trophy_filled,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                AppText(
                                    color: Colors.white,
                                    size: AppSizes.bodySmallest,
                                    text:
                                        ' Top offer • ${store.offers?.length == 1 ? store.offers?.first.title : '${store.offers?.length} Offers available'}'),
                              ],
                            ),
                          ))
                  ],
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: store.name,
                          weight: FontWeight.w600,
                          maxLines: 3,
                          size: AppSizes.body,
                          overflow: TextOverflow.ellipsis,
                        ),
                        FavouriteButton(
                          store: store,
                          color: AppColors.neutral500,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Visibility(
                            visible: store.isUberOneShop,
                            child: Row(
                              children: [
                                Image.asset(
                                  AssetNames.uberOneSmall,
                                  height: 12,
                                  color: AppColors.uberOneGold,
                                ),
                                const AppText(text: '• ')
                              ],
                            )),
                        AppText(
                          text: '\$${store.delivery.fee} Delivery Fee',
                          color: store.isUberOneShop
                              ? AppColors.uberOneGold
                              : AppColors.neutral500,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppText(
                          text: '${store.rating.averageRating}',
                        ),
                        const Icon(
                          Icons.star,
                          size: 10,
                        ),
                        AppText(
                            color: AppColors.neutral500,
                            text:
                                '(${store.rating.ratings}+) • ${store.delivery.estimatedDeliveryTime} min'),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: widget.stores.length,
      ),
    );
  }
}
