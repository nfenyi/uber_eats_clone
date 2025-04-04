import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/grocery_grocery/grocery_grocery_screen.dart';
import 'package:uber_eats_clone/presentation/features/home/screens/search_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';
import 'package:uber_eats_clone/presentation/features/some_kind_of_section/advert_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../../app_functions.dart';
import '../../../../models/advert/advert_model.dart';
import '../../../../models/store/store_model.dart';
import '../../../../state/user_location_providers.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/weblinks.dart';
import '../../../services/sign_in_view_model.dart';
import '../../home/home_screen.dart';
import '../../home/map/map_screen.dart';
import '../../main_screen/screens/main_screen.dart';
import '../../stores_list/stores_list_screen.dart';
import '../../webview/webview_screen.dart';

class GroceryScreen extends ConsumerStatefulWidget {
  const GroceryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends ConsumerState<GroceryScreen> {
  final webViewcontroller = WebViewControllerPlus();

  List<FoodCategory> _groceryCategories = [];

  // bool _onSearchScreen = false;
  bool _onFilterScreen = false;

  // final FocusNode _focus = FocusNode();

  List<Store> _groceryScreenStores = [];
  final _scrollController = ScrollController();
  final List<Store> _groceryGroceryStores = [];
  final List<Store> _convenienceStores = [];
  final List<Store> _alcoholStores = [];
  final List<Store> _giftStores = [];
  final List<Store> _pharmacyStores = [];
  final List<Store> _babyStores = [];
  final List<Store> _specialtyFoodsStores = [];
  final List<Store> _petSuppliesStores = [];
  final List<Store> _flowerStores = [];
  final List<Store> _retailStores = [];

  Future<List<Advert>> _getGroceryAdverts() async {
    final advertsSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.adverts)
        .where('type', isEqualTo: 'grocery')
        .get();

    final groceryAdverts = advertsSnapshot.docs.map(
      (snapshot) {
        // logger.d(snapshot.data());
        return Advert.fromJson(snapshot.data());
      },
    ).toList();
    return groceryAdverts;
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarIconBrightness: Brightness.dark,
    //   statusBarColor: Colors.white,
    // ));

    //TODO: store in global lists so this filteration does not occur on every screen
    //that needs this sorting
    //or better still let firebase take care of sorting
    for (var store in allStores) {
      if (store.type.contains('Grocery')) {
        _groceryGroceryStores.add(store);
      }
      if (store.type.contains('Convenience')) {
        _convenienceStores.add(store);
      }

      if (store.type.contains('Alcohol')) {
        _alcoholStores.add(store);
      }
      if (store.type.contains('Gifts')) {
        _giftStores.add(store);
      }
      if (store.type.contains('Pharmacy')) {
        _pharmacyStores.add(store);
      }
      if (store.type.contains('Baby')) {
        _babyStores.add(store);
      }
      if (store.type.contains('Specialty Foods')) {
        _specialtyFoodsStores.add(store);
      }
      if (store.type.contains('Pet Supplies')) {
        _petSuppliesStores.add(store);
      }
      if (store.type.contains('Flowers')) {
        _flowerStores.add(store);
      }
      if (store.type.contains('Retail')) {
        _retailStores.add(store);
      }
    }
    _groceryScreenStores = List<Store>.from([
      ..._groceryGroceryStores,
      ..._convenienceStores,
      ..._alcoholStores,
      ..._giftStores,
      ..._pharmacyStores,
      ..._babyStores,
      ..._specialtyFoodsStores,
      ..._petSuppliesStores,
      ..._flowerStores,
      ..._retailStores
    ]).toSet().toList();

    //   _scrollController.addListener(() {
    //   setState(() {
    //     if (_scrollController. == 1) {
    //       //so floating button does not show in inspection tabbarview
    //       _showFloatingActionButton = false;
    //     } else {
    //       _showFloatingActionButton = true;
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedGeoPoint = ref.read(selectedLocationGeoPoint)!;
    // FirebaseFirestore.instance
    //     .collection(FirestoreCollections.featuredStores)
    //     .doc()
    //     .set({
    //   'store': FirebaseFirestore.instance
    //       .collection(FirestoreCollections.stores)
    //       .doc('NazJMIA9yaUsLRjLxBGa')
    // });
    // FirebaseFirestore.instance
    //     .collection(FirestoreCollections.featuredStores)
    //     .doc()
    //     .set({
    //   'store': FirebaseFirestore.instance
    //       .collection(FirestoreCollections.stores)
    //       .doc('pWxVJ3aWrzkMluIn1x3T')
    // });

    // for (var category in _groceryCategories) {
    //   FirebaseFirestore.instance
    //       .collection(FirestoreCollections.groceryCategories)
    //       .doc()
    //       .set(category.toJson());
    // }

    TimeOfDay timeOfDayNow = TimeOfDay.now();
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              titlePadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmallest),
              background: const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: AppText(
                  text: 'Grocery',
                  weight: FontWeight.w600,
                  size: AppSizes.heading4,
                ),
              ),
              title: InkWell(
                onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    stores: _groceryScreenStores,
                  ),
                )),
                child: Ink(
                  child: const AppTextFormField(
                    enabled: false,
                    constraintWidth: 40,
                    hintText: 'Search grocery, drinks, stores',
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
                            _onFilterScreen = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: () async {
                      await navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => MapScreen(
                          userLocation: selectedGeoPoint,
                          filteredStores: const [],
                        ),
                      ));
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
                FutureBuilder(
                    future: _getGroceryCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.horizontalPaddingSmall),
                          child: AppText(text: snapshot.error.toString()),
                        );
                      }
                      return CategoriesListView(
                          groceryCategories: _groceryCategories,
                          groceryGroceryStores: _groceryGroceryStores,
                          alcoholStores: _alcoholStores,
                          pharmacyStores: _pharmacyStores);
                    }),
                FutureBuilder<List<DocumentReference>>(
                    future: _getFeaturedStoreRefs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        logger.d(snapshot.error.toString());
                        return const SizedBox.shrink();
                      }
                      final List<Color> featuredStoresColors = [];
                      for (var i = 0; i < _groceryScreenStores.length; i++) {
                        featuredStoresColors.add(Color.fromARGB(
                            50,
                            Random().nextInt(256),
                            Random().nextInt(256),
                            Random().nextInt(256)));
                      }
                      final storeRefs = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(10),
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
                                                            AppText(
                                                                color: Colors
                                                                    .green,
                                                                size: AppSizes
                                                                    .bodySmallest,
                                                                text:
                                                                    '${store.offers?.length == 1 ? store.offers?.first.title : '${store.offers?.length} Offers available'}'),
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
                MainScreenTopic(
                  callback: () {
                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => StoresListScreen(
                        stores: _groceryScreenStores,
                        screenTitle: 'Grocery Stores',
                      ),
                    ));
                  },
                  title: 'Stock up on groceries',
                  subtitle: 'Fresh groceries delivered to your door',
                ),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    cacheExtent: 300,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    separatorBuilder: (context, index) => const Gap(10),
                    scrollDirection: Axis.horizontal,
                    itemCount: _groceryScreenStores.length,
                    itemBuilder: (context, index) {
                      final groceryScreenStore = _groceryScreenStores[index];
                      return SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: groceryScreenStore.cardImage,
                                        width: 200,
                                        height: 120,
                                        fit: BoxFit.fill,
                                      ),
                                      if (groceryScreenStore.offers != null &&
                                          groceryScreenStore.offers!.isNotEmpty)
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.green.shade900,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AppText(
                                                      color: Colors.white,
                                                      size:
                                                          AppSizes.bodySmallest,
                                                      text:
                                                          '${groceryScreenStore.offers?.length == 1 ? groceryScreenStore.offers?.first.title : '${groceryScreenStore.offers?.length} Offers available'}'),
                                                ],
                                              ),
                                            )),
                                      (timeOfDayNow.hour <
                                                  groceryScreenStore
                                                      .openingTime.hour ||
                                              (timeOfDayNow.hour >=
                                                      groceryScreenStore
                                                          .closingTime.hour &&
                                                  timeOfDayNow.minute >=
                                                      groceryScreenStore
                                                          .closingTime.minute))
                                          ? Container(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              width: 200,
                                              height: 120,
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
                                          : !groceryScreenStore
                                                  .delivery.canDeliver
                                              ? Container(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  width: 200,
                                                  height: 120,
                                                  child: const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, top: 8.0),
                                      child: FavouriteButton(
                                          store: groceryScreenStore))
                                ],
                              ),
                            ),
                            const Gap(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  text: groceryScreenStore.name,
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
                                        text: groceryScreenStore
                                            .rating.averageRating
                                            .toString()))
                              ],
                            ),
                            Row(
                              children: [
                                Visibility(
                                    visible:
                                        groceryScreenStore.delivery.fee < 1,
                                    child: Image.asset(
                                      AssetNames.uberOneSmall,
                                      height: 10,
                                    )),
                                Visibility(
                                    visible:
                                        groceryScreenStore.delivery.fee < 1,
                                    child: const AppText(
                                      text: ' • ',
                                    )),
                                AppText(
                                  text:
                                      '\$${groceryScreenStore.delivery.fee} Delivery Fee',
                                ),
                              ],
                            ),
                            AppText(
                                text:
                                    '${groceryScreenStore.delivery.estimatedDeliveryTime} min')
                          ],
                        ),
                      );
                    },
                  ),
                ),
                MainScreenTopic(
                  callback: () {
                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => StoresListScreen(
                        stores: _groceryScreenStores,
                        screenTitle: 'Grocery Stores',
                      ),
                    ));
                  },
                  title: 'Quick essentials',
                  subtitle: 'Fresh snacks and drinks to daily needs',
                ),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    cacheExtent: 300,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    separatorBuilder: (context, index) => const Gap(10),
                    scrollDirection: Axis.horizontal,
                    itemCount: _groceryScreenStores.length,
                    itemBuilder: (context, index) {
                      final groceryScreenStore = _groceryScreenStores[index];
                      return SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: groceryScreenStore.cardImage,
                                        width: 200,
                                        height: 120,
                                        fit: BoxFit.fill,
                                      ),
                                      if (groceryScreenStore.offers != null &&
                                          groceryScreenStore.offers!.isNotEmpty)
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.green.shade900,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AppText(
                                                      color: Colors.white,
                                                      size:
                                                          AppSizes.bodySmallest,
                                                      text:
                                                          '${groceryScreenStore.offers?.length == 1 ? groceryScreenStore.offers?.first.title : '${groceryScreenStore.offers?.length} Offers available'}'),
                                                ],
                                              ),
                                            )),
                                      (timeOfDayNow.hour <
                                                  groceryScreenStore
                                                      .openingTime.hour ||
                                              (timeOfDayNow.hour >=
                                                      groceryScreenStore
                                                          .closingTime.hour &&
                                                  timeOfDayNow.minute >=
                                                      groceryScreenStore
                                                          .closingTime.minute))
                                          ? Container(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              width: 200,
                                              height: 120,
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
                                          : !groceryScreenStore
                                                  .delivery.canDeliver
                                              ? Container(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  width: 200,
                                                  height: 120,
                                                  child: const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, top: 8.0),
                                      child: FavouriteButton(
                                          store: groceryScreenStore))
                                ],
                              ),
                            ),
                            const Gap(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  text: groceryScreenStore.name,
                                  weight: FontWeight.w600,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.neutral100,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: AppText(
                                        text: groceryScreenStore
                                            .rating.averageRating
                                            .toString()))
                              ],
                            ),
                            Row(
                              children: [
                                Visibility(
                                    visible:
                                        groceryScreenStore.delivery.fee < 1,
                                    child: Image.asset(
                                      AssetNames.uberOneSmall,
                                      height: 10,
                                    )),
                                Visibility(
                                    visible:
                                        groceryScreenStore.delivery.fee < 1,
                                    child: const AppText(
                                      text: ' • ',
                                    )),
                                AppText(
                                  text:
                                      '\$${groceryScreenStore.delivery.fee} Delivery Fee',
                                ),
                              ],
                            ),
                            AppText(
                                text:
                                    '${groceryScreenStore.delivery.estimatedDeliveryTime} min')
                          ],
                        ),
                      );
                    },
                  ),
                ),
                FutureBuilder<List<Advert>>(
                    future: _getGroceryAdverts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final groceryAdverts = snapshot.data!;
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: groceryAdverts.length,
                            itemBuilder: (context, index) {
                              final advert = groceryAdverts[index];
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
                                                store: store,
                                                advert: advert,
                                              );
                                            },
                                          )),
                                      title: advert.title,
                                      subtitle: 'From ${store.name}',
                                      imageUrl: store.logo),
                                  SizedBox(
                                    height: 207,
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
                                                          height: 207,
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
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.horizontalPaddingSmall),
                          child: AppText(
                            text: snapshot.error.toString(),
                            maxLines: null,
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                AllStoresListView(stores: _groceryScreenStores),
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
                              ..onTap = () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    controller: webViewcontroller,
                                    link: Weblinks.uberOneTerms,
                                  ),
                                ));
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
      ),
    );
  }

  Future<void> _getGroceryCategories() async {
    final groceryCategoriesSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.groceryCategories)
        .get();
    _groceryCategories = groceryCategoriesSnapshot.docs.map(
      (snapshot) {
        return FoodCategory.fromJson(snapshot.data());
      },
    ).toList();
    // _animationControllers = List.generate(
    //     _foodCategories.length,
    //     (index) => AnimationController(
    //           vsync: this,
    //           duration: const Duration(
    //               milliseconds: 300), // Adjust duration for speed
    //         ));

    // _rotations = List.generate(
    //     _foodCategories.length,
    //     (index) => Tween<double>(begin: 0, end: 0.7).animate(
    //           // Adjust value for hop height
    //           CurvedAnimation(
    //               parent: _animationControllers[index],
    //               curve: Curves.easeInOut), // Smooth animation
    //         ));
  }

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
}

