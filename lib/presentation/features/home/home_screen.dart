import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:latlong2/latlong.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/hive_adapters/cart_item/cart_item_model.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/favourite/favourite_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/alcohol/alcohol_screen.dart';
import 'package:uber_eats_clone/presentation/features/home/screens/search_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';
import 'package:uber_eats_clone/presentation/features/some_kind_of_section/advert_screen.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';
import 'package:uber_eats_clone/state/user_location_providers.dart';
import '../../../app_functions.dart';
import '../../../models/advert/advert_model.dart';
import '../../../models/offer/offer_model.dart';
import '../../../models/store/store_model.dart';
import '../../constants/asset_names.dart';
import '../../constants/other_constants.dart';
import '../../services/sign_in_view_model.dart';
import '../main_screen/screens/main_screen.dart';
import '../stores_list/stores_list_screen.dart';
import '../product/product_screen.dart';
import '../promotion/promo_screen.dart';
import 'map/map_screen.dart';

Map<String, Product> products = {};

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
// List<FavouriteStore> favoriteStores = [];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late List<Advert> _homeScreenAdverts;

  List<FoodCategory> _foodCategories = [];

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
  // final _scrollController = ScrollController();

  List<AnimationController> _animationControllers = [];
  late List<Animation<double>> _rotations;

  late List<Store> _popularNearYou;

  FoodCategory? _selectedFoodCategory;
  // Define the scroll range and corresponding width range (as fractions of screen width)
  final double _fullWidthFraction = 1.0;
  final double _minWidthFraction = 0.8;
  final double _scrollThreshold = 350.0;

  late double _screenWidth;
  late final ValueNotifier<double> _searchFieldWidthNotifier;

  final _nestedScrollViewKey = GlobalKey<NestedScrollViewState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));
    _searchFieldWidthNotifier = ValueNotifier<double>(double.infinity);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nestedScrollViewKey.currentState!.outerController.addListener(() {
        if (_nestedScrollViewKey.currentState!.outerController.offset <= 0) {
          _searchFieldWidthNotifier.value = (_screenWidth * _fullWidthFraction);
        } else if (_nestedScrollViewKey.currentState!.outerController.offset >=
            _scrollThreshold) {
          _searchFieldWidthNotifier.value = _screenWidth * _minWidthFraction;
        } else {
          final double scrollRatio =
              _nestedScrollViewKey.currentState!.outerController.offset /
                  _scrollThreshold;
          _searchFieldWidthNotifier.value = (_screenWidth *
                  (_fullWidthFraction -
                      (scrollRatio *
                          (_fullWidthFraction - _minWidthFraction)))) -
              50;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _scrollController.dispose();
    for (var animationController in _animationControllers) {
      animationController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(userCurrentGeoLocationProvider);
    final storedGeoPoint = ref.watch(selectedLocationGeoPoint);
    _screenWidth = MediaQuery.sizeOf(context).width;
    // var addressDetails = const AddressDetails(
    //     instruction: "bring your own tip",
    //     apartment: "A1",
    //     latlng: GeoPoint(5.707472, 0.1633695),
    //     addressLabel: "Home",
    //     placeDescription: "Odoi Atesena Avenue, Adenta Municipality, Ghana",
    //     building: "Blk 22",
    //     dropoffOption: "Meet at my door");
    // var hiveaddress = addressDetails.toJson();
    // hiveaddress['latlng'] =
    //     HiveGeoPoint(latitude: 5.707472, longitude: -0.1633695);
    // Hive.box(AppBoxes.appState).put(BoxKeys.selectedLocation, hiveaddress);
    // List<Product> newProducts = [
    //   Product(
    //       name: 'Rose 50/50 Dozens - Each',
    //       id: const Uuid().v4(),
    //       initialPrice: 12.36,
    //       similarProducts: [],
    //       stores: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.stores)
    //             .doc('NazJMIA9yaUsLRjLxBGa')
    //       ],
    //       imageUrls: [
    //         "data:image/jpeg;base64,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"
    //       ]),
    //   Product(
    //       stores: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.stores)
    //             .doc('NazJMIA9yaUsLRjLxBGa')
    //       ],
    //       name: 'Pink Roses',
    //       id: const Uuid().v4(),
    //       initialPrice: 12.36,
    //       imageUrls: [
    //         'https://tb-static.uber.com/prod/image-proc/processed_images/cc5109f9bc35bd51eabd2a0db2aa6a9b/957777de4e8d7439bef56daddbfae227.jpeg'
    //       ]),
    //   Product(
    //       stores: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.stores)
    //             .doc('NazJMIA9yaUsLRjLxBGa')
    //       ],
    //       name: 'White Roses',
    //       id: const Uuid().v4(),
    //       initialPrice: 12.36,
    //       description:
    //           'ajjlaklasjklfjaklfjlskdjfklasjfkldjsaklfjaskldjfklsajklfasklfasklfjklklsklalkklaklajfklkakljklsajklasjlkfasklnfklansklnafsklfndnaknalnkflnaklnklfansnldanfklnadsklnaknklnaskfnl',
    //       imageUrls: [
    //         'https://safewayflowers.com/cdn/shop/files/E5435P_LOL_preset_mol-mx-tile-wide-sv-new.jpg?v=1740523151&width=1445'
    //       ]),
    //   Product(
    //       stores: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.stores)
    //             .doc('NazJMIA9yaUsLRjLxBGa')
    //       ],
    //       name: 'Multipet Lamb Chop Plush Dog Toy (1 toy)',
    //       id: const Uuid().v4(),
    //       initialPrice: 6.73,
    //       description:
    //           'hsajhjasjfkljlasjfklasjfljasddjfkajlfjasklfjklasdjfjadfsjkl',
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       stores: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.stores)
    //             .doc('NazJMIA9yaUsLRjLxBGa')
    //       ],
    //       name: 'Hartz Cat Toy, Mini Mice (5 ct)',
    //       id: const Uuid().v4(),
    //       description: 'lakjklfsjalkfklsanmfnsldnflsndfalnmsfadlmasfmlasflfsa',
    //       ingredients: 'klakslowoowonno',
    //       initialPrice: 1.69,
    //       imageUrls: [
    //         'https://s7d1.scene7.com/is/image/mcdonalds/DC_202112_0652_MediumDietCoke_Glass_1564x1564-1:product-header-mobile?wid=1313&hei=1313&dpr=off'
    //       ]),
    //   Product(
    //       stores: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.stores)
    //             .doc('NazJMIA9yaUsLRjLxBGa')
    //       ],
    //       name: 'Azzaro Chrome Eau De Toilette Vaporisateur Spray (1 fl oz)',
    //       id: const Uuid().v4(),
    //       initialPrice: 46.18,
    //       quantity: '1 fl oz',
    //       imageUrls: [
    //         'https://m.media-amazon.com/images/I/61f0nmLBvSL._SL1500_.jpg'
    //       ]),
    //   Product(
    //       name: 'Vince Camuto Amore Women\'s Gift Set',
    //       id: const Uuid().v4(),
    //       initialPrice: 21,
    //       calories: 120,
    //       imageUrls: [
    //         'https://m.media-amazon.com/images/I/81T81fV2caL._SL1500_.jpg',
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name:
    //           'Ariana Grande Cloud Body Mist Gift Set For Women, Female (11.4 fl oz, 2 ct)',
    //       id: const Uuid().v4(),
    //       initialPrice: 15.75,
    //       quantity: '11.4 fl oz',
    //       imageUrls: [
    //         'https://i5.walmartimages.com/seo/Ariana-Grande-Cloud-Body-Mist-Gift-Set-for-Women-2-Pieces_5358d3dd-91a1-435e-b936-7da873a74a84.1e2d4de1626dc80daa59f2538ea531dd.png?odnHeight=768&odnWidth=768&odnBg=FFFFFF'
    //       ]),
    //   Product(
    //       name: 'Ben & Jerry\'s Half Baked Ice Cream(chocolate & vanilla)',
    //       id: const Uuid().v4(),
    //       promoPrice: 5.86,
    //       description: 'hajhkajfljklajkjfjaldjklasljlakf',
    //       ingredients: 'ajlfkajlsjakjljladsjlkjaskljalsjklasdjdlkafsjslk',
    //       quantity: '1 pint',
    //       initialPrice: 7.86,
    //       imageUrls: [
    //         'https://target.scene7.com/is/image/Target/GUEST_a0b438f8-dd62-4faa-9eba-abbb2ad8474b',
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Talenti Mini Sorbetto Bar Alphonso Mango',
    //       id: const Uuid().v4(),
    //       initialPrice: 6.31,
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Ben & Jerry\'s Netflix and Chill\'d Ice Cream (16 oz)',
    //       id: const Uuid().v4(),
    //       initialPrice: 6.54,
    //       quantity: '16 oz',
    //       ingredients:
    //           'jaojkasjljasljfklsdjlajdsafsdlkanllna\n\najkafkljaljklsjakljklasaklf',
    //       description: 'jkajkasdjlajjlkafjklajkljaflkjfaljaf',
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Bakery Cake 1 Layer Black Forest Cream Split - Each',
    //       id: const Uuid().v4(),
    //       initialPrice: 15.73,
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Debi Lilly Perfect Fresh Flowers Gift Luxe',
    //       id: const Uuid().v4(),
    //       initialPrice: 17.98,
    //       quantity: '35 oz',
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Debi Lilly Bouquet Extending Smiles',
    //       id: const Uuid().v4(),
    //       initialPrice: 16.86,
    //       quantity: '34.9 oz',
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Debi Lilly Loving Supreme',
    //       id: const Uuid().v4(),
    //       initialPrice: 33.73,
    //       imageUrls: [
    //         'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMSEhUTEhEWFhUVFxcVFhgYGRcYFxkZGhceFiAXGRgYHSggGholGxkXITEhJyorLy4uGB8zODMtNygtLjcBCgoKDg0OGxAQGyslICUrKzctKzcvLzU1LTAtNS0vLy0tLS8tLS0yLS0uLS0tLS0tLS0tLS0tLS0tLS0tLy0tLf/AABEIAOEA4QMBIgACEQEDEQH/xAAbAAEAAgMBAQAAAAAAAAAAAAAABQYCAwQBB//EAD4QAAIBAwMDAwMCBAQEBAcAAAECEQADIQQSMQUiQQYTUTJhcSORFEKBoVLB0fAHM2KxgpLh8RUkNENTcqL/xAAZAQEAAwEBAAAAAAAAAAAAAAAAAgMEAQX/xAAqEQACAgEEAQMDBAMAAAAAAAAAAQIRAwQSITFBEyKBUWHRMnHh8BSRof/aAAwDAQACEQMRAD8A+40pSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKV4TQHtK1tdArT/GL8jz/aP9aA6qVpNyvBezAImJ/px/kaA30rV7hr33KA2UrWt5SSsiQASPIBmCR94P7GtlAKUpQClKUArWLy7tsifiubXazZjieCf8prjuaJjF61cySGIiQfkAzic/NUyy06jzQJmlarV5WJAOViR8TW2rU0+gKUpXQKUpQClKUApSlAKUpQCvCaxZ6rvqD1INOQqrvbIbMBe2R4MnjHxOfFcbSVs6k30WAvVc1/qy3bui2qM57gWwFUghQCTkycceKrV31delbjPsXOYAUQCSzA4jByeMVH3rTxct3uxtwK8lGUrhtx+CDkTn74qUk6ddlyw+GXXretd7Ba0WBZTAC7juWSQp/xCJgxMYNUb08XOoIOqd3wbtxjFu1khixbg5UKMHccjBiW9PdY9k+46s0LG0NgExubbwWhFE8gE/NcvXuovfAdA5RwbT9rQSl07LhMDBUyDAGWxmrKpl0U4+1L5Jz1Trhd0ijR3HcM21jaY7wrh1DychQ4GeAJOAJqrnrWp0Vi0XNwe7b3N725rioG2QxEe3I2ESCRMGTXvU+r/wALpytvY8/pypkYJJJC4kDHMndnia5+i9X/AI5Vt6m2Lk3Mq4JWdoO5gTiBuPI81CN/J2MJKPiiR0vrq+t/FtbmmLRvUhmgEJMgxJ28ECJ+RVu13qdUVSB3MpZUglmO5RC45AJnHJXNfPuo+pU0t8ldIoYj29wAXAMbdoG3tZVYGMFcc139Y9SNqLnT3DRbly0qQwYqtv6o2yCxxJPcCQIEm0uyM4K02iP1PqDXWb13qIuWmTcLVy2A4X21ubLasCJV4ctzK7jODtr6N6N9VWtfZ3odtxQPdtzJQmR/VTBIP75r527WbpZXsoSd9za4BUsWZiWeGUESBO0mBOeK5ehemtRaufxemv21uqxdLAnayE/8prh2iShiNgyfGCKZp43a6M2bDLE7XR9vFytgqM6RrxqLFq8FKi4ivtb6lJGVP3BkH7iuXqPqfTadvba8Gu8C1bm5dJ+NiSR/WKm2krZW2kThNazdBUlTPNRGm69vs+41prbFmHtv9UA8mMGVIOJGYnFaNfeS3bcozN7g3AL3EHxEcDB5qjJnUVaOkjvDWG3sGmVBx5wP+9cz6xCFsJwAJjyF8D8x+01waJ9yJvJW0gCi3tyzTyw4AmAB9pxXV6f6gLhIt2TbG5t6t9QYYPmORWVTcmldWkvq2DalrUPcjYluzAiCd5P3gcREVMosAD4rKoqzecXe5zEsIxH+x/nWvjH3zYJWlKVeBSlKAUpSgFKUoBXNq9RtUkVtdqhep6hS6bWyrNuESICkEHHHd/WBUMktqB3abWK4XOT4zVN9Z6Bv1Ltp5bL7dpJJVSxUbZmYxPkxUxeuwS0gRwynj+njiK47rF1NzaUYA7cyBnBIAE8AxxB5g1R/kNcHYycej5tqtTvUBkIO4W7iCQ0MwMANkE9wgjkZq3+sP/qVQXC9rUAtaKkmHXsdUZZAgpZMEEcgxzUOPRCIXZr7lv8AmSTEd0q3aMGGBIAMFcSJrHR9TFnTtY1Dksl0ajTs/dAYFHXcsk9rOQYydw+J0xan0aNybskbbWfYHuIuJVmACMzhoyRyx5J/PhqiX6mXB9wCBBGYH7f6VyX7zauyGVlt9zLtghSSsCPqYeCeQdpwM1u6T6Q1Ny6haQsTuLdmIjIaT5gR/rVm5PjwWbl8G/ql9yrtqLOy0zKDcBKuHMQWtqZwCBKjcvb521p1mrPTksvbC3LjxcR5/T7CQxUgjcRMHCgAxPgSPU/Q7h1cksqXLYQId2xGuJ7t1bbYD7FggB5AWATVG6/e1moKj+GNu2jBLakBbpMhAWQkQSWkwqiXzPNVTmyiWWS48F56N0y1rTpyGNoG3ySpBS2xsqAkkC4x3NksCUb6ts1t9d9GT3LDo4TT2LhtvPc7+2vuswJmVB/TiMNP2FQ/oXqWp0ygaiztUBBb37lIVA8KqcLHusSZUyRz4mvVxL9PFxCXZ7qWUII7dpLuboGd1y4HdtomBbJHbUFJSVMgpOVKXRV9Bq5KPtmS0tbMoIiJDS28nDBZ2yOJFWTUe8oA9hbgw6d0IGn+c5YZ+N2BiDioX/4Lq1tG48NtElVyYHweTx5An4qQt9X2WENz9PeJRG7WYDlo5C/cxPj5qWSScdsujRkybo7bFjqPUv4SxpLbN795m96+zzsEkhN4kglYkifpIBOSJH096Ks6R1u3LxuXgSyx22xIKntMs5MkSf2Bqt6PqLhzqAYCOqsRyAw3BY/wfp8eP6mrFousW7zLgztGYMiCcBjg4I8AxzWPdd8GWGOLdssGq1vfbAVSFfI3ZB2Nn7rE4+dvjIz02mGpvMdxt2rSw3AO4nfBnGJnzkVWPUWpuyjW7cMGUqRgsYKK3wSN/B8LFS3SNWyhEZWRFloJHc3+K62WJg/AzWZw3Spq0GrdFkfVabT7bZli5PJDSREk7cDn7Vt12s//AAKoYjLQJ+wH3/NR1+0pYmRkCFHM/MTnEftXlrWqFVSNjAsJMCQJaf6CZkf61epOF2kq/vZJRrss+j1O+3uOCBn81XtNcG7c5IMEnmPjMTPnx8102tQwtbP5mYk4jsB+D5Kx+/zAPFp9C92N43biS5mMAYUj+YY8+W8xUc2WUtqS5Ik30q/cck49oSFP+L7gfH3mpStGj0q212rxW+t2GLjBKXZwUpSrQKUpQCsHasmMVpoBUP1a4xMBSscN2mSeBAkgEgeMx9szFVnUN7rbnWD3KoyCVYxJAEgQp/8ALVOd8UcZy61nAkLPI5jaMgsfBIj6R98itQtqH7SVJG3dtEQCCMg5EG2JPG3EHNY9S1RSXCkhdsAATkgMZmFXaOSQAQfJFahfBzBIEfBVsCVBJ2rJIGOYgHAFYzhhd0twXnV2HsDZtCgbw5Jkb8RDbdpjd3gAjEUL1qwsXAsh1YEKOwESqsqwGLYDKQxAB8fzCvouqFu4BvzgOpnZMidyupkOJwynEgiDFfNeuaC3c6gto3SVN20hJJbbvvABQpJC7PcCgAcZMktOjFK2W43TLl6Q0QfTb7qBkdka0gJ/k3Df2kclmWD/AIB9qs3vWlADsltRgSURQBiBPgcVy9I0Q0+nW0CT7YcSeWM72aPEszGBxwKhdFqH1DRbfsG1mKtBCbVBGMsTcW6s/IMkwFq6z1MGFOLZYb2pCHaLswASCQSAcg/giq91jSpbvrdbhxJmCJBkP3HG0TxJgGOJo3Td9h7Rbc1u44svhWCwrcrEZY8RXfd07XdHbP8AOpYKW87WKgkj5CjNRfJLUYUofNEdpr5ZNzKVMAwwM8AweZM4GeAJySa6uhdUsxcu6i7K27bJbsbgASfqIVm2m6wCqCT5cCACTRtZ6r3FtOtplZvdS4GVDjaV+QDMn5HcTma4H11sgG421VIYwchZA3goJ4iD8zHFZU3HKmeRL9VH0rSao7DHBJ2tBggEQSD9Mj5g88VVvUvR1U6jVCLjFAy2zuYK4Enlt0BVkK09xGNvaLHcDXUUoxjsPiYBBg7lP8srHy2Rk15q9OPadLjQrKUMQMQVwQIHmIAj7kYtbcmSaIz0/wBBQ6drfvkrcIuK4WAVE7SUbMkNJByMDxXH7Sae+9q86D6TbYLgq0iNpmG/yrX6av3Qps2nWLcdzAk7SSFhQ0TB/t81LL0621wteTfJwWZl5MQdp2kRwDxH3NHCPTO0kbNHqv1CHyn/ANszJC+AY/75/NTQ0QumSxCxkAAlj9j4NRS9FO87WwYiR4ziRkgZ+/713aE+1c7lGxYAIac88RgTB88/euNcU/qTo6ut21tgXLlyAe1ZBJmJiFwxx4FRHSrpu3WJLd2FJADgBhEKCwRQACZycmrDd1DAm6VTain2+6WkxwCsJORukn9qz6YgVQ7Ioc4kCOzBwfjP9qoyx3S2X2QabPP4JrJI2tDjLhtzNg5kiJz8fFWDpStElSogQDyPsfv8n5P2rd00HYCYzPHxOK661YcKj7kQbFKUrSRFKUoBSlKAEVqZK20oDmdwokmAPJqE1IDXd4KnwfuoOM+OePvUn1UkAADBPcfgCoq5cHJ8fBrJqMngsjC+Tj6tpC6kIon8RjyPg/MH44NVXUagWGZ7rSZIA2kkTEEMYIIYEDnHBEVdbLTGceQ2YI8qeR4/9K+a+rLn67hzIA7RyCc5Pz+f8prOpKaVFkcScjfpuuo/0k4VUH0jaFInAGCdsf1+01Aes/cS6l6zbUNbCXA6q0757Q8f9Pt4yAGGYwOfSTvIHdnxJzzgfhaluuaD3LARSSxUi2AIkENncFMHfPaMABSIFS27Jd8HcuJRRd06hvKvbYFLgFy2wMjIBiR+P3rkKFTNu1c2GSfbZiJMz2DH7L/Wqp6a1Z02mW3fbaLbPuLZjc7XNxC5VYMbsQe08VcOmdSHtl7bW7q/y7WwRMYZZzOI/wC1XPLHuzXg1SST8mzTW4BZx7SldqKfqgmSxBzJiBPyfgV5a6gzM4tiQiIlpORuO6JGJwJJkYHiud21Nxz+naQeWJLER+VBJ/YV3aRkGnuPZuC4xDAXBBBcSuCMEBhEDEg+ZqxOzTOalw+2RDdO0hPt3XFwgxNxVMnyZ+ZkzXfb9Oaa2N9mzaLDI7RI/wD1nAP4qFHQ1RtRqGUXHtA7Qw3Km0hFCqQe6ACWgnBiC0jq0/WL6QbyowUFmCi6G24mA5YEiRgNuE5XyO9Celi3wRHrDU3NNp/d077ALilgAIO59xHjaDciY53N8k1UNf6lu6ptxcrnCqzARMgHPcfE/avqVrT29X/Eaa8siSjZgwwDrcU+JVlYGvkfWPTtzRahrVzIHcjgYuIeGHwfBHgg8iDUJx9tnlarG4Pjon/Tes9newAJIXHG6CT45b4J+T81ZLPqFTfFmAolgzFp4QnOB25SefqqA6L0K9eti5b4BYmTt3MFlV4wJnPzzUvb9HFLg33Q1rljA37iVwTBld0nJwBiNxIox7lTKcd0i09P6lZuJKYwJPDYxmPmAf611m25RkUKxLKO4naVLSwMZ4Bx54NYaPp6xtRVVRkKrCfyTzJP/apXpVkG4JmPjxV0bnJvyv8ATL/HI0/SjZXtUDcZ8fVAH9/FSPStFBLEYnH58/nipXaOIr0CKv8ATjdlLm6PaUpUyApSlAKUpQClKUApSlAcHVJIA3RJz/vzVb15IJgn8nx+firPrFiHCln4WJj+2KrnVF53SD5J5/tXn6zFvi0X4+qNegk2xugOwMjzJzx9sVAdb6EXUPdcEhoJwqi2zfJMjbu5JP0jiTEvp9SMyzTE8Cfjj6viqZ6j6w66kWbeQ7Btpkj3NjbS0QJ7Qdsx2KeYqjR4qgotU0SXtPbHSrTMyKrFV9wEwdm3ayll2GSJKkHH0nmQBt1Vlbatde8NrNksxMORLL2xLbVJ4X6Nu1u0Cn6X1FqrV5zkmGXuWAMgg7ZPBAxP28mseq9Tualtzsm4DFsMO2TMR/jJOfJ48CNU9LKcuP0kskJT/Y69X1hQFIB2s2xVAdobc8MMrlgLMCOYyPF80/pF7doIt5g31OqhdodoLAHE5kbjnmIqC9CemQ1337kutoqQMe2bo7lAHJKnuLGMhMZNX7T67uZmaEUxPy0xA/EgY5JgZBiT02OPBzHpuWVXWem3u6ZtPea4Nw2hiSIhv8KOEbiQCIrq9H6FtN082yO6w94MPkC810OPsUYHzzHIqzNrrVwECGwSV7leBzAYAmPt5rTZti2RctkvbuDiQScSIJIE55n5qWOCxqkzRjx7Hfk5G07d72YdLhLRIBDE74M4+r5jGK5L2nUmTau2xJJ3lABI2kJI3kmAZJIETBPPbZ6RLbtPdIU825KlftwSBzg/0Ndp6fasj3LqqPG5iOfABbz9qmrZteeC8/n55I7o2hVb93UbYFxURRmGKLtAUeFVFAnk5+AKo3/FnVrc1Om06CbltXLAfN4oEQDif05/8S19RV/caVGAIWePufnMDH28V8s/4j3kfVbbA337abNwXcwcE3CywJJWcEcGfiutWmedqXv/AAWnp9gpaULaFvEFRIBbI3CIIkCcxgqMVJ9LDbZeJj5x4Ey4mPGfCj8mK6Db1A2W7gslcs7S2wl0V0QNtw8tlQSIC5zFWW6WRdw2sxXhZK7gJKknLZ4gD4O2c5p+3tlO01/w8ESiyNqj4HnmADmeB8cVL9MvC2sEDie3MVC2Oo7pO7M5HaeBkSGjcATPxEfepaw8nmcgmfPmOeB8VPHkTVpkpR4J5GkA/Ne1rsXQwkVsrUjKKUpXQKUpQClKUApSlAKxZgASeBmsL2pRI3MBPEnmq3171FDG1a7jHIEyfIH4wT+alGLk6LcWKWR0jLWep1aRYP0zuJGeNwAXnInx4qudU6oe5syg3NCyPp3EmG+rPB+K0khFZdqLd2KJjcdnuDDL/i+gTJ+fkVHdZ04uKodgoGwMPpxBAlicszFST+3NWvFGUaaPUx6eCXRH6vroVWuLcWMhWDyxHx24A+TmoS1s9tb16Ge5JSMyJIER9RxMn5qz6zo9q+mztUBe04gbRgAyP/afE1zFEDgtaJchSvJMiJAtuoMbvuZEA81kdYpV5KJpQlRX9RodSw3W1aTHG0kScZYxJ/1+K19Y6ff02lX3bPu3t+HZ7V1dsn9MWmtFsKB3FoljExFSv8QGeUIUmFlSQu1MxtuBQm7bjbnxAJFabs6q4yhW7QwQqigT2/qjcUCBZkZ3ZDEHAMPVySW7pGecnLno+g+jLlv+CsFGlYe2xjb+oHMnaOASSR9mWnWJtBArbR3DeRItsWZ5MAwCGCgwYzUP6BtPp1vWiQwYi4igDBQBWDbcTDIPwo5q36zT7xKuQCPhWH7MD/aDipNp9OzRp5pPkr9rTn22K3fdUbSDM/qEx23InCg5xhj8iujS6llm2cj3kPHIdXkj47gHP3Zqz1Flz2G6zeAqWnH/APbHaPzmpa3oOJjcWDvHAGO0f+VR+FNV8s2ZMkEufP8AH7Ef1i9YU7Lxt7SpY7/pG3kkkbRHMz/maw6L03TMwex7LTjdbKNiYjcpOK0+qlRiVfaqr3MSYXuHLTjAHM/NfPLlkXXNvSFoRldGQsqNuBFxS6j6Y2EMDzvBxBrmO5NpmCOSdcMlvU/rzfut2muWLIOHUD3GA/mIYGF87PIweYHBqr7pqRfe6tm5aWDcCM6XgREC2CAJBYMpfE4OJqG1fR7dvat1LivglXbeNucxJQgkESPMxkVlY9T30u6fSrbQWfetqCqwLlo3VG1ZGB9QMSQSROK0qUeipzS7RcfRHVALhSyBshdouD21S4+4D21kgAWwDAOeO3zataZZj+m2oVWVG2wwUnsKjBa2QVJhuZ5PEfrkFxbtuzatlD7atuUFTLsVJ42gZB/IqZdFbe0vsf6W3b7ayNoAtv2gyzZHiBkVj1GL1Y0ibimR+i0x3KZU4AkAbsAoGknJKmcARs/FT+mH+I7fG2eB4HjMfvmuWyux1DFZOJVCoOwABYwRgj5+n7V2IWJMqMGBCnMmP28zPgVzBh2Ro4+ESuhfBEY8YiuyuW2kCK32zWyKpUZH2Z0pSpHBSlKAUpSgFQvWOoMrBbZXcMw3B85+MT+9TVc2tTtJVFLRiR/pmq8qbjw6BXdXq1Yb3KKwjeFfdA+YCnMD5jFRF2yoCiyoXG5oQBsgA4OBiP6DwM1YtB0e4GDO4Cx9AGfn6v5fyM1r67oTuBVSFUYIHao5YkhgfANdxepJq3Rp005OSi3SPnXULwsqxtFrt1t2wgkli0AFiPo/lwxBgQAfHnRmcKWuTcLyDJ3KqwPq3YYkyMeI+anb/p+O7cS5zGYE54J5GB+R9639M9JFju7QQqqTOVIAlVGYHma1ptyblwj1fVjblJ0jg1emuWrZuAurOAUWdyhvCFCx2kkjIx9xiY/qvQtU6pdc5ChbiyWldxLld08r3DIMoBGYqeGjuW7ie6sLuGWwYEcEnIkD8TWHWeoubj2CCDIFvaGJhv5oEnChs4+k5qmctvtRTL6Rar6nz3QOxdrattCv7fu/ULj7tqoU/lD/AHkD8xVs6Zb2A3GU2hmVEhVcMdw3EAtAB7yIIiAAKw6ZpvaY3nDW9xIaGuPbMlWNzYB2M6qsjMFFERipPV3FuWb/ALTjcqyGkRtBBIILTBAiY5Y/cVhgvUVviKMOODn30Qmqvdyug2uCGDqE3oAqyfJ2nHPOeRU90v1NeCBnRCp3dwlRKkTMqVByBGJgxioY6ffYQszK+4oQeJIEwGghgFC5/wAXgAVQPUqX7blQWVXZu0nvAECGjtzjKzxzHN3pbF7WW5NsI2kfa7fVLrNL+3atxMqC7EfIcwFH/hP5FQfVf+IKDdp9AN90Svu3NxthgpJAmWuuACTMDBkk4r57oL95dJ/D29SQLvKkMPbyshCZwQHkqf5gYnNSlroYt2pGDbBuIXDKQVKbnBIksodWgZGDyADW5OqRknl3Lg96tZvvuF1m7l7i53ECTuEHEtJU+IkAd1QHTOo3bd0rpx2kk7RMD8HmI+9WLWabUFCEtb1J9s7jE7WPcFZlgMYBjnfEbhmPsFbW0rYKOWXMwRukBjuEBTDdpAmCPmu6dw20+/JPBOK77O5766i2m+S1p9rBYYIHxuYGGWWUQO6fn5nuj9LOpL6Vv4Z30wlENsG5bVyGF0XZ3ggz2KsghCcEbqz03XFr5umzajcWVdkS5A7iQZ8fzBsnA4qU01/+H1dvVTsi4TtnJU7ibLTAYlSyqfnaPEjRKtpryaecobq+5os9du2tb7mpUFLln9JkKuu25tffIgMSy7WjggjO3N16J1ZdUqC2RtzutsQCpCeCcxMZ4znmo/qPXOmawMq2jauSzMj29nuys7g1uQHmMkgnIyax6P0O2xt2WthtO7QVbcSDBMhmkGCV4HmZFdUeOCtRlGFyTXwXfR6VsI0qwyN2Tjjxk4Hx5qQ02lIMucjiCY/aozoXpW1pGm3dvFQIW21xmtr+FJian6gomWc7FblFYW1rZUysUpSgFKUoBSlKAUpSgFeMs4Ne0oDjbptvnbn8n+1ZpbC4AA/AiumsHSu2yTk32yl+uQ5kJh9g2HEzJIIJBggz/uK59PYQhbx2ksgYzHkDjcJHJ/2KtnUenLejcSIkYjMxz+396qnWOjXEja5UD6Tlhj5M4Jz48+Ki1w0bsOSEoKD4K11q6xcAmMggCRDEliwOwcAMDO6N4+mZp6eX/wCZUOCNiq5JYsScGWPheIX/AKJySCO3VdNEQwBOCxYFi0Y+5wpMQefJFatDdtKz231DW2ABlbYZS7N7YFwqs7d7yR5ls4Nd2JQqi2aUV7Sf1W26sgDax2yZBgggg+Qwba0/aPBmhDp4u32H2GzMyoH07mMgL8EAmeMzUnb6o7MPdX/ljaSgKqXmWNwZU3JFxcETsxip20ttSXQAGG3EQwMkGZ3Rg+OPxtFZMuXjakYMuRSVUQej9JqWG8yGEp3DacxMieQQeRxzkVs1WmtW2Ab6WDblViysRcW5lR2gLI7ZE9sDtmp/fafb+pARxGxzt3yVAbbgkCBtYR2iZFc/WboKMIIJUgBhwBjBGDkCI5x9qy267M5XL1qWWxYtpBHuqoAMQSA0EEbQ0gkmTtIkA57V6f7h/WKsigTIWdk7tqtH3ifIxBrm6jppt3EX3YLhSAdv/SASJDLkCDAMCQa06vWNpLdq1ceLmNxH0lSZIX7Bt4JABIAwJiuSjcVt7NGPGpL7k117oxuXmvaNFubQAzjtTfBYzLEuxBRQB8jgVXdH1a7dueyf0xKhnBUiDBONsggETBJmRggxM9I16gTvwDvIViAScSAfEKP9cVlf6cNQHvt2wxdgsblI7gI292DwIJiARWmWaqXR6HqyhFQvj/pp1nS7LXt1hp2nchbsMTIQ74EASN3wZq4egrF1LTJesspBDbmEDdG0qs5MDhhiCB4qpaHWG3cAu2huA2MjAgYycc+QZ84r6P0PU23tgW5AUCVJJInIgkkleY+wjxFasc7XJbrsk/RUWrX1/v4JGvVWaKJraBFTPEAFe0pQClKUApSlAKUpQClKUApSlAKUpQHjLNabtqRBAI+/Fb6UBAa7pNtQXCnHImQB5Oc/38VSerW1W4SFgKdu6URQSQVbJnBUkRxmPv8AUilVH1D0Zzd3IpIczicHE48MSJnjHin3Numy81JnzwXIuf8AMYrBgqTuUkBsZHYGBYcECal+lBnHt3LYM7ZC42jEGZkSdp+Du+2Ml9HsLu9WZsmAATkROfJkx9iDVk0XQm07Exlp4PaZJ+2OcD4P5rPlScbZ3U+m1fkLaYFtzFixInbJIiMkY+fEcf1jtbYmdjQZO0k4iI44PPECIP1ZNTrkRviRzmeOIMTOJ+c/0NazZb3ACvMDIgjdBnk/7n5rDKNmCkUrVMq2im5wWOWWASAu3aI/IMxMgxxXvTul+4Sbq3DcdnFu60bVA4kT5OOMSOKmrvpS+2peF7JJVztIKlp8mSfHE4/ew2uglboG1fZhiSIBz/JHPnn4J+0TlgnxSNTq7TKNprG2URVCuwDE7SSRLAjwI8/0ru6JpLl+4ii2FC5bEdw7d0gYBVmKrwdv9Rb7fpWwJzcIIIjdHK7TlQDwfn/OpPpnSrdhStpdoMTkkmFCjn7D9yfmrY6WTlciueRyluKPquil7g3p+oO0MNxO0tMHt7okx/XNXrpvTltLtUfEny0CP9iu1UrKtcIKCpE8uplOCh4R4BXtKVMzilKUApSlAKUpQClKUApSlAKUpQClKUApSlAKUpQHkVi1sHBEis6UBzDQoG3RnxniuHqnTyXW4JbaRK/1H04P3mpelVyxRaoGASvdgrKlWA8Ar2lKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKAUpSgFKUoBSlKA//Z'
    //       ]),
    //   Product(
    //       name: 'Rich\'s Celebration Cake (45 oz)',
    //       id: const Uuid().v4(),
    //       initialPrice: 22.48,
    //       quantity: '45 oz',
    //       description: 'jkajkasdjlajjlkafjklajkljaflkjfaljaf',
    //       imageUrls: [
    //         'https://www.richsusa.com/products/cakes-brownies-finished/cakes-fully-finished/16537/?rpc_product_image=16537&v=1'
    //       ]),
    // ];

    // List<ProductCategory> prodcat = [
    //   ProductCategory(
    //     name: 'Featured items',
    //     productsAndQuantities: [
    //       {'name': 'Bacon Egg Cheese Biscuit', 'id': '123887'},
    //       {'name': 'Hash Browns', 'id': '123887'},
    //       {'name': 'Medium Premium Hot Chocolate', 'id': '123887'},
    //     ],
    //   ),
    //   ProductCategory(
    //     name: 'Most Popular',
    //     productsAndQuantities: [
    //       {'name': 'Hash Browns', 'id': '123887'},
    //       {'name': 'Medium French Fries', 'id': '123887'},
    //     ],
    //   ),
    //   ProductCategory(
    //     name: 'Homestyle Breakfasts',
    //     productsAndQuantities: [
    //       {
    //         'name': 'Big Breakfast with Muffin & Hotcakes',
    //         'id': '31654654645',
    //       },
    //       {'name': 'Hotcakes and Sausages', 'id': '43131333145'},
    //       {'name': 'Big Breakfast with Muffin', 'id': '43132134345'},
    //       {'name': 'Hotcakes', 'id': '4534313346465'},
    //     ],
    //   ),
    //   ProductCategory(
    //     name: 'Beverages',
    //     productsAndQuantities: [
    //       {'name': 'Medium Diet Coke', 'id': '123887'},
    //       {'name': 'Medium Dr Pepper', 'id': '123887'},
    //       {'name': 'Medium POWERADE', 'id': '123887'},
    //       {'name': 'Medium Frozen Coca-Cola', 'id': '123887'},
    //     ],
    //   ),
    // ];

    // List<Advert> newAdverts = [
    //   Advert(
    //       title: 'Plan flowers for Mom',
    //       shopId: 'NazJMIA9yaUsLRjLxBGa',
    //       products: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('0e7d1c02-dfeb-447a-8c93-98b4978f9a10'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('3bed4545-6230-4d77-a055-b043d37b7624'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('546c4ce3-98c4-4312-aa07-e15824c3e163'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('af460542-d9ee-4bd9-b096-fd36fcfda341'),
    //       ],
    //       type: 'flowers gift advert'),
    //   Advert(
    //       title: 'Pet gifts',
    //       shopId: 'NazJMIA9yaUsLRjLxBGa',
    //       products: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('175ea35a-70c3-4fe7-ab08-2e5e0bcb1dc8'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('5c059df8-1a52-48fe-8bee-6937eec4f901'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('5a99b80f-a844-4143-af10-cee93f0cadda'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('5e21fbdd-ef10-48f0-94fe-6a31a767bf0e'),
    //       ],
    //       type: 'pet supplies gift advert'),
    //   Advert(
    //       title: 'Perfumes and more',
    //       shopId: 'NazJMIA9yaUsLRjLxBGa',
    //       products: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('1e530deb-7d9f-4382-9a5a-d7ba96ba75ff'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('bc818672-4412-4019-a75f-a74fcc91198f'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('d4b15559-b753-4bab-9652-05079e9de302'),
    //       ],
    //       type: 'perfume gift advert'),
    //   Advert(
    //       title: 'Cakes and cupcakes',
    //       shopId: 'NazJMIA9yaUsLRjLxBGa',
    //       products: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('4a7a56b0-cf37-48ca-b172-8d3ab4eb5d9a'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('9e474b7f-e4ff-4482-8416-f3b5bb166758'),
    //       ],
    //       type: 'birthday gift advert'),
    //   Advert(
    //       title: 'Frozen delights',
    //       shopId: 'NazJMIA9yaUsLRjLxBGa',
    //       products: [
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('511a51ec-d1ba-4000-a126-bec3f3653615'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('d804af20-e499-438b-8f4e-f1532832dbc7'),
    //         FirebaseFirestore.instance
    //             .collection(FirestoreCollections.products)
    //             .doc('eec51b48-341f-4311-9c10-e831a8e6fa26'),
    //       ],
    //       type: 'sweets gift advert'),
    // ];

    // for (var vid in _exploreVideos) {
    //   FirebaseFirestore.instance
    //       .collection(FirestoreCollections.exploreVideos)
    //       .doc(vid.id)
    //       .set(vid.toJson());
    // }

    // for (var advert in newAdverts) {
    //   FirebaseFirestore.instance
    //       .collection(FirestoreCollections.adverts)
    //       .doc()
    //       .set(advert.toJson());
    // }

    DateTime dateTimeNow = DateTime.now();
    return SafeArea(
      child: NestedScrollView(
        key: _nestedScrollViewKey,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            // automaticallyImplyLeading: false,
            expandedHeight: 125,
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
                          onPressed: null,
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
                              )));
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
              title: ScrollResponsiveSearchField(_searchFieldWidthNotifier),
              expandedTitleScale: 1,
              titlePadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmallest),
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                      valueListenable: Hive.box(AppBoxes.appState)
                          .listenable(keys: [BoxKeys.userInfo]),
                      builder: (context, appStateBox, child) {
                        var timePreference =
                            ref.watch(deliveryScheduleProvider);
                        return appStateBox.get(BoxKeys.userInfo) == null ||
                                currentLocation == null
                            ? FutureBuilder(
                                future: _getLocation(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.all(
                                          AppSizes.horizontalPaddingSmall),
                                      child: Skeletonizer(
                                        enabled: true,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppText(
                                              text: 'bnbnmbkbkbj',
                                              color: AppColors.neutral500,
                                            ),
                                            AppText(
                                                text:
                                                    'vjvjbhhnklnlklsljkslkjajlkaslkaasklf')
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                  return LocationWidget(
                                    appStateBox: appStateBox,
                                    timePreference: timePreference,
                                  );
                                })
                            : LocationWidget(
                                appStateBox: appStateBox,
                                timePreference: timePreference,
                              );
                      }),
                ],
              ),
            ),
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(15),
              _foodCategories.isNotEmpty
                  ? Builder(builder: (context) {
                      int? previousFoodCategoryIndex;
                      int? currentFoodCategoryIndex;

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
                                  previousFoodCategoryIndex =
                                      currentFoodCategoryIndex;
                                  currentFoodCategoryIndex = index;
                                  _selectedFoodCategory = category;
                                  _animationControllers[index].forward();
                                  if (previousFoodCategoryIndex != null) {
                                    _animationControllers[
                                            previousFoodCategoryIndex!]
                                        .reverse();
                                  }

                                  setState(() {
                                    _selectedFilters = [];

                                    _onFilterScreen = true;
                                  });
                                } else if (_selectedFoodCategory == category) {
                                  previousFoodCategoryIndex = null;
                                  currentFoodCategoryIndex = null;
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
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color:
                                              _selectedFoodCategory == category
                                                  ? Colors.amber.shade100
                                                  : null),
                                      height: 50,
                                      width: 50,
                                      child: AnimatedBuilder(
                                        animation: _rotations[index],
                                        builder: (context, child) {
                                          return Transform.rotate(
                                              angle: _rotations[index].value,
                                              child: child);
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: category.image,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
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
                    })
                  : FutureBuilder(
                      future: _getFoodCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Skeletonizer(
                              enabled: true,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 65,
                                    child: ListView.separated(
                                        itemCount: 5,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
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
                                                  color: AppColors.neutral100,
                                                  width: 60,
                                                  height: 60,
                                                ),
                                              ),
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
                                                  color: AppColors.neutral100,
                                                  width: 60,
                                                  height: 60,
                                                  child: const AppText(
                                                    text: '!',
                                                    size: AppSizes.body,
                                                  )),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ],
                            ),
                          );
                        }

                        return Builder(builder: (context) {
                          int? previousFoodCategoryIndex0;
                          int? currentFoodCategoryIndex0;

                          return SizedBox(
                            height: 75,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              separatorBuilder: (context, index) =>
                                  const Gap(15),
                              itemCount: _foodCategories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final category = _foodCategories[index];
                                return InkWell(
                                  // radius: 50,
                                  onTap: () {
                                    if (_selectedFoodCategory != category) {
                                      previousFoodCategoryIndex0 =
                                          currentFoodCategoryIndex0;
                                      currentFoodCategoryIndex0 = index;
                                      _selectedFoodCategory = category;
                                      _animationControllers[index].forward();
                                      if (previousFoodCategoryIndex0 != null) {
                                        _animationControllers[
                                                previousFoodCategoryIndex0!]
                                            .reverse();
                                      }

                                      setState(() {
                                        _selectedFilters = [];

                                        _onFilterScreen = true;
                                      });
                                    } else if (_selectedFoodCategory ==
                                        category) {
                                      previousFoodCategoryIndex0 = null;
                                      currentFoodCategoryIndex0 = null;
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
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: _selectedFoodCategory ==
                                                      category
                                                  ? Colors.amber.shade100
                                                  : null),
                                          height: 50,
                                          width: 50,
                                          child: AnimatedBuilder(
                                            animation: _rotations[index],
                                            builder: (context, child) {
                                              return Transform.rotate(
                                                  angle:
                                                      _rotations[index].value,
                                                  child: child);
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: category.image,
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
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
                        });
                      }),
              FutureBuilder(
                  future: _getStoresAndProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Skeletonizer(
                          enabled: true,
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const Gap(20),
                            itemCount: 4,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(10),
                                      //     color: Colors.blue),
                                      color: AppColors.neutral100,
                                      width: double.infinity,
                                      height: 130,
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Column(
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
                            AppText(
                              text: snapshot.error.toString(),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              return const Icon(
                                  Icons.keyboard_arrow_down_sharp);
                            }
                            return null;
                          },
                          wrapped: false,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.horizontalPaddingSmall),
                          value: _selectedFilters,
                          onChanged: (value) {
                            late String tappedFilter;
                            if (value.isEmpty) {
                              tappedFilter = _selectedFilters.first;
                            } else if (_selectedFilters.isNotEmpty &&
                                _selectedFilters.length < value.length) {
                              value.any(
                                (element) {
                                  if (!_selectedFilters.contains(element)) {
                                    tappedFilter = element;
                                    return true;
                                  }
                                  return false;
                                },
                              );
                            } else if (_selectedFilters.isNotEmpty &&
                                _selectedFilters.length > value.length) {
                              for (var filter in _selectedFilters) {
                                if (!value.contains(filter)) {
                                  tappedFilter = filter;
                                  break;
                                }
                              }
                            }

                            if (OtherConstants.filters.indexOf(tappedFilter) ==
                                3) {
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
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            // horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: OtherConstants
                                                    .deliveryPriceFilters
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
                                                        .deliveryPriceFilters
                                                        .length -
                                                    1,
                                                divisions: OtherConstants
                                                        .deliveryPriceFilters
                                                        .length -
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
                                                _selectedDeliveryFeeIndex =
                                                    temp;

                                                _setStateWithModal(
                                                    value, tappedFilter);
                                              },
                                            ),
                                            Center(
                                              child: AppTextButton(
                                                size: AppSizes.bodySmall,
                                                text: 'Reset',
                                                callback: () {
                                                  _selectedDeliveryFeeIndex =
                                                      null;
                                                  _resetFilter(value, 3);
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
                            } else if (OtherConstants.filters
                                    .indexOf(tappedFilter) ==
                                4) {
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
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            // horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: OtherConstants
                                                    .ratingsFilters
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

                                                _setStateWithModal(
                                                    value, tappedFilter);
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
                                                  navigatorKey.currentState!
                                                      .pop();

                                                  _selectedRatingIndex = null;
                                                  _resetFilter(value, 4);
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
                            } else if (OtherConstants.filters
                                    .indexOf(tappedFilter) ==
                                5) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  String? temp;
                                  if (_selectedPriceCategory != null) {
                                    temp = _selectedPriceCategory;
                                  }

                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            // horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  choiceItems: C2Choice
                                                      .listFrom<String, String>(
                                                    source: OtherConstants
                                                        .pricesFilters,
                                                    value: (i, v) => v,
                                                    label: (i, v) => v,
                                                  ),
                                                  wrapped: true,
                                                  alignment: WrapAlignment
                                                      .spaceBetween,
                                                  choiceStyle:
                                                      C2ChipStyle.filled(
                                                    selectedStyle:
                                                        const C2ChipStyle(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          AppColors.neutral900,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(100),
                                                      ),
                                                    ),
                                                    height: 30,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
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

                                                  _setStateWithModal(
                                                      value, tappedFilter);
                                                }
                                              },
                                            ),
                                            Center(
                                              child: AppTextButton(
                                                size: AppSizes.bodySmall,
                                                text: 'Reset',
                                                callback: () {
                                                  _selectedPriceCategory = null;
                                                  _resetFilter(value, 5);
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
                            } else if (OtherConstants.filters
                                    .indexOf(tappedFilter) ==
                                6) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  List<String> temp = _selectedDietaryOptions;

                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            // horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                          temp.add(
                                                              'Vegetarian');
                                                        } else {
                                                          temp.removeWhere(
                                                            (element) =>
                                                                element ==
                                                                'Vegetarian',
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
                                                                element ==
                                                                'Vegan',
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
                                                          temp.add(
                                                              'Gluten-free');
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
                                                                element ==
                                                                'Halal',
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
                                                  _selectedDietaryOptions =
                                                      temp;

                                                  _setStateWithModal(
                                                      value, tappedFilter);
                                                }
                                              },
                                            ),
                                            Center(
                                              child: AppTextButton(
                                                size: AppSizes.bodySmall,
                                                text: 'Reset',
                                                callback: () {
                                                  _selectedDietaryOptions = [];

                                                  _resetFilter(value, 6);
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
                            } else if (OtherConstants.filters
                                    .indexOf(tappedFilter) ==
                                7) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  var temp = _selectedSort;

                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            // horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Center(
                                                child: AppText(
                                              text: 'Sort',
                                              size: AppSizes.bodySmall,
                                              weight: FontWeight.w600,
                                            )),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: OtherConstants
                                                  .sortOptions.length,
                                              itemBuilder: (context, index) {
                                                final sortOption =
                                                    OtherConstants
                                                        .sortOptions[index];
                                                return RadioListTile<
                                                    String>.adaptive(
                                                  value: sortOption,
                                                  title:
                                                      AppText(text: sortOption),
                                                  groupValue: temp,
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .trailing,
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

                                                  _setStateWithModal(
                                                      value, tappedFilter);
                                                }
                                              },
                                            ),
                                            Center(
                                              child: AppTextButton(
                                                size: AppSizes.bodySmall,
                                                text: 'Reset',
                                                callback: () {
                                                  _selectedSort = null;
                                                  _resetFilter(value, 7);
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
                            } else {
                              setState(() {
                                if (_selectedFilters.contains(tappedFilter)) {
                                  _selectedFilters.remove(tappedFilter);
                                } else {
                                  _selectedFilters.add(tappedFilter);
                                  if (_onFilterScreen == false) {
                                    _onFilterScreen = true;
                                  }
                                }
                              });
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
                            ? FutureBuilder(
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
                                              separatorBuilder:
                                                  (context, index) =>
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
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Container(
                                                        // decoration: BoxDecoration(
                                                        //     borderRadius: BorderRadius.circular(10),
                                                        //     color: Colors.blue),
                                                        color: AppColors
                                                            .neutral100,
                                                        width: double.infinity,
                                                        height: 130,
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
                                    logger.d(snapshot.error);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizes.horizontalPaddingSmall),
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Gap(100),
                                          Image.asset(
                                            AssetNames.fallenIceCream,
                                            width: 180,
                                          ),
                                          const Gap(10),
                                          const AppText(
                                            text:
                                                'Sorry, something went wrong.',
                                            weight: FontWeight.bold,
                                            size: AppSizes.body,
                                          ),
                                          AppText(
                                            text: snapshot.error.toString(),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
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
                                                    '${allStores.length} ${allStores.length == 1 ? 'result' : 'results'}',
                                                weight: FontWeight.w600,
                                              ),
                                              AppButton2(
                                                text: 'Reset',
                                                callback: () {
                                                  setState(() {
                                                    _selectedFoodCategory =
                                                        null;
                                                    _selectedFilters = [];
                                                    _onFilterScreen = false;
                                                    _selectedDeliveryFeeIndex =
                                                        null;
                                                    _selectedRatingIndex = null;
                                                    _selectedPriceCategory =
                                                        null;
                                                    _selectedDietaryOptions =
                                                        [];
                                                    _selectedSort = null;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          (allStores.isNotEmpty)
                                              ? Column(
                                                  children: [
                                                    const Gap(10),
                                                    InkWell(
                                                      onTap: () async {
                                                        await navigatorKey
                                                            .currentState!
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              MapScreen(
                                                            userLocation:
                                                                storedGeoPoint!,
                                                            filteredStores:
                                                                allStores,
                                                            selectedFilters:
                                                                _selectedFilters,
                                                          ),
                                                        ));
                                                      },
                                                      child: Ink(
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Image.asset(
                                                                AssetNames.map,
                                                                width: double
                                                                    .infinity),
                                                            Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child: const AppText(
                                                                    text:
                                                                        'View map'))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const Gap(20),
                                                    ListView.separated(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final store =
                                                              allStores[index];
                                                          final bool isClosed = dateTimeNow
                                                                      .hour <
                                                                  store
                                                                      .openingTime
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
                                                            onTap: () async {
                                                              await AppFunctions
                                                                  .navigateToStoreScreen(
                                                                      store);
                                                            },
                                                            child: Ink(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      children: [
                                                                        Stack(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          children: [
                                                                            CachedNetworkImage(
                                                                              imageUrl: store.cardImage,
                                                                              width: double.infinity,
                                                                              height: 170,
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                            if (store.offers != null &&
                                                                                store.offers!.isNotEmpty)
                                                                              Padding(
                                                                                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
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
                                                                                        StoreOffersText(store)
                                                                                      ],
                                                                                    ),
                                                                                  ))
                                                                          ],
                                                                        ),
                                                                        isClosed
                                                                            ? Container(
                                                                                color: Colors.black.withOpacity(0.5),
                                                                                width: double.infinity,
                                                                                height: 170,
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
                                                                                : const SizedBox.shrink(),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 8.0,
                                                                              top: 8.0),
                                                                          child:
                                                                              FavouriteButton(store: store),
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
                                                                            FontWeight.w600,
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
                                                                          child:
                                                                              AppText(text: store.rating.averageRating.toString()))
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Visibility(
                                                                          visible: store
                                                                              .isUberOneShop,
                                                                          child:
                                                                              Image.asset(
                                                                            AssetNames.uberOneSmall,
                                                                            height:
                                                                                10,
                                                                            color:
                                                                                AppColors.uberOneGold,
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
                                                        itemCount:
                                                            allStores.length),
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
                                })
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    MainScreenTopic(
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
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        separatorBuilder: (context, index) =>
                                            const Gap(10),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 10,
                                        itemBuilder: (context, index) {
                                          final store = _hottestDeals[index];
                                          final bool isClosed = dateTimeNow
                                                      .hour <
                                                  store.openingTime.hour ||
                                              (dateTimeNow.hour >=
                                                      store.closingTime.hour &&
                                                  dateTimeNow.minute >=
                                                      store.closingTime.minute);
                                          return InkWell(
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
                                              child: SizedBox(
                                                width: 200,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
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
                                                                      StoreOffersText(
                                                                          store)
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
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          120,
                                                                      child:
                                                                          const Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          AppText(
                                                                            text:
                                                                                'Pick up',
                                                                            color:
                                                                                Colors.white,
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
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                        FavouriteButton(
                                                          store: store,
                                                          color: AppColors
                                                              .neutral600,
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Visibility(
                                                            visible: store
                                                                .isUberOneShop,
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
                                                          color: store
                                                                  .isUberOneShop
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  163, 133, 42)
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
                                    MainScreenTopic(
                                        callback: () => navigatorKey
                                                .currentState!
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  StoresListScreen(
                                                      stores: allStores,
                                                      screenTitle:
                                                          'Stores near you'),
                                            )),
                                        title: 'Stores near you'),
                                    SizedBox(
                                      height: 102,
                                      child: ListView.separated(
                                        cacheExtent: 300,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        separatorBuilder: (context, index) =>
                                            const Gap(10),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: allStores.length,
                                        itemBuilder: (context, index) {
                                          final store = allStores[index];
                                          return InkWell(
                                            onTap: () async {
                                              await AppFunctions
                                                  .navigateToStoreScreen(store);
                                            },
                                            child: Ink(
                                              child: SizedBox(
                                                // width: 200,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .neutral200)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child:
                                                            CachedNetworkImage(
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
                                    MainScreenTopic(
                                        callback: () {
                                          navigatorKey.currentState!
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                StoresListScreen(
                                                    screenTitle:
                                                        'National Brands',
                                                    stores: _nationalBrands),
                                          ));
                                        },
                                        title: 'National Brands'),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.separated(
                                        cacheExtent: 300,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        separatorBuilder: (context, index) =>
                                            const Gap(10),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _nationalBrands.length,
                                        itemBuilder: (context, index) {
                                          final nationalBrand =
                                              _nationalBrands[index];
                                          return InkWell(
                                            onTap: () async => AppFunctions
                                                .navigateToStoreScreen(
                                                    nationalBrand),
                                            child: Ink(
                                              child: SizedBox(
                                                width: 200,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.topRight,
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    nationalBrand
                                                                        .cardImage,
                                                                width: 200,
                                                                height: 120,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              if (nationalBrand
                                                                          .offers !=
                                                                      null &&
                                                                  nationalBrand
                                                                      .offers!
                                                                      .isNotEmpty)
                                                                Padding(
                                                                    padding: const EdgeInsets
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
                                                                            BorderRadius.circular(5),
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
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          StoreOffersText(
                                                                              nationalBrand)
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
                                                              : !nationalBrand
                                                                      .delivery
                                                                      .canDeliver
                                                                  ? Container(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          120,
                                                                      child:
                                                                          const Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          AppText(
                                                                            text:
                                                                                'Pick up',
                                                                            color:
                                                                                Colors.white,
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
                                                                      right:
                                                                          8.0,
                                                                      top: 8.0),
                                                              child: FavouriteButton(
                                                                  store:
                                                                      nationalBrand))
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
                                                          text: nationalBrand
                                                              .name,
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                        AverageRatingWidget(
                                                            nationalBrand)
                                                      ],
                                                    ),
                                                    AppText(
                                                      text:
                                                          '\$${nationalBrand.delivery.fee} Delivery Fee',
                                                      color: nationalBrand
                                                                  .delivery
                                                                  .fee ==
                                                              0
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 163, 133, 42)
                                                          : AppColors
                                                              .neutral500,
                                                    ),
                                                    AppText(
                                                      text:
                                                          '${nationalBrand.delivery.estimatedDeliveryTime} min',
                                                      color:
                                                          AppColors.neutral500,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const Gap(10),
                                    const BannerCarousel(),
                                    MainScreenTopic(
                                        callback: () => navigatorKey
                                                .currentState!
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
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        separatorBuilder: (context, index) =>
                                            const Gap(10),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _popularNearYou.length,
                                        itemBuilder: (context, index) {
                                          final popularStore =
                                              _popularNearYou[index];
                                          return InkWell(
                                            onTap: () async {
                                              await AppFunctions
                                                  .navigateToStoreScreen(
                                                      popularStore);
                                            },
                                            child: Ink(
                                              child: SizedBox(
                                                width: 200,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.topRight,
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    popularStore
                                                                        .cardImage,
                                                                width: 200,
                                                                height: 120,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              if (popularStore
                                                                          .offers !=
                                                                      null &&
                                                                  popularStore
                                                                      .offers!
                                                                      .isNotEmpty)
                                                                Padding(
                                                                    padding: const EdgeInsets
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
                                                                            BorderRadius.circular(5),
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
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          StoreOffersText(
                                                                              popularStore)
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
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          120,
                                                                      child:
                                                                          const Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          AppText(
                                                                            text:
                                                                                'Pick up',
                                                                            color:
                                                                                Colors.white,
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
                                                                      right:
                                                                          8.0,
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
                                                          text:
                                                              popularStore.name,
                                                          weight:
                                                              FontWeight.w600,
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
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        2),
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
                                                                  .delivery
                                                                  .fee ==
                                                              0
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 163, 133, 42)
                                                          : AppColors
                                                              .neutral500,
                                                    ),
                                                    AppText(
                                                      text:
                                                          '${popularStore.delivery.estimatedDeliveryTime} min',
                                                      color:
                                                          AppColors.neutral500,
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
                                        itemCount: _homeScreenAdverts.length,
                                        itemBuilder: (context, index) {
                                          final advert =
                                              _homeScreenAdverts[index];
                                          final store = allStores.firstWhere(
                                            (element) =>
                                                element.id == advert.shopId,
                                          );

                                          return Column(
                                            children: [
                                              MainScreenTopic(
                                                  callback: () => navigatorKey
                                                          .currentState!
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) {
                                                          return AdvertScreen(
                                                            store: store,
                                                            advert: advert,
                                                          );
                                                        },
                                                      )),
                                                  title: advert.title,
                                                  subtitle:
                                                      'From ${store.name}',
                                                  imageUrl: store.logo),
                                              SizedBox(
                                                height: 210,
                                                child: ListView.separated(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: AppSizes
                                                            .horizontalPaddingSmall),
                                                    itemCount:
                                                        advert.products.length,
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const Gap(15),
                                                    itemBuilder:
                                                        (context, index) {
                                                      final productReference =
                                                          advert
                                                              .products[index];
                                                      return FutureBuilder<
                                                              Product>(
                                                          future: AppFunctions
                                                              .loadProductReference(
                                                                  productReference
                                                                      as DocumentReference),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  child:
                                                                      Container(
                                                                    color: AppColors
                                                                        .neutral100,
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
                                                                  child:
                                                                      Container(
                                                                    color: AppColors
                                                                        .neutral100,
                                                                    width: 110,
                                                                    height: 200,
                                                                    child:
                                                                        AppText(
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
                                                                    snapshot
                                                                        .data!,
                                                                store: store);
                                                          });
                                                    }),
                                              ),
                                            ],
                                          );
                                        }),
                                    MainScreenTopic(
                                        callback: () => navigatorKey
                                                .currentState!
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  StoresListScreen(
                                                      stores: allStores,
                                                      screenTitle:
                                                          'All Stores'),
                                            )),
                                        title: 'All Stores'),
                                    ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final store = allStores[index];
                                          final bool isClosed = dateTimeNow
                                                      .hour <
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
                                                      alignment:
                                                          Alignment.topLeft,
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl:
                                                              store.cardImage,
                                                          width:
                                                              double.infinity,
                                                          height: 170,
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
                                                                    StoreOffersText(
                                                                        store)
                                                                  ],
                                                                ),
                                                              ))
                                                      ],
                                                    ),
                                                    isClosed
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
                                                                width: double
                                                                    .infinity,
                                                                height: 170,
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
                                                            store: store))
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
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .neutral200,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 2),
                                                      child: AppText(
                                                          text: store.rating
                                                              .averageRating
                                                              .toString()))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Visibility(
                                                      visible:
                                                          store.isUberOneShop,
                                                      child: Image.asset(
                                                        AssetNames.uberOneSmall,
                                                        height: 10,
                                                        color: AppColors
                                                            .uberOneGold,
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
                                        itemCount: allStores.length),
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
                                                recognizer:
                                                    TapGestureRecognizer()
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
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _resetFilter(
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

  void _setStateWithModal(List<String> value, String newFilter) {
    navigatorKey.currentState!.pop();
    setState(() {
      if (!_selectedFilters.contains(newFilter)) {
        _selectedFilters.add(newFilter);
      }

      _onFilterScreen = true;
    });
  }

  Future<void> _getStoresAndProducts() async {
    // logger.d(await FlutterUdid.consistentUdid);
    //all stores
    final storesSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.stores)
        .get();
    allStores = storesSnapshot.docs.map(
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
    _nationalBrands = allStores
        .where(
          (element) => element.location.countryOfOrigin == 'Ghanaian',
        )
        .toList();
    _hottestDeals = List.from(allStores);
    _hottestDeals.sort(
      (a, b) => b.rating.averageRating.compareTo(a.rating.averageRating),
    );
    // _hottestDeals = _hottestDeals.reversed.toList();

    _popularNearYou = allStores;
    _popularNearYou.sort(
      (a, b) => b.visits.compareTo(a.visits),
    );
    // _popularNearYou = _popularNearYou.reversed.toList();

    final advertsSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.adverts)
        .get();

    Iterable<Advert> allAdverts = advertsSnapshot.docs.map(
      (snapshot) {
        // logger.d(snapshot.data());
        return Advert.fromJson(snapshot.data());
      },
    );
    //TODO: will let Aloglia take care of .contains function later
    _homeScreenAdverts = allAdverts.where(
      (element) {
        return !element.type.toLowerCase().contains('gift');
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
    allStores = storesList.isEmpty ? storesIterable.toList() : storesList;
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
  }

  Future<int> _getRedeemedPromosCount() async {
    Map<dynamic, dynamic>? userInfo =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);

    userInfo ??= await AppFunctions.getOnlineUserInfo();

    return userInfo['redeemedPromos'].length;
  }

  Future<void> _getLocation() async {
    Map<dynamic, dynamic>? userInfo =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    userInfo ??= await AppFunctions.getOnlineUserInfo();
  }
}

class AverageRatingWidget extends StatelessWidget {
  const AverageRatingWidget(
    this.store, {
    super.key,
  });

  final Store store;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.neutral200,
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: AppText(text: store.rating.averageRating.toString()));
  }
}

class LocationWidget extends ConsumerWidget {
  const LocationWidget({
    super.key,
    required this.timePreference,
    required this.appStateBox,
  });

  final DateTime? timePreference;

  final Box<dynamic> appStateBox;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storedGeoPoint = ref.read(selectedLocationGeoPoint)!;
    final currentLocation = ref.read(userCurrentGeoLocationProvider);
    final locationFarAway = GlobalKey();
    return Padding(
      padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
      child: InkWell(
        onTap: () async {
          await navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => const AddressesScreen(),
          ));
        },
        child: Ink(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: timePreference == null
                    ? 'Deliver now'
                    : '${AppFunctions.formatDate(timePreference.toString(), format: 'D, G:i A')} - ${AppFunctions.formatDate(timePreference!.add(const Duration(minutes: 30)).toString(), format: 'G:i A')}',
                color: AppColors.neutral500,
              ),
              Showcase(
                overlayOpacity: 0.05,
                // disableMovingAnimation: true,
                textColor: Colors.white,
                tooltipBackgroundColor: Colors.black87,
                tooltipBorderRadius: BorderRadius.circular(5),
                description:
                    'Is this the right address? You seem quite far away',
                key: locationFarAway,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Builder(builder: (context) {
                      const distance = Distance(roundResult: true);
                      final distanceResult = distance.as(
                          LengthUnit.Meter,
                          LatLng(currentLocation!.latitude!,
                              currentLocation.longitude!),
                          LatLng(storedGeoPoint.latitude,
                              storedGeoPoint.longitude));

                      if (distanceResult > 400) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) {
                            ShowCaseWidget.of(context)
                                .startShowCase([locationFarAway]);
                          }
                        });
                        Future.delayed(
                          const Duration(seconds: 30),
                          () {
                            if (context.mounted) {
                              ShowCaseWidget.of(context).dismiss();
                            }
                          },
                        );
                      }
                      return AppText(
                          text: AppFunctions.formatPlaceDescription(ref
                              .read(selectedLocationDescription)
                              .split(', ')
                              .first));
                    }),
                    const Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    super.key,
    required this.store,
    this.color = Colors.white,
    this.size,
  });

  final Store store;
  final Color color;
  final double? size;

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
              .update({store.id: store.toJson()});
        }
        setState(() {});
      },
      child: Ink(
        child: Icon(
          isFavourite ? Icons.favorite : Icons.favorite_outline,
          color: widget.color,
          size: widget.size,
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
                    // CachedNetworkImage(
                    //   imageUrl: _product.imageUrls.first,
                    //   width: 110,
                    //   height: 120,
                    //   fit: BoxFit.fill,
                    // ),
                    AppFunctions.displayNetworkImage(
                      _product.imageUrls.first,
                      width: 110,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                      child: AddToCartButton(
                        product: _product,
                        store: _store,
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
                  ),
                ],
              ),
              if (_product.isSponsored ?? false)
                const AppText(text: 'Sponsored', color: AppColors.neutral500)
            ],
          ),
        ),
      ),
    );
  }
}

