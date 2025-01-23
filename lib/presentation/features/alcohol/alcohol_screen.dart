import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../app_functions.dart';

import '../../constants/app_sizes.dart';
import '../../constants/asset_names.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/widgets.dart';
import '../home/home_screen.dart';

class AlcoholScreen extends StatefulWidget {
  final List<Store> alcoholStores;
  const AlcoholScreen({super.key, required this.alcoholStores});

  @override
  State<AlcoholScreen> createState() => _AlcoholScreenState();
}

class _AlcoholScreenState extends State<AlcoholScreen> {
  late final List<Color> _featuredStoresColors = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.alcoholStores.length; i++) {
      _featuredStoresColors.add(Color.fromARGB(50, Random().nextInt(256),
          Random().nextInt(256), Random().nextInt(256)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeOfDayNow = TimeOfDay.now();
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    background: const SafeArea(
                      child: Padding(
                        padding:
                            EdgeInsets.all(AppSizes.horizontalPaddingSmall),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Alcohol',
                              weight: FontWeight.w600,
                              size: AppSizes.heading4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    centerTitle: true,
                    titlePadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    // expandedTitleScale: 2,
                    title: InkWell(
                      // onTap: () =>
                      //     navigatorKey.currentState!.push(MaterialPageRoute(
                      //   builder: (context) => SearchScreen(
                      //     stores: _groceryScreenStores,
                      //   ),
                      // ))

                      child: Ink(
                        child: const AppTextFormField(
                          enabled: false,
                          hintText: 'Search alcohol',
                          radius: 50,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    expandedTitleScale: 1,
                  ),
                )
              ];
            },
            body: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(AppSizes.horizontalPaddingSmall),
                  child: Row(
                    children: [
                      AppText(
                        text: 'Featured stores',
                        size: AppSizes.heading6,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    cacheExtent: 300,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    separatorBuilder: (context, index) => const Gap(10),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.alcoholStores.length,
                    itemBuilder: (context, index) {
                      final store = widget.alcoholStores[index];
                      final bool isClosed = timeOfDayNow.hour <
                              store.openingTime.hour ||
                          (timeOfDayNow.hour >= store.closingTime.hour &&
                              timeOfDayNow.minute >= store.closingTime.minute);
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // navigatorKey.currentState!.push(MaterialPageRoute(
                            //   builder: (context) => StoreScreen(store),
                            // ));
                          },
                          child: Ink(
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(12),
                            // ),

                            child: Stack(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 20),
                                  color: _featuredStoresColors[index],
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: store.logo,
                                        width: 200,
                                        height: 50,
                                        // fit: BoxFit.fitWidth,
                                      ),
                                      Column(
                                        children: [
                                          AppText(
                                            text: store.name,
                                            weight: FontWeight.w600,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                  visible:
                                                      store.delivery.fee < 1,
                                                  child: Image.asset(
                                                    AssetNames.uberOneSmall,
                                                    height: 10,
                                                  )),
                                              Visibility(
                                                  visible:
                                                      store.delivery.fee < 1,
                                                  child: const AppText(
                                                      text: ' •')),
                                              AppText(
                                                  text:
                                                      " ${store.delivery.estimatedDeliveryTime} min")
                                            ],
                                          ),
                                          //TODO: offers available text
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                isClosed
                                    ? Container(
                                        color: Colors.black.withOpacity(0.5),
                                        width: 150,
                                        height: 150,
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            AppText(
                                              text: 'Closed',
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      )
                                    : !store.delivery.canDeliver
                                        ? Container(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            width: 150,
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                AppText(
                                                  text: 'Pick up',
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                HomeScreenTopic(
                    callback: () {},
                    title: 'Prep brunch for Mum',
                    subtitle: 'From ${stores[6].name}',
                    imageUrl: stores[6].logo),
                SizedBox(
                  height: 200,
                  child: CustomScrollView(
                    scrollDirection: Axis.horizontal,
                    slivers: stores[6]
                        .productCategories
                        .map((productCategory) => SliverPadding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              sliver: SliverList.separated(
                                separatorBuilder: (context, index) =>
                                    const Gap(10),
                                itemBuilder: (context, index) =>
                                    ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        // TODO: find a way to do lazy loading and remove shrinkWrap
                                        shrinkWrap: true,
                                        itemCount:
                                            productCategory.products.length,
                                        separatorBuilder: (context, index) =>
                                            const Gap(15),
                                        itemBuilder: (context, index) {
                                          final product =
                                              productCategory.products[index];
                                          return ProductGridTile(
                                            product: product,
                                            store: stores[6],
                                          );
                                        }),
                                itemCount: 1,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                HomeScreenTopic(callback: () {}, title: 'All Stores'),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final store = widget.alcoholStores[index];
                      final bool isClosed = timeOfDayNow.hour <
                              store.openingTime.hour ||
                          (timeOfDayNow.hour >= store.closingTime.hour &&
                              timeOfDayNow.minute >= store.closingTime.minute);
                      return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: AppColors.neutral200)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: store.logo,
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          title: AppText(text: store.name),
                          contentPadding: EdgeInsets.zero,
                          trailing: Icon(
                            store.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: AppColors.neutral300,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Visibility(
                                      visible: store.delivery.fee < 1,
                                      child: Image.asset(
                                        AssetNames.uberOneSmall,
                                        height: 10,
                                      )),
                                  AppText(
                                      text: isClosed
                                          ? store.openingTime.hour -
                                                      timeOfDayNow.hour >
                                                  1
                                              ? 'Available at ${AppFunctions.formatTime(store.openingTime)}'
                                              : 'Available in ${store.openingTime.hour - timeOfDayNow.hour == 1 ? '1 hr' : '${store.openingTime.minute - timeOfDayNow.minute} mins'}'
                                          : '\$${store.delivery.fee} Delivery Fee',
                                      color: store.delivery.fee < 1
                                          ? const Color.fromARGB(
                                              255, 163, 133, 42)
                                          : null),
                                  AppText(
                                      text:
                                          ' • ${store.delivery.estimatedDeliveryTime} min'),
                                ],
                              ),
                              const AppText(
                                text: 'Offers available',
                                color: Colors.green,
                              )
                            ],
                          ));
                    },
                    separatorBuilder: (context, index) => const Divider(
                          indent: 30,
                        ),
                    itemCount: widget.alcoholStores.length),
              ],
            )));
  }
}
