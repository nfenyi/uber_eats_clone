import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';

import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import '../../../core/widgets.dart';
import '../home_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<Store> stores;
  const SearchScreen({super.key, required this.stores});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  void _updateSearchScreenWithValue(String query) {
    setState(() {
      _searchController.text = query;
    });
  }

  final List<String> _searchHistory = ['Pharmacy', 'Fries'];
  final List<String> _topSearches = [
    'milk',
    'bread',
    'eggs',
    'candy',
    'water',
    'toilet paper'
  ];
  List<Store> _storesWithNameOrProduct = [];
  final List<String> _filters = [
    'Uber One',
    'Pickup',
    'Offers',
    'Delivery fee',
    'Rating',
    'Price',
    'Dietary',
    'Sort'
  ];
  List<String> _selectedFilters = [];

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDayNow = TimeOfDay.now();
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: AppTextFormField(
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        _storesWithNameOrProduct = widget.stores
                            .where((store) =>
                                store.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                store.products.any(
                                  (product) {
                                    return product.name
                                        .toLowerCase()
                                        .contains(value);
                                    //TODO: store products gotten here in seperare variables to display per store to prevent looping through
                                    //all products again to find those that contain the search query/value to render them
                                  },
                                ))
                            .toList();
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
                          child: const Icon(FontAwesomeIcons.circleXmark))
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: InkWell(
                      onTap: () {
                        navigatorKey.currentState!.pop();
                      },
                      child: Ink(
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(10),
              Column(
                children: [
                  const TabBar(
                      labelPadding: EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall,
                          vertical: 8),
                      dividerHeight: 3,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      tabs: [
                        AppText(text: 'All'),
                        AppText(text: 'Restaurants'),
                        AppText(text: 'Grocery'),
                        AppText(text: 'Alcohol'),
                      ]),
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
              Expanded(
                child: TabBarView(children: [
                  _searchController.text.isEmpty
                      ? InitialSearchPage1(
                          searchHistory: _searchHistory,
                          updateSearchScreenWithValue:
                              _updateSearchScreenWithValue,
                          foodCategories: _foodCategories)
                      : _storesWithNameOrProduct.isEmpty
                          ? NoSearchResult(searchController: _searchController)
                          : SearchResultDisplay1(
                              timeOfDayNow: timeOfDayNow,
                              storesWithNameOrProduct:
                                  _storesWithNameOrProduct),
                  _searchController.text.isEmpty
                      ? InitialSearchPage2(
                          searchHistory: _searchHistory,
                          topSearches: _topSearches)
                      : _storesWithNameOrProduct.isEmpty
                          ? NoSearchResult(searchController: _searchController)
                          : SearchResultDisplay2(
                              storesWithProduct: _storesWithNameOrProduct),
                  _searchController.text.isEmpty
                      ? InitialSearchPage2(
                          searchHistory: _searchHistory,
                          topSearches: _topSearches)
                      : _storesWithNameOrProduct.isEmpty
                          ? NoSearchResult(searchController: _searchController)
                          : SearchResultDisplay2(
                              storesWithProduct: _storesWithNameOrProduct),
                  _searchController.text.isEmpty
                      ? InitialSearchPage2(
                          searchHistory: _searchHistory,
                          topSearches: _topSearches)
                      : _storesWithNameOrProduct.isEmpty
                          ? NoSearchResult(searchController: _searchController)
                          : SearchResultDisplay2(
                              storesWithProduct: _storesWithNameOrProduct),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
