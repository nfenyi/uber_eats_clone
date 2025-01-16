import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/home/screens/search_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/weblinks.dart';
import '../../home/home_screen.dart';
import '../../home/map/map_screen.dart';
import '../../national_brands/national_brands_screen.dart';
import '../../store/store_screen.dart';
import '../../webview/webview_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final webViewcontroller = WebViewControllerPlus();

  final _dropdownValues = ['1226 University Dr', 'placeholder'];

  final List<FoodCategory> _foodCategories = [
    FoodCategory('Breakfast', AssetNames.breakfast),
    FoodCategory('Coffee', AssetNames.coffee),
    FoodCategory('Pizza', AssetNames.pizza),
    FoodCategory('Grocery', AssetNames.grocery),
    FoodCategory('Fast Food', AssetNames.fastFood),
    FoodCategory('Chinese', AssetNames.chinese),
    FoodCategory('Healthy', AssetNames.healthy),
    FoodCategory('Sandwich', AssetNames.sandwich),
    FoodCategory('Mexican', AssetNames.mexican),
    FoodCategory('Sushi', AssetNames.sushi),
    FoodCategory('Korean', AssetNames.korean),
    FoodCategory('Donuts', AssetNames.donuts),
    FoodCategory('Indian', AssetNames.indian),
  ];

  List<String> _selectedFilters = [];

  late final List<Store> _nationalBrands;
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
  final _scrollController = ScrollController();

  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));

    _nationalBrands = stores
        .where(
          (element) => element.location.countryOfOrigin == 'Ghanaian',
        )
        .toList();
    _hottestDeals = List.from(stores);
    _hottestDeals.sort(
      (a, b) => a.rating.averageRating.compareTo(b.rating.averageRating),
    );
    _hottestDeals = _hottestDeals.reversed.toList();
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
                        size: AppSizes.body,
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
                    onTap: () =>
                        navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const MapScreen(),
                    )),
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
                                        store.isFavorite
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
                                        ? 'Closed • Available  at ${store.openingTime.hour}:${store.openingTime.minute}'
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
                  const Gap(236),
                  HomeScreenTopic(
                    title: 'Top 10 hottest this week',
                    callback: () => navigatorKey.currentState!.push,
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      cacheExtent: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      separatorBuilder: (context, index) => const Gap(10),
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final store = _hottestDeals[index];
                        final bool isClosed =
                            timeOfDayNow.hour < store.openingTime.hour ||
                                (timeOfDayNow.hour >= store.closingTime.hour &&
                                    timeOfDayNow.minute >=
                                        store.closingTime.minute);
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => StoreScreen(store),
                            ));
                          },
                          child: Ink(
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(12),
                            // ),
                            child: SizedBox(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: store.cardImage,
                                          width: 200,
                                          height: 120,
                                          fit: BoxFit.fill,
                                        ),
                                        isClosed
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
                                                      text: 'Closed',
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : !store.delivery.canDeliver
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
                                  ),
                                  const Gap(5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: store.name,
                                        weight: FontWeight.w600,
                                      ),
                                      Icon(
                                        store.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: AppColors.neutral600,
                                      )
                                    ],
                                  ),
                                  AppText(
                                      text:
                                          '\$${store.delivery.fee} Delivery Fee',
                                      color: store.delivery.fee < 1
                                          ? const Color.fromARGB(
                                              255, 163, 133, 42)
                                          : null),
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
                                          text:
                                              '(${store.rating.ratings}+) • ${store.delivery.estimatedDeliveryTime} min'),
                                    ],
                                  )
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
                            builder: (context) => const AddressesScreen()));
                      },
                      title: 'Stores near you'),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      cacheExtent: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      separatorBuilder: (context, index) => const Gap(10),
                      scrollDirection: Axis.horizontal,
                      itemCount: stores.length,
                      itemBuilder: (context, index) {
                        final store = stores[index];
                        return InkWell(
                          onTap: () {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => StoreScreen(store),
                            ));
                          },
                          child: Ink(
                            child: SizedBox(
                              // width: 200,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: AppColors.neutral200)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: store.logo,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const Gap(5),
                                  AppText(
                                    text: store.name,
                                    weight: FontWeight.w600,
                                  ),
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
                          builder: (context) => NationalBrandsScreen(
                              nationalBrands: _nationalBrands),
                        ));
                      },
                      title: 'National Brands'),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      cacheExtent: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      separatorBuilder: (context, index) => const Gap(10),
                      scrollDirection: Axis.horizontal,
                      itemCount: _nationalBrands.length,
                      itemBuilder: (context, index) {
                        final nationalBrand = _nationalBrands[index];
                        return SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: nationalBrand.cardImage,
                                      width: 200,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  (timeOfDayNow.hour <
                                              nationalBrand.openingTime.hour ||
                                          (timeOfDayNow.hour >=
                                                  nationalBrand
                                                      .closingTime.hour &&
                                              timeOfDayNow.minute >=
                                                  nationalBrand
                                                      .closingTime.minute))
                                      ? Container(
                                          color: Colors.black.withOpacity(0.5),
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
                                      : !nationalBrand.delivery.canDeliver
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
                                          nationalBrand.isFavorite
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                    text: nationalBrand.name,
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
                                          text: nationalBrand
                                              .rating.averageRating
                                              .toString()))
                                ],
                              ),
                              AppText(
                                  text:
                                      '\$${nationalBrand.delivery.fee} Delivery Fee',
                                  color: nationalBrand.delivery.fee == 0
                                      ? const Color.fromARGB(255, 163, 133, 42)
                                      : null),
                              AppText(
                                  text:
                                      '${nationalBrand.delivery.estimatedDeliveryTime} min')
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                            width: Adaptive.w(80),
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                color: Colors.white,
                                                text:
                                                    '\$0 Delivery Fee + up to 10% off with Uber One',
                                              ),
                                              Gap(10),
                                              AppText(
                                                color: Colors.white,
                                                text: 'Save on your next ride',
                                              ),
                                            ]),
                                        AppButton2(
                                            text: 'Try free for 4 weeks',
                                            callback: () {}),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      child: Image.asset(
                                        height: double.infinity,
                                        AssetNames.hamburger,
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                              ],
                            )),
                        const Gap(10),
                        Container(
                            width: Adaptive.w(80),
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                color: Colors.white,
                                                text:
                                                    '\$0 Delivery Fee + up to 10% off with Uber One',
                                              ),
                                            ]),
                                        AppButton2(
                                            text: 'Request ride',
                                            callback: () {}),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      child: Image.asset(
                                        height: double.infinity,
                                        AssetNames.whiteCar,
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                              ],
                            )),
                      ],
                    ),
                  ),
                  HomeScreenTopic(callback: () {}, title: 'Popular near you'),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      cacheExtent: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      separatorBuilder: (context, index) => const Gap(10),
                      scrollDirection: Axis.horizontal,
                      itemCount: _nationalBrands.length,
                      itemBuilder: (context, index) {
                        final nationalBrand = _nationalBrands[index];
                        return SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: nationalBrand.cardImage,
                                      width: 200,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  (timeOfDayNow.hour <
                                              nationalBrand.openingTime.hour ||
                                          (timeOfDayNow.hour >=
                                                  nationalBrand
                                                      .closingTime.hour &&
                                              timeOfDayNow.minute >=
                                                  nationalBrand
                                                      .closingTime.minute))
                                      ? Container(
                                          color: Colors.black.withOpacity(0.5),
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
                                      : !nationalBrand.delivery.canDeliver
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
                                          nationalBrand.isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                    text: nationalBrand.name,
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
                                          text: nationalBrand
                                              .rating.averageRating
                                              .toString()))
                                ],
                              ),
                              AppText(
                                  text:
                                      '\$${nationalBrand.delivery.fee} Delivery Fee',
                                  color: nationalBrand.delivery.fee == 0
                                      ? const Color.fromARGB(255, 163, 133, 42)
                                      : null),
                              AppText(
                                  text:
                                      '${nationalBrand.delivery.estimatedDeliveryTime} min')
                            ],
                          ),
                        );
                      },
                    ),
                  ),
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
                          .map((productCategory) => SliverList.separated(
                                separatorBuilder: (context, index) =>
                                    const Gap(10),
                                itemBuilder: (context, index) => Row(
                                    children: productCategory.products
                                        .map((product) => SizedBox(
                                              width: 100,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              product.imageUrl,
                                                          width: 100,
                                                          height: 120,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0,
                                                                top: 8.0),
                                                        child: InkWell(
                                                          onTap: () {},
                                                          child: Ink(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                          Offset(
                                                                              2,
                                                                              2),
                                                                    )
                                                                  ],
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50)),
                                                              child: const Icon(
                                                                Icons.add,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Gap(5),
                                                  AppText(
                                                    text: product.name,
                                                    weight: FontWeight.w600,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Visibility(
                                                        visible: product
                                                                .promoPrice !=
                                                            null,
                                                        child: Row(
                                                          children: [
                                                            AppText(
                                                                text:
                                                                    '\$${product.initialPrice}',
                                                                color: Colors
                                                                    .green),
                                                            const Gap(5),
                                                          ],
                                                        ),
                                                      ),
                                                      AppText(
                                                        text: product
                                                            .initialPrice
                                                            .toString(),
                                                        decoration:
                                                            product.promoPrice !=
                                                                    null
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList()),
                                itemCount: 1,
                              ))
                          .toList(),
                    ),
                  ),
                  HomeScreenTopic(
                      callback: () {},
                      title: 'Beer',
                      subtitle: 'From ${stores[7].name}',
                      imageUrl: stores[7].logo),
                  HomeScreenTopic(callback: () {}, title: 'All Stores'),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: store.cardImage,
                                    width: double.infinity,
                                    height: 170,
                                    fit: BoxFit.fill,
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
                                          store.isFavorite
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
                                        ? 'Closed • Available at ${store.openingTime.hour}:${store.openingTime.minute}'
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const AppText(text: 'Deliver now'),
                    subtitle: DropdownButton(
                      underline: Container(
                        height: 1,
                        color: Colors.transparent,
                      ),
                      value: _dropdownValues.first,
                      items: _dropdownValues.map(
                        (e) {
                          return DropdownMenuItem(
                            value: e,
                            child: AppText(text: e),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {},
                    ),
                    trailing: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.neutral100,
                        ),
                        padding: const EdgeInsets.all(5),
                        child: const Badge(
                            backgroundColor: AppColors.primary2,
                            child: Icon(Icons.notifications_outlined))),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: InkWell(
                  onTap: () =>
                      navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      stores: stores,
                    ),
                  )),
                  child: Ink(
                    child: const AppTextFormField(
                      enabled: false,
                      hintText: 'Search Uber Eats',
                      radius: 50,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
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
                    return Column(
                      children: [
                        Image.asset(
                          foodCategory.image,
                          height: 45,
                        ),
                        AppText(
                          text: foodCategory.name,
                        )
                      ],
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

class SearchResultDisplay1 extends StatelessWidget {
  const SearchResultDisplay1({
    super.key,
    required TimeOfDay timeOfDayNow,
    required List<Store> storesWithNameOrProduct,
  })  : _stores = storesWithNameOrProduct,
        _timeOfDayNow = timeOfDayNow;

  final List<Store> _stores;
  final TimeOfDay _timeOfDayNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(125),
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSizes.horizontalPaddingSmall),
          child: AppText(
            text: '383 results',
            size: AppSizes.body,
          ),
        ),
        const Gap(10),
        Expanded(
          child: ListView.separated(
              // physics:
              //     const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                final store = _stores[index];
                final isClosed = _timeOfDayNow.hour < store.openingTime.hour ||
                    (_timeOfDayNow.hour >= store.closingTime.hour &&
                        _timeOfDayNow.minute >= store.closingTime.minute);
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
                            height: 180,
                            fit: BoxFit.fill,
                          ),
                        ),
                        isClosed
                            ? Container(
                                color: Colors.black.withOpacity(0.5),
                                width: double.infinity,
                                height: 180,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    color: Colors.black.withOpacity(0.5),
                                    width: double.infinity,
                                    height: 180,
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
                          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                          child: InkWell(
                            onTap: () {},
                            child: Ink(
                              child: Icon(
                                store.isFavorite
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
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: AppText(
                                text: store.rating.averageRating.toString()))
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
                            text: '\$${store.delivery.fee} Delivery Fee',
                            color: store.delivery.fee < 1
                                ? const Color.fromARGB(255, 163, 133, 42)
                                : null),
                        AppText(
                            text:
                                ' • ${store.delivery.estimatedDeliveryTime} min'),
                      ],
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => const Gap(20),
              itemCount: _stores.length),
        ),
      ],
    );
  }
}

