import 'dart:async';
import 'dart:math';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/product/product_screen.dart';

import '../../../../../main.dart';
import '../../../../../models/store/store_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/other_constants.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets.dart';
import '../../../home/home_screen.dart';

class GroceryShopSearchScreen extends StatefulWidget {
  final Store store;
  const GroceryShopSearchScreen({super.key, required this.store});

  @override
  State<GroceryShopSearchScreen> createState() =>
      _GroceryShopSearchScreenState();
}

class _GroceryShopSearchScreenState extends State<GroceryShopSearchScreen> {
  late List<String> _searchHistory;
  List<Map> _searchResults = [];
  List<Map> _filteredSearchResults = [];
  final _searchController = TextEditingController();
  Timer? _debounce;
  final List<String> _searchFilters = ['Sort', 'Aisle', 'Brand', 'Deals'];
  final _sortOptions = ['Price low to high', 'Price high to low'];
  bool _showSearchListView = true;
  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPrice;
  List<String> _selectedFilters = [];
  String? _selectedSort;

  final _topSearches = [
    'milk',
    'bread',
    'eggs',
    'candy',
    'beer',
    'water',
    'toilet paper'
  ];

  final Set<Aisle> _mayAlsoLikeAisles = {};

  List<String> _selectedAisles = [];

