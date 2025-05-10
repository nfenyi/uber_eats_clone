import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';

import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';

import '../../main_screen/screens/main_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Store> _availableFavoriteStores = [];
  final List<Store> _unavailableFavoriteStores = [];

  @override
  void initState() {
    super.initState();
    final timeOfDayNow = TimeOfDay.now();
    for (var store in allStores) {
      if (favoriteStores.any((element) => element.id == store.id)) {
        if (timeOfDayNow.isBefore(store.openingTime) ||
            timeOfDayNow.isAfter(store.closingTime)) {
          _unavailableFavoriteStores.add(store);
        } else {
          _availableFavoriteStores.add(store);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeNow = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Your Favorites',
          size: AppSizes.body,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          if (_availableFavoriteStores.isNotEmpty)
            const SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              sliver: SliverToBoxAdapter(
                child: AppText(
                  text: 'Recently added',
                  weight: FontWeight.w600,
                  size: AppSizes.heading6,
                ),
              ),
            ),
          if (_availableFavoriteStores.isNotEmpty)
            SliverList.builder(
              itemCount: _availableFavoriteStores.length,
              itemBuilder: (context, index) {
                final favoriteStore = _availableFavoriteStores[index];
                return ListTile(
                  trailing: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(50)),
                    child: AppText(
                        size: AppSizes.bodyTiny,
                        text: favoriteStore.rating.averageRating
                            .toStringAsFixed(1)),
                  ),
                  titleAlignment: ListTileTitleAlignment.top,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(3),
                      if (favoriteStore.isUberOneShop)
                        Column(
                          children: [
                            Image.asset(
                              AssetNames.uberOneSmall,
                              width: 15,
                            ),
                            const Gap(3),
                          ],
                        ),
                      Row(
                        children: [
                          AppText(
                            text:
                                '\$${favoriteStore.delivery.fee.toStringAsFixed(2)} Delivery Fee • ${favoriteStore.delivery.estimatedDeliveryTime} min',
                            size: AppSizes.bodySmallest,
                          )
                        ],
                      ),
                      if (favoriteStore.offers != null &&
                          favoriteStore.offers!.isNotEmpty)
                        const AppText(
                          text: 'Offers available',
                          color: Colors.green,
                        )
                    ],
                  ),
                  isThreeLine: true,
                  title: AppText(text: favoriteStore.name),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        AppFunctions.displayNetworkImage(
                          favoriteStore.cardImage,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, top: 5),
                          child: FavouriteButton(
                            store: favoriteStore,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          if (_unavailableFavoriteStores.isNotEmpty)
            const SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              sliver: SliverToBoxAdapter(
                child: AppText(
                  text: 'Currently unavailable',
                  weight: FontWeight.w600,
                  size: AppSizes.heading6,
                ),
              ),
            ),
          if (_unavailableFavoriteStores.isNotEmpty)
            SliverList.builder(
              itemCount: _unavailableFavoriteStores.length,
              itemBuilder: (context, index) {
                final favoriteStore = _unavailableFavoriteStores[index];
                return ListTile(
                  trailing: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(50)),
                    child: AppText(
                        size: AppSizes.bodyTiny,
                        text: favoriteStore.rating.averageRating
                            .toStringAsFixed(1)),
                  ),
                  titleAlignment: ListTileTitleAlignment.top,
                  subtitle: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(3),
                      if (favoriteStore.isUberOneShop)
                        Column(
                          children: [
                            Image.asset(
                              AssetNames.uberOneSmall,
                              width: 15,
                            ),
                            const Gap(3),
                          ],
                        ),
                      Row(
                        children: [
                          AppText(
                            text: favoriteStore.openingTime.hour -
                                        dateTimeNow.hour >
                                    1
                                ? 'Available at ${AppFunctions.formatTimeOFDay(favoriteStore.openingTime)}'
                                : 'Available in ${favoriteStore.openingTime.hour - dateTimeNow.hour == 1 ? '1 hr' : '${favoriteStore.openingTime.minute - dateTimeNow.minute} mins'}',
                            size: AppSizes.bodySmallest,
                          )
                        ],
                      ),
                      if (favoriteStore.offers != null &&
                          favoriteStore.offers!.isNotEmpty)
                        const AppText(
                          text: 'Offers available',
                          color: Colors.green,
                        )
                    ],
                  ),
                  isThreeLine: true,
                  title: AppText(text: favoriteStore.name),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AppFunctions.displayNetworkImage(
                              favoriteStore.cardImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration:
                                  const BoxDecoration(color: Colors.black26),
                            ),
                            const AppText(
                              text: 'Closed',
                              size: AppSizes.bodySmallest,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, top: 5),
                          child: FavouriteButton(
                            store: favoriteStore,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}
