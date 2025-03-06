import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:location/location.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/favourite/favourite_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/grocery_store/screens/grocery_store_screens.dart';
import 'package:uber_eats_clone/presentation/features/home/screens/search_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/uber_one_screen2.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../app_functions.dart';
import '../../../hive_adapters/geopoint/geopoint_adapter.dart';
import '../../../models/advert/advert_model.dart';
import '../../../models/offer/offer_model.dart';
import '../../../models/store/store_model.dart';
import '../../constants/asset_names.dart';
import '../../constants/other_constants.dart';
import '../../constants/weblinks.dart';
import '../../services/sign_in_view_model.dart';
import '../stores_list/stores_list_screen.dart';
import '../product/product_screen.dart';
import '../promotion/promo_screen.dart';
import '../store/store_screen.dart';
import '../webview/webview_screen.dart';
import 'map/map_screen.dart';

Map<String, Product> products = {};
List<Store> stores = [];

// List<Store> stores = [
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     name: "McDonald's",
//     isUberOneShop: true,
//     doesPickup: false,
//     isGroupFriendly: true,
//     location: Location(
//         countryOfOrigin: 'Ghanaian',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$',
//     type: 'Fast Food',
//     productCategories: [
//       // ProductCategory(name: 'Homestyle Breakfasts', products: [])
//     ],
//     cardImage:
//         'https://www.foodandwine.com/thmb/8N5jLutuTK4TDzpDkhMfdaHLZxI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/McDonalds-Hacks-Menu-FT-1-BLOG0122-4ac9d62f6c9143be8da3d0a8553348b0.jpg',
//     logo:
//         'https://e7.pngegg.com/pngimages/676/74/png-clipart-fast-food-mcdonald-s-logo-golden-arches-restaurant-mcdonalds-mcdonald-s-logo-miscellaneous-food.png',
//     delivery: Delivery(
//       canDeliver: true,
//       fee: 0,
//       estimatedDeliveryTime: '15-30',
//     ),
//     rating: Rating(averageRating: 4.6, ratings: 660),
//   ),
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     doesPickup: true,
//     isGroupFriendly: true,
//     location: Location(
//         countryOfOrigin: 'American',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$\$',
//     type: 'Cafe',
//     name: "Jack in the Box",
//     productCategories: [],
//     cardImage:
//         'https://media-cdn.tripadvisor.com/media/photo-s/08/c1/9b/d5/jack-in-the-box.jpg',
//     logo:
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHDNjPca07Vm7i0F4kk8zcFDQX0O4o8wv4Kg&s',
//     delivery:
//         Delivery(canDeliver: false, fee: 0, estimatedDeliveryTime: '10-25'),
//     rating: Rating(averageRating: 4.4, ratings: 9654),
//   ),
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     doesPickup: false,
//     name: "Starbucks",
//     isGroupFriendly: true,
//     location: Location(
//         countryOfOrigin: 'Ghanaian',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$',
//     type: 'Cafe',
//     productCategories: [],
//     cardImage:
//         'https://media-cldnry.s-nbcnews.com/image/upload/t_fit-1240w,f_auto,q_auto:best/newscms/2020_41/1617109/starbucks-te-main2-201007.jpg',
//     logo:
//         'https://redprinting.com/cdn/shop/articles/starbucks-logo-vector-and-png-redprinting-com.jpg?v=1713379657&width=1100',
//     delivery:
//         Delivery(canDeliver: true, fee: 3.99, estimatedDeliveryTime: '10-20'),
//     rating: Rating(averageRating: 4.2, ratings: 2547),
//   ),
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     doesPickup: true,
//     name: "Wendy's",
//     productCategories: [],
//     isGroupFriendly: false,
//     location: Location(
//         countryOfOrigin: 'American',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$\$',
//     type: 'Fast Food',
//     cardImage: 'https://utc.imgix.net/uploads/Wendys_ServiceImage_02.jpg',
//     logo:
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUN0gOq_cRelnSsHcv_Aiq95sPwUYnooIeTQ&s',
//     delivery:
//         Delivery(canDeliver: true, fee: 5.49, estimatedDeliveryTime: '20-35'),
//     rating: Rating(averageRating: 3.9, ratings: 2356),
//   ),
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     doesPickup: false,
//     isGroupFriendly: true,
//     location: Location(
//         countryOfOrigin: 'Ghanaian',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$\$\$',
//     type: 'Fast Food',
//     productCategories: [],
//     cardImage:
//         'https://img.cdn4dd.com/cdn-cgi/image/fit=contain,width=1200,height=672,format=auto/https://doordash-static.s3.amazonaws.com/media/store/header/fb9e5a96-94b0-4406-9746-a0f8a7387bf7.jpg',
//     name: "The Posh Bagel",
//     logo:
//         'https://img.cdn4dd.com/cdn-cgi/image/fit=contain,width=1200,height=672,format=auto/https://doordash-static.s3.amazonaws.com/media/restaurant/cover/Posh-Bagel.png',
//     delivery:
//         Delivery(canDeliver: false, fee: 0.49, estimatedDeliveryTime: '15-20'),
//     rating: Rating(averageRating: 3.8, ratings: 52),
//   ),
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     doesPickup: false,
//     isGroupFriendly: false,
//     location: Location(
//         countryOfOrigin: 'Ivorian',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$\$\$\$',
//     type: 'Restaurant',
//     productCategories: [],
//     cardImage:
//         'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
//     name: "Joe & The Juice",
//     logo: 'https://gulffranchise.com/franchise-images/joe-juice-fl.png',
//     delivery:
//         Delivery(canDeliver: true, fee: 0.99, estimatedDeliveryTime: '10-15'),
//     rating: Rating(averageRating: 3.7, ratings: 32),
//   ),
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     doesPickup: true,
//     isGroupFriendly: false,
//     location: Location(
//         countryOfOrigin: 'Ghanaian',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$\$\$\$',
//     type: 'Grocery, Alcohol, Pharmacy, Box Catering',
//     productCategories: [
//       ProductCategory(
//           name: 'Pancakes', productsAndQuantities: [], products: []),
//       ProductCategory(name: 'Syrups', products: [], productsAndQuantities: []),
//       ProductCategory(name: 'Fruit', products: [], productsAndQuantities: []),
//     ],
//     cardImage:
//         'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
//     name: "Safeway",
//     aisles: [
//       Aisle(
//         name: 'Breakfast',
//         productCategories: [
//           ProductCategory(name: 'Pancakes', productsAndQuantities: [
//             {
//               'name': 'Signature Select Grade a Pure Maple Syrup',
//               'id': '123887',
//               'quantity': 6
//             },
//             {
//               'name': 'Signature Select Grade a Pure Maple Syrup',
//               'id': '123887',
//               'quantity': 6
//             }
//           ], products: []),
//           ProductCategory(name: 'Syrups', productsAndQuantities: [
//             {
//               'name': 'Signature Select Grade a Pure Maple Syrup',
//               'id': '123887',
//               'quantity': 6
//             }
//           ], products: []),
//           ProductCategory(
//               productsAndQuantities: [], name: 'Fruit', products: []),
//         ],
//       ),
//       Aisle(name: 'Canned Products', productCategories: []),
//       Aisle(
//         name: 'International Food',
//         productCategories: [],
//       ),
//       Aisle(name: 'Other', productCategories: []),
//       Aisle(name: 'Flowers & Plants', productCategories: []),
//       Aisle(name: 'Pets', productCategories: []),
//       Aisle(name: 'Meat', productCategories: [])
//     ],
//     logo:
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhZy8UOQW_ONW303-Cd1_39k8db8JVhfKlHA&s',
//     delivery:
//         Delivery(canDeliver: true, fee: 0.99, estimatedDeliveryTime: '10-15'),
//     rating: Rating(averageRating: 3.7, ratings: 32),
//   ),
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     doesPickup: true,
//     productCategories: [
//       ProductCategory(name: 'Beer', products: [], productsAndQuantities: [
//         {
//           'id': '33213434465',
//           'name': 'Corona Extra Mexican Lager Beer(12 pack)',
//           'quantity': 7
//         }
//       ])
//     ],
//     isGroupFriendly: true,
//     location: Location(
//         countryOfOrigin: 'Ghanaian',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$',
//     type: 'Alcohol',
//     cardImage:
//         'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
//     name: "7 Seven",
//     logo:
//         'https://cdn.prod.website-files.com/640ea4106aa3032db2a6cefb/6489566e8bfc72986607f1f2_6451a8cf783fe3e5bddce039_7-Eleven.png',
//     delivery:
//         Delivery(canDeliver: false, fee: 8.99, estimatedDeliveryTime: '10-15'),
//     rating: Rating(averageRating: 3.7, ratings: 660),
//   ),
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     doesPickup: true,
//     productCategories: [],
//     isGroupFriendly: true,
//     location: Location(
//         countryOfOrigin: 'Ghanaian',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$',
//     type: 'Fast Food',
//     cardImage:
//         'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
//     name: "Joe & The Juice",
//     logo: 'https://gulffranchise.com/franchise-images/joe-juice-fl.png',
//     delivery:
//         Delivery(canDeliver: false, fee: 7.97, estimatedDeliveryTime: '10-15'),
//     rating: Rating(averageRating: 3.7, ratings: 32),
//   ),
//   Store(
//     id: const Uuid().v4(),
//     openingTime: DateTime(2000, 1, 1, 8),
//     closingTime: DateTime(2000, 1, 1, 21, 30),
//     doesPickup: false,
//     productCategories: [],
//     isGroupFriendly: true,
//     location: Location(
//         countryOfOrigin: 'Ghanaian',
//         streetAddress: '1100 El Camino Real, MENLO PARK, CA 94025-4308'),
//     priceCategory: '\$',
//     type: 'Fast Food',
//     cardImage:
//         'https://www.belgravialdn.com/sites/belgravialdn.com/files/styles/aspect_ratio_4_3_1021w/public/2023/09/0211_joe_004-edited.jpg.webp?h=43753d63&itok=OZEobaI0',
//     name: "Joe & The Juice",
//     logo: 'https://gulffranchise.com/franchise-images/joe-juice-fl.png',
//     delivery:
//         Delivery(canDeliver: true, fee: 6.99, estimatedDeliveryTime: '10-15'),
//     rating: Rating(averageRating: 3.7, ratings: 660),
//   ),
// ];
List<FavouriteStore> favoriteStores = [];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final webViewcontroller = WebViewControllerPlus();

  List<FoodCategory> _foodCategories = [
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

  late List<Store> _nationalBrands;
  late List<Store> _hottestDeals;

  // bool _onSearchScreen = false;
  bool _onFilterScreen = false;

  // final FocusNode _focus = FocusNode();

  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPriceCategory;
  List<String> _selectedDietaryOptions = [];
  String? _selectedSort;
  final _scrollController = ScrollController();

  FoodCategory? _selectedFoodCategory;

  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _rotations;

  int? _previousFoodCategoryIndex;
  late List<Store> _popularNearYou;
  late List<Advert> _adverts;
  late GeoPoint storedUserLocation;

  int? _currentFoodCategoryIndex;

  late String _userPlaceDescription;

  late LocationData _currentLocation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));

    _animationControllers = List.generate(
        _foodCategories.length,
        (index) => AnimationController(
              vsync: this,
              duration: const Duration(
                  milliseconds: 300), // Adjust duration for speed
            ));

    _rotations = List.generate(
        _foodCategories.length,
        (index) => Tween<double>(begin: 0, end: 0.7).animate(
              // Adjust value for hop height
              CurvedAnimation(
                  parent: _animationControllers[index],
                  curve: Curves.easeInOut), // Smooth animation
            ));
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
    for (var animationController in _animationControllers) {
      animationController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // for (var category in _foodCategories) {
    //   FirebaseFirestore.instance
    //       .collection(FirestoreCollections.foodCategories)
    //       .add(category.toJson());
    // }
    // _getStoresAndProducts();

    DateTime dateTimeNow = DateTime.now();
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            actionsPadding:
                const EdgeInsets.only(right: AppSizes.horizontalPaddingSmall),
            automaticallyImplyLeading: false,
            expandedHeight: 115,
            floating: true,
            pinned: true,
            actions: [
              FutureBuilder<int>(
                  future: _getRedeemedPromosCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return TextButton(
                          style: TextButton.styleFrom(
                              fixedSize: const Size(10, 10),
                              backgroundColor: AppColors.neutral100,
                              shape: const CircleBorder()),
                          child: const Icon(
                            Icons.notifications_outlined,
                            size: 20,
                          ),
                          onPressed: () {});
                    } else if (snapshot.hasError) {
                      return TextButton(
                          style: TextButton.styleFrom(
                              fixedSize: const Size(10, 10),
                              backgroundColor: AppColors.neutral100,
                              shape: const CircleBorder()),
                          child: const Badge(
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              label: AppText(
                                text: '!',
                                size: AppSizes.bodySmallest,
                              ),
                              child: Icon(
                                Icons.notifications_outlined,
                                size: 20,
                              )),
                          onPressed: () {});
                    }
                    return TextButton(
                      style: TextButton.styleFrom(
                          fixedSize: const Size(10, 10),
                          backgroundColor: AppColors.neutral100,
                          shape: const CircleBorder()),
                      child: snapshot.data == 0
                          ? const Icon(
                              Icons.notifications_outlined,
                              size: 20,
                            )
                          : Badge(
                              label: AppText(
                                text: '${snapshot.data!}',
                                size: AppSizes.bodySmallest,
                              ),
                              backgroundColor: AppColors.primary2,
                              child: const Icon(
                                Icons.notifications_outlined,
                                size: 20,
                              )),
                      onPressed: () =>
                          navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const PromoScreen(),
                      )),
                    );
                  }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              titlePadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              title: InkWell(
                onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    userLocation: storedUserLocation,
                    stores: stores,
                  ),
                )),
                child: Ink(
                  child: const AppTextFormField(
                    constraintWidth: 40,
                    enabled: false,
                    hintText: 'Search Uber Eats',
                    radius: 50,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              background: FutureBuilder(
                  future: _getLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding:
                            EdgeInsets.all(AppSizes.horizontalPaddingSmall),
                        child: Skeletonizer(
                          enabled: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                text: 'bnbnmbkbkbj',
                                color: AppColors.neutral500,
                              ),
                              AppText(
                                  text: 'vjvjbhhnklnlklsljkslkjajlkaslkaasklf')
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      logger.d(snapshot.error.toString());
                      return Padding(
                        padding: const EdgeInsets.all(
                            AppSizes.horizontalPaddingSmall),
                        child: InkWell(
                          onTap: () {
                            setState(() {});
                          },
                          child: Ink(
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  text: 'Error',
                                  color: AppColors.neutral500,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding:
                          const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
                      child: InkWell(
                        onTap: () =>
                            navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const AddressesScreen(),
                        )),
                        child: Ink(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AppText(
                                text: 'Deliver now',
                                color: AppColors.neutral500,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText(
                                      text: _userPlaceDescription
                                          .split(',')
                                          .first),
                                  const Icon(Icons.keyboard_arrow_down)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(15),
              FutureBuilder(
                  future: _getFoodCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Skeletonizer(
                          enabled: true,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 75,
                                child: ListView.separated(
                                    itemCount: 5,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    separatorBuilder: (context, index) =>
                                        const Gap(15),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                              color: Colors.blue,
                                              width: 45,
                                              height: 45,
                                            ),
                                          ),
                                          const Gap(5),
                                          const AppText(text: 'helloworld'),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Skeletonizer(
                          enabled: true,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 90,
                                child: ListView.separated(
                                    itemCount: 5,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    separatorBuilder: (context, index) =>
                                        const Gap(15),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                                color: Colors.blue,
                                                width: 60,
                                                height: 60,
                                                child: const AppText(
                                                  text: '!',
                                                  size: AppSizes.body,
                                                )),
                                          ),
                                          const Gap(5),
                                          const AppText(text: 'helloworld'),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 75,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        separatorBuilder: (context, index) => const Gap(15),
                        itemCount: _foodCategories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final category = _foodCategories[index];
                          return InkWell(
                            // radius: 50,
                            onTap: () {
                              if (_selectedFoodCategory != category) {
                                _previousFoodCategoryIndex =
                                    _currentFoodCategoryIndex;
                                _currentFoodCategoryIndex = index;
                                _selectedFoodCategory = category;
                                _animationControllers[index].forward();
                                if (_previousFoodCategoryIndex != null) {
                                  _animationControllers[
                                          _previousFoodCategoryIndex!]
                                      .reverse();
                                }

                                setState(() {
                                  _selectedFilters = [];

                                  _onFilterScreen = true;
                                });
                              } else if (_selectedFoodCategory == category) {
                                _previousFoodCategoryIndex = null;
                                _currentFoodCategoryIndex = null;
                                _selectedFoodCategory = null;
                                _animationControllers[index].reverse();
                                setState(() {
                                  _selectedFilters = [];

                                  _onFilterScreen = false;
                                });
                              }
                            },
                            child: SizedBox(
                              height: 55,
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (_selectedFoodCategory == category)
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.amber.shade100),
                                          height: 55,
                                          width: 55,
                                        ),
                                      AnimatedBuilder(
                                        animation: _rotations[index],
                                        builder: (context, child) {
                                          return Transform.rotate(
                                              angle: _rotations[index].value,
                                              child: child);
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: category.image,
                                          height: 45,
                                          width: 45,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AppText(
                                    text: category.name,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
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
                    if (_selectedPriceCategory == null) {
                      return AppText(
                        text: item.label,
                      );
                    } else {
                      return AppText(text: _selectedPriceCategory!);
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
                  late String newFilter;

                  if (value.isEmpty) {
                    newFilter = _selectedFilters.first;
                  } else if (_selectedFilters.isNotEmpty) {
                    _selectedFilters.any(
                      (element) {
                        if (!value.contains(element)) {
                          newFilter = element;
                          return true;
                        }
                        return false;
                      },
                    );
                  } else if (value.length == 1) {
                    newFilter = value.first;
                  }
                  if (OtherConstants.filters.indexOf(newFilter) == 0) {
                    setState(() {
                      if (_selectedFilters.contains(newFilter)) {
                        _selectedFilters.remove(newFilter);
                      } else {
                        _selectedFilters.add(newFilter);
                        if (_onFilterScreen == false) {
                          _onFilterScreen = true;
                        }
                      }
                    });
                  } else if (OtherConstants.filters.indexOf(newFilter) == 1) {
                    setState(() {
                      if (_selectedFilters.contains(newFilter)) {
                        _selectedFilters.remove(newFilter);
                      } else {
                        _selectedFilters.add(newFilter);
                        if (_onFilterScreen == false) {
                          _onFilterScreen = true;
                        }
                      }
                    });
                  } else if (OtherConstants.filters.indexOf(newFilter) == 2) {
                    setState(() {
                      if (_selectedFilters.contains(newFilter)) {
                        _selectedFilters.remove(newFilter);
                      } else {
                        _selectedFilters.add(newFilter);
                        if (_onFilterScreen == false) {
                          _onFilterScreen = true;
                        }
                      }
                    });
                  } else if (OtherConstants.filters.indexOf(newFilter) == 3) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        late int temp;
                        // logger.d(_selectedDeliveryFeeIndex);
                        if (_selectedDeliveryFeeIndex == null) {
                          temp = 3;
                        } else {
                          temp = _selectedDeliveryFeeIndex!;
                        }
                        return StatefulBuilder(builder: (context, setState) {
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
                                    size: AppSizes.bodySmall,
                                    weight: FontWeight.w600,
                                  )),
                                  const Gap(10),
                                  const Divider(),
                                  const Gap(10),
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
                                          // logger.d(temp);
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

                                      setStateWithModal(value, newFilter);
                                    },
                                  ),
                                  Center(
                                    child: AppTextButton(
                                      size: AppSizes.bodySmall,
                                      text: 'Reset',
                                      callback: () {
                                        _selectedDeliveryFeeIndex = null;
                                        resetFilter(value, 3);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  } else if (OtherConstants.filters.indexOf(newFilter) == 4) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        late int temp;
                        // logger.d(_selectedRatingIndex);
                        if (_selectedRatingIndex == null) {
                          temp = 0;
                        } else {
                          temp = _selectedRatingIndex!;
                        }
                        return StatefulBuilder(builder: (context, setState) {
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
                                    size: AppSizes.bodySmall,
                                    weight: FontWeight.w600,
                                  )),
                                  const Gap(10),
                                  const Divider(),
                                  const Gap(10),
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
                                      max:
                                          OtherConstants.ratingsFilters.length -
                                              1,
                                      divisions:
                                          OtherConstants.ratingsFilters.length -
                                              1,
                                      value: temp.toDouble(),
                                      onChanged: (value) {
                                        setState(() {
                                          temp = value.toInt();
                                          // logger.d(temp);
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

                                      setStateWithModal(value, newFilter);
                                    },
                                  ),
                                  Center(
                                    child: AppTextButton(
                                      size: AppSizes.bodySmall,
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

                                        _selectedRatingIndex = null;
                                        resetFilter(value, 4);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  } else if (OtherConstants.filters.indexOf(newFilter) == 5) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        String? temp;
                        if (_selectedPriceCategory != null) {
                          temp = _selectedPriceCategory;
                        }

                        return StatefulBuilder(builder: (context, setState) {
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
                                    size: AppSizes.bodySmall,
                                    weight: FontWeight.w600,
                                  )),
                                  const Gap(5),
                                  const Divider(),
                                  const Gap(5),
                                  Center(
                                    child: ChipsChoice.single(
                                        choiceItems:
                                            C2Choice.listFrom<String, String>(
                                          source: OtherConstants.pricesFilters,
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
                                      if (temp != null) {
                                        _selectedPriceCategory = temp;

                                        setStateWithModal(value, newFilter);
                                      }
                                    },
                                  ),
                                  Center(
                                    child: AppTextButton(
                                      size: AppSizes.bodySmall,
                                      text: 'Reset',
                                      callback: () {
                                        _selectedPriceCategory = null;
                                        resetFilter(value, 5);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  } else if (OtherConstants.filters.indexOf(newFilter) == 6) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        List<String> temp = _selectedDietaryOptions;

                        return StatefulBuilder(builder: (context, setState) {
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
                                    size: AppSizes.bodySmall,
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
                                                      element == 'Gluten-free',
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
                                      if (temp.isNotEmpty) {
                                        _selectedDietaryOptions = temp;

                                        setStateWithModal(value, newFilter);
                                      }
                                    },
                                  ),
                                  Center(
                                    child: AppTextButton(
                                      size: AppSizes.bodySmall,
                                      text: 'Reset',
                                      callback: () {
                                        _selectedDietaryOptions = [];

                                        resetFilter(value, 6);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  } else if (OtherConstants.filters.indexOf(newFilter) == 7) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        var temp = _selectedSort;

                        return StatefulBuilder(builder: (context, setState) {
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
                                    size: AppSizes.bodySmall,
                                    weight: FontWeight.w600,
                                  )),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      final sortOption =
                                          OtherConstants.sortOptions[index];
                                      return RadioListTile<String>.adaptive(
                                        value: sortOption,
                                        title: AppText(text: sortOption),
                                        groupValue: temp,
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        onChanged: (value) {
                                          setState(() {
                                            temp = value;
                                          });
                                        },
                                      );
                                      // AppRadioListTile(
                                      //   groupValue: 'Sort',
                                      //   value: 'Recommended',
                                      // ),
                                      // AppRadioListTile(
                                      //   groupValue: 'Sort',
                                      //   value: 'Rating',
                                      // ),
                                      // AppRadioListTile(
                                      //   groupValue: 'Sort',
                                      //   value: 'Delivery time',
                                      // ),
                                    },
                                  ),
                                  const Gap(20),
                                  AppButton(
                                    text: 'Apply',
                                    callback: () {
                                      if (temp != null) {
                                        _selectedSort = temp;

                                        setStateWithModal(value, newFilter);
                                      }
                                    },
                                  ),
                                  Center(
                                    child: AppTextButton(
                                      size: AppSizes.bodySmall,
                                      text: 'Reset',
                                      callback: () {
                                        _selectedSort = null;
                                        resetFilter(value, 7);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
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
              _onFilterScreen
                  ? RefreshIndicator(
                      color: Colors.black,
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: FutureBuilder(
                          future: _getFilterdStores(
                              category: _selectedFoodCategory?.name,
                              selectedFilters: _selectedFilters),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                child: Skeletonizer(
                                  enabled: true,
                                  child: Column(
                                    children: [
                                      ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const Gap(20),
                                        itemCount: 6,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  // decoration: BoxDecoration(
                                                  //     borderRadius: BorderRadius.circular(10),
                                                  //     color: Colors.blue),
                                                  color: Colors.blue,
                                                  width: double.infinity,
                                                  height: 150,
                                                ),
                                              ),
                                              const Gap(15),
                                              const AppText(
                                                  text: 'klmalmlamkla'),
                                              const Gap(5),
                                              const AppText(
                                                  text:
                                                      'klmalmlamklakamlkm;ksasamklk'),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Gap(100),
                                  Image.asset(
                                    AssetNames.fallenIceCream,
                                    width: 180,
                                  ),
                                  const Gap(10),
                                  const AppText(
                                    text: 'Sorry, something went wrong.',
                                    weight: FontWeight.bold,
                                    size: AppSizes.body,
                                  ),
                                  // TODO: UNCOMMENT
                                  AppText(text: snapshot.error.toString())
                                ],
                              );
                            }
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                child: Column(
                                  children: [
                                    const Gap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          size: AppSizes.bodySmall,
                                          text:
                                              '${stores.length} ${stores.length == 1 ? 'result' : 'results'}',
                                          weight: FontWeight.w600,
                                        ),
                                        AppButton2(
                                          text: 'Reset',
                                          callback: () {
                                            setState(() {
                                              _selectedFoodCategory = null;
                                              _selectedFilters = [];
                                              _onFilterScreen = false;
                                              _selectedDeliveryFeeIndex = null;
                                              _selectedRatingIndex = null;
                                              _selectedPriceCategory = null;
                                              _selectedDietaryOptions = [];
                                              _selectedSort = null;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    (stores.isNotEmpty)
                                        ? Column(
                                            children: [
                                              const Gap(10),
                                              InkWell(
                                                onTap: () async {
                                                  await navigatorKey
                                                      .currentState!
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        MapScreen(
                                                      userLocation:
                                                          storedUserLocation,
                                                      filteredStores: stores,
                                                      selectedFilters:
                                                          _selectedFilters,
                                                    ),
                                                  ));
                                                },
                                                child: Ink(
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Image.asset(
                                                          AssetNames.map,
                                                          width:
                                                              double.infinity),
                                                      Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          child: const AppText(
                                                              text: 'View map'))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Gap(20),
                                              ListView.separated(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final store = stores[index];
                                                    final bool isClosed = dateTimeNow
                                                                .hour <
                                                            store.openingTime
                                                                .hour ||
                                                        (dateTimeNow.hour >=
                                                                store
                                                                    .closingTime
                                                                    .hour &&
                                                            dateTimeNow
                                                                    .minute >=
                                                                store
                                                                    .closingTime
                                                                    .minute);
                                                    return InkWell(
                                                      onTap: () {
                                                        navigatorKey
                                                            .currentState!
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) {
                                                            if (store.type
                                                                .toLowerCase()
                                                                .contains(
                                                                    'grocery')) {
                                                              return GroceryStoreMainScreen(
                                                                  store);
                                                            } else {
                                                              return StoreScreen(
                                                                  userLocation:
                                                                      storedUserLocation,
                                                                  store);
                                                            }
                                                          },
                                                        ));
                                                      },
                                                      child: Ink(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                children: [
                                                                  Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                            store.cardImage,
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            170,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                      if (store.offers !=
                                                                              null &&
                                                                          store
                                                                              .offers!
                                                                              .isNotEmpty)
                                                                        Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 8.0, top: 8.0),
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                color: Colors.green.shade900,
                                                                              ),
                                                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  AppText(color: Colors.white, size: AppSizes.bodySmallest, text: '${store.offers?.length == 1 ? store.offers?.first.title : '${store.offers?.length} Offers available'}'),
                                                                                ],
                                                                              ),
                                                                            ))
                                                                    ],
                                                                  ),
                                                                  isClosed
                                                                      ? Container(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.5),
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              170,
                                                                          child:
                                                                              const Column(
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
                                                                      : !store.delivery
                                                                              .canDeliver
                                                                          ? Container(
                                                                              color: Colors.black.withOpacity(0.5),
                                                                              width: double.infinity,
                                                                              height: 170,
                                                                              child: const Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  AppText(
                                                                                    text: 'Pick up',
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink(),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8.0,
                                                                        top:
                                                                            8.0),
                                                                    child: FavouriteButton(
                                                                        store:
                                                                            store),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            const Gap(5),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                AppText(
                                                                  text: store
                                                                      .name,
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .neutral200,
                                                                        borderRadius: BorderRadius.circular(
                                                                            20)),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            5,
                                                                        vertical:
                                                                            2),
                                                                    child: AppText(
                                                                        text: store
                                                                            .rating
                                                                            .averageRating
                                                                            .toString()))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Visibility(
                                                                    visible: store
                                                                        .isUberOneShop,
                                                                    child: Image
                                                                        .asset(
                                                                      AssetNames
                                                                          .uberOneSmall,
                                                                      height:
                                                                          10,
                                                                      color: AppColors
                                                                          .uberOneGold,
                                                                    )),
                                                                AppText(
                                                                  text: isClosed
                                                                      ? 'Closed • Available at ${AppFunctions.formatDate(store.openingTime.toString(), format: 'h:i A')}'
                                                                      : '\$${store.delivery.fee} Delivery Fee',
                                                                  color: AppColors
                                                                      .neutral500,
                                                                ),
                                                                AppText(
                                                                  text:
                                                                      ' • ${store.delivery.estimatedDeliveryTime} min',
                                                                  color: AppColors
                                                                      .neutral500,
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          const Gap(10),
                                                  itemCount: stores.length),
                                            ],
                                          )
                                        : const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                                // AppText(
                                                //   text: 'No matches',
                                                // )
                                              ])
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : FutureBuilder(
                      future: _getStoresAndProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Skeletonizer(
                              enabled: true,
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Gap(20),
                                itemCount: 4,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          // decoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.circular(10),
                                          //     color: Colors.blue),
                                          color: Colors.blue,
                                          width: double.infinity,
                                          height: 150,
                                        ),
                                      ),
                                      const Gap(15),
                                      const AppText(text: 'klmalmlamkla'),
                                      const Gap(5),
                                      const AppText(
                                          text: 'klmalmlamklakamlkm;ksasamklk'),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Gap(100),
                              Image.asset(
                                AssetNames.fallenIceCream,
                                width: 180,
                              ),
                              const Gap(10),
                              const AppText(
                                text: 'Sorry, something went wrong.',
                                weight: FontWeight.bold,
                                size: AppSizes.body,
                              ),
                              // TODO: UNCOMMENT
                              AppText(text: snapshot.error.toString())
                            ],
                          );
                        }
                        return RefreshIndicator(
                          displacement: 70,
                          onRefresh: () async {
                            await _getStoresAndProducts();
                            setState(() {});
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                HomeScreenTopic(
                                  title: 'Top 10 hottest this week',
                                  callback: () => navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => StoresListScreen(
                                        stores: _hottestDeals,
                                        screenTitle:
                                            'Top 10 hottest this week'),
                                  )),
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.separated(
                                    cacheExtent: 300,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    separatorBuilder: (context, index) =>
                                        const Gap(10),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      final store = _hottestDeals[index];
                                      final bool isClosed = dateTimeNow.hour <
                                              store.openingTime.hour ||
                                          (dateTimeNow.hour >=
                                                  store.closingTime.hour &&
                                              dateTimeNow.minute >=
                                                  store.closingTime.minute);
                                      return InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          navigatorKey.currentState!
                                              .push(MaterialPageRoute(
                                            builder: (context) {
                                              if (store.type
                                                  .toLowerCase()
                                                  .contains('grocery')) {
                                                return GroceryStoreMainScreen(
                                                    store);
                                              } else {
                                                return StoreScreen(
                                                  store,
                                                  userLocation:
                                                      storedUserLocation,
                                                );
                                              }
                                            },
                                          ));
                                        },
                                        child: Ink(
                                          // decoration: BoxDecoration(
                                          //   borderRadius: BorderRadius.circular(12),
                                          // ),
                                          child: SizedBox(
                                            width: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            store.cardImage,
                                                        width: 200,
                                                        height: 120,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      if (store.offers !=
                                                              null &&
                                                          store.offers!
                                                              .isNotEmpty)
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0,
                                                                    top: 8.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .green
                                                                    .shade900,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  AppText(
                                                                      color: Colors
                                                                          .white,
                                                                      size: AppSizes
                                                                          .bodySmallest,
                                                                      text:
                                                                          '${store.offers?.length == 1 ? store.offers?.first.title : '${store.offers?.length} Offers available'}'),
                                                                ],
                                                              ),
                                                            )),
                                                      isClosed
                                                          ? Container(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              width: 200,
                                                              height: 120,
                                                              child:
                                                                  const Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  AppText(
                                                                    text:
                                                                        'Closed',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : !store.delivery
                                                                  .canDeliver
                                                              ? Container(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  width: 200,
                                                                  height: 120,
                                                                  child:
                                                                      const Column(
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
                                                const Gap(5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AppText(
                                                      text: store.name,
                                                      weight: FontWeight.w600,
                                                    ),
                                                    FavouriteButton(
                                                      store: store,
                                                      color:
                                                          AppColors.neutral600,
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Visibility(
                                                        visible:
                                                            store.isUberOneShop,
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              AssetNames
                                                                  .uberOneSmall,
                                                              color: AppColors
                                                                  .uberOneGold,
                                                              height: 10,
                                                            ),
                                                            const Gap(3),
                                                          ],
                                                        )),
                                                    AppText(
                                                      text:
                                                          '\$${store.delivery.fee} Delivery Fee',
                                                      color: store.isUberOneShop
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 163, 133, 42)
                                                          : AppColors
                                                              .neutral500,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    AppText(
                                                      text:
                                                          '${store.rating.averageRating}',
                                                    ),
                                                    const Icon(
                                                      Icons.star,
                                                      size: 10,
                                                    ),
                                                    AppText(
                                                        color: AppColors
                                                            .neutral500,
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
                                    callback: () => navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              StoresListScreen(
                                                  stores: stores,
                                                  screenTitle:
                                                      'Stores near you'),
                                        )),
                                    title: 'Stores near you'),
                                SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    cacheExtent: 300,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    separatorBuilder: (context, index) =>
                                        const Gap(10),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: stores.length,
                                    itemBuilder: (context, index) {
                                      final store = stores[index];
                                      return InkWell(
                                        onTap: () {
                                          navigatorKey.currentState!
                                              .push(MaterialPageRoute(
                                            builder: (context) => StoreScreen(
                                              store,
                                              userLocation: storedUserLocation,
                                            ),
                                          ));
                                        },
                                        child: Ink(
                                          child: SizedBox(
                                            // width: 200,
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                          color: AppColors
                                                              .neutral200)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
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
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) => StoresListScreen(
                                            screenTitle: 'National Brands',
                                            stores: _nationalBrands),
                                      ));
                                    },
                                    title: 'National Brands'),
                                SizedBox(
                                  height: 200,
                                  child: ListView.separated(
                                    cacheExtent: 300,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    separatorBuilder: (context, index) =>
                                        const Gap(10),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _nationalBrands.length,
                                    itemBuilder: (context, index) {
                                      final nationalBrand =
                                          _nationalBrands[index];
                                      return SizedBox(
                                        width: 200,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: nationalBrand
                                                            .cardImage,
                                                        width: 200,
                                                        height: 120,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      if (nationalBrand
                                                                  .offers !=
                                                              null &&
                                                          nationalBrand.offers!
                                                              .isNotEmpty)
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0,
                                                                    top: 8.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .green
                                                                    .shade900,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  AppText(
                                                                      color: Colors
                                                                          .white,
                                                                      size: AppSizes
                                                                          .bodySmallest,
                                                                      text:
                                                                          '${nationalBrand.offers?.length == 1 ? nationalBrand.offers?.first.title : '${nationalBrand.offers?.length} Offers available'}'),
                                                                ],
                                                              ),
                                                            ))
                                                    ],
                                                  ),
                                                  (dateTimeNow.hour <
                                                              nationalBrand
                                                                  .openingTime
                                                                  .hour ||
                                                          (dateTimeNow.hour >=
                                                                  nationalBrand
                                                                      .closingTime
                                                                      .hour &&
                                                              dateTimeNow
                                                                      .minute >=
                                                                  nationalBrand
                                                                      .closingTime
                                                                      .minute))
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
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : !nationalBrand.delivery
                                                              .canDeliver
                                                          ? Container(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              width: 200,
                                                              height: 120,
                                                              child:
                                                                  const Column(
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
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0,
                                                              top: 8.0),
                                                      child: FavouriteButton(
                                                          store: nationalBrand))
                                                ],
                                              ),
                                            ),
                                            const Gap(5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: nationalBrand.name,
                                                  weight: FontWeight.w600,
                                                ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .neutral200,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5,
                                                        vertical: 2),
                                                    child: AppText(
                                                        text: nationalBrand
                                                            .rating
                                                            .averageRating
                                                            .toString()))
                                              ],
                                            ),
                                            AppText(
                                              text:
                                                  '\$${nationalBrand.delivery.fee} Delivery Fee',
                                              color:
                                                  nationalBrand.delivery.fee ==
                                                          0
                                                      ? const Color.fromARGB(
                                                          255, 163, 133, 42)
                                                      : AppColors.neutral500,
                                            ),
                                            AppText(
                                              text:
                                                  '${nationalBrand.delivery.estimatedDeliveryTime} min',
                                              color: AppColors.neutral500,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Gap(10),
                                SizedBox(
                                  height: 140,
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Container(
                                          width: 350,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            color: Colors.brown,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AppText(
                                                              color:
                                                                  Colors.white,
                                                              text:
                                                                  '\$0 Delivery Fee + up to 10% off with Uber One',
                                                              size: AppSizes
                                                                  .bodySmall,
                                                            ),
                                                          ]),
                                                      AppButton2(
                                                          text:
                                                              'Try free for 4 weeks',
                                                          callback: () {
                                                            navigatorKey
                                                                .currentState!
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const UberOneScreen2(),
                                                            ));
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
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
                                          width: 350,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AppText(
                                                              color:
                                                                  Colors.white,
                                                              text:
                                                                  'Use your promo and get there for less',
                                                              size: AppSizes
                                                                  .bodySmall,
                                                            ),
                                                            Gap(3),
                                                            AppText(
                                                              color:
                                                                  Colors.white,
                                                              text:
                                                                  'Save on your next ride',
                                                              size: AppSizes
                                                                  .bodySmallest,
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
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
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
                                HomeScreenTopic(
                                    callback: () => navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              StoresListScreen(
                                                  stores: _popularNearYou,
                                                  screenTitle:
                                                      'Popular near you'),
                                        )),
                                    title: 'Popular near you'),
                                SizedBox(
                                  height: 200,
                                  child: ListView.separated(
                                    cacheExtent: 300,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    separatorBuilder: (context, index) =>
                                        const Gap(10),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _popularNearYou.length,
                                    itemBuilder: (context, index) {
                                      final popularStore =
                                          _popularNearYou[index];
                                      return InkWell(
                                        onTap: () => navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            if (popularStore.type
                                                .toLowerCase()
                                                .contains('grocery')) {
                                              return GroceryStoreMainScreen(
                                                  popularStore);
                                            } else {
                                              return StoreScreen(
                                                popularStore,
                                                userLocation:
                                                    storedUserLocation,
                                              );
                                            }
                                          },
                                        )),
                                        child: Ink(
                                          child: SizedBox(
                                            width: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      Stack(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                                popularStore
                                                                    .cardImage,
                                                            width: 200,
                                                            height: 120,
                                                            fit: BoxFit.fill,
                                                          ),
                                                          if (popularStore
                                                                      .offers !=
                                                                  null &&
                                                              popularStore
                                                                  .offers!
                                                                  .isNotEmpty)
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        top:
                                                                            8.0),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .green
                                                                        .shade900,
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      AppText(
                                                                          color: Colors
                                                                              .white,
                                                                          size: AppSizes
                                                                              .bodySmallest,
                                                                          text:
                                                                              '${popularStore.offers?.length == 1 ? popularStore.offers?.first.title : '${popularStore.offers?.length} Offers available'}'),
                                                                    ],
                                                                  ),
                                                                ))
                                                        ],
                                                      ),
                                                      (dateTimeNow.hour <
                                                                  popularStore
                                                                      .openingTime
                                                                      .hour ||
                                                              (dateTimeNow.hour >=
                                                                      popularStore
                                                                          .closingTime
                                                                          .hour &&
                                                                  dateTimeNow
                                                                          .minute >=
                                                                      popularStore
                                                                          .closingTime
                                                                          .minute))
                                                          ? Container(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              width: 200,
                                                              height: 120,
                                                              child:
                                                                  const Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  AppText(
                                                                    text:
                                                                        'Closed',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : !popularStore
                                                                  .delivery
                                                                  .canDeliver
                                                              ? Container(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  width: 200,
                                                                  height: 120,
                                                                  child:
                                                                      const Column(
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
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0,
                                                                  top: 8.0),
                                                          child: FavouriteButton(
                                                              store:
                                                                  popularStore)),
                                                    ],
                                                  ),
                                                ),
                                                const Gap(5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AppText(
                                                      text: popularStore.name,
                                                      weight: FontWeight.w600,
                                                    ),
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .neutral200,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 2),
                                                        child: AppText(
                                                            text: popularStore
                                                                .rating
                                                                .averageRating
                                                                .toString()))
                                                  ],
                                                ),
                                                AppText(
                                                  text:
                                                      '\$${popularStore.delivery.fee} Delivery Fee',
                                                  color: popularStore
                                                              .delivery.fee ==
                                                          0
                                                      ? const Color.fromARGB(
                                                          255, 163, 133, 42)
                                                      : AppColors.neutral500,
                                                ),
                                                AppText(
                                                  text:
                                                      '${popularStore.delivery.estimatedDeliveryTime} min',
                                                  color: AppColors.neutral500,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _adverts.length,
                                    itemBuilder: (context, index) {
                                      final advert = _adverts[index];
                                      final store = stores.firstWhere(
                                        (element) =>
                                            element.id == advert.shopId,
                                      );

                                      return Column(
                                        children: [
                                          HomeScreenTopic(
                                              callback: () => navigatorKey
                                                      .currentState!
                                                      .push(MaterialPageRoute(
                                                    builder: (context) {
                                                      if (store.type
                                                          .toLowerCase()
                                                          .contains(
                                                              'grocery')) {
                                                        return GroceryStoreMainScreen(
                                                            store);
                                                      } else {
                                                        return StoreScreen(
                                                            userLocation:
                                                                storedUserLocation,
                                                            store);
                                                      }
                                                    },
                                                  )),
                                              title: advert.title,
                                              subtitle: 'From ${store.name}',
                                              imageUrl: store.logo),
                                          SizedBox(
                                            height: 200,
                                            child: ListView.separated(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                // TODO: find a way to do lazy loading and remove shrinkWrap
                                                // shrinkWrap: true,

                                                itemCount:
                                                    advert.products.length,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const Gap(15),
                                                itemBuilder: (context, index) {
                                                  final productReference =
                                                      advert.products[index];
                                                  return FutureBuilder<Product>(
                                                      future: AppFunctions
                                                          .loadProductReference(
                                                              productReference
                                                                  as DocumentReference),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              child: Container(
                                                                color:
                                                                    Colors.blue,
                                                                width: 110,
                                                                height: 200,
                                                              ));
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              child: Container(
                                                                color: AppColors
                                                                    .neutral100,
                                                                width: 110,
                                                                height: 200,
                                                                child: AppText(
                                                                  text: snapshot
                                                                      .error
                                                                      .toString(),
                                                                  size: AppSizes
                                                                      .bodySmallest,
                                                                ),
                                                              ));
                                                        }

                                                        return ProductGridTile(
                                                            product:
                                                                snapshot.data!,
                                                            store: store);
                                                      });
                                                }),
                                          ),
                                        ],
                                      );
                                    }),
                                HomeScreenTopic(
                                    callback: () => navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              StoresListScreen(
                                                  stores: stores,
                                                  screenTitle: 'All Stores'),
                                        )),
                                    title: 'All Stores'),
                                ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final store = stores[index];
                                      final bool isClosed = dateTimeNow.hour <
                                              store.openingTime.hour ||
                                          (dateTimeNow.hour >=
                                                  store.closingTime.hour &&
                                              dateTimeNow.minute >=
                                                  store.closingTime.minute);
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: store.cardImage,
                                                      width: double.infinity,
                                                      height: 170,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    if (store.offers != null &&
                                                        store
                                                            .offers!.isNotEmpty)
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  top: 8.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Colors
                                                                  .green
                                                                  .shade900,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        2),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                AppText(
                                                                    color: Colors
                                                                        .white,
                                                                    size: AppSizes
                                                                        .bodySmallest,
                                                                    text:
                                                                        '${store.offers?.length == 1 ? store.offers?.first.title : '${store.offers?.length} Offers available'}'),
                                                              ],
                                                            ),
                                                          ))
                                                  ],
                                                ),
                                                isClosed
                                                    ? Container(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        width: double.infinity,
                                                        height: 170,
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
                                                            width:
                                                                double.infinity,
                                                            height: 170,
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
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0,
                                                            top: 8.0),
                                                    child: FavouriteButton(
                                                        store: store))
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
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.neutral200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                                  child: AppText(
                                                      text: store
                                                          .rating.averageRating
                                                          .toString()))
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Visibility(
                                                  visible: store.isUberOneShop,
                                                  child: Image.asset(
                                                    AssetNames.uberOneSmall,
                                                    height: 10,
                                                    color:
                                                        AppColors.uberOneGold,
                                                  )),
                                              AppText(
                                                text: isClosed
                                                    ? 'Closed • Available at ${AppFunctions.formatDate(store.openingTime.toString(), format: 'h:i A')}'
                                                    : '\$${store.delivery.fee} Delivery Fee',
                                                color: store.isUberOneShop
                                                    ? const Color.fromARGB(
                                                        255, 163, 133, 42)
                                                    : AppColors.neutral500,
                                              ),
                                              AppText(
                                                text:
                                                    ' • ${store.delivery.estimatedDeliveryTime} min',
                                                color: AppColors.neutral500,
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Gap(10),
                                    itemCount: stores.length),
                                const Gap(20),
                                const Divider(),
                                const Gap(3),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
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
                                            text:
                                                'Learn more or change settings',
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                navigatorKey.currentState!
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewScreen(
                                                    controller:
                                                        webViewcontroller,
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
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }

  void resetFilter(
    List<String> value,
    int filterIndex,
  ) {
    navigatorKey.currentState!.pop();
    setState(() {
      List<String> temp = List<String>.from(value);

      temp.removeWhere(
        (element) => element == OtherConstants.filters[filterIndex],
      );

      _selectedFilters = temp;

      if (value.isEmpty) {
        _onFilterScreen = false;
      }
    });
  }

  void setStateWithModal(List<String> value, String newFilter) {
    navigatorKey.currentState!.pop();
    setState(() {
      if (!_selectedFilters.contains(newFilter)) {
        _selectedFilters.add(newFilter);
      }

      _onFilterScreen = true;
    });
  }

  Future<void> _getStoresAndProducts() async {
    //all stores
    final storesSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.stores)
        .get();
    stores = storesSnapshot.docs.map(
      (snapshot) {
        // logger.d(snapshot.data());
        return Store.fromJson(snapshot.data());
      },
    ).toList();

    //all products
    final productsSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.products)
        .get();
    products = {
      for (final doc in productsSnapshot.docs)
        doc.data()['id'] as String: Product.fromJson(doc.data())
    };

    //setting other lists
    _nationalBrands = stores
        .where(
          (element) => element.location.countryOfOrigin == 'Ghanaian',
        )
        .toList();
    _hottestDeals = List.from(stores);
    _hottestDeals.sort(
      (a, b) => b.rating.averageRating.compareTo(a.rating.averageRating),
    );
    // _hottestDeals = _hottestDeals.reversed.toList();

    final favoriteStoresSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.favoriteStores)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    favoriteStores = favoriteStoresSnapshot.data()!.entries.map(
      (snapshot) {
        return FavouriteStore.fromJson(snapshot.value);
      },
    ).toList();

    _popularNearYou = stores;
    _popularNearYou.sort(
      (a, b) => b.visits.compareTo(a.visits),
    );
    // _popularNearYou = _popularNearYou.reversed.toList();

    final advertsSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.adverts)
        .get();

    _adverts = advertsSnapshot.docs.map(
      (snapshot) {
        // logger.d(snapshot.data());
        return Advert.fromJson(snapshot.data());
      },
    ).toList();
  }

  Future<void> _getFilterdStores(
      {required String? category,
      required List<String> selectedFilters}) async {
    //all stores
    var storesList = <Store>[];
    final storesSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.stores)
        .get();

    var storesIterable = storesSnapshot.docs.map(
      (snapshot) {
        return Store.fromJson(snapshot.data());
      },
    );

    if (category != null) {
      storesIterable = storesIterable.where(
        (element) =>
            element.type.toLowerCase().contains(category.toLowerCase()),
      );
    }

    for (var filter in selectedFilters) {
      if (filter == 'Uber One') {
        storesIterable = storesIterable.where(
          (element) => element.isUberOneShop == true,
        );
      } else if (filter == 'Pickup') {
        storesIterable = storesIterable.where(
          (element) => element.doesPickup == true,
        );
      } else if (filter == 'Offers') {
        storesIterable = storesIterable.where(
          (element) => element.offers != null && element.offers!.isNotEmpty,
        );
      } else if (filter == 'Rating') {
        storesIterable = storesIterable.where(
          (element) {
            if (_selectedRatingIndex == 0) {
              return element.rating.averageRating > 3;
            } else if (_selectedRatingIndex == 1) {
              return element.rating.averageRating > 3.5;
            } else if (_selectedRatingIndex == 2) {
              return element.rating.averageRating > 4;
            } else if (_selectedRatingIndex == 3) {
              return element.rating.averageRating > 4.5;
            } else {
              return element.rating.averageRating == 5;
            }
          },
        );
      } else if (filter == 'Price') {
        storesIterable = storesIterable.where(
          (element) => element.priceCategory == _selectedPriceCategory,
        );
      } else if (filter == 'Dietary') {
        storesIterable = storesIterable.where(
          (element) => _selectedDietaryOptions.contains(element.dietary),
        );
      } else if (filter == 'Delivery fee' &&
          _selectedDeliveryFeeIndex !=
              OtherConstants.deliveryPriceFilters.length - 1) {
        storesIterable = storesIterable.where(
          (element) {
            return element.delivery.fee <
                int.parse(OtherConstants
                    .deliveryPriceFilters[_selectedDeliveryFeeIndex!]
                    .split('\$')
                    .last);
          },
        );
      } else if (filter == 'Sort') {
        storesList = storesIterable.toList();
        if (_selectedSort == 'Rating') {
          storesList.sort(
            (a, b) => b.rating.averageRating.compareTo(a.rating.averageRating),
          );
        } else if (_selectedSort == 'Delivery time') {
          storesList.sort(
            (a, b) =>
                int.parse(a.delivery.estimatedDeliveryTime.split('-').first)
                    .compareTo(int.parse(
                        b.delivery.estimatedDeliveryTime.split('-').first)),
          );
        }
      }
    }
    stores = storesList.isEmpty ? storesIterable.toList() : storesList;
  }

  Future<void> _getFoodCategories() async {
//  final snapshot = await FirebaseFirestore.instance.collection(FirestoreCollections.foodCategories).get();
//     Reference storageReference = FirebaseStorage.instance.ref(FirebaseStorageRefs.foodCategoryImages);
//     final listResult = await storageReference.listAll();
//     List<String> downloadUrls = [];
//     for (var item in listResult.items) {
//       downloadUrls.add(await item.getDownloadURL());
//     }

    final foodCategoriesSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.foodCategories)
        .get();
    _foodCategories = foodCategoriesSnapshot.docs.map(
      (snapshot) {
        return FoodCategory.fromJson(snapshot.data());
      },
    ).toList();
  }

  Future<int> _getRedeemedPromosCount() async {
    Map<dynamic, dynamic>? userInfo =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    if (userInfo == null) {
      final userInfoSnapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userInfo = userInfoSnapshot.data();
      var userInfoForHiveBox = userInfo!;
      userInfoForHiveBox['latlng'] = HiveGeoPoint(
          latitude: userInfo['latlng'].latitude,
          longitude: userInfo['latlng'].longitude);

      await Hive.box(AppBoxes.appState)
          .put(BoxKeys.userInfo, userInfoForHiveBox);
    }
    return userInfo['redeemedPromos'].length;
  }

  Future<void> _getLocation() async {
    Map<dynamic, dynamic>? userInfo =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    if (userInfo == null) {
      final userInfoSnapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userInfo = userInfoSnapshot.data();

      var userInfoForHiveBox = userInfo!;
      userInfoForHiveBox['latlng'] = HiveGeoPoint(
          latitude: userInfo['latlng'].latitude,
          longitude: userInfo['latlng'].longitude);

      await Hive.box(AppBoxes.appState)
          .put(BoxKeys.userInfo, userInfoForHiveBox);
    }
    storedUserLocation =
        GeoPoint(userInfo['latlng'].latitude, userInfo['latlng'].longitude);
    _userPlaceDescription = userInfo['placeDescription'];
    final location = Location();
    _currentLocation = await location.getLocation();
  }
}

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    super.key,
    required this.store,
    this.color = Colors.white,
  });

  final Store store;
  final Color color;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    bool isFavourite = favoriteStores.any(
      (element) => element.id == widget.store.id,
    );
    return InkWell(
      onTap: () async {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        if (isFavourite) {
          await FirebaseFirestore.instance
              .collection(FirestoreCollections.favoriteStores)
              .doc(userId)
              .update({widget.store.id: FieldValue.delete()}).then(
            (value) {
              favoriteStores.removeWhere(
                (element) => element.id == widget.store.id,
              );
            },
          );
        } else {
          var store = FavouriteStore(
              id: widget.store.id, dateFavorited: DateTime.now());
          await FirebaseFirestore.instance
              .collection(FirestoreCollections.favoriteStores)
              .doc(userId)
              .update({store.id: store.toJson()}).then(
            (value) => favoriteStores.add(store),
          );
        }
        setState(() {});
      },
      child: Ink(
        child: Icon(
          isFavourite ? Icons.favorite : Icons.favorite_outline,
          color: widget.color,
        ),
      ),
    );
  }
}