class AddToCartButton extends ConsumerStatefulWidget {
  final Product product;
  final Store store;
  final bool removeShadow;

  final Color? backgroundColor;
  const AddToCartButton({
    required this.product,
    required this.store,
    this.removeShadow = false,
    this.backgroundColor = Colors.white,
    super.key,
  });

  @override
  ConsumerState<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends ConsumerState<AddToCartButton> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<HiveCartProduct>(AppBoxes.storedProducts).listenable(),
        builder: (context, productsBox, child) {
          final cartBox = Hive.box<HiveCartItem>(AppBoxes.carts);

          final cartItemInBox = cartBox.get(widget.store.id);
          final product = productsBox.values.firstWhereOrNull(
            (element) => element.id == widget.product.id,
          );
          return Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                boxShadow: widget.removeShadow
                    ? null
                    : const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2, 2),
                        )
                      ],
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(50)),
            child: cartItemInBox == null || product == null
                ? InkWell(
                    onTap: () async {
                      if (widget.product.requiredOptions.isNotEmpty) {
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => ProductScreen(
                              product: widget.product, store: widget.store),
                        ));
                        return;
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      await productsBox.add(HiveCartProduct(
                        name: widget.product.name,
                        purchasePrice: widget.product.promoPrice ??
                            widget.product.initialPrice,
                        id: widget.product.id,
                        quantity: 1,
                      ));
                      if (cartItemInBox == null) {
                        final newCartItem = HiveCartItem(
                            // initialPricesTotal: widget.product.initialPrice,
                            subtotal: widget.product.promoPrice ??
                                widget.product.initialPrice,
                            placeDescription:
                                ref.read(selectedLocationDescription),
                            deliveryDate: ref
                                .read(deliveryScheduleProvider.notifier)
                                .state,
                            storeId: widget.store.id,
                            products: HiveList(productsBox));
                        newCartItem.products.add(productsBox.values.last);
                        await cartBox.put(widget.store.id, newCartItem);
                      } else {
                        cartItemInBox.products.add(productsBox.values.last);
                        await cartItemInBox.save();
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Ink(
                      child: const Icon(
                        Icons.add,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            if (product.quantity == 1) {
                              await product.delete().then(
                                (value) {
                                  if (cartItemInBox.products.isEmpty) {
                                    cartItemInBox.delete();
                                  }
                                },
                              );
                            } else {
                              product.quantity -= 1;
                              cartItemInBox.subtotal -=
                                  widget.product.promoPrice ??
                                      widget.product.initialPrice;
                              // cartItemInBox.initialPricesTotal -=
                              //     widget.product.initialPrice;
                              await product.save();
                              await cartItemInBox.save();
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Ink(
                            child: product.quantity == 1
                                ? const Icon(
                                    Icons.delete_outline,
                                    size: 15,
                                  )
                                : const Iconify(
                                    Ic.baseline_minus,
                                    size: 15,
                                  ),
                          )),
                      const Gap(10),
                      _isLoading
                          ? const SizedBox(
                              height: 6,
                              width: 6,
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                strokeWidth: 0.3,
                              ),
                            )
                          : AppText(text: product.quantity.toString()),
                      const Gap(10),
                      InkWell(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            product.quantity += 1;
                            cartItemInBox.subtotal +=
                                widget.product.promoPrice ??
                                    widget.product.initialPrice;
                            // cartItemInBox.initialPricesTotal +=
                            //     widget.product.initialPrice;
                            await product.save();
                            await cartItemInBox.save();
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Ink(
                            child: const Icon(
                              Icons.add,
                              size: 15,
                            ),
                          )),
                    ],
                  ),
          );
        });
  }
}

