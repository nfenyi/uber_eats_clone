import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';

import '../../../app_functions.dart';

import '../../../main.dart';
import '../../../models/advert/advert_model.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../constants/asset_names.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/widgets.dart';
import '../../services/sign_in_view_model.dart';
import '../address/screens/addresses_screen.dart';
import '../home/home_screen.dart';
import '../home/screens/search_screen.dart';
import '../main_screen/screens/main_screen.dart';
import '../some_kind_of_section/advert_screen.dart';

class AlcoholScreen extends ConsumerStatefulWidget {
  const AlcoholScreen({super.key});

  @override
  ConsumerState<AlcoholScreen> createState() => _AlcoholScreenState();
}

class _AlcoholScreenState extends ConsumerState<AlcoholScreen> {
  final List<Store> _alcoholStores = allStores
      .where(
        (element) => element.type.toLowerCase().contains('alcohol'),
      )
      .toList();

  bool _onFilterScreen = false;
  Future<List<DocumentReference>> _getFeaturedStoreRefs() async {
    final featuredGroceryStoresSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.featuredStores)
        .get();
    final documentSnapshots = featuredGroceryStoresSnapshot.docs;
    List<DocumentReference> storeRefs = [];
    for (var docSnapshot in documentSnapshots) {
      storeRefs.add(docSnapshot.data().values.first);
    }