class ProductGridTile extends StatelessWidget {
  const ProductGridTile({
    super.key,
    required Product product,
    required Store store,
    VoidCallback? callback,
  })  : _product = product,
        _store = store,
        _callback = callback;

  final Product _product;
  final Store _store;
  final VoidCallback? _callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _callback ??
          () {
            navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => ProductScreen(
                product: _product,
                store: _store,
              ),
            ));
          },
      child: Ink(
        child: SizedBox(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CachedNetworkImage(
                      imageUrl: _product.imageUrls.first,
                      width: 110,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0),
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
                                borderRadius: BorderRadius.circular(50)),
                            child: const Icon(
                              Icons.add,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Gap(5),
              AppText(
                text: _product.name,
                weight: FontWeight.w600,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Visibility(
                    visible: _product.promoPrice != null,
                    child: Row(
                      children: [
                        AppText(
                            text: '\$${_product.promoPrice}',
                            color: Colors.green),
                        const Gap(5),
                      ],
                    ),
                  ),
                  AppText(
                    text: "\$${_product.initialPrice}",
                    color: AppColors.neutral500,
                    decoration: _product.promoPrice != null
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllStoresResultDisplay extends StatelessWidget {
  const AllStoresResultDisplay({
    super.key,
    required this.timeOfDayNow,
    required this.storesWithNameOrProduct,
    required this.storedUserLocation,
  });

  final List<Store> storesWithNameOrProduct;
  final TimeOfDay timeOfDayNow;

  final GeoPoint storedUserLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: AppText(
            text:
                '${storesWithNameOrProduct.length} ${storesWithNameOrProduct.length == 1 ? 'result' : 'results'}',
            size: AppSizes.bodySmall,
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
                final store = storesWithNameOrProduct[index];
                final isClosed = timeOfDayNow.hour < store.openingTime.hour ||
                    (timeOfDayNow.hour >= store.closingTime.hour &&
                        timeOfDayNow.minute >= store.closingTime.minute);
                return InkWell(
                  onTap: () async {
                    await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) {
                        if (store.type.toLowerCase().contains('grocery')) {
                          return GroceryStoreMainScreen(store);
                        } else {
                          return StoreScreen(
                            store,
                            userLocation: storedUserLocation,
                          );
                        }
                      },
                    ));
                  },
                  child: Ink(
                    child: Column(
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
                                height: 180,
                                fit: BoxFit.fill,
                              ),
                              isClosed
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
                                  padding: const EdgeInsets.only(
                                      right: 8.0, top: 8.0),
                                  child: FavouriteButton(store: store))
                            ],
                          ),
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: store.name,
                              size: AppSizes.bodySmall,
                              weight: FontWeight.bold,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: AppColors.neutral200,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: AppText(
                                    text:
                                        store.rating.averageRating.toString()))
                          ],
                        ),
                        Row(
                          children: [
                            Visibility(
                                visible: store.isUberOneShop,
                                child: Image.asset(
                                  AssetNames.uberOneSmall,
                                  height: 10,
                                  color: AppColors.uberOneGold,
                                )),
                            AppText(
                                text: '\$${store.delivery.fee} Delivery Fee',
                                color: store.isUberOneShop
                                    ? const Color.fromARGB(255, 163, 133, 42)
                                    : AppColors.neutral500),
                            AppText(
                              text:
                                  ' • ${store.delivery.estimatedDeliveryTime} min',
                              color: AppColors.neutral500,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Gap(20),
              itemCount: storesWithNameOrProduct.length),
        ),
      ],
    );
  }
}