  @override
  void initState() {
    super.initState();
    _searchHistory = Hive.box<String>(AppBoxes.recentSearches)
        .values
        .toList()
        .reversed
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTextFormField(
          constraintWidth: 40,
          textInputAction: TextInputAction.search,
          controller: _searchController,
          // autofocus: true,
          onChanged: (value) async {
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () async {
              if (value != null) {
                _searchResults.clear();
                _mayAlsoLikeAisles.clear();
                if (widget.store.aisles == null) {
                  return;
                }
                if (value.isEmpty) {
                  setState(() {});
                  return;
                }

                for (var aisle in widget.store.aisles!) {
                  for (var productCategory in aisle.productCategories) {
                    for (var productAndQuantity
                        in productCategory.productsAndQuantities) {
                      // logger.d(productAndQuantity);
                      if (productAndQuantity.isNotEmpty &&
                          productAndQuantity['name']
                              .toLowerCase()
                              .contains(value.toLowerCase())) {
                        _mayAlsoLikeAisles.add(aisle);
                        // logger.d('yes');
                        _searchResults.add(productAndQuantity);
                      }
                    }
                  }
                }
                if (_searchResults.isNotEmpty &&
                    value.length > 2 &&
                    Hive.box<String>(AppBoxes.recentSearches).values.any(
                          (element) => !element.contains(value),
                        )) {
                  await Hive.box<String>(AppBoxes.recentSearches).add(value);

                  if (Hive.box<String>(AppBoxes.recentSearches).length > 10) {
                    await Hive.box<String>(AppBoxes.recentSearches).deleteAt(0);
                    _searchHistory = Hive.box<String>(AppBoxes.recentSearches)
                        .values
                        .toList()
                        .reversed
                        .toList();
                  }
                }

                setState(() {});
              }
            });
          },
          hintText: 'Search ${widget.store.name}',
          radius: 50,
          suffixIcon: Visibility(
            visible: _searchController.text.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _searchController.clear();
                });
              },
              child: const Icon(Icons.cancel),
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
                onTap: navigatorKey.currentState!.pop,
                child: Ink(child: const Icon(Icons.arrow_back))),
          ),
        ),
      ),
      body: Visibility(
        replacement: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChipsChoice<String>.multiple(
                choiceLeadingBuilder: (item, i) {
                  if (i > 2) {
                    return const Iconify(
                      AntDesign.tag,
                      size: 20,
                      color: AppColors.neutral500,
                    );
                  }
                  return null;
                },
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
                    // } else if (i == 6) {
                    //   if (_selectedDietaryOptions.isEmpty) {
                    //     return AppText(
                    //       text: item.label,
                    //     );
                    //   } else {
                    //     return AppText(
                    //         text:
                    //             '${item.label}(${_selectedDietaryOptions.length})');
                    //   }
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
                  if (i < 3) {
                    return const Icon(Icons.keyboard_arrow_down_sharp);
                  }
                  return null;
                },
                wrapped: false,
                padding: EdgeInsets.zero,
                value: _selectedFilters,
                onChanged: (value) {
                  // logger.d(value);

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
                    } else if (_searchFilters.indexOf(newFilter) == 0) {
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
                                      itemCount: _sortOptions.length,
                                      itemBuilder: (context, index) {
                                        final sortOption = _sortOptions[index];
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
                                          resetFilter(value, 0);
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
                    } else if (_searchFilters.indexOf(newFilter) == 1) {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          var temp = _selectedAisles;

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
                                      text: 'Aisles',
                                      size: AppSizes.bodySmall,
                                      weight: FontWeight.w600,
                                    )),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: widget.store.aisles == null
                                          ? 0
                                          : widget.store.aisles!.length,
                                      itemBuilder: (context, index) {
                                        final aisleOption =
                                            widget.store.aisles![index].name;
                                        return CheckboxListTile.adaptive(
                                          value: _selectedAisles
                                              .contains(aisleOption),
                                          title: AppText(text: aisleOption),
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value != null) {
                                                if (value) {
                                                  temp.add(aisleOption);
                                                } else {
                                                  temp.removeWhere(
                                                    (element) =>
                                                        element == aisleOption,
                                                  );
                                                }
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                                    const Gap(20),
                                    AppButton(
                                      text: 'Apply',
                                      callback: () {
                                        if (temp.isNotEmpty) {
                                          _selectedAisles = temp;

                                          setStateWithModal(value, newFilter);
                                        }
                                      },
                                    ),
                                    Center(
                                      child: AppTextButton(
                                        size: AppSizes.bodySmall,
                                        text: 'Reset',
                                        callback: () {
                                          _selectedAisles = [];
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
                    } else if (_searchFilters.indexOf(newFilter) == 3) {
                      //TODO: to implement
                      setState(() {
                        _selectedFilters.add('Deals');
                      });
                    }
                  }
                },
                choiceItems: C2Choice.listFrom<String, String>(
                  source: _searchFilters,
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
              const Divider(),
              const Gap(10),
              AppText(
                text:
                    '${_searchResults.length} ${_searchResults.length == 1 ? 'result' : 'results'}',
                weight: FontWeight.bold,
                size: AppSizes.body,
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final reference = _searchResults[index]['product'];
                  return FutureBuilder<Product>(
                      future: AppFunctions.loadProductReference(
                          reference as DocumentReference),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Skeletonizer(
                            enabled: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.neutral100,
                                  ),
                                  width: double.infinity,
                                  height: 120,
                                ),
                                const AppText(text: 'noalsfkm'),
                                const AppText(text: 'noalsfkjkslamklasfm')
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return AppText(text: snapshot.error.toString());
                        }
                        final product = snapshot.data!;
                        return GrocerySearchProductGridTile(
                          product: product,
                          store: widget.store,
                        );
                      });
                },
              ),

              //Implement you may also like Column widget in between grid

              if (_mayAlsoLikeAisles.isNotEmpty)
                Builder(builder: (context) {
                  var mayAlsoLikeAisle = _mayAlsoLikeAisles
                      .elementAt(Random().nextInt(_mayAlsoLikeAisles.length));
                  var mayAlsoLikeCategory = mayAlsoLikeAisle.productCategories[
                      Random()
                          .nextInt(mayAlsoLikeAisle.productCategories.length)];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'You may also like ${mayAlsoLikeCategory.name}',
                          weight: FontWeight.bold,
                          size: AppSizes.heading6,
                        ),
                        const Gap(15),
                        SizedBox(
                          height: 250,
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              final reference = mayAlsoLikeCategory
                                      .productsAndQuantities[index
                                  // Random().nextInt(mayAlsoLikeCategory
                                  //     .productsAndQuantities
                                  //     .length)
                                  ]['product'];
                              return FutureBuilder<Product>(
                                  future: AppFunctions.loadProductReference(
                                      reference as DocumentReference),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Skeletonizer(
                                        enabled: true,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors.neutral100,
                                              ),
                                              width: 70,
                                              height: 70,
                                            ),
                                            const AppText(text: 'noalsfkm'),
                                            const AppText(
                                                text: 'noalsfkjkslamklasfm')
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return SizedBox(
                                        width: 70,
                                        child: AppText(
                                            text: snapshot.error.toString()),
                                      );
                                    }
                                    final product = snapshot.data!;
                                    return ProductGridTilePriceFirst(
                                        product: product, store: widget.store);
                                  });
                            },
                            itemCount: mayAlsoLikeCategory
                                .productsAndQuantities.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => const Gap(10),
                          ),
                        )
                      ]);
                })
            ],
          ),
        ),
        visible: _showSearchListView,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: _searchController.text.isEmpty
              ? InitialSearchPage2(
                  searchWithListTile: _searchStoresWithOtherListTile,
                  searchHistory: _searchHistory,
                  topSearches: _topSearches)
              : _searchResults.isEmpty
                  ? const Center(child: NoSearchResult())
                  //restaurants
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              _showSearchListView = false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.search),
                          title: AppText(text: _searchResults[index]['name']),
                        );
                      },
                      itemCount: _searchResults.length < 10
                          ? _searchResults.length
                          : 10),
        ),
      ),
    );
  }

  void _searchStoresWithOtherListTile(String query) {
    _searchResults = [];
    if (widget.store.aisles == null) {
      return;
    } else {
      for (var aisle in widget.store.aisles!) {
        for (var productCat in aisle.productCategories) {
          for (var productAndQuantity in productCat.productsAndQuantities) {
            if (productAndQuantity['name']
                .toLowerCase()
                .contains(query.toLowerCase())) {
              _searchResults.add(productAndQuantity);
            }
          }
        }
      }
    }

    // TODO: store products gotten here in seperare variables to display per store to prevent looping through
    // all products again to find those that contain the search query/value to render them
    setState(() {
      _searchController.text = query;
    });
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
        // _onFilterScreen = false;
      }
    });
  }

  Future<void> setStateWithModal(List<String> value, String newFilter) async {
    //TODO: implement filters
    // if (_selectedFilters.isNotEmpty) {
    //   _filteredSearchResults.clear();
    //   if (_selectedFilters.any(
    //     (element) => element == 'Aisles',
    //   )) {
    //     for (var aisle in widget.store.aisles!) {
    //       if (_selectedAisles.any(
    //         (element) => element == aisle.name,
    //       )) {
    //         for (var productCategory in aisle.productCategories) {
    //           for (var productAndQuantity
    //               in productCategory.productsAndQuantities) {
    //             // logger.d(productAndQuantity);
    //             if (productAndQuantity.isNotEmpty &&
    //                 productAndQuantity['name']
    //                     .toLowerCase()
    //                     .contains(_searchController.text.toLowerCase())) {
    //               _mayAlsoLikeAisles.add(aisle);
    //               // logger.d('yes');
    //               _filteredSearchResults.add(productAndQuantity);
    //             }
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
    // if (_selectedSort != null) {
    //   if(_selectedSort == "")
    //  _filteredSearchResults.sort(
    //   (a, b) => b[''].compareTo(a.visits),
    //  )

    //       .orderBy('initialPrice',
    //           descending: _selectedSort == 'Price low to high' ? false : true)
    //       .get();
    //   if (_selectedSort == 'Rating') {
    //     _filteredSearchResults.sort(
    //       (a, b) => b.rating.averageRating.compareTo(a.rating.averageRating),
    //     );
    //   } else if (_selectedSort == 'Delivery time') {
    //     storesList.sort(
    //       (a, b) => int.parse(a.delivery.estimatedDeliveryTime.split('-').first)
    //           .compareTo(
    //               int.parse(b.delivery.estimatedDeliveryTime.split('-').first)),
    //     );
    //   }
    // }

    navigatorKey.currentState!.pop();
    setState(() {
      if (!_selectedFilters.contains(newFilter)) {
        _selectedFilters.add(newFilter);
        _filteredSearchResults = _searchResults;
      }

      // _onFilterScreen = true;
    });
  }
}