    return storeRefs;
  }

  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPrice;
  List<String> _selectedDietaryOptions = [];
  String? _selectedSort;
  List<String> _selectedFilters = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final timeOfDayNow = TimeOfDay.now();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        ref.read(bottomNavIndexProvider.notifier).updateIndex(1);
      },
      child: SafeArea(
          child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar.medium(
            title: const AppText(
              text: 'Alcohol',
              size: AppSizes.heading6,
            ),
            expandedHeight: 100,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmallest),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              ref
                                  .read(bottomNavIndexProvider.notifier)
                                  .updateIndex(1);
                            },
                            child: const Icon(Icons.arrow_back)),
                        const Gap(5),
                        const AppText(
                          text: 'Alcohol',
                          weight: FontWeight.w600,
                          size: AppSizes.heading4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    stores: _alcoholStores,
                  ),
                )),
                child: Ink(
                  child: const AppTextFormField(
                    enabled: false,
                    constraintWidth: 40,
                    hintText: 'Search alcohol',
                    radius: 50,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: Visibility(
          visible: !_onFilterScreen,
          replacement: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        size: AppSizes.bodySmall,
                        text: '80 results',
                        weight: FontWeight.w600,
                      ),
                      AppButton2(
                        text: 'Reset',
                        callback: () {
                          setState(() {
                            _selectedFilters = [];
                            _onFilterScreen = false;
                            _selectedDeliveryFeeIndex = null;
                            _selectedRatingIndex = null;
                            _selectedPrice = null;
                            _selectedDietaryOptions = [];
                            _selectedSort = null;
                          });
                        },
                      ),
                    ],
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: () async {
                      // await navigatorKey.currentState!.push(MaterialPageRoute(
                      //   builder: (context) => MapScreen(
                      //     userLocation: storedUserLocation!,
                      //     filteredStores: const [],
                      //   ),
                      // ));
                    },
                    child: Ink(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(AssetNames.map, width: double.infinity),
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const AppText(text: 'View map'))
                        ],
                      ),
                    ),
                  ),
                  const Gap(20),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final store = allStores[index];
                        final bool isClosed =
                            timeOfDayNow.hour < store.openingTime.hour ||
                                (timeOfDayNow.hour >= store.closingTime.hour &&
                                    timeOfDayNow.minute >=
                                        store.closingTime.minute);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: store.cardImage,
                                    width: double.infinity,
                                    height: 170,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                isClosed
                                    ? Container(
                                        color: Colors.black.withOpacity(0.5),
                                        width: double.infinity,
                                        height: 170,
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
                                            width: double.infinity,
                                            height: 170,
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, top: 8.0),
                                  child: FavouriteButton(store: store),
                                )
                              ],
                            ),
                            const Gap(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  text: store.name,
                                  weight: FontWeight.w600,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.neutral200,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: AppText(
                                        text: store.rating.averageRating
                                            .toString()))
                              ],
                            ),
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
                                        ? 'Closed • Available at ${AppFunctions.formatDate(store.openingTime.toString(), format: 'h:i A')}'
                                        : '\$${store.delivery.fee} Delivery Fee',
                                    color: store.delivery.fee < 1
                                        ? const Color.fromARGB(
                                            255, 163, 133, 42)
                                        : null),
                                AppText(
                                    text:
                                        ' • ${store.delivery.estimatedDeliveryTime} min'),
                              ],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const Gap(10),
                      itemCount: allStores.length),
                ],
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(10),
                FutureBuilder<List<DocumentReference>>(
                    //TODO: change to featured alcohol stores
                    future: _getFeaturedStoreRefs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        logger.d(snapshot.error.toString());
                        return const SizedBox.shrink();
                      } else if (!snapshot.hasData) {
                        const SizedBox.shrink();
                      }
                      final storeRefs = snapshot.data!;
                      final List<Color> featuredStoresColors = [];
                      for (var i = 0; i < storeRefs.length; i++) {
                        featuredStoresColors.add(Color.fromARGB(
                            50,
                            Random().nextInt(256),
                            Random().nextInt(256),
                            Random().nextInt(256)));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.all(AppSizes.horizontalPaddingSmall),
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
                              separatorBuilder: (context, index) =>
                                  const Gap(10),
                              scrollDirection: Axis.horizontal,
                              itemCount: storeRefs.length,
                              itemBuilder: (context, index) {
                                final reference = storeRefs[index];

                                // logger.d(store.id);

                                return FutureBuilder<Store>(
                                    future: AppFunctions.loadStoreReference(
                                        reference),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Skeletonizer(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: SizedBox(
                                            width: 150,
                                            height: 150,
                                            child: AppText(
                                                text:
                                                    snapshot.error.toString()),
                                          ),
                                        );
                                      }

                                      final store = snapshot.data!;

                                      final bool isClosed = timeOfDayNow.hour <
                                              store.openingTime.hour ||
                                          (timeOfDayNow.hour >=
                                                  store.closingTime.hour &&
                                              timeOfDayNow.minute >=
                                                  store.closingTime.minute);
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          onTap: () async {
                                            await AppFunctions
                                                .navigateToStoreScreen(store);
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 20),
                                                  color: featuredStoresColors[
                                                      index],
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
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
                                                            weight:
                                                                FontWeight.w600,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Visibility(
                                                                  visible: store
                                                                          .delivery
                                                                          .fee <
                                                                      1,
                                                                  child: Image
                                                                      .asset(
                                                                    AssetNames
                                                                        .uberOneSmall,
                                                                    height: 10,
                                                                  )),
                                                              Visibility(
                                                                  visible: store
                                                                          .delivery
                                                                          .fee <
                                                                      1,
                                                                  child: const AppText(
                                                                      text:
                                                                          ' •')),
                                                              AppText(
                                                                  text:
                                                                      " ${store.delivery.estimatedDeliveryTime} min")
                                                            ],
                                                          ),
                                                          if (store.offers !=
                                                                  null &&
                                                              store.offers!
                                                                  .isNotEmpty)
                                                            StoreOffersText(
                                                              store,
                                                              size: AppSizes
                                                                  .bodySmallest,
                                                              color:
                                                                  Colors.green,
                                                            )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                isClosed
                                                    ? Container(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        width: 150,
                                                        height: 150,
                                                        child: const Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            AppText(
                                                              text: 'Closed',
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : !store.delivery.canDeliver
                                                        ? Container(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                            width: 150,
                                                            child: const Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                AppText(
                                                                  text:
                                                                      'Pick up',
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                FutureBuilder<List<Advert>>(
                    future: _getAlcoholAdverts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final alcoholAdverts = snapshot.data!;
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            //TODO: create adverts for alcohol and grocery
                            itemCount: alcoholAdverts.length,
                            itemBuilder: (context, index) {
                              final advert = alcoholAdverts[index];
                              final store = allStores.firstWhere(
                                (element) => element.id == advert.shopId,
                              );

                              return Column(
                                children: [
                                  MainScreenTopic(
                                      callback: () => navigatorKey.currentState!
                                              .push(MaterialPageRoute(
                                            builder: (context) {
                                              return AdvertScreen(
                                                  store: store, advert: advert);
                                            },
                                          )),
                                      title: advert.title,
                                      subtitle: 'From ${store.name}',
                                      imageUrl: store.logo),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        itemCount: advert.products.length,
                                        separatorBuilder: (context, index) =>
                                            const Gap(15),
                                        itemBuilder: (context, index) {
                                          final productReference =
                                              advert.products[index];
                                          return FutureBuilder<Product>(
                                              future: AppFunctions
                                                  .loadProductReference(
                                                      productReference
                                                          as DocumentReference),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Skeletonizer(
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Container(
                                                          color: Colors.blue,
                                                          width: 110,
                                                          height: 200,
                                                        )),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Container(
                                                        color: AppColors
                                                            .neutral100,
                                                        width: 110,
                                                        height: 200,
                                                        child: AppText(
                                                          text: snapshot.error
                                                              .toString(),
                                                          size: AppSizes
                                                              .bodySmallest,
                                                        ),
                                                      ));
                                                }

                                                return ProductGridTile(
                                                    product: snapshot.data!,
                                                    store: store);
                                              });
                                        }),
                                  ),
                                ],
                              );
                            });
                      }
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.horizontalPaddingSmall),
                          child: AppText(text: snapshot.error.toString()),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                //TODO: Add alcohol store to firestore
                MainScreenTopic(callback: () {}, title: 'All Stores'),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final store = _alcoholStores[index];
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
                          trailing: FavouriteButton(
                            store: store,
                            color: AppColors.neutral500,
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
                                              ? 'Available at ${AppFunctions.formatDate(store.openingTime.toString(), format: 'h:i A')}'
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
                    itemCount: _alcoholStores.length),
                const Gap(20),
                const Divider(),
                const Gap(3),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: RichText(
                    text: TextSpan(
                        text:
                            "Uber is paid by merchants for marketing and promotion, which influences the personalized recommendations you see. ",
                        style: const TextStyle(
                          fontSize: AppSizes.bodySmallest,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Learn more or change settings',
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return const PersonalizedRecommendationsWidget();
                                  },
                                );
                              },
                          ),
                        ]),
                  ),
                ),
                const Gap(10)
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<List<Advert>> _getAlcoholAdverts() async {
    final advertsSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.adverts)
        .where('type', isEqualTo: 'alcohol')
        .get();

    final alcoholAdverts = advertsSnapshot.docs.map(
      (snapshot) {
        // logger.d(snapshot.data());
        return Advert.fromJson(snapshot.data());
      },
    ).toList();
    return alcoholAdverts;
  }
}

class PersonalizedRecommendationsWidget extends StatelessWidget {
  const PersonalizedRecommendationsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
                child: AppText(
              text: 'Recommendations and Promotions',
              size: AppSizes.bodySmall,
              weight: FontWeight.w600,
            )),
            const Gap(10),
            const Divider(),
            const Gap(10),
            const AppText(
                text:
                    'We are paid by merchants, brands and other partners to advertise and promote their products and services in the Uber Eats and Postmates apps. These are indicated by a "Sponsored" or "Ad" tag.\n\nWe may use information such as your location and user profile, as well as your trip, order and search history, to personalise the ads you see.\n\n'),
            InkWell(
              onTap: () {},
              child: Ink(
                child: const AppText(
                  text:
                      'You can opt out of this personalisation in your Recommendations and Promos settings.',
                  decoration: TextDecoration.underline,
                  weight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(10),
            AppButton(
              text: 'OK',
              callback: navigatorKey.currentState!.pop,
            )
          ],
        ),
      ),
    );
  }
}