class SearchResultDisplay extends StatelessWidget {
  const SearchResultDisplay({
    super.key,
    required this.storesWithProduct,
    required this.showProducts,
    required this.query,
    required this.storedUserLocation,
  });

  final List<Store> storesWithProduct;
  final String query;
  final bool showProducts;
  final GeoPoint storedUserLocation;

  @override
  Widget build(BuildContext context) {
    List<Offer> offers = [];
    List<DocumentReference> matchingProducts = [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: AppText(
            text:
                '${storesWithProduct.length} ${storesWithProduct.length == 1 ? 'result' : 'results'}',
            size: AppSizes.bodySmall,
          ),
        ),
        const Divider(
          indent: 5,
          endIndent: 5,
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: storesWithProduct.length,
            itemBuilder: (context, index) {
              final store = storesWithProduct[index];
              if (store.type.toLowerCase().contains('grocery')) {
                for (var aisle in store.aisles!) {
                  for (var productCategory in aisle.productCategories) {
                    for (var productAndQuantity
                        in productCategory.productsAndQuantities) {
                      if (productAndQuantity['name']
                          .toLowerCase()
                          .contains(query)) {
                        if (productAndQuantity['product'] != null) {
                          matchingProducts.add(productAndQuantity['product']);
                        }
                      }
                    }
                  }
                }
              } else {
                for (var productCategory in store.productCategories!) {
                  for (var productAndQuantity
                      in productCategory.productsAndQuantities) {
                    if (productAndQuantity['name']
                        .toLowerCase()
                        .contains(query)) {
                      if (productAndQuantity['product'] != null) {
                        matchingProducts.add(productAndQuantity['product']);
                      }
                    }
                  }
                }
              }
              // logger.d(matchingProducts);
              return InkWell(
                onTap: () {
                  navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) {
                      if (store.type.toLowerCase().contains('grocery')) {
                        return GroceryStoreMainScreen(store);
                      } else {
                        return StoreScreen(
                          store,
                          userLocation: storedUserLocation,
                        );
                      }
                    },
                  ));
                },
                child: Ink(
                  child: Column(
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
                        title: AppText(
                          text: store.name,
                          size: AppSizes.bodySmall,
                          weight: FontWeight.bold,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Visibility(
                                    visible: store.isUberOneShop,
                                    child: Image.asset(
                                      AssetNames.uberOneSmall,
                                      height: 10,
                                      color: AppColors.uberOneGold,
                                    )),
                                AppText(
                                    text:
                                        '\$${store.delivery.fee} Delivery Fee',
                                    color: store.isUberOneShop
                                        ? const Color.fromARGB(
                                            255, 163, 133, 42)
                                        : AppColors.neutral500),
                                AppText(
                                  text:
                                      ' • ${store.delivery.estimatedDeliveryTime} min',
                                  color: AppColors.neutral500,
                                ),
                              ],
                            ),
                            const AppText(
                              text: 'Offers available',
                              color: AppColors.primary2,
                            )
                          ],
                        ),
                      ),
                      const Gap(10),
                      if (showProducts)
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                            cacheExtent: 300,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            separatorBuilder: (context, index) => const Gap(10),
                            scrollDirection: Axis.horizontal,
                            itemCount: matchingProducts.length <= 10
                                ? matchingProducts.length
                                : 11,
                            itemBuilder: (context, index) {
                              final productReference = matchingProducts[index];
                              if (index == 11) {
                                return AppButton2(
                                  text: 'View Store',
                                  // isSecondary: true,
                                  callback: () {
                                    navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        if (store.type
                                            .toLowerCase()
                                            .contains('grocery')) {
                                          return GroceryStoreMainScreen(store);
                                        } else {
                                          return StoreScreen(
                                            store,
                                            userLocation: storedUserLocation,
                                          );
                                        }
                                      },
                                    ));
                                  },
                                );
                              }

                              return SizedBox(
                                width: 100,
                                child: FutureBuilder<Product>(
                                    future: AppFunctions.loadProductReference(
                                        productReference),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Skeletonizer(
                                            enabled: true,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                color: Colors.blue,
                                                width: 100,
                                                height: 140,
                                              ),
                                            ));
                                      } else if (snapshot.hasError) {
                                        return AppText(
                                            text: snapshot.error.toString());
                                      }
                                      final product = snapshot.data!;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      product.imageUrls.first,
                                                  width: 100,
                                                  height: 120,
                                                  fit: BoxFit.fill,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0, top: 8.0),
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
                                                                offset: Offset(
                                                                    2, 2),
                                                              )
                                                            ],
                                                            color: Colors.white,
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
                                          ),
                                          const Gap(5),
                                          Row(
                                            children: [
                                              Visibility(
                                                visible:
                                                    product.promoPrice != null,
                                                child: Row(
                                                  children: [
                                                    AppText(
                                                        text:
                                                            '\$${product.initialPrice}',
                                                        color: Colors.green),
                                                    const Gap(5),
                                                  ],
                                                ),
                                              ),
                                              AppText(
                                                text: product.initialPrice
                                                    .toString(),
                                                decoration:
                                                    product.promoPrice != null
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                              )
                                            ],
                                          ),
                                          AppText(
                                            text: product.name,
                                            weight: FontWeight.w600,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Builder(builder: (context) {
                                            late Offer matchingOffer;
                                            return (offers.any(
                                              (element) {
                                                matchingOffer = element;
                                                return element.product.id ==
                                                        product.id &&
                                                    element.store.id ==
                                                        store.id;
                                              },
                                            ))
                                                ? AppText(
                                                    text: matchingOffer.title,
                                                    color:
                                                        Colors.green.shade900,
                                                    size: AppSizes.bodySmallest,
                                                  )
                                                : const SizedBox.shrink();
                                          }),
                                        ],
                                      );
                                    }),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class NoSearchResult extends StatelessWidget {
  const NoSearchResult(
    TabController tabController, {
    super.key,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(150),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetNames.didntFindMatch,
              width: 200,
            ),
            const AppText(
              text: "We didn't find a match",
              size: AppSizes.body,
              weight: FontWeight.w600,
            ),
            const AppText(
              text: "Try searching for something else",
              color: AppColors.neutral500,
              size: AppSizes.bodySmall,
            ),
            const Gap(10),
            if (_tabController.index != 0)
              AppButton(
                text: 'Search in all',
                callback: () => _tabController.animateTo(0),
                borderRadius: 50,
                width: 120,
                height: 40,
              ),
          ],
        )
      ],
    );
  }
}