class SearchResultDisplay2 extends StatelessWidget {
  const SearchResultDisplay2({
    super.key,
    required List<Store> storesWithProduct,
  }) : _storesWithProduct = storesWithProduct;

  final List<Store> _storesWithProduct;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(137),
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSizes.horizontalPaddingSmall),
          child: AppText(
            text: '83 results',
            size: AppSizes.body,
          ),
        ),
        const Divider(
          indent: 5,
          endIndent: 5,
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: _storesWithProduct.length,
            itemBuilder: (context, index) {
              final store = _storesWithProduct[index];
              return Column(
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: store.logo,
                        width: 50,
                        height: 50,
                        fit: BoxFit.fill,
                      ),
                    ),
                    title: AppText(text: store.name),
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
                                text: '\$${store.delivery.fee} Delivery Fee',
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
                          color: AppColors.primary2,
                        )
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 200,
                  //   child: ListView.separated(
                  //     cacheExtent: 300,
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: AppSizes.horizontalPaddingSmall),
                  //     separatorBuilder: (context, index) => const Gap(10),
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: store.products.length,
                  //     itemBuilder: (context, index) {
                  //       final product = store.products[index];
                  //       return SizedBox(
                  //         width: 100,
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Stack(
                  //               alignment: Alignment.bottomRight,
                  //               children: [
                  //                 ClipRRect(
                  //                   borderRadius: BorderRadius.circular(12),
                  //                   child: CachedNetworkImage(
                  //                     imageUrl: product.imageUrl,
                  //                     width: 100,
                  //                     height: 120,
                  //                     fit: BoxFit.fill,
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(
                  //                       right: 8.0, top: 8.0),
                  //                   child: InkWell(
                  //                     onTap: () {},
                  //                     child: Ink(
                  //                       child: Container(
                  //                         padding: const EdgeInsets.all(5),
                  //                         decoration: BoxDecoration(
                  //                             boxShadow: const [
                  //                               BoxShadow(
                  //                                 color: Colors.black12,
                  //                                 offset: Offset(2, 2),
                  //                               )
                  //                             ],
                  //                             color: Colors.white,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(50)),
                  //                         child: const Icon(
                  //                           Icons.add,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //             const Gap(5),
                  //             AppText(
                  //               text: product.name,
                  //               weight: FontWeight.w600,
                  //               maxLines: 3,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Visibility(
                  //                   visible: product.promoPrice != null,
                  //                   child: Row(
                  //                     children: [
                  //                       AppText(
                  //                           text: '\$${product.initialPrice}',
                  //                           color: Colors.green),
                  //                       const Gap(5),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 AppText(
                  //                   text: product.initialPrice.toString(),
                  //                   decoration: product.promoPrice != null
                  //                       ? TextDecoration.lineThrough
                  //                       : TextDecoration.none,
                  //                 )
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}

class NoSearchResult extends StatelessWidget {
  const NoSearchResult({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              // fit: BoxFit.fitHeight,
              AssetNames.noSearchResult,
              height: 60,
            ),
            const Gap(10),
            AppText(
              text: 'No results found for "${_searchController.text}"',
            ),
          ],
        ))
      ],
    );
  }
}

