import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/browse_video/browse_video_model.dart';
import 'package:uber_eats_clone/models/favourite/favourite_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/grocery_store/screens/screens/grocery_store_main_screen.dart';
import 'package:uber_eats_clone/presentation/features/home/screens/search_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';
import 'package:uber_eats_clone/presentation/features/some_kind_of_section/advert_screen.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../app_functions.dart';
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
import '../uber_one/join_uber_one_screen.dart';
import '../webview/webview_screen.dart';
import 'map/map_screen.dart';

Map<String, Product> products = {};
List<Store> stores = [];

GeoPoint? storedUserLocation;
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
late List<Advert> adverts;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final webViewcontroller = WebViewControllerPlus();

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
  final _scrollController = ScrollController();

  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _rotations;

  late List<Store> _popularNearYou;

  LocationData? _currentLocation;
  FoodCategory? _selectedFoodCategory;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
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
    //       name: 'Bacon Egg Cheese Biscuit',
    //       id: const Uuid().v4(),
    //       initialPrice: 7.39,
    //       calories: 450,
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Hash Browns',
    //       id: const Uuid().v4(),
    //       initialPrice: 3.79,
    //       calories: 140,
    //       imageUrls: [
    //         'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAQEA8QExAPEBIQDxAQEA8OFQ8NDw8QFREXFhURExUYHiggGBolGxMXITEhJSkrLi4vFx8zODMsNygtMCsBCgoKDg0OGhAQGi0mHyYrLTEwKzcvLSsuLSsrKy8tKysvLy0tLy8tLS8tLzAtLS0tLSstLSsvKy0tLS0tLS0tLf/AABEIAOEA4QMBEQACEQEDEQH/xAAbAAEAAgMBAQAAAAAAAAAAAAAAAwQBAgUGB//EAEIQAAIBAgMEBwUFBQYHAAAAAAABAgMRBBIhBTFBUQYTImFxgZEycqGxwQdCguHwJTNSstEjQ0SzwtIUFlNUYnOT/8QAGgEBAAMBAQEAAAAAAAAAAAAAAAECAwQFBv/EADkRAQACAgAEAwUGBAUFAQAAAAABAgMRBBIhMQVBURNhgaGxMnGR0eHwIiMzQhU0UnLBJENTYvEU/9oADAMBAAIRAxEAPwD7iAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABHVrRjrKSjpfV20M75aUjdpiFq1m3aFGttzDwTbqJW3d/gcdvE+Gr3t+revCZbdoQQ6S4d8XfTTT13mUeMcP573+/e0ngMro4fFwqJNPfu3HZg4vHm+zLmvitTusHSzAAAAAAAAAAAAAAAAAAAAAAAAAAA4XSHbyoJxhaVTjutDTjzfceZxviHsZ5MfW30/X3OzhuF9p1t2+rxlfHzxLlJtttW1b1Xlu8jwM02yX579ZetTHXFERCq4NvVvz57jHTXmWqVONlprfh+t5Go117qTadujgKrhljd6PTfv5/MnHE11DLJ/F1ejwu3YKShJ8F2vP9eh7XD+KxSYpk7erz8nBzMc1XbjJNXWqPdraLRuHDMa6SySgAAAAAAAAAAAAAAAAAAAAAAAV9oYnqqVSpp2Ytq+6/D4mPEZPZ4rX9IXx057xV8qxtaVWbUnZyk5SSd9G77/NHycdZm895fQ1iKR0XsJFQ0S0SK76s7TNiXtN7l8dUVnrZMdkdLEXludrvXdpwI96816LKq6EbU5eqOnVs8127tK3mn9Ckz03715jfR7PY+0FaMXLfzPc8P4yK6x2l5XEYe8xDtnvuAAAAAAAAAAAAAAAAAAAAAAAw5Jb2l46Aee6Y7Qpqg6eeLc5K6Tu8sXd7t2qR5Xi2blxckd5n5Q7eBxzbJzejw9CnnbnZ+Hd+keDFZiNPVtPL0WoRy8HbV+n5keau9p1FWWm/iFdqtZqLlGPHi7FLaiZiG1Y3G5S06dk2t2594iO8omUVla293VuK9e7eZxHTS257rNHEZW9W8sktNVr3+qJt03PorNd9F3EV605U11kv7SyV27Xby628j3uHz3y46zvr2edfHWtp6PZ4CCjHKtytZXb+Z7VY10efadrRZUAAAAAAAAAAAAAAAAAAADm7VjfR7nErK0PB7cjlqZXpaHYb477HzfiUzOfl9Ih7HBf09x6q2zp3Tbdst01ud9zXkYTXTbJC3iMRFwUVfR37rfrUzt20rSs72g/4p2y68dPDgZztryebNKCqb79/C0VuRERsmZqsyhplWllqne9rc+ehOvKFN+cqtKeZNbkrx8+/nv3lI6dGlo11SVK/VU2t6a3c3/U1pHLXUeaIrz2dbonSlVk67VqcOzS0cXKdss5LmtGvHwPW8KwTXd57eX3uLxC1Y1SO/n93k9jh3r5HuQ8qVglAAAAAAAAAAAAAAAAAAAAHO2l7S936srKYcPbezVXp2vlkruMlpZ249xy8Tw1c0de8dnTw+ecVt+Ty2Io1qE5KaSjL78U1CTUVpB/rieJmxXx9Lf/AF6uO9Mkbr3aTva+9tej/Vjk6b3LWvdPRwCjRc3Jp2aW6978PN/AmYiY5pROWZvywip1nBa+dtLX8zON66LTWJlI8W5Ql2Hvy35q2r7vyJ3uEckRPdUU8rT4P6bjPW2neNLWCwdTHVFTg0qcJR6+f8NNu9o/+TSdtPE7+E4a2a/uhhly14eu57z2+/8AJ73B4WFGnClBKMYKySsvFu3FvV+J9LSkUry1eFe9r2m1u8rtB6ovCkrRKAAAAAAAAAAAAAAAAAAAAObtH217q+bKytCqyqUU6Skmmrpppp8U1ZlbUi0TFo6LRaYncOfX2HBu8Hl1fZd3FacOK1+Z5mbwytp3Sde7y+HxddOMtEas5+0MHVjGzhJrTd2ld7ly7jzM/DZscda+nv7urFlpaekuNXt7K42v3W5nJvTrrPmlppyWVXk3fRLM3x0trwK13bpWNyiZ11l08D0Yq1mpVP7Knpdb6klpuXC6e98tx6nDeF5b6nJ/DHzcuXjqU6V6z8nrcHhIUYRp045YxvZb9W7tvvbPoMeOuOsVr2eTkyWyW5rd0rLqtqbAvFlQAAAAAAAAAAAAAAAAAAAObtH2/wAK+bKytCo2VWYA3gQLMCUNZ4WnK2anTlbNbNGLtm9r1KTix271ifh691ovaO0ylpU4R9mEY6JdlKOiVlu7i9aVr9mIhWbWt3ls2XVRtkJYAzGQF+Dul4Isq2AAAAAAAAAAAAAAAAAAADm7Q9vyX1KytCpIosp4zaFOjKlGbyqq5pTk4xpwcYZu029L7l3lLXisxvzb4eHvlraadeXXTrMzuddNIsJtujONCTzw6+ygpRk0pObgoymllTbVt5WMtZiJ9WuTgctLXrGp5e/X3b3Ed+zD6RQkqUqUJ1Yzrqi0koy1pzlHJdpXvC1pNWvrYj20Tqa9erSPD7Vm1csxExXfu7xHX3ane43vyZ2htuo6WEqYdRksUp5VUpzqS0pOpGKhGcdezJPUm2WdVmnmnDwVIyZKZ5+xrtMRHfU9ZifX0Rx6VXpuaoqWWjhZynGpamp4iShFaxuoqWe8raKG7Ue36biPKPmtPher8s211tGtddUjc+et61qPPaGt0slHLeiu1KpHszc0+oqSWJcHlWZRhDMud7W0IniNd4/cd16+FRber+UeWvtRHJvr03M6n0Yjt/ESlTahSySWCqSSjUc3TxNWULxeayypReqe8RltOvh80TwGGK23M7/jjvGt0iJ9PPrHdf2Dj61V1Y1Y2cMjTjTnSpttyTjFzd3bKtGk1db7l8VrTvmc3G4MWPlnFPSd+cTPl1nXTz8pmJ92nWRq4V/DvsotCspSQAAAAAAAAAAAAAAAAAAHL2h7fkisrQqTZRZWxGEjUlRnK96NR1IpWs24Sg1JNaq0vVIpNYmYn0a481sdb1j+6NT+MT0/BUpbAoLJ+8fV2y3m+FZ1o7uU5P4XvZFIw1j9+/bpnxDNO+3X3f8Aryz8o/Jfw+x6EZZ8jcs8J5pzqTkpQcnDVvcnOWneXrjrE7Y24zNavLvpqY1qI7632jz1Cy9k4eVOFJ0acqdPWFOazxg9Von7z9S/s665ddFI4rNF5yRaYtPee21iGEpxTSp00nCMGlGKThG+WD01iruy72TFYjyZzlvPe0999/Oe8/ez1aSSSSUdEopJJckluJVm0zO5lhRYQ2USRpMgXME9H4loRKwSgAAAAAAAAAAAAAAAAAAHK2h+8fgikrQoyZRZtBEiWEALFOJMITIttDIQAathLW4EdQiRYwEtWu6/69SaoldLIAAAAAAAAAAAAAAAAAABydo/vH4IpK0OfN6lFktNgTwJE8WShs5Jatpd70QmYiNzJrfZtOSim20kldt6JIWtFYm1p1CIiZnUNKVaM1eMlJbrrnyK48tMleak7hNqWrOrQw2aIYuAmiJIZwU+2vNfAR3JdMuqAAAAAAAAAAAAAAAAAADy3SfaPVzcI+24rXeorn3s8fxPxH/8/wDBT7U/L9XbwvD8/wDFbt9UFDEdZCM+a1XJ7mvU6+HzxmxVyR5/XzZZKclpquUZG7NYiwJ4SLQhVnapiMjSlGnTzZXqnOTS1XHRnnX1n4z2do3Wtd68tz+jojdMPNHeZ+UfqqZmqkcK7uMa0ZK+t6dsyg+f5Hnc9q5q8DPaLxMf7dbiPg6dRNJzx35fn22uV31eIg/u11llyzx9mXjqkehlt7DjKT/bk6T/ALo7T989nNWPaYZjzr1+HmvZD1HMAaVGQIMPK0l7yIhMu0aKAAAAAAAAAAAAAAAAAAA8l0g2a6mJlJyUY5ILnJ6cjxOM8MtxHEc821XUe+Xdh4mMePWtyjjBQSit0VZHpY8dcdIpXtDntabWm0rOHkXQsolDeIFXZ0r4jE/gXovyPK4Sd8bnn/b9HVmj+Tj+Ji42xdCX8S+KzL6oy4mmvEsN/WPptbHO+GvH78k230+qjNb4VIyXy+djbxqJjh4yR3raJU4Kf5k1nzh0M90nzSfqetW0WiJjzckxqdNGyRHiqmWEpWvli3ZcbGWfJ7PHa+t6iZ0tjrzWivq4tPFrEKcIudN2Tb0lpfceZj4qniGO2OkzWenp+/o6rYp4e0WnUvXwd0nzSZ7UOFsAAAAAAAAAAAAAAAAAAONtZdt+CKWWhwNoOWSeV2lbR8dN9vI5uK5/ZW9n301xcvPHN2Vdg4urOdn2oWd5NJWfDXieZ4bxPE5b6v1r66dXE48da9O70cWe04mUyBrhMLlqVKma/WW7NrWt331OXDwvs818u/ta6emmt8vNStNdl2VGLcZOKbj7LerXgdVsVLWi0xEzHafRlF7RExE9JbVaMZxcZLMna6fc7/QZcVMtZpeNx6FbTWd17sqnZJLRJJJcki8VisREdoVmdzuWMpIxIDzW1dt4TCNqUoKS/uqKjKo+5paR/E0cu8OHpWIj3REO3DwnEcR1iJ16z2/f3bel6O7RjicLRrxTipxfZbTayycWm/GJ04789YtDn4nBOHLOOfJ0i7AAAAAAAAAAAAAAAAAAPLbc23hqeInRnWhTnGMHapeCs1dWk+z8TG2SkW1MuqnCZr0561mY93X5d1R1Iy1jKMlzg1JeqJnr2ZTE1nUxpvguXIrWNdCZ26MSyG8QLFMlCVMlDaUrK7dlzeiJI69IcnHdJsFRvmxNJtb40260vSF7GVs+OveXXj8P4nJ9mk/Hp9dPO4/7QqauqNCc3/FWapR8Uldv4GFuMj+2Ho4vBLz/AFLRH3dfy/5eX2n0pxmIupVXTi/7uhejHza7T8G7HNfPkt3l6uDw7h8PWK7n1nr+nyeelozOHTM9X1/7LMRmwGX/AKVerD1tP/Welwk/y9e98v4xXXEb9Yj8v+HsDpeWAAAAAAAAAAAAAAAYuAA+M/aY/wBo1f8A10f5EeZxP9SX1Xhf+Wj75+ryUZOLum4vnFuL9UYx0d1o30lfwu2MVD2cRXX45yXo2W9paO0sp4XBbvSPwdCHSjHL/Ez84UJfOA9tk9Uf4fws/wDbj8Z/NIuluP8A+5f/AM8N/sHtsnr9PyR/hvCf6Pnb82f+a8e/8VPyhQj8oEe2yev0Xjw7hP8Axx+M/mhrdIMZPfisR5VJw/lsROW8+ctK8Hw9e2Ov4b+qjXrynrOUpvnUlKb+JSdz3dFYrT7Ma+7oicwTLV1CdI21dUaRzK1WqWiGVrPpP2N45NYyjydOsvNOMv5Y+p28JPeHheM13yX++P8Al9LUjseGzcABkAAAAAAAABgAAAwBmwHxX7TJftKt7lH/AC0ebxP9SX1Xhf8Alq/H6vJORg7hVBoiUqqkaX5jrRpPMdeNHMw8QNHO1eKRPKr7SEUsYidI9o3pwrT9mlVl3xjJr1sWjHM9oYW4rHXvaPxhdobCxs91Fx75uK+tzSMF58nNfxLBH92/hLqYXoJiqls04Q8FKf8AQ0jhrerlv4tTyrM/L83suh3RCWCq9cq05SdOVNxtGMHFtPdq98VxN8eHkne3BxXHznpycsRG9vd0pPibPPTJkjZAZAyAAAAAADDAxcDKAyAA1bA+G/ahU/adf3KH+VE87iI/mS+n8Nn/AKavx+ryLqmOnbtmmpS9mMpe6nL5FojfZS2SK/anXyXKWy8VLdRn+K0PmWjFafJjbjsNe94+v0XaXRjFy+7GPi2/ki8cPZz28Uwx23PwXKPQus/aqW7ox+rf0Lxw3rLnt4t/pr8/0X6HQiP3pTl4tJfBF44erC3imae2o/fvdHD9DaK+4n715/MvGGkeTntxue390/T6OvhOjtOG6CXglH5GkViOzntktb7UzLp0dlxX3SdKL9HBW4Ei5SwwFqFEITRgSJFEDYABkAAAAAAGAAADIACDERbWgHi9s9D6VerKtOmpzkopyk5tWirLS9tyMrYqzO5h1U4vLSnJW2oVKXRGnDdTpx92MU/WxMY6x2hS2fJb7Vpn4yvU9hxXC5bTJZp7KS+6NITx2b3DQmhs3uJ0JobO7gJ4YBcgJoYNcgJY4dBCRUkSNlADZIDNgMgAAAAAAAAAAABgDIAABq4IDR0VyAx1C5AZ6lAZ6tAZyIDOUDNgFgFgMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf/Z'
    //       ]),
    //   Product(
    //       name: 'Medium Premium Hot Chocolate',
    //       id: const Uuid().v4(),
    //       initialPrice: 14.7,
    //       calories: 450,
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Medium French Fries',
    //       id: const Uuid().v4(),
    //       initialPrice: 4.47,
    //       calories: 320,
    //       imageUrls: [
    //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjtOYyH-94C9D7ZWXsag9d-CC8_iHKUDdfZA&s'
    //       ]),
    //   Product(
    //       name: 'Medium Diet Coke',
    //       id: const Uuid().v4(),
    //       initialPrice: 1.69,
    //       calories: 0,
    //       selectOptionRequired: true,
    //       options: [
    //         Option(name: 'Large Diet Coke', price: 0.30, calories: 0),
    //         Option(
    //             name: 'Medium Diet Coke',
    //             price: 0.30,
    //             calories: 0,
    //             subOptions: [
    //               SubOption(name: 'Straw', canBeMultiple: true),
    //               SubOption(name: 'Straw', canBeMultiple: false),
    //             ]),
    //         Option(name: 'Small Diet Coke', price: 0.30, calories: 0)
    //       ],
    //       imageUrls: [
    //         'https://s7d1.scene7.com/is/image/mcdonalds/DC_202112_0652_MediumDietCoke_Glass_1564x1564-1:product-header-mobile?wid=1313&hei=1313&dpr=off'
    //       ]),
    //   Product(
    //       name: 'Medium Dr Pepper',
    //       id: const Uuid().v4(),
    //       initialPrice: 1.69,
    //       calories: 200,
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Medium POWERADE',
    //       id: const Uuid().v4(),
    //       initialPrice: 1.69,
    //       calories: 120,
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Medium Frozen Coca-Cola',
    //       id: const Uuid().v4(),
    //       initialPrice: 3.39,
    //       calories: 80,
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: 'Medium Minute Maid Orange Juice',
    //       id: const Uuid().v4(),
    //       calories: 200,
    //       initialPrice: 4.39,
    //       imageUrls: [
    //         'https://s7d1.scene7.com/is/image/mcdonaldsstage/DC_202212_3582_MediumMinuteMaidPremiumOrangeJuice_1564x1564:product-header-mobile?wid=1313&hei=1313&dpr=off'
    //       ]),
    //   Product(
    //       name: 'Sweet N Sour Dipping Sauce',
    //       id: const Uuid().v4(),
    //       calories: 50,
    //       initialPrice: 0.20,
    //       description: 'Limit of 2',
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
    //       ]),
    //   Product(
    //       name: '13 Cookie Tote',
    //       id: const Uuid().v4(),
    //       initialPrice: 7.69,
    //       calories: 2210,
    //       description: 'Comes with 13 cookies',
    //       imageUrls: [
    //         'data:image/jpeg;base64,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'
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

    // List<BrowseVideo> _browseVideos = [
    //   BrowseVideo(
    //       id: const Uuid().v4(),
    //       productRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.products)
    //           .doc('1240'),
    //       storeRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.stores)
    //           .doc('pWxVJ3aWrzkMluIn1x3T'),
    //       videoUrl:
    //           'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/browse%20videos%2F%F0%9F%8D%BA%F0%9F%8D%8B%20coronaextra%20bebidas%20cervejacorona%F0%9F%8D%BB%F0%9F%A4%A4%F0%9F%A4%97%20mexico%F0%9F%87%B2%F0%9F%87%BD%20brasil.mp4?alt=media&token=33bbc44d-bf96-4fc5-b746-e0eae07d22ea'),
    //   BrowseVideo(
    //       id: const Uuid().v4(),
    //       productRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.products)
    //           .doc('7dc114b6-fa6a-4b4b-b8ac-953dbcea0864'),
    //       storeRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.stores)
    //           .doc('n9g1kTpCk6MQjwrngK6V'),
    //       videoUrl:
    //           'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/browse%20videos%2FThis%20how%20we%20make%20a%20bacon%20egg%20and%20cheese%20mcqwidle%20fyp%20viral%20mcdonalds%20fyp%E3%82%B7%20trending%20tiktok%20foryou.mp4?alt=media&token=c185ab55-2fbe-40d8-9f44-63ee847de899'),
    //   BrowseVideo(
    //       id: const Uuid().v4(),
    //       productRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.products)
    //           .doc('6a036181-4fa8-4eab-949e-e6c4af81aac2'),
    //       storeRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.stores)
    //           .doc('wcWtBqW8AnN0AVq4MCaE'),
    //       videoUrl:
    //           'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/browse%20videos%2FMake%20a%20Joe%E2%80%99s%20club%20with%20us%20%F0%9F%A4%B2%F0%9F%8F%BC%20joeandthejuice%20joesclub.mp4?alt=media&token=c732bdc6-59cc-42c8-bdcc-59b89c72ed3a'),
    //   BrowseVideo(
    //       id: const Uuid().v4(),
    //       productRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.products)
    //           .doc('f6c6a80e-86ce-4840-820c-ac4ab16332e3'),
    //       storeRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.stores)
    //           .doc('n9g1kTpCk6MQjwrngK6V'),
    //       videoUrl:
    //           'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/browse%20videos%2FThailand%20Frozen%20Coca%20Cola%20%F0%9F%A5%A4%F0%9F%A7%8A%20bangkok%20thailand%20tiktokeats%20foodietok%20foodreview%20streetfood%20tiktokthailand.mp4?alt=media&token=fa7a4670-837f-4e1a-915f-7cd6f0c7b532'),
    //   BrowseVideo(
    //       id: const Uuid().v4(),
    //       productRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.products)
    //           .doc('17df74ac-bb54-4ac7-afd4-150aca00e349'),
    //       storeRef: FirebaseFirestore.instance
    //           .collection(FirestoreCollections.stores)
    //           .doc('wcWtBqW8AnN0AVq4MCaE'),
    //       videoUrl:
    //           'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/browse%20videos%2F%D8%A7%D8%B3%D8%A7%D9%8A%20%D8%AC%D9%88_%D8%A7%D9%86%D8%AF_%D8%AC%D9%88%D8%B3%20fyp%20foryou%20a%C3%A7ai%20a%C3%A7a%C3%AD%20explore%20joeandthejuiceksa%20explore%20riyadh%20khobar%20joeandthejuice%20summer.mp4?alt=media&token=c95476c9-12f9-49ae-ba35-a6c8eef3e8b5'),
    // ];

    // for (var vid in _browseVideos) {
    //   FirebaseFirestore.instance
    //       .collection(FirestoreCollections.browseVideos)
    //       .doc(vid.id)
    //       .set(vid.toJson());
    // }

    // for (var product in newProducts) {
    //   FirebaseFirestore.instance
    //       .collection(FirestoreCollections.products)
    //       .doc(product.id)
    //       .set(product.toJson());
    // }

    // _getStoresAndProducts();

    DateTime dateTimeNow = DateTime.now();
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            // automaticallyImplyLeading: false,
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
              expandedTitleScale: 1,
              titlePadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmallest),
              title: InkWell(
                onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => SearchScreen(
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
              //TODO: change to valuelistenablebuilder
              background: ValueListenableBuilder(
                  valueListenable: Hive.box(AppBoxes.appState)
                      .listenable(keys: [BoxKeys.userInfo]),
                  builder: (context, appStateBox, child) {
                    var timePreference = ref.watch(deliveryScheduleProvider);
                    return appStateBox.get(BoxKeys.userInfo) == null ||
                            _currentLocation == null
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
                                currentLocation: _currentLocation,
                              );
                            })
                        : LocationWidget(
                            appStateBox: appStateBox,
                            timePreference: timePreference,
                            currentLocation: _currentLocation,
                          );
                  }),
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
                                      text: 'Sorry, something went wrong.',
                                      weight: FontWeight.bold,
                                      size: AppSizes.body,
                                    ),
                                    AppText(text: snapshot.error.toString())
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
                                                          storedUserLocation!,
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
                  : RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: FutureBuilder(
                          future: _getStoresAndProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
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
                                          const AppText(text: 'klmalmlamkla'),
                                          const Gap(5),
                                          const AppText(
                                              text:
                                                  'klmalmlamklakamlkm;ksasamklk'),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
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
                                      text: 'Sorry, something went wrong.',
                                      weight: FontWeight.bold,
                                      size: AppSizes.body,
                                    ),
                                    // TODO: UNCOMMENT
                                    AppText(text: snapshot.error.toString())
                                  ],
                                ),
                              );
                            }
                            return SingleChildScrollView(
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                        weight: FontWeight.w600,
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
                                                        color:
                                                            store.isUberOneShop
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    163,
                                                                    133,
                                                                    42)
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
                                              builder: (context) {
                                                if (store.type
                                                    .toLowerCase()
                                                    .contains('grocery')) {
                                                  return GroceryStoreMainScreen(
                                                      store);
                                                } else {
                                                  return StoreScreen(
                                                    store,
                                                  );
                                                }
                                              },
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
                                                            BorderRadius
                                                                .circular(50),
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
                                                          imageUrl:
                                                              nationalBrand
                                                                  .cardImage,
                                                          width: 200,
                                                          height: 120,
                                                          fit: BoxFit.fill,
                                                        ),
                                                        if (nationalBrand
                                                                    .offers !=
                                                                null &&
                                                            nationalBrand
                                                                .offers!
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
                                                                .withOpacity(
                                                                    0.5),
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
                                                    text: nationalBrand.name,
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
                                                          text: nationalBrand
                                                              .rating
                                                              .averageRating
                                                              .toString()))
                                                ],
                                              ),
                                              AppText(
                                                text:
                                                    '\$${nationalBrand.delivery.fee} Delivery Fee',
                                                color: nationalBrand
                                                            .delivery.fee ==
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
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                          autoPlay: true,

                                          // padEnds: true,
                                          height: 150,
                                          enableInfiniteScroll: false,
                                          scrollDirection: Axis.horizontal),
                                      items: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Container(
                                              width: 350,
                                              // height: 140,
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
                                                                  color: Colors
                                                                      .white,
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
                                                                  builder:
                                                                      (context) =>
                                                                          const JoinUberOneScreen(),
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
                                                            const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        child: Image.asset(
                                                          height:
                                                              double.infinity,
                                                          AssetNames.hamburger,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ))
                                                ],
                                              )),
                                        ),
                                        const Gap(10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Container(
                                              width: 350,
                                              // height: 140,
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
                                                                  color: Colors
                                                                      .white,
                                                                  text:
                                                                      'Use your promo and get there for less',
                                                                  size: AppSizes
                                                                      .bodySmall,
                                                                ),
                                                                Gap(3),
                                                                AppText(
                                                                  color: Colors
                                                                      .white,
                                                                  text:
                                                                      'Save on your next ride',
                                                                  size: AppSizes
                                                                      .bodySmallest,
                                                                ),
                                                              ]),
                                                          AppButton2(
                                                              text:
                                                                  'Request ride',
                                                              callback:
                                                                  () async {
                                                                await launchUrl(
                                                                    Uri.parse(
                                                                        'https://play.google.com/store/apps/details?id=com.ubercab'));
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        child: Image.asset(
                                                          height:
                                                              double.infinity,
                                                          AssetNames.whiteCar,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ))
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  MainScreenTopic(
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
                                          onTap: () => navigatorKey
                                              .currentState!
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
                                                        BorderRadius.circular(
                                                            12),
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
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left: 8.0,
                                                                      top: 8.0),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
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
                                                                        AppText(
                                                                            color:
                                                                                Colors.white,
                                                                            size: AppSizes.bodySmallest,
                                                                            text: '${popularStore.offers?.length == 1 ? popularStore.offers?.first.title : '${popularStore.offers?.length} Offers available'}'),
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
                                      itemCount: adverts.length,
                                      itemBuilder: (context, index) {
                                        final advert = adverts[index];
                                        final store = stores.firstWhere(
                                          (element) =>
                                              element.id == advert.shopId,
                                        );

                                        return Column(
                                          children: [
                                            MainScreenTopic(
                                                callback: () => navigatorKey
                                                        .currentState!
                                                        .push(MaterialPageRoute(
                                                      builder: (context) {
                                                        return AdvertScreen(
                                                            store: store,
                                                            productRefs: advert
                                                                .products);
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
                                                        advert.products[index];
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
                                                                  color: Colors
                                                                      .blue,
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
                                                              product: snapshot
                                                                  .data!,
                                                              store: store);
                                                        });
                                                  }),
                                            ),
                                          ],
                                        );
                                      }),
                                  MainScreenTopic(
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
                                                    alignment:
                                                        Alignment.topLeft,
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            store.cardImage,
                                                        width: double.infinity,
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
                                                                text: 'Closed',
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
                                                                .circular(20)),
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
                                                      link:
                                                          Weblinks.uberOneTerms,
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
                            );
                          }),
                    ),
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
    // logger.d(await FlutterUdid.consistentUdid);
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

    adverts = advertsSnapshot.docs.map(
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

    userInfo ??= await AppFunctions.getUserInfo();

    return userInfo['redeemedPromos'].length;
  }

  Future<void> _getLocation() async {
    Map<dynamic, dynamic>? userInfo =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    userInfo ??= await AppFunctions.getUserInfo();

    final location = Location();
    _currentLocation = await location.getLocation();
  }
}

