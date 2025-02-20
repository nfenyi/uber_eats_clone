import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../home/home_screen.dart';

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
    TimeOfDay timeOfDayNow = TimeOfDay.now();
    for (var store in stores) {
      if (store.isFavorite) {
        if (timeOfDayNow.hour < store.openingTime.hour ||
            (timeOfDayNow.hour >= store.closingTime.hour &&
                timeOfDayNow.minute >= store.closingTime.minute)) {
          _unavailableFavoriteStores.add(store);
        } else {
          _availableFavoriteStores.add(store);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Your Favorites',
          size: AppSizes.bodySmall,
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
                  //add date liked to like model?
                  text: 'Recently added',
                  // weight: FontWeight.w600,
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
                        text: favoriteStore.rating.averageRating
                            .toStringAsFixed(1)),
                  ),
                  titleAlignment: ListTileTitleAlignment.titleHeight,
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
                      )
                    ],
                  ),
                  title: AppText(text: favoriteStore.name),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CachedNetworkImage(
                          imageUrl: favoriteStore.cardImage,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 5, top: 5),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
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
                  //add date liked to like model?
                  text: 'Currently unavailable',
                  // weight: FontWeight.w600,
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
                        text: favoriteStore.rating.averageRating
                            .toStringAsFixed(1)),
                  ),
                  titleAlignment: ListTileTitleAlignment.titleHeight,
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
                      )
                    ],
                  ),
                  title: AppText(text: favoriteStore.name),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: favoriteStore.cardImage,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: 70,
                              height: 70,
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
                        const Padding(
                          padding: EdgeInsets.only(right: 5, top: 5),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
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
