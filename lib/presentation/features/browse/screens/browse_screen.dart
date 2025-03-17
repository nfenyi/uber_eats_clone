import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/send_gifts_screen.dart';

import '../../../../main.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/widgets.dart';
import '../../alcohol/alcohol_screen.dart';
import '../../box_catering/screens/box_catering_screens.dart';
import '../../grocery_grocery/grocery_grocery_screen.dart';
import '../../home/home_screen.dart';
import '../../home/screens/search_screen.dart';
import '../../pharmacy/screens/pharmacy_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final List<FoodCategory> _shopsNearYou = [
    FoodCategory('Grocery', AssetNames.grocery2),
    FoodCategory('Convenience', AssetNames.convenience),
    FoodCategory('Alcohol', AssetNames.alcohol),
    FoodCategory('Gifts', AssetNames.gift),
    FoodCategory('Pharmacy', AssetNames.pharmacy),
    FoodCategory('Baby', AssetNames.babyBottle),
    FoodCategory('Specialty Foods', AssetNames.specialtyFoods),
    FoodCategory('Pet Supplies', AssetNames.petSupplies),
    FoodCategory('Retail', AssetNames.retail),
    //TODO: implement offers
    FoodCategory('Box Catering', AssetNames.boxCatering),
  ];
  final List<FoodCategory> _foodNearYou = [
    FoodCategory('Breakfast and Brunch', AssetNames.breakfastNBrunch),
    FoodCategory('Kosher', AssetNames.kosher),
    FoodCategory('Deli', AssetNames.deli),
    FoodCategory('Pizza', AssetNames.pizzaImage),
    //TODO: implement best overall
    FoodCategory('Best Overall', AssetNames.bestOverall),
    FoodCategory('Fast Food', AssetNames.fastFoodImage),
    FoodCategory('Healthy', AssetNames.healthyImage),
    FoodCategory('Halal', AssetNames.halal),
    FoodCategory('Vegetarian Friendly', AssetNames.vegetarianFriendly),
    FoodCategory('Cantonese', AssetNames.cantonese),

    FoodCategory('Kids Friendly', AssetNames.kidsFriendly),
    FoodCategory('Traditional American', AssetNames.traditionalAmerican),
    FoodCategory('Israeli', AssetNames.israeli),
    FoodCategory('Eastern European', AssetNames.easternEuropean),
    FoodCategory('Arab', AssetNames.arab),
  ];
  final List<Store> _groceryGroceryStores = [];
  final List<Store> _convenienceStores = [];
  final List<Store> _alcoholStores = [];
  final List<Store> _pharmacyStores = [];
  List<Store> _groceryScreenStores = [];
  final List<Store> _boxCateringStores = [];
  final List<Store> _babyStores = [];
  final List<Store> _specialtyFoodsStores = [];
  final List<Store> _petSuppliesStores = [];
  final List<Store> _retailStores = [];

  @override
  void initState() {
    super.initState();
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

      if (store.type.contains('Retail')) {
        _retailStores.add(store);
      }
      if (store.type.contains('Box Catering')) {
        _boxCateringStores.add(store);
      }
    }
    _groceryScreenStores = List<Store>.from([
      ..._groceryGroceryStores,
      ..._convenienceStores,
      ..._alcoholStores,
      ..._pharmacyStores,
      ..._babyStores,
      ..._specialtyFoodsStores,
      ..._petSuppliesStores,
      ..._retailStores,
      ..._boxCateringStores
    ]).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    titleSpacing: 0,
                    //TODO: change appbar 'surfaceTintColor' at the main screen level
                    surfaceTintColor: Colors.white,
                    pinned: true,
                    floating: true,
                    title: InkWell(
                      onTap: () =>
                          navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => SearchScreen(
                          userLocation: Hive.box(AppBoxes.appState)
                              .get(BoxKeys.userInfo)['addresses']['latlng'],
                          stores: stores,
                        ),
                      )),
                      child: Ink(
                        child: const AppTextFormField(
                          enabled: false,
                          hintText: 'Search Uber Eats',
                          constraintWidth: 40,
                          radius: 50,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SliverToBoxAdapter(
                  //   child: InkWell(
                  //     onTap: () =>
                  //         navigatorKey.currentState!.push(MaterialPageRoute(
                  //       builder: (context) => SearchScreen(
                  //         stores: stores,
                  //       ),
                  //     )),
                  //     child: Ink(
                  //       child: const AppTextFormField(
                  //         enabled: false,
                  //         hintText: 'Search Uber Eats',
                  //         constraintWidth: 40,
                  //         radius: 50,
                  //         prefixIcon: Icon(
                  //           Icons.search,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ];
              },
              body: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10),
                        AppText(
                          text: 'Shops near you',
                          size: AppSizes.heading6,
                          weight: FontWeight.w600,
                        ),
                        Gap(5),
                      ],
                    ),
                  ),
                  SliverGrid.builder(
                    itemCount: _shopsNearYou.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 80,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      final shopNearYou = _shopsNearYou[index];
                      return InkWell(
                        onTap: () {
                          if (shopNearYou.name == 'Grocery') {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => GroceryGroceryScreen(
                                  stores: _groceryGroceryStores),
                            ));
                          } else if (shopNearYou.name == 'Alcohol') {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) =>
                                  AlcoholScreen(alcoholStores: _alcoholStores),
                            ));
                          } else if (shopNearYou.name == 'Pharmacy') {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => PharmacyScreen(
                                  pharmacyStores: _pharmacyStores),
                            ));
                          } else if (shopNearYou.name == 'Gifts') {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => const SendGiftsScreen(),
                            ));
                          } else if (shopNearYou.name == 'Box Catering') {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => BoxCateringScreen(
                                boxCateringStores: _boxCateringStores,
                              ),
                            ));
                          }
                        },
                        child: SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              Image.asset(
                                shopNearYou.image,
                                height: 45,
                              ),
                              AppText(
                                text: shopNearYou.name,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10),
                        AppText(
                          text: 'Food near you',
                          size: AppSizes.heading6,
                          weight: FontWeight.w600,
                        ),
                        Gap(5),
                      ],
                    ),
                  ),
                  SliverGrid.builder(
                    itemCount: _foodNearYou.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 140,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 0,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final foodNearYou = _foodNearYou[index];
                      return InkWell(
                        onTap: () {
                          // if (index == 0) {
                          //   navigatorKey.currentState!.push(MaterialPageRoute(
                          //     builder: (context) => GroceryGroceryScreen(
                          //         stores: _groceryGroceryStores),
                          //   ));
                          // } else if (index == 2) {
                          //   navigatorKey.currentState!.push(MaterialPageRoute(
                          //     builder: (context) =>
                          //         AlcoholScreen(alcoholStores: _alcoholStores),
                          //   ));
                          // } else if (index == 4) {
                          //   navigatorKey.currentState!.push(MaterialPageRoute(
                          //     builder: (context) => PharmacyScreen(
                          //         pharmacyStores: _pharmacyStores),
                          //   ));
                          // }
                        },
                        child: Ink(
                          child: SizedBox(
                            width: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  foodNearYou.image,
                                  height: 100,
                                ),
                                AppText(
                                  text: foodNearYou.name,
                                  size: AppSizes.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )));
  }
}
