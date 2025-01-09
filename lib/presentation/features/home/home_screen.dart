import 'package:chips_choice/chips_choice.dart';
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
import 'package:uber_eats_clone/presentation/features/sign_in/views/address_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../constants/asset_names.dart';
import '../../constants/other_constants.dart';
import '../../constants/weblinks.dart';
import '../store/store_screen.dart';
import '../webview/webview_screen.dart';
import 'map/map_screen.dart';

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

  final List<Store> _stores = [
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        name: "McDonald's",
        doesPickup: false,
        isFavorite: true,
        isGhanaian: true,
        products: [],
        votes: 1245,
        cardImage:
            'https://www.foodandwine.com/thmb/8N5jLutuTK4TDzpDkhMfdaHLZxI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/McDonalds-Hacks-Menu-FT-1-BLOG0122-4ac9d62f6c9143be8da3d0a8553348b0.jpg',
        logo:
            'https://e7.pngegg.com/pngimages/676/74/png-clipart-fast-food-mcdonald-s-logo-golden-arches-restaurant-mcdonalds-mcdonald-s-logo-miscellaneous-food.png',
        delivery: Delivery(canDeliver: true, fee: 0),
        rating: 4.6,
        estimatedDeliveryTime: '15-30'),
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        votes: 9654,
        doesPickup: true,
        name: "Jack in the Box",
        isFavorite: false,
        products: [],
        isGhanaian: false,
        cardImage:
            'https://media-cdn.tripadvisor.com/media/photo-s/08/c1/9b/d5/jack-in-the-box.jpg',
        logo:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHDNjPca07Vm7i0F4kk8zcFDQX0O4o8wv4Kg&s',
        delivery: Delivery(canDeliver: false, fee: 0),
        rating: 4.4,
        estimatedDeliveryTime: '10-25'),
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        doesPickup: false,
        votes: 2547,
        name: "Starbucks",
        isFavorite: false,
        isGhanaian: true,
        products: [],
        cardImage:
            'https://media-cldnry.s-nbcnews.com/image/upload/t_fit-1240w,f_auto,q_auto:best/newscms/2020_41/1617109/starbucks-te-main2-201007.jpg',
        logo:
            'https://redprinting.com/cdn/shop/articles/starbucks-logo-vector-and-png-redprinting-com.jpg?v=1713379657&width=1100',
        delivery: Delivery(canDeliver: true, fee: 3.99),
        rating: 4.2,
        estimatedDeliveryTime: '10-20'),
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        doesPickup: true,
        votes: 2356,
        name: "Wendy's",
        isFavorite: true,
        products: [],
        isGhanaian: false,
        cardImage: 'https://utc.imgix.net/uploads/Wendys_ServiceImage_02.jpg',
        logo:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUN0gOq_cRelnSsHcv_Aiq95sPwUYnooIeTQ&s',
        delivery: Delivery(canDeliver: true, fee: 5.49),
        rating: 3.9,
        estimatedDeliveryTime: '20-35'),
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        doesPickup: false,
        votes: 52,
        isFavorite: false,
        isGhanaian: false,
        products: [],
        cardImage:
            'https://img.cdn4dd.com/cdn-cgi/image/fit=contain,width=1200,height=672,format=auto/https://doordash-static.s3.amazonaws.com/media/store/header/fb9e5a96-94b0-4406-9746-a0f8a7387bf7.jpg',
        name: "The Posh Bagel",
        logo:
            'https://img.cdn4dd.com/cdn-cgi/image/fit=contain,width=1200,height=672,format=auto/https://doordash-static.s3.amazonaws.com/media/restaurant/cover/Posh-Bagel.png',
        delivery: Delivery(canDeliver: false, fee: 0.49),
        rating: 3.8,
        estimatedDeliveryTime: '15-20'),
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        doesPickup: false,
        votes: 32,
        isGhanaian: false,
        products: [],
        isFavorite: false,
        cardImage:
            'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
        name: "Joe & The Juice",
        logo: 'https://gulffranchise.com/franchise-images/joe-juice-fl.png',
        delivery: Delivery(canDeliver: true, fee: 0.99),
        rating: 3.7,
        estimatedDeliveryTime: '10-15'),
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        doesPickup: true,
        votes: 32,
        isGhanaian: true,
        products: [
          Product(
              name: 'Birch Benders Oganic Buttermilk Pancake & Waffle Mix',
              initialPrice: 7.30,
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX2JBcwTEOFS2X5ss4oJDhm9_OIj6NOmeiWw&s',
              quantity: 5),
          Product(
              name: 'Signature Select Grade a Pure Maple',
              initialPrice: 10.11,
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTC0GD164u8Cvwu3fVbiOlEPPuye2EDkJy_w&s',
              quantity: 7),
          Product(
              name: 'Pearl Milling Company',
              initialPrice: 6.51,
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHstuwD4AyM-VGvrcVOhXht_j0lf3ie8Kahg&s',
              quantity: 11),
          Product(
              name: 'Organic Blueberries(18 oz)',
              initialPrice: 10.11,
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8lW8htrtQcsW1QI0UM34PNvTrLAFFniMruA&s',
              quantity: 3),
          Product(
              name: 'O Organics Organic Syrup 100% Pure',
              initialPrice: 9.55,
              imageUrl:
                  'https://img.cdn4dd.com/cdn-cgi/image/fit=contain,width=1200,height=672,format=auto/https://doordash-static.s3.amazonaws.com/media/photosV2/abeb5951-b4ff-4f00-a7cb-10174e731013-retina-large.png',
              quantity: 7)
        ],
        isFavorite: false,
        cardImage:
            'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
        name: "Safeway",
        logo:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhZy8UOQW_ONW303-Cd1_39k8db8JVhfKlHA&s',
        delivery: Delivery(canDeliver: true, fee: 0.99),
        rating: 3.7,
        estimatedDeliveryTime: '10-15'),
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        doesPickup: true,
        votes: 32,
        products: [
          Product(
              name: 'Corona Extra Mexican Lager Beer(12 pack)',
              initialPrice: 21.39,
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlnRtgDZ74Kh3YBFrqaD3F3WpgTANg7ebL8A&s',
              quantity: 7),
          Product(
              name: 'Modelo Cerveza Especial Lager Beer',
              initialPrice: 36.29,
              imageUrl:
                  'https://i5.walmartimages.com/seo/Modelo-Especial-Mexican-Lager-Import-Beer-6-Pack-12-fl-oz-Glass-Bottles-4-4-ABV_cb2e7f8a-d7df-4bfd-b36c-257f9b023092.9e785aa9a4bf79387b8bbdec7f3b2d19.jpeg',
              quantity: 15),
          Product(
              name: 'Coors Light American Lager Beer',
              initialPrice: 15.39,
              imageUrl:
                  'https://m.media-amazon.com/images/I/61JXbG2MPFL._SL1000_.jpg',
              quantity: 7),
        ],
        isGhanaian: false,
        isFavorite: false,
        cardImage:
            'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
        name: "7 Seven",
        logo:
            'https://cdn.prod.website-files.com/640ea4106aa3032db2a6cefb/6489566e8bfc72986607f1f2_6451a8cf783fe3e5bddce039_7-Eleven.png',
        delivery: Delivery(canDeliver: false, fee: 8.99),
        rating: 3.7,
        estimatedDeliveryTime: '10-15'),
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        doesPickup: true,
        votes: 32,
        products: [],
        isGhanaian: true,
        isFavorite: false,
        cardImage:
            'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
        name: "Joe & The Juice",
        logo: 'https://gulffranchise.com/franchise-images/joe-juice-fl.png',
        delivery: Delivery(canDeliver: false, fee: 7.97),
        rating: 3.7,
        estimatedDeliveryTime: '10-15'),
    Store(
        openingHour: const TimeOfDay(hour: 8, minute: 0),
        closingHour: const TimeOfDay(hour: 21, minute: 0),
        doesPickup: false,
        votes: 32,
        products: [],
        isGhanaian: false,
        isFavorite: false,
        cardImage:
            'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
        name: "Joe & The Juice",
        logo: 'https://gulffranchise.com/franchise-images/joe-juice-fl.png',
        delivery: Delivery(canDeliver: true, fee: 6.99),
        rating: 3.7,
        estimatedDeliveryTime: '10-15'),
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

  bool _showFilters = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));

    _nationalBrands = _stores
        .where(
          (element) => element.isGhanaian,
        )
        .toList();
    _hottestDeals = List.from(_stores);
    _hottestDeals.sort(
      (a, b) => a.rating.compareTo(b.rating),
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
                        final store = _stores[index];
                        final bool isClosed =
                            timeOfDayNow.hour < store.openingHour.hour ||
                                (timeOfDayNow.hour >= store.closingHour.hour &&
                                    timeOfDayNow.minute >=
                                        store.closingHour.minute);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    store.cardImage,
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
                                    child:
                                        AppText(text: store.rating.toString()))
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
                                        ? 'Closed • Available at ${store.openingHour}'
                                        : '\$${store.delivery.fee} Delivery Fee',
                                    color: store.delivery.fee < 1
                                        ? const Color.fromARGB(
                                            255, 163, 133, 42)
                                        : null),
                                AppText(
                                    text:
                                        ' • ${store.estimatedDeliveryTime} min'),
                              ],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const Gap(10),
                      itemCount: _stores.length),
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
                            timeOfDayNow.hour < store.openingHour.hour ||
                                (timeOfDayNow.hour >= store.closingHour.hour &&
                                    timeOfDayNow.minute >=
                                        store.closingHour.minute);
                        return ClipRRect(
                          child: InkWell(
                            radius: 12,
                            onTap: () {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) => const StoreScreen(),
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
                                      // borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        children: [
                                          Image.network(
                                            store.cardImage,
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                          text: '${store.rating}',
                                        ),
                                        const Icon(
                                          Icons.star,
                                          size: 10,
                                        ),
                                        AppText(
                                            text:
                                                '(${store.votes}+) • ${store.estimatedDeliveryTime} min'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  HomeScreenTopic(callback: () {}, title: 'Stores near you'),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      cacheExtent: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      separatorBuilder: (context, index) => const Gap(10),
                      scrollDirection: Axis.horizontal,
                      itemCount: _stores.length,
                      itemBuilder: (context, index) {
                        final store = _stores[index];
                        return InkWell(
                          onTap: () {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => const StoreScreen(),
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
                                      child: Image.network(
                                        store.logo,
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
                  HomeScreenTopic(callback: () {}, title: 'National Brands'),
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
                                    child: Image.network(
                                      nationalBrand.cardImage,
                                      width: 200,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  (timeOfDayNow.hour <
                                              nationalBrand.openingHour.hour ||
                                          (timeOfDayNow.hour >=
                                                  nationalBrand
                                                      .closingHour.hour &&
                                              timeOfDayNow.minute >=
                                                  nationalBrand
                                                      .closingHour.minute))
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
                                          text:
                                              nationalBrand.rating.toString()))
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
                                      '${nationalBrand.estimatedDeliveryTime} min')
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
                                    child: Image.network(
                                      nationalBrand.cardImage,
                                      width: 200,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  (timeOfDayNow.hour <
                                              nationalBrand.openingHour.hour ||
                                          (timeOfDayNow.hour >=
                                                  nationalBrand
                                                      .closingHour.hour &&
                                              timeOfDayNow.minute >=
                                                  nationalBrand
                                                      .closingHour.minute))
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
                                          text:
                                              nationalBrand.rating.toString()))
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
                                      '${nationalBrand.estimatedDeliveryTime} min')
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  HomeScreenTopic(
                      callback: () {},
                      title: 'Prep brunch for Mum',
                      subtitle: 'From ${_stores[6].name}',
                      imageUrl: _stores[6].logo),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      cacheExtent: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      separatorBuilder: (context, index) => const Gap(10),
                      scrollDirection: Axis.horizontal,
                      itemCount: _stores[6].products.length,
                      itemBuilder: (context, index) {
                        final product = _stores[6].products[index];
                        return SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      product.imageUrl,
                                      width: 100,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 8.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Ink(
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(2, 2),
                                                )
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
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
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: product.promoPrice != null,
                                    child: Row(
                                      children: [
                                        AppText(
                                            text: '\$${product.initialPrice}',
                                            color: Colors.green),
                                        const Gap(5),
                                      ],
                                    ),
                                  ),
                                  AppText(
                                    text: product.initialPrice.toString(),
                                    decoration: product.promoPrice != null
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  HomeScreenTopic(
                      callback: () {},
                      title: 'Beer',
                      subtitle: 'From ${_stores[7].name}',
                      imageUrl: _stores[7].logo),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      cacheExtent: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      separatorBuilder: (context, index) => const Gap(10),
                      scrollDirection: Axis.horizontal,
                      itemCount: _stores[7].products.length,
                      itemBuilder: (context, index) {
                        final product = _stores[7].products[index];
                        return SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      product.imageUrl,
                                      width: 100,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 8.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Ink(
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(2, 2),
                                                )
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
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
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: product.promoPrice != null,
                                    child: Row(
                                      children: [
                                        AppText(
                                            text: '\$${product.initialPrice}',
                                            color: Colors.green),
                                        const Gap(5),
                                      ],
                                    ),
                                  ),
                                  AppText(
                                    text: product.initialPrice.toString(),
                                    decoration: product.promoPrice != null
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  HomeScreenTopic(callback: () {}, title: 'All Stores'),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final store = _stores[index];
                        final bool isClosed =
                            timeOfDayNow.hour < store.openingHour.hour ||
                                (timeOfDayNow.hour >= store.closingHour.hour &&
                                    timeOfDayNow.minute >=
                                        store.closingHour.minute);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    store.cardImage,
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
                                    child:
                                        AppText(text: store.rating.toString()))
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
                                        ? 'Closed • Available at ${store.openingHour}'
                                        : '\$${store.delivery.fee} Delivery Fee',
                                    color: store.delivery.fee < 1
                                        ? const Color.fromARGB(
                                            255, 163, 133, 42)
                                        : null),
                                AppText(
                                    text:
                                        ' • ${store.estimatedDeliveryTime} min'),
                              ],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const Gap(10),
                      itemCount: _stores.length),
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
                      stores: _stores,
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
              if (_onFilterScreen || _showFilters)
                ChipsChoice<String>.multiple(
                  choiceLabelBuilder: (item, i) {
                    if (i < 3) {
                      return AppText(
                        text: item.label,
                      );
                    } else if (i == 3) {
                      if (_selectedDeliveryFeeIndex == null) {
                        return AppText(
                          text: item.label,
                        );
                      } else {
                        return AppText(
                            text: OtherConstants.deliveryPriceFilters[
                                _selectedDeliveryFeeIndex!]);
                      }
                    } else if (i == 4) {
                      if (_selectedRatingIndex == null) {
                        return AppText(
                          text: item.label,
                        );
                      } else {
                        return AppText(
                            text: OtherConstants
                                .ratingsFilters[_selectedRatingIndex!]);
                      }
                    } else if (i == 5) {
                      if (_selectedPrice == null) {
                        return AppText(
                          text: item.label,
                        );
                      } else {
                        return AppText(text: _selectedPrice!);
                      }
                    } else if (i == 6) {
                      if (_selectedDietaryOptions.isEmpty) {
                        return AppText(
                          text: item.label,
                        );
                      } else {
                        return AppText(
                            text:
                                '${item.label}(${_selectedDietaryOptions.length})');
                      }
                    } else {
                      if (_selectedSort == null) {
                        return AppText(
                          text: item.label,
                        );
                      } else {
                        return AppText(text: _selectedSort!);
                      }
                    }
                  },
                  choiceTrailingBuilder: (item, i) {
                    if (i > 2) {
                      return const Icon(Icons.keyboard_arrow_down_sharp);
                    }
                    return null;
                  },
                  wrapped: false,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  value: _selectedFilters,
                  onChanged: (value) {
                    logger.d(value);

                    late String newFilter;
                    if (value.any(
                          (element) {
                            newFilter = element;
                            return !_selectedFilters.contains(element);
                          },
                        ) ||
                        (value.isEmpty && _selectedFilters.isNotEmpty)) {
                      if (_selectedFilters.isNotEmpty) {
                        newFilter = _selectedFilters.first;
                      }
                      if (OtherConstants.filters.indexOf(newFilter) == 3) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            late int temp;
                            logger.d(_selectedDeliveryFeeIndex);
                            if (_selectedDeliveryFeeIndex == null) {
                              temp = 3;
                            } else {
                              temp = _selectedDeliveryFeeIndex!;
                            }
                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    // horizontal:
                                    AppSizes.horizontalPaddingSmall),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                        child: AppText(
                                      text: 'Delivery fee',
                                      size: AppSizes.body,
                                      weight: FontWeight.w600,
                                    )),
                                    AppText(
                                        text: temp == 0
                                            ? 'Under \$1'
                                            : temp == 1
                                                ? 'Under \$3'
                                                : temp == 2
                                                    ? 'Under \$5'
                                                    : 'Any amount'),
                                    Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children:
                                            OtherConstants.deliveryPriceFilters
                                                .map(
                                                  (e) => AppText(text: e),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                    Slider.adaptive(
                                        thumbColor: Colors.white,
                                        min: 0,
                                        max: OtherConstants
                                                .deliveryPriceFilters.length -
                                            1,
                                        divisions: OtherConstants
                                                .deliveryPriceFilters.length -
                                            1,
                                        value: temp.toDouble(),
                                        onChanged: (value) {
                                          setState(() {
                                            temp = value.toInt();
                                            logger.d(temp);
                                          });
                                        }),
                                    AppButton(
                                      text: 'Apply',
                                      callback: () {
                                        _selectedDeliveryFeeIndex = temp;
                                        // logger.d(_selectedDeliveryFeeIndex);
                                        //                      setState(() {
                                        //   _currentlySelectedFilters = value;
                                        // });
                                        navigatorKey.currentState!.pop();
                                        setState(() {
                                          _selectedFilters = value;
                                          if (value.isNotEmpty) {
                                            _onFilterScreen = true;
                                          } else {
                                            _onFilterScreen = false;
                                          }
                                        });
                                      },
                                    ),
                                    Center(
                                      child: AppTextButton(
                                        size: AppSizes.body,
                                        text: 'Reset',
                                        callback: () {
                                          // setState(() {
                                          //   _currentlySelectedFilters =
                                          //       List.from(value);
                                          //   _currentlySelectedFilters.removeWhere(
                                          //     (element) =>
                                          //         element == 'Delivery fee',
                                          //   );
                                          // });
                                          navigatorKey.currentState!.pop();
                                          setState(() {
                                            List<String> temp =
                                                List<String>.from(value);

                                            temp.removeWhere(
                                              (element) =>
                                                  element ==
                                                  OtherConstants.filters[3],
                                            );

                                            _selectedFilters = temp;
                                            _selectedDeliveryFeeIndex = null;

                                            if (temp.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
                          4) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            late int temp;
                            logger.d(_selectedRatingIndex);
                            if (_selectedRatingIndex == null) {
                              temp = 0;
                            } else {
                              temp = _selectedRatingIndex!;
                            }
                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    // horizontal:
                                    AppSizes.horizontalPaddingSmall),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                        child: AppText(
                                      text: 'Rating',
                                      size: AppSizes.body,
                                      weight: FontWeight.w600,
                                    )),
                                    AppText(
                                        text: temp == 0
                                            ? 'Over 3'
                                            : temp == 1
                                                ? 'Over 3.5'
                                                : temp == 2
                                                    ? 'Over 4'
                                                    : temp == 3
                                                        ? 'Over 4.5'
                                                        : 'Over 5'),
                                    Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: OtherConstants.ratingsFilters
                                            .map(
                                              (e) => AppText(text: e),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    Slider.adaptive(
                                        thumbColor: Colors.white,
                                        min: 0,
                                        max: OtherConstants
                                                .ratingsFilters.length -
                                            1,
                                        divisions: OtherConstants
                                                .ratingsFilters.length -
                                            1,
                                        value: temp.toDouble(),
                                        onChanged: (value) {
                                          setState(() {
                                            temp = value.toInt();
                                            logger.d(temp);
                                          });
                                        }),
                                    AppButton(
                                      text: 'Apply',
                                      callback: () {
                                        _selectedRatingIndex = temp;
                                        // logger.d(_selectedRatingIndex);
                                        //                      setState(() {
                                        //   _currentlySelectedFilters = value;
                                        // });
                                        navigatorKey.currentState!.pop();
                                        setState(() {
                                          _selectedFilters = value;
                                          if (value.isNotEmpty) {
                                            _onFilterScreen = true;
                                          } else {
                                            _onFilterScreen = false;
                                          }
                                        });
                                      },
                                    ),
                                    Center(
                                      child: AppTextButton(
                                        size: AppSizes.body,
                                        text: 'Reset',
                                        callback: () {
                                          // setState(() {
                                          //   _currentlySelectedFilters =
                                          //       List.from(value);
                                          //   _currentlySelectedFilters.removeWhere(
                                          //     (element) =>
                                          //         element == 'Delivery fee',
                                          //   );
                                          // });
                                          navigatorKey.currentState!.pop();
                                          setState(() {
                                            List<String> temp =
                                                List<String>.from(value);
                                            temp.removeWhere(
                                              (element) =>
                                                  element ==
                                                  OtherConstants.filters[4],
                                            );
                                            _selectedFilters = temp;
                                            _selectedRatingIndex = null;
                                            if (temp.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
                          5) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            String? temp;
                            if (_selectedPrice != null) {
                              temp = _selectedPrice;
                            }

                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    // horizontal:
                                    AppSizes.horizontalPaddingSmall),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                        child: AppText(
                                      text: 'Price',
                                      size: AppSizes.body,
                                      weight: FontWeight.w600,
                                    )),
                                    Center(
                                      child: ChipsChoice.single(
                                          choiceItems:
                                              C2Choice.listFrom<String, String>(
                                            source:
                                                OtherConstants.pricesFilters,
                                            value: (i, v) => v,
                                            label: (i, v) => v,
                                          ),
                                          wrapped: true,
                                          alignment: WrapAlignment.spaceBetween,
                                          choiceStyle: C2ChipStyle.filled(
                                            selectedStyle: const C2ChipStyle(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  AppColors.neutral900,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(100),
                                              ),
                                            ),
                                            height: 30,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: AppColors.neutral200,
                                          ),
                                          value: temp,
                                          onChanged: (value) {
                                            setState(() {
                                              temp = value;
                                            });
                                          }),
                                    ),
                                    const Gap(20),
                                    AppButton(
                                      text: 'Apply',
                                      callback: () {
                                        _selectedPrice = temp;

                                        navigatorKey.currentState!.pop();
                                        setState(() {
                                          _selectedFilters = value;
                                          if (value.isNotEmpty) {
                                            _onFilterScreen = true;
                                          } else {
                                            _onFilterScreen = false;
                                          }
                                        });
                                      },
                                    ),
                                    Center(
                                      child: AppTextButton(
                                        size: AppSizes.body,
                                        text: 'Reset',
                                        callback: () {
                                          navigatorKey.currentState!.pop();

                                          setState(() {
                                            List<String> temp =
                                                List<String>.from(value);
                                            temp.removeWhere(
                                              (element) =>
                                                  element ==
                                                  OtherConstants.filters[5],
                                            );
                                            _selectedFilters = temp;
                                            _selectedPrice = null;
                                            if (value.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
                          6) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            List<String> temp = _selectedDietaryOptions;

                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    // horizontal:
                                    AppSizes.horizontalPaddingSmall),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                        child: AppText(
                                      text: 'Dietary',
                                      size: AppSizes.body,
                                      weight: FontWeight.w600,
                                    )),
                                    ListView(
                                      shrinkWrap: true,
                                      children: [
                                        AppCheckboxListTile(
                                          onChanged: (value) {
                                            setState(() {
                                              if (value != null) {
                                                if (value) {
                                                  temp.add('Vegetarian');
                                                } else {
                                                  temp.removeWhere(
                                                    (element) =>
                                                        element == 'Vegetarian',
                                                  );
                                                }
                                              }
                                            });
                                          },
                                          value: 'Vegetarian',
                                          selectedOptions: temp,
                                        ),
                                        AppCheckboxListTile(
                                          onChanged: (value) {
                                            setState(() {
                                              if (value != null) {
                                                if (value) {
                                                  temp.add('Vegan');
                                                } else {
                                                  temp.removeWhere(
                                                    (element) =>
                                                        element == 'Vegan',
                                                  );
                                                }
                                              }
                                            });
                                          },
                                          value: 'Vegan',
                                          selectedOptions: temp,
                                        ),
                                        AppCheckboxListTile(
                                          onChanged: (value) {
                                            setState(() {
                                              if (value != null) {
                                                if (value) {
                                                  temp.add('Gluten-free');
                                                } else {
                                                  temp.removeWhere(
                                                    (element) =>
                                                        element ==
                                                        'Gluten-free',
                                                  );
                                                }
                                              }
                                            });
                                          },
                                          value: 'Gluten-free',
                                          selectedOptions: temp,
                                        ),
                                        AppCheckboxListTile(
                                          onChanged: (value) {
                                            setState(() {
                                              if (value != null) {
                                                if (value) {
                                                  temp.add('Halal');
                                                } else {
                                                  temp.removeWhere(
                                                    (element) =>
                                                        element == 'Halal',
                                                  );
                                                }
                                              }
                                            });
                                          },
                                          value: 'Halal',
                                          selectedOptions: temp,
                                        ),
                                      ],
                                    ),
                                    const Gap(20),
                                    AppButton(
                                      text: 'Apply',
                                      callback: () {
                                        _selectedDietaryOptions = temp;

                                        navigatorKey.currentState!.pop();
                                        setState(() {
                                          _selectedFilters = value;
                                          if (value.isNotEmpty) {
                                            _onFilterScreen = true;
                                          } else {
                                            _onFilterScreen = false;
                                          }
                                        });
                                      },
                                    ),
                                    Center(
                                      child: AppTextButton(
                                        size: AppSizes.body,
                                        text: 'Reset',
                                        callback: () {
                                          navigatorKey.currentState!.pop();
                                          setState(() {
                                            List<String> temp2 =
                                                List<String>.from(value);
                                            temp2.removeWhere(
                                              (element) =>
                                                  element ==
                                                  OtherConstants.filters[6],
                                            );
                                            _selectedFilters = temp2;
                                            _selectedDietaryOptions = [];
                                            if (value.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
                          7) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            String? temp;

                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    // horizontal:
                                    AppSizes.horizontalPaddingSmall),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                        child: AppText(
                                      text: 'Sort',
                                      size: AppSizes.body,
                                      weight: FontWeight.w600,
                                    )),
                                    ListView(
                                      shrinkWrap: true,
                                      children: const [
                                        AppRadioListTile(
                                          groupValue: 'Sort',
                                          value: 'Recommended',
                                        ),
                                        AppRadioListTile(
                                          groupValue: 'Sort',
                                          value: 'Rating',
                                        ),
                                        AppRadioListTile(
                                          groupValue: 'Sort',
                                          value: 'Delivery time',
                                        ),
                                      ],
                                    ),
                                    const Gap(20),
                                    AppButton(
                                      text: 'Apply',
                                      callback: () {
                                        _selectedSort = temp;

                                        navigatorKey.currentState!.pop();
                                        setState(() {
                                          _selectedFilters = value;
                                          if (value.isNotEmpty) {
                                            _onFilterScreen = true;
                                          } else {
                                            _onFilterScreen = false;
                                          }
                                        });
                                      },
                                    ),
                                    Center(
                                      child: AppTextButton(
                                        size: AppSizes.body,
                                        text: 'Reset',
                                        callback: () {
                                          navigatorKey.currentState!.pop();
                                          setState(() {
                                            List<String> temp =
                                                List<String>.from(value);

                                            temp.removeWhere(
                                              (element) =>
                                                  element ==
                                                  OtherConstants.filters[7],
                                            );
                                            _selectedFilters = temp;
                                            _selectedSort = null;
                                            if (value.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: OtherConstants.filters,
                    value: (i, v) => v,
                    label: (i, v) => v,
                  ),
                  choiceStyle: C2ChipStyle.filled(
                    selectedStyle: const C2ChipStyle(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.neutral900,
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    height: 30,
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.neutral200,
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
                final isClosed = _timeOfDayNow.hour < store.openingHour.hour ||
                    (_timeOfDayNow.hour >= store.closingHour.hour &&
                        _timeOfDayNow.minute >= store.closingHour.minute);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            store.cardImage,
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
                            child: AppText(text: store.rating.toString()))
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
                        AppText(text: ' • ${store.estimatedDeliveryTime} min'),
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
                      child: Image.network(
                        store.logo,
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
                                text: ' • ${store.estimatedDeliveryTime} min'),
                          ],
                        ),
                        const AppText(
                          text: 'Offers available',
                          color: AppColors.primary2,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      cacheExtent: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      separatorBuilder: (context, index) => const Gap(10),
                      scrollDirection: Axis.horizontal,
                      itemCount: store.products.length,
                      itemBuilder: (context, index) {
                        final product = store.products[index];
                        return SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      product.imageUrl,
                                      width: 100,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 8.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Ink(
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(2, 2),
                                                )
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
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
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: product.promoPrice != null,
                                    child: Row(
                                      children: [
                                        AppText(
                                            text: '\$${product.initialPrice}',
                                            color: Colors.green),
                                        const Gap(5),
                                      ],
                                    ),
                                  ),
                                  AppText(
                                    text: product.initialPrice.toString(),
                                    decoration: product.promoPrice != null
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
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

class InitialSearchPage2 extends StatelessWidget {
  const InitialSearchPage2({
    super.key,
    required List<String> searchHistory,
    required List<String> topSearches,
  })  : _searchHistory = searchHistory,
        _topSearches = topSearches;

  final List<String> _searchHistory;
  final List<String> _topSearches;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
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
                  onTap: () {},
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.watch_later),
                  title: AppText(text: item),
                );
              },
              itemCount: _searchHistory.length <= 6 ? _searchHistory.length : 6,
            ),
            const AppText(
              text: 'Top searches',
              size: AppSizes.body,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final topSearch = _topSearches[index];
                return ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.search,

                    // size: 30,
                  ),
                  title: AppText(text: topSearch),
                );
              },
              itemCount: _topSearches.length <= 6 ? _topSearches.length : 6,
            ),
          ],
        ),
      ),
    );
  }
}

class Store {
  final String name;
  final bool doesPickup;
  final String logo;
  final Delivery delivery;
  final double rating;
  final String estimatedDeliveryTime;
  final String cardImage;
  final int votes;
  final bool isFavorite;
  final bool isGhanaian;
  final List<Product> products;
  final TimeOfDay openingHour;
  final TimeOfDay closingHour;
  Store(
      {required this.name,
      required this.logo,
      required this.doesPickup,
      required this.delivery,
      required this.rating,
      required this.cardImage,
      required this.votes,
      required this.isFavorite,
      required this.products,
      required this.isGhanaian,
      required this.openingHour,
      required this.closingHour,
      required this.estimatedDeliveryTime});
}

class Delivery {
  final bool canDeliver;
  final double fee;

  Delivery({required this.canDeliver, required this.fee});
}

class Product {
  final String name;
  final double initialPrice;
  final double? promoPrice;
  final String imageUrl;
  final int quantity;

  Product(
      {required this.name,
      required this.initialPrice,
      this.promoPrice,
      required this.imageUrl,
      required this.quantity});
}

class HomeScreenTopic extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback callback;
  final String? imageUrl;
  const HomeScreenTopic({
    super.key,
    this.imageUrl,
    this.subtitle,
    required this.callback,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.horizontalPaddingSmall, vertical: 5),
      onTap: callback,
      leading: imageUrl != null
          ? Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.neutral200)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  imageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.fill,
                ),
              ),
            )
          : null,
      title: AppText(
        text: title,
        size: AppSizes.heading6,
        weight: FontWeight.w600,
      ),
      subtitle: subtitle == null
          ? null
          : AppText(
              text: subtitle!,
            ),
      trailing: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(50)),
          child: const Icon(Icons.arrow_forward)),
    );
  }
}

class FoodCategory {
  final String name;
  final String image;

  FoodCategory(this.name, this.image);
}