class InitialSearchPage1 extends StatelessWidget {
  const InitialSearchPage1({
    super.key,
    required List<String> searchHistory,
    required List<FoodCategory> foodCategories,
    required Function(String query) updateSearchScreenWithValue,
  })  : _searchHistory = searchHistory,
        _updateSearchScreenWithValue = updateSearchScreenWithValue,
        _foodCategories = foodCategories;

  final List<String> _searchHistory;
  final List<FoodCategory> _foodCategories;
  final Function(String query) _updateSearchScreenWithValue;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            const AppText(
              text: 'Recent',
              size: AppSizes.body,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = _searchHistory[index];
                return ListTile(
                  onTap: () {
                    _updateSearchScreenWithValue(item);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.watch_later),
                  title: AppText(text: item),
                );
              },
              itemCount: _searchHistory.length < 6 ? _searchHistory.length : 6,
            ),
            const AppText(
              text: 'Top categories',
              size: AppSizes.body,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final foodCategory = _foodCategories[index];
                return ListTile(
                  onTap: () {
                    _updateSearchScreenWithValue(foodCategory.name);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: Image.asset(
                    foodCategory.image,
                    height: 30,
                    width: 30,
                  ),
                  title: AppText(text: foodCategory.name),
                );
              },
              itemCount: _foodCategories.length,
            ),
          ],
        ),
      ),
    );
  }
}