class ProductGridTilePriceFirst extends StatelessWidget {
  const ProductGridTilePriceFirst({
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
                    AppFunctions.displayNetworkImage(
                      _product.imageUrls.first,
                      width: 110,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                      child: AddToCartButton(product: _product, store: _store),
                    )
                  ],
                ),
              ),
              const Gap(5),
              Row(
                children: [
                  Visibility(
                    visible: _product.promoPrice != null,
                    child: Row(
                      children: [
                        AppText(
                            weight: FontWeight.w600,
                            text: '\$${_product.promoPrice}',
                            color: Colors.green),
                        const Gap(5),
                      ],
                    ),
                  ),
                  AppText(
                    text: "\$${_product.initialPrice}",
                    weight: FontWeight.w600,
                    decoration: _product.promoPrice != null
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  )
                ],
              ),
              AppText(
                text: _product.name,
                color: AppColors.neutral500,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (_product.promoPrice != null)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.all(5),
                  child: AppText(
                      color: Colors.white,
                      text:
                          '${(((_product.initialPrice - _product.promoPrice!) / _product.initialPrice) * 100).toStringAsFixed(0)}% off'),
                ),
              if (_product.isSponsored ?? false)
                const AppText(text: 'Sponsored', color: AppColors.neutral500)
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
  });

  final List<Store> storesWithNameOrProduct;
  final TimeOfDay timeOfDayNow;

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
                    await AppFunctions.navigateToStoreScreen(store);
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
  });

  final List<Store> storesWithProduct;
  final String query;
  final bool showProducts;

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
              return Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await AppFunctions.navigateToStoreScreen(store);
                    },
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
                        ),
                        if (store.offers != null && store.offers!.isNotEmpty)
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
                      height: 207,
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
                              callback: () async {
                                await AppFunctions.navigateToStoreScreen(store);
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
                                            color: AppColors.neutral100,
                                            width: 100,
                                            height: 140,
                                          ),
                                        ));
                                  } else if (snapshot.hasError) {
                                    return AppText(
                                        text: snapshot.error.toString());
                                  }
                                  final product = snapshot.data!;
                                  return InkWell(
                                    onTap: () {
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) => ProductScreen(
                                          product: product,
                                          store: store,
                                        ),
                                      ));
                                    },
                                    child: Ink(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                AppFunctions
                                                    .displayNetworkImage(
                                                  product.imageUrls.first,
                                                  width: 100,
                                                  height: 120,
                                                  fit: BoxFit.fill,
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0,
                                                            top: 8.0),
                                                    child: AddToCartButton(
                                                        product: product,
                                                        store: store))
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
                                                text:
                                                    '\$${product.initialPrice}',
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
                                            return product.offer != null
                                                ? FutureBuilder(
                                                    future: AppFunctions
                                                        .loadOfferReference(product
                                                                .offer
                                                            as DocumentReference),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        final offer =
                                                            snapshot.data!;
                                                        return AppText(
                                                          text: offer.title,
                                                          color: Colors
                                                              .green.shade900,
                                                          size: AppSizes
                                                              .bodySmallest,
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return AppText(
                                                          text: snapshot.error
                                                              .toString(),
                                                        );
                                                      } else {
                                                        return const Skeletonizer(
                                                          enabled: true,
                                                          child: AppText(
                                                            text: 'soajlaskls',
                                                          ),
                                                        );
                                                      }
                                                    })
                                                : const SizedBox.shrink();
                                          }),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
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
  const NoSearchResult({super.key, TabController? tabController})
      : _tabController = tabController;

  final TabController? _tabController;

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
            if (_tabController != null && _tabController.index != 0)
              AppButton2(
                text: 'Search in all',
                textColor: Colors.white,
                callback: () => _tabController.animateTo(0),
                backgroundColor: Colors.black,
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

class MainScreenTopic extends StatelessWidget {
  final String title;
  final bool removeDivider;
  final String? subtitle;
  final VoidCallback callback;
  final String? imageUrl;
  const MainScreenTopic({
    super.key,
    this.imageUrl,
    this.subtitle,
    this.removeDivider = false,
    required this.callback,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(10),
        if (!removeDivider)
          const Divider(
            color: AppColors.neutral200,
          ),
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
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

class StoreOffersText extends StatelessWidget {
  final Store store;
  final Color color;
  final double? size;
  const StoreOffersText(this.store,
      {super.key, this.color = Colors.white, this.size});

  @override
  Widget build(BuildContext context) {
    return store.offers?.length == 1
        ? FutureBuilder(
            future: AppFunctions.loadOfferReference(
                store.offers!.first as DocumentReference),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final offer = snapshot.data!;
                return AppText(
                    color: color,
                    size: AppSizes.bodySmallest,
                    text: offer.title);
              } else if (snapshot.hasError) {
                return AppText(
                  color: color,
                  text: snapshot.error.toString(),
                );
              } else {
                return const SizedBox.shrink();
              }
            })
        : AppText(
            size: size,
            color: color,
            text: '${store.offers?.length} Offers available');
  }
}

class ScrollResponsiveSearchField extends StatefulWidget {
  final ValueNotifier<double> currentWidthNotifier;
  const ScrollResponsiveSearchField(
    this.currentWidthNotifier, {
    super.key,
  });

  @override
  State<ScrollResponsiveSearchField> createState() =>
      _ScrollResponsiveSearchFieldState();
}

class _ScrollResponsiveSearchFieldState
    extends State<ScrollResponsiveSearchField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.currentWidthNotifier,
        builder: (context, value, child) {
          return InkWell(
            onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => SearchScreen(
                stores: allStores,
              ),
            )),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(50)),
              width: value,
              height: 50.0,
              child: const Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 18,
                  ),
                  Gap(10),
                  AppText(
                    text: 'Search Uber Eats',
                    color: AppColors.neutral500,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