class AllStoresListView extends StatelessWidget {
  const AllStoresListView({
    super.key,
    required List<Store> stores,
  }) : _groceryScreenStores = stores;

  final List<Store> _groceryScreenStores;

  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDayNow = TimeOfDay.now();
    return Column(
      children: [
        MainScreenTopic(callback: () {}, title: 'All Stores'),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final store = _groceryScreenStores[index];
              final bool isClosed =
                  timeOfDayNow.hour < store.openingTime.hour ||
                      (timeOfDayNow.hour >= store.closingTime.hour &&
                          timeOfDayNow.minute >= store.closingTime.minute);
              return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColors.neutral200)),
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
                                  ? store.openingTime.hour - timeOfDayNow.hour >
                                          1
                                      ? 'Available at ${AppFunctions.formatDate(store.openingTime.toString(), format: 'h:i A')}'
                                      : 'Available in ${store.openingTime.hour - timeOfDayNow.hour == 1 ? '1 hr' : '${store.openingTime.minute - timeOfDayNow.minute} mins'}'
                                  : '\$${store.delivery.fee} Delivery Fee',
                              color: store.delivery.fee < 1
                                  ? const Color.fromARGB(255, 163, 133, 42)
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
            itemCount: _groceryScreenStores.length),
      ],
    );
  }
}