class InitialSearchPage1 extends StatelessWidget {
  const InitialSearchPage1({
    super.key,
    required this.searchHistory,
    required this.foodCategories,
    required this.searchStoresWithCategory,
    required this.searchStoresWithOtherListTile,
  });

  final List<String> searchHistory;
  final List<FoodCategory> foodCategories;
  final Function(String) searchStoresWithCategory;
  final Function(String) searchStoresWithOtherListTile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (searchHistory.isNotEmpty)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10),
                  AppText(
                    text: 'Recent',
                    color: AppColors.neutral500,
                    size: AppSizes.bodySmall,
                  ),
                ],
              ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = searchHistory[index];
                return ListTile(
                  onTap: () {
                    searchStoresWithOtherListTile(item);
                  },
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 40,
                  leading: const Icon(
                    Icons.watch_later,
                    color: AppColors.neutral500,
                    size: 20,
                  ),
                  title: AppText(text: item),
                );
              },
              itemCount: searchHistory.length < 6 ? searchHistory.length : 6,
            ),
            const Gap(10),
            const AppText(
              text: 'Top categories',
              color: AppColors.neutral500,
              size: AppSizes.bodySmall,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final foodCategory = foodCategories[index];
                return ListTile(
                  onTap: () {
                    searchStoresWithCategory(foodCategory.name);
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
              itemCount: foodCategories.length,
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
    required this.searchHistory,
    required this.topSearches,
    required this.searchWithListTile,
  });

  final List<String> searchHistory;
  final List<String> topSearches;
  final Function(String) searchWithListTile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (searchHistory.isNotEmpty)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10),
                  AppText(
                    text: 'Recent',
                    color: AppColors.neutral500,
                    size: AppSizes.bodySmall,
                  ),
                ],
              ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = searchHistory[index];
                return ListTile(
                  onTap: () {
                    searchWithListTile(item);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.watch_later,
                    color: AppColors.neutral500,
                    size: 20,
                  ),
                  title: AppText(text: item),
                );
              },
              itemCount: searchHistory.length <= 6 ? searchHistory.length : 6,
            ),
            const Gap(10),
            const AppText(
              text: 'Top searches',
              color: AppColors.neutral500,
              size: AppSizes.bodySmall,
            ),
            const Gap(10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final topSearch = topSearches[index];
                return ListTile(
                  onTap: () {
                    searchWithListTile(topSearch);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.search,
                    color: AppColors.neutral500,
                    // size: 30,
                  ),
                  title: AppText(text: topSearch),
                );
              },
              itemCount: topSearches.length <= 6 ? topSearches.length : 6,
            ),
          ],
        ),
      ),
    );
  }
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
    return Column(
      children: [
        const Gap(10),
        const Divider(
          color: AppColors.neutral200,
        ),
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall, vertical: 5),
          leading: imageUrl != null
              ? Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.neutral200)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : null,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: callback,
                child: Ink(
                  child: AppText(
                    text: title,
                    size: AppSizes.heading6,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          subtitle: subtitle == null
              ? null
              : AppText(
                  text: subtitle!,
                  color: AppColors.neutral500,
                ),
          trailing: InkWell(
            onTap: callback,
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(50)),
                child: const Icon(Icons.arrow_forward)),
          ),
        ),
      ],
    );
  }
}