class GrocerySearchProductGridTile extends StatelessWidget {
  const GrocerySearchProductGridTile(
      {super.key,
      required this.product,
      this.height = 120,
      required this.store});
  final Store store;
  final Product product;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            // ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child:
            AppFunctions.displayNetworkImage(product.imageUrls.first,
                width: double.infinity, height: height)
            // )
            ,
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                child: AddToCartButton(product: product, store: store))
          ],
        ),
        const Gap(5),
        Row(
          children: [
            Visibility(
              visible: product.promoPrice != null,
              child: AppText(
                  text: '\$${product.promoPrice} ', color: Colors.green),
            ),
            AppText(
              text: '\$${product.initialPrice}',
              decoration: product.promoPrice != null
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
            AppText(
                text: '• ${product.quantity ?? ''}',
                color: AppColors.neutral500)
          ],
        ),
        AppText(
          text: product.name,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          color: AppColors.neutral500,
        ),
        if (product.promoPrice != null)
          Container(
              decoration: BoxDecoration(
                  color: Colors.green.shade900,
                  borderRadius: BorderRadius.circular(50)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: AppText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  text:
                      '${(((product.initialPrice - product.promoPrice!) / product.initialPrice) * 100).toStringAsFixed(0)}% off')),
        if (product.isSponsored ?? false)
          const AppText(text: 'Sponsored', color: AppColors.neutral500)
      ],
    );
  }
}