class CategoriesListView extends ConsumerWidget {
  const CategoriesListView({
    super.key,
    required List<FoodCategory> groceryCategories,
    required List<Store> groceryGroceryStores,
    required List<Store> alcoholStores,
    required List<Store> pharmacyStores,
  })  : _groceryCategories = groceryCategories,
        _groceryGroceryStores = groceryGroceryStores,
        _alcoholStores = alcoholStores,
        _pharmacyStores = pharmacyStores;

  final List<FoodCategory> _groceryCategories;
  final List<Store> _groceryGroceryStores;
  final List<Store> _alcoholStores;
  final List<Store> _pharmacyStores;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 65,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        separatorBuilder: (context, index) => const Gap(15),
        itemCount: _groceryCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = _groceryCategories[index];
          return InkWell(
            onTap: () {
              switch (category.name) {
                case 'Grocery':
                  navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) =>
                        GroceryGroceryScreen(stores: _groceryGroceryStores),
                  ));
                  break;
                case 'Alcohol':
                  ref.read(bottomNavIndexProvider.notifier).showAlcoholScreen();
                  break;
                case 'Pharmacy':
                  ref
                      .read(bottomNavIndexProvider.notifier)
                      .showPharmacyScreen();
                  break;
                // case 'Gifts':
                //   navigatorKey.currentState!.push(MaterialPageRoute(
                //     builder: (context) => Material(child: const GiftScreen()),
                //   ));
                //   break;
                default:
                  break;
              }
            },
            child: SizedBox(
              width: 62,
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: category.image,
                    height: 45,
                    width: 45,
                  ),
                  AppText(
                    text: category.name,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
