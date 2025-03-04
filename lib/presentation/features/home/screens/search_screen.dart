import 'dart:async';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import '../../../core/widgets.dart';
import '../home_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<Store> stores;
  // final List<Product> products;
  const SearchScreen({
    super.key,
    required this.stores,
    // required this.products
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  List<Store> _groceryStoresWithProduct = [];
  List<Store> _restaurantsWithProduct = [];
  List<Store> _alcoholStoresWithProduct = [];
  List<Store> _groceryStores = [];
  List<Store> _restaurants = [];
  List<Store> _alcoholStores = [];
  final _searchController = TextEditingController();

  void _filterSearchResults(List<Store> searchedStores) {
    Iterable<Store> filteredSearchedStores = searchedStores;
    if (_selectedFilters.contains('Uber One')) {
      filteredSearchedStores = filteredSearchedStores.where(
        (store) => store.isUberOneShop,
      );
    }
    if (_selectedFilters.contains('Pickup')) {
      filteredSearchedStores = filteredSearchedStores.where(
        (store) => store.doesPickup,
      );
    }
    if (_selectedFilters.contains('Offers')) {
      filteredSearchedStores = filteredSearchedStores.where(
        (store) => store.offers != null && store.offers!.isNotEmpty,
      );
    }
    if (_selectedFilters.contains('Delivery fee')) {
      filteredSearchedStores = filteredSearchedStores.where(
        (store) => store.delivery.fee == _selectedDeliveryFee,
      );
    }
    if (_selectedFilters.contains('Price')) {
      filteredSearchedStores = filteredSearchedStores.where(
        (store) => store.priceCategory == _selectedPriceCategory,
      );
    }
  }

  void _searchStoresWithCategory(String query) {
    _groceryStores = [];
    _restaurants = [];
    _alcoholStores = [];
    _groceryStoresWithProduct = [];
    _restaurantsWithProduct = [];
    _alcoholStoresWithProduct = [];

    _stores = widget.stores.where((store) {
      if (store.type.toLowerCase().contains(query.toLowerCase())) {
        if (store.type.toLowerCase().contains('grocery')) {
          _groceryStores.add(store);
          // if (store.aisles == null) {
          //   return false;
          // } else {
          // return store.aisles!.any((aisle) {
          //   return aisle.productCategories.any((productCategory) =>
          //       productCategory.productsAndQuantities
          //           .any((productAndQuantity) {
          //         if (productAndQuantity['name']
          //             .toLowerCase()
          //             .contains(query)) {
          //           _groceryStoresWithProduct.add(store);
          //         }
          //         return true;
          //       }));
          // });
          // }
        } else if (store.type.toLowerCase().contains('alcohol')) {
          _alcoholStores.add(store);
          // if (store.aisles == null) {
          //   return false;
          // } else {
          // return store.aisles!.any((aisle) {
          //   return aisle.productCategories.any((productCategory) =>
          //       productCategory.productsAndQuantities
          //           .any((productAndQuantity) {
          //         if (productAndQuantity['name']
          //             .toLowerCase()
          //             .contains(query)) {
          //           _groceryStoresWithProduct.add(store);
          //         }
          //         return true;
          //       }));
          // });
          // }
        }
        if (store.type.toLowerCase().contains('restaurant')) {
          _restaurants.add(store);
          // if (store.aisles == null) {
          //   return false;
          // } else {
          // return store.aisles!.any((aisle) {
          //   return aisle.productCategories.any((productCategory) =>
          //       productCategory.productsAndQuantities
          //           .any((productAndQuantity) {
          //         if (productAndQuantity['name']
          //             .toLowerCase()
          //             .contains(query)) {
          //           _groceryStoresWithProduct.add(store);
          //         }
          //         return true;
          //       }));
          // });
          // }
        }
        // {
        //   return store.productCategories!.any((productCategory) =>
        //       productCategory.productsAndQuantities.any((productAndQuantity) {
        //         if (productAndQuantity['name'].toLowerCase().contains(query)) {
        //           if (store.type.toLowerCase().contains('restaurant')) {
        //             _restaurantsWithProduct.add(store);
        //           } else if (store.type.toLowerCase().contains('alcohol')) {
        //             _alcoholStoresWithProduct.add(store);
        //           }
        //           return true;
        //         }
        //         return false;
        //       }));
        // }
        return true;
      } else {
        return false;
      }
    }).toList();

    // TODO: store products gotten here in seperare variables to display per store to prevent looping through
    // all products again to find those that contain the search query/value to render them
    setState(() {
      _searchController.text = query;
    });
  }

  void _searchStoresWithOtherListTile(String query) {
    _groceryStores = [];
    _restaurants = [];
    _alcoholStores = [];
    _groceryStoresWithProduct = [];
    _restaurantsWithProduct = [];
    _alcoholStoresWithProduct = [];

    _stores = widget.stores.where((store) {
      if (store.type.toLowerCase().contains('grocery')) {
        if (store.aisles == null) {
          return false;
        } else {
          return store.aisles!.any((aisle) {
            return aisle.productCategories.any((productCategory) =>
                productCategory.productsAndQuantities.any((productAndQuantity) {
                  if (productAndQuantity['name']
                      .toLowerCase()
                      .contains(query)) {
                    _groceryStoresWithProduct.add(store);
                    return true;
                  }
                  return false;
                }));
          });
        }
      } else {
        return store.productCategories!.any((productCategory) =>
            productCategory.productsAndQuantities.any((productAndQuantity) {
              if (productAndQuantity['name'].toLowerCase().contains(query)) {
                if (store.type.toLowerCase().contains('restaurant')) {
                  _restaurantsWithProduct.add(store);
                } else if (store.type.toLowerCase().contains('alcohol')) {
                  _alcoholStoresWithProduct.add(store);
                }
                return true;
              }
              return false;
            }));
      }
    }).toList();

    // TODO: store products gotten here in seperare variables to display per store to prevent looping through
    // all products again to find those that contain the search query/value to render them
    setState(() {
      _searchController.text = query;
    });
  }

  late List<String> _searchHistory;
  final List<String> _topSearches = [
    'milk',
    'bread',
    'eggs',
    'candy',
    'beer',
    'water',
    'toilet paper'
  ];
  List<Store> _stores = [];
  final List<String> _filters = [
    'Uber One',
    'Pickup',
    'Offers',
    'Delivery fee',
    // 'Rating',
    'Price',
    'Dietary',
    'Sort'
  ];
  List<String> _selectedFilters = [];
  Timer? _debounce;

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

  late final TabController _tabController;

  final double _selectedDeliveryFee = 3;

  final String _selectedPriceCategory = '';

  @override
  void initState() {
    super.initState();
    _searchHistory = Hive.box<String>(AppBoxes.recentSearches)
        .values
        .toList()
        .reversed
        .toList();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDayNow = TimeOfDay.now();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Gap(15),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppTextFormField(
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce =
                      Timer(const Duration(milliseconds: 1500), () async {
                    _groceryStores = [];
                    _restaurants = [];
                    _alcoholStores = [];
                    _groceryStoresWithProduct = [];
                    _restaurantsWithProduct = [];
                    _alcoholStoresWithProduct = [];
                    if (value != null) {
                      if (value.isEmpty) {
                        setState(() {});
                      } else {
                        //       final snapshot = await FirebaseFirestore.instance
                        //     .collection(FirestoreCollections.stores).where('aisles')

                        //     .get();

                        // DocumentReference reference =
                        //     data!['productCategories'].first['products'].first;
                        // logger.d(reference.id);
                        setState(() {
                          _stores = widget.stores.where((store) {
                            if (store.type.toLowerCase().contains('grocery')) {
                              if (store.aisles == null) {
                                return false;
                              } else {
                                return store.aisles!.any((aisle) {
                                  return aisle.productCategories.any(
                                      (productCategory) => productCategory
                                              .productsAndQuantities
                                              .any((productAndQuantity) {
                                            if (productAndQuantity['name']
                                                .toLowerCase()
                                                .contains(value)) {
                                              _groceryStoresWithProduct
                                                  .add(store);
                                              return true;
                                            }
                                            return false;
                                          }));
                                });
                              }
                            } else {
                              return store.productCategories!.any(
                                  (productCategory) => productCategory
                                          .productsAndQuantities
                                          .any((productAndQuantity) {
                                        if (productAndQuantity['name']
                                            .toLowerCase()
                                            .contains(value)) {
                                          if (store.type
                                              .toLowerCase()
                                              .contains('restaurant')) {
                                            _restaurantsWithProduct.add(store);
                                          } else if (store.type
                                              .toLowerCase()
                                              .contains('alcohol')) {
                                            _alcoholStoresWithProduct
                                                .add(store);
                                          }
                                          return true;
                                        }
                                        return false;
                                      }));
                            }
                          }).toList();

                          // TODO: store products gotten here in seperare variables to display per store to prevent looping through
                          // all products again to find those that contain the search query/value to render them
                        });
                        if (_stores.isNotEmpty &&
                            value.length > 2 &&
                            Hive.box<String>(AppBoxes.recentSearches)
                                .values
                                .any(
                                  (element) => !element.contains(value),
                                )) {
                          await Hive.box<String>(AppBoxes.recentSearches)
                              .add(value);

                          if (Hive.box<String>(AppBoxes.recentSearches).length >
                              10) {
                            await Hive.box<String>(AppBoxes.recentSearches)
                                .deleteAt(0);
                            _searchHistory =
                                Hive.box<String>(AppBoxes.recentSearches)
                                    .values
                                    .toList()
                                    .reversed
                                    .toList();
                          }
                        }
                      }
                    }
                  });
                },
                controller: _searchController,
                // onTapOutside: (pointerDownEvent) {
                //   setState(() {
                //     _onSearchScreen = false;
                //   });
                // },
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                        child: const Icon(Icons.cancel))
                    : null,

                // onTap: () {
                //   setState(() {
                //     if (_onSearchScreen) {
                //       _onSearchScreen = false;
                //     }
                //   });
                // },
                hintText: 'Search Uber Eats',
                radius: 50,
                constraintWidth: 40,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: () {
                      navigatorKey.currentState!.pop();
                    },
                    child: Ink(
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(10),
            Column(
              children: [
                // Row(
                //   children: [
                TabBar(
                  isScrollable: true,
                  tabs: const [
                    AppText(text: 'All'),
                    AppText(text: 'Restaurants'),
                    AppText(text: 'Grocery'),
                    AppText(text: 'Alcohol'),
                  ],
                  controller: _tabController,
                ),
                //   ],
                // ),
                const Gap(10),
                if (_searchController.text.isNotEmpty)
                  ChipsChoice<String>.multiple(
                    wrapped: false,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    value: _selectedFilters,
                    onChanged: (value) {
                      // ref
                      //     .read(inspectionResolutionProvider.notifier)
                      //     .updateProperties(neighbourhoodClass: value);

                      if (value.contains('Uber One')) {}

                      setState(() {
                        _selectedFilters = value;
                      });
                    },
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: _filters,
                      value: (i, v) => v,
                      label: (i, v) => v,
                    ),
                    choiceStyle: C2ChipStyle.filled(
                      selectedStyle: const C2ChipStyle(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
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
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _searchController.text.isEmpty
                      ? InitialSearchPage1(
                          searchHistory: _searchHistory,
                          searchStoresWithCategory: _searchStoresWithCategory,
                          searchStoresWithOtherListTile:
                              _searchStoresWithOtherListTile,
                          foodCategories: _foodCategories)
                      : _stores.isEmpty
                          ? NoSearchResult(_tabController)
                          //all stores
                          : AllStoresResultDisplay(
                              timeOfDayNow: timeOfDayNow,
                              storesWithNameOrProduct: _stores),
                  _searchController.text.isEmpty
                      ? InitialSearchPage2(
                          searchWithListTile: _searchStoresWithOtherListTile,
                          searchHistory: _searchHistory,
                          topSearches: _topSearches)
                      : _restaurantsWithProduct.isEmpty && _restaurants.isEmpty
                          ? NoSearchResult(_tabController)
                          //restaurants
                          : SearchResultDisplay(
                              query: _searchController.text,
                              showProducts: _restaurantsWithProduct.isNotEmpty,
                              storesWithProduct: _restaurantsWithProduct.isEmpty
                                  ? _restaurants
                                  : _restaurantsWithProduct),
                  _searchController.text.isEmpty
                      ? InitialSearchPage2(
                          searchWithListTile: _searchStoresWithOtherListTile,
                          searchHistory: _searchHistory,
                          topSearches: _topSearches)
                      : _groceryStoresWithProduct.isEmpty &&
                              _groceryStores.isEmpty
                          ? NoSearchResult(_tabController)
                          //groceries
                          : SearchResultDisplay(
                              showProducts:
                                  _groceryStoresWithProduct.isNotEmpty,
                              query: _searchController.text,
                              storesWithProduct:
                                  _groceryStoresWithProduct.isEmpty
                                      ? _groceryStores
                                      : _groceryStoresWithProduct),
                  _searchController.text.isEmpty
                      ? InitialSearchPage2(
                          searchWithListTile: _searchStoresWithOtherListTile,
                          searchHistory: _searchHistory,
                          topSearches: _topSearches)
                      : _alcoholStoresWithProduct.isEmpty &&
                              _alcoholStores.isEmpty
                          ? NoSearchResult(_tabController)
                          //alcohol
                          : SearchResultDisplay(
                              showProducts:
                                  _alcoholStoresWithProduct.isNotEmpty,
                              query: _searchController.text,
                              storesWithProduct:
                                  _alcoholStoresWithProduct.isEmpty
                                      ? _alcoholStores
                                      : _alcoholStoresWithProduct),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
