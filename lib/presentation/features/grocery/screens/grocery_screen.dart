import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:location/location.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/grocery_grocery/grocery_grocery_screen.dart';
import 'package:uber_eats_clone/presentation/features/home/screens/search_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/some_kind_of_section/some_kind_of_section_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../../app_functions.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/weblinks.dart';
import '../../alcohol/alcohol_screen.dart';
import '../../grocery_store/screens/grocery_store_screens.dart';
import '../../home/home_screen.dart';
import '../../home/map/map_screen.dart';
import '../../stores_list_screen/stores_list_screen.dart';
import '../../pharmacy/screens/pharmacy_screen.dart';
import '../../store/store_screen.dart';
import '../../webview/webview_screen.dart';

class GroceryScreen extends ConsumerStatefulWidget {
  const GroceryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends ConsumerState<GroceryScreen> {
  final webViewcontroller = WebViewControllerPlus();

  final List<FoodCategory> _foodCategories = [
    FoodCategory('Grocery', AssetNames.grocery2),
    FoodCategory('Convenience', AssetNames.convenience),
    FoodCategory('Alcohol', AssetNames.alcohol),
    FoodCategory('Gifts', AssetNames.gift),
    FoodCategory('Pharmacy', AssetNames.pharmacy),
    FoodCategory('Baby', AssetNames.babyBottle),
    FoodCategory('Specialty Foods', AssetNames.specialtyFoods),
    FoodCategory('Pet Supplies', AssetNames.petSupplies),
    FoodCategory('Flowers', AssetNames.flowers),
    FoodCategory('Retail', AssetNames.retail),
  ];

  List<String> _selectedFilters = [];

  late List<Store> _hottestDeals;

  // bool _onSearchScreen = false;
  bool _onFilterScreen = false;

  // final FocusNode _focus = FocusNode();

  List<Store> _filteredStores = [];

  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPrice;
  List<String> _selectedDietaryOptions = [];
  String? _selectedSort;
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

  bool _showFilters = true;

  late final List<Color> _featuredStoresColors = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));

    _hottestDeals = List.from(stores);
    _hottestDeals.sort(
      (a, b) => a.rating.averageRating.compareTo(b.rating.averageRating),
    );
    _hottestDeals = _hottestDeals.reversed.toList();
    //TODO: store in global lists so this filteration does not occur on every screen
    //that needs this sorting
    //or better still let firebase take care of sorting
    for (var store in stores) {
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

    for (var i = 0; i < _groceryScreenStores.length; i++) {
      _featuredStoresColors.add(Color.fromARGB(50, Random().nextInt(256),
          Random().nextInt(256), Random().nextInt(256)));
    }
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
    TimeOfDay timeOfDayNow = TimeOfDay.now();
    return SafeArea(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Visibility(
          visible: !_onFilterScreen,
          replacement: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                children: [
                  const Gap(157),
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
                      final userLocation = await Location().getLocation();
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => MapScreen(
                          userLocation: userLocation,
                          filteredStores: [],
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
                        final store = stores[index];
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
                                  child: InkWell(
                                    onTap: () {},
                                    child: Ink(
                                      child: Icon(
                                        favoriteStores.any(
                                          (element) => element.id == store.id,
                                        )
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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
                      itemCount: stores.length),
                ],
              ),
            ),
          ),
          child: NotificationListener<UserScrollNotification>(
            onNotification: (UserScrollNotification userScrollNotification) {
              if (userScrollNotification.direction == ScrollDirection.reverse) {
                setState(() {
                  _showFilters = false;
                });
              } else if (userScrollNotification.direction ==
                  ScrollDirection.forward) {
                setState(() {
                  _showFilters = true;
                });
              }
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(160),
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
                      itemCount: _groceryScreenStores.length,
                      itemBuilder: (context, index) {
                        final store = _groceryScreenStores[index];
                        final bool isClosed =
                            timeOfDayNow.hour < store.openingTime.hour ||
                                (timeOfDayNow.hour >= store.closingTime.hour &&
                                    timeOfDayNow.minute >=
                                        store.closingTime.minute);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) {
                                  if (store.type.contains('Grocery')) {
                                    return GroceryStoreMainScreen(store);
                                  } else {
                                    return StoreScreen(store);
                                  }
                                },
                              ));
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
                  HomeScreenTopic(
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
                    height: 185,
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
                                    CachedNetworkImage(
                                      imageUrl: groceryScreenStore.cardImage,
                                      width: 200,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
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
                                      child: InkWell(
                                        onTap: () {},
                                        child: Ink(
                                          child: Icon(
                                            favoriteStores.any(
                                              (element) =>
                                                  element.id ==
                                                  groceryScreenStore.id,
                                            )
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Gap(5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                  HomeScreenTopic(
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
                                    CachedNetworkImage(
                                      imageUrl: groceryScreenStore.cardImage,
                                      width: 200,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
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
                                      child: InkWell(
                                        onTap: () {},
                                        child: Ink(
                                          child: Icon(
                                            favoriteStores.any(
                                              (element) =>
                                                  element.id ==
                                                  groceryScreenStore.id,
                                            )
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Gap(5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                  HomeScreenTopic(
                      callback: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) =>
                              SomeKindOfSectionScreen(store: stores[2]),
                        ));
                      },
                      title: 'Prep brunch for Mum',
                      subtitle: 'From ${stores[2].name}',
                      imageUrl: stores[2].logo),
                  // SizedBox(
                  //   height: 200,
                  //   child: CustomScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     slivers: stores[2]
                  //         .productCategories
                  //         .map((productCategory) => SliverPadding(
                  //               padding:
                  //                   const EdgeInsets.symmetric(horizontal: 10),
                  //               sliver: SliverList.separated(
                  //                 separatorBuilder: (context, index) =>
                  //                     const Gap(10),
                  //                 itemBuilder: (context, index) =>
                  //                     ListView.separated(
                  //                         scrollDirection: Axis.horizontal,
                  //                         // TODO: find a way to do lazy loading and remove shrinkWrap
                  //                         shrinkWrap: true,
                  //                         itemCount:
                  //                             productCategory.productsAndQuantities.length,
                  //                         separatorBuilder: (context, index) =>
                  //                             const Gap(15),
                  //                         itemBuilder: (context, index) {
                  //                           final product =
                  //                               productCategory.products[index];
                  //                           return SizedBox(
                  //                             width: 100,
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: [
                  //                                 Stack(
                  //                                   alignment:
                  //                                       Alignment.bottomRight,
                  //                                   children: [
                  //                                     ClipRRect(
                  //                                       borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(12),
                  //                                       child:
                  //                                           CachedNetworkImage(
                  //                                         imageUrl: product
                  //                                             .imageUrls.first,
                  //                                         width: 100,
                  //                                         height: 120,
                  //                                         fit: BoxFit.fill,
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .only(
                  //                                               right: 8.0,
                  //                                               top: 8.0),
                  //                                       child: InkWell(
                  //                                         onTap: () {},
                  //                                         child: Ink(
                  //                                           child: Container(
                  //                                             padding:
                  //                                                 const EdgeInsets
                  //                                                     .all(5),
                  //                                             decoration: BoxDecoration(
                  //                                                 boxShadow: const [
                  //                                                   BoxShadow(
                  //                                                     color: Colors
                  //                                                         .black12,
                  //                                                     offset:
                  //                                                         Offset(
                  //                                                             2,
                  //                                                             2),
                  //                                                   )
                  //                                                 ],
                  //                                                 color: Colors
                  //                                                     .white,
                  //                                                 borderRadius:
                  //                                                     BorderRadius
                  //                                                         .circular(
                  //                                                             50)),
                  //                                             child: const Icon(
                  //                                               Icons.add,
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     )
                  //                                   ],
                  //                                 ),
                  //                                 const Gap(5),
                  //                                 AppText(
                  //                                   text: product.name,
                  //                                   weight: FontWeight.w600,
                  //                                   maxLines: 3,
                  //                                   overflow:
                  //                                       TextOverflow.ellipsis,
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Visibility(
                  //                                       visible: product
                  //                                               .promoPrice !=
                  //                                           null,
                  //                                       child: Row(
                  //                                         children: [
                  //                                           AppText(
                  //                                               text:
                  //                                                   '\$${product.initialPrice}',
                  //                                               color: Colors
                  //                                                   .green),
                  //                                           const Gap(5),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     AppText(
                  //                                       text: product
                  //                                           .initialPrice
                  //                                           .toString(),
                  //                                       decoration:
                  //                                           product.promoPrice !=
                  //                                                   null
                  //                                               ? TextDecoration
                  //                                                   .lineThrough
                  //                                               : TextDecoration
                  //                                                   .none,
                  //                                     )
                  //                                   ],
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           );
                  //                         }),
                  //                 itemCount: 1,
                  //               ),
                  //             ))
                  //         .toList(),
                  //   ),
                  // ),

                  HomeScreenTopic(
                      callback: () {},
                      title: 'Breakfast baked goods',
                      subtitle: 'From ${stores[2].name}',
                      imageUrl: stores[2].logo),
                  // SizedBox(
                  //   height: 200,
                  //   child: CustomScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     slivers: stores[2]
                  //         .productCategories
                  //         .map((productCategory) => SliverPadding(
                  //               padding:
                  //                   const EdgeInsets.symmetric(horizontal: 10),
                  //               sliver: SliverList.separated(
                  //                 separatorBuilder: (context, index) =>
                  //                     const Gap(10),
                  //                 itemBuilder: (context, index) =>
                  //                     ListView.separated(
                  //                         scrollDirection: Axis.horizontal,
                  //                         // TODO: find a way to do lazy loading and remove shrinkWrap
                  //                         shrinkWrap: true,
                  //                         itemCount: productCategory
                  //                             .productsAndQuantities.length,
                  //                         separatorBuilder: (context, index) =>
                  //                             const Gap(15),
                  //                         itemBuilder: (context, index) {
                  //                           final product =
                  //                               productCategory.products[index];
                  //                           return SizedBox(
                  //                             width: 100,
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: [
                  //                                 Stack(
                  //                                   alignment:
                  //                                       Alignment.bottomRight,
                  //                                   children: [
                  //                                     ClipRRect(
                  //                                       borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(12),
                  //                                       child:
                  //                                           CachedNetworkImage(
                  //                                         imageUrl: product
                  //                                             .imageUrls.first,
                  //                                         width: 100,
                  //                                         height: 120,
                  //                                         fit: BoxFit.fill,
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .only(
                  //                                               right: 8.0,
                  //                                               top: 8.0),
                  //                                       child: InkWell(
                  //                                         onTap: () {},
                  //                                         child: Ink(
                  //                                           child: Container(
                  //                                             padding:
                  //                                                 const EdgeInsets
                  //                                                     .all(5),
                  //                                             decoration: BoxDecoration(
                  //                                                 boxShadow: const [
                  //                                                   BoxShadow(
                  //                                                     color: Colors
                  //                                                         .black12,
                  //                                                     offset:
                  //                                                         Offset(
                  //                                                             2,
                  //                                                             2),
                  //                                                   )
                  //                                                 ],
                  //                                                 color: Colors
                  //                                                     .white,
                  //                                                 borderRadius:
                  //                                                     BorderRadius
                  //                                                         .circular(
                  //                                                             50)),
                  //                                             child: const Icon(
                  //                                               Icons.add,
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     )
                  //                                   ],
                  //                                 ),
                  //                                 const Gap(5),
                  //                                 AppText(
                  //                                   text: product.name,
                  //                                   weight: FontWeight.w600,
                  //                                   maxLines: 3,
                  //                                   overflow:
                  //                                       TextOverflow.ellipsis,
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Visibility(
                  //                                       visible: product
                  //                                               .promoPrice !=
                  //                                           null,
                  //                                       child: Row(
                  //                                         children: [
                  //                                           AppText(
                  //                                               text:
                  //                                                   '\$${product.initialPrice}',
                  //                                               color: Colors
                  //                                                   .green),
                  //                                           const Gap(5),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     AppText(
                  //                                       text: product
                  //                                           .initialPrice
                  //                                           .toString(),
                  //                                       decoration:
                  //                                           product.promoPrice !=
                  //                                                   null
                  //                                               ? TextDecoration
                  //                                                   .lineThrough
                  //                                               : TextDecoration
                  //                                                   .none,
                  //                                     )
                  //                                   ],
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           );
                  //                         }),
                  //                 itemCount: 1,
                  //               ),
                  //             ))
                  //         .toList(),
                  //   ),
                  // ),

                  HomeScreenTopic(callback: () {}, title: 'All Stores'),
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
                                    timeOfDayNow.minute >=
                                        store.closingTime.minute);
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
                              favoriteStores.any(
                                (element) => element.id == store.id,
                              )
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: Colors.white,
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
                      itemCount: _groceryScreenStores.length),
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
        Container(
          color: Colors.white.withOpacity(0.96),
          // height: _onFilterScreen ? 180 : 275,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_onFilterScreen)
                const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Grocery',
                          weight: FontWeight.w600,
                          size: AppSizes.heading4,
                        ),
                      ],
                    )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: InkWell(
                  onTap: () =>
                      navigatorKey.currentState!.push(MaterialPageRoute(
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
              const Gap(10),
              if (_onFilterScreen || _showFilters)
                SizedBox(
                  height: 65,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    separatorBuilder: (context, index) => const Gap(15),
                    itemCount: _foodCategories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final foodCategory = _foodCategories[index];
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => GroceryGroceryScreen(
                                  stores: _groceryGroceryStores),
                            ));
                          } else if (index == 2) {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) =>
                                  AlcoholScreen(alcoholStores: _alcoholStores),
                            ));
                          } else if (index == 4) {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => PharmacyScreen(
                                  pharmacyStores: _pharmacyStores),
                            ));
                          }
                        },
                        child: SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              Image.asset(
                                foodCategory.image,
                                height: 45,
                              ),
                              AppText(
                                text: foodCategory.name,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    ));
  }
}