class LocationWidget extends StatelessWidget {
  const LocationWidget(
      {super.key,
      required this.timePreference,
      required this.appStateBox,
      required LocationData? currentLocation})
      : _currentLocation = currentLocation;

  final DateTime? timePreference;
  final LocationData? _currentLocation;
  final Box<dynamic> appStateBox;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final locationFarAway = GlobalKey();
      Map userInfo = appStateBox.get(BoxKeys.userInfo);
      String? userPlaceDescription =
          userInfo['selectedAddress']['placeDescription'];

      storedUserLocation = GeoPoint(
          userInfo['selectedAddress']['latlng'].latitude,
          userInfo['selectedAddress']['latlng'].longitude);
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
                            LatLng(_currentLocation!.latitude!,
                                _currentLocation!.longitude!),
                            LatLng(storedUserLocation!.latitude,
                                storedUserLocation!.longitude));

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
                            text: AppFunctions.formatPlaceDescription(
                                    userPlaceDescription!)
                                .split(', ')
                                .first);
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
    });
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
                    await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) {
                        if (store.type.toLowerCase().contains('grocery')) {
                          return GroceryStoreMainScreen(store);
                        } else {
                          return StoreScreen(
                            store,
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
              return InkWell(
                onTap: () {
                  navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) {
                      if (store.type.toLowerCase().contains('grocery')) {
                        return GroceryStoreMainScreen(store);
                      } else {
                        return StoreScreen(
                          store,
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
                                                final castedProduct =
                                                    element.product
                                                        as DocumentReference;
                                                return castedProduct.path
                                                        .contains(product.id) &&
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

class MainScreenTopic extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback callback;
  final String? imageUrl;
  const MainScreenTopic({
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
