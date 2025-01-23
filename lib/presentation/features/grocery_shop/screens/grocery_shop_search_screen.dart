import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/other_constants.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets.dart';
import '../../home/home_screen.dart';
import '../../sign_in/views/drop_off_options_screen.dart';

class GroceryShopSearchScreen extends StatefulWidget {
  final Store store;
  const GroceryShopSearchScreen({super.key, required this.store});

  @override
  State<GroceryShopSearchScreen> createState() =>
      _GroceryShopSearchScreenState();
}

class _GroceryShopSearchScreenState extends State<GroceryShopSearchScreen> {
  final List<String> _popularSearches = [];
  Set<Product> _searchResults = {};
  final _searchController = TextEditingController();
  Timer? _debounce;
  final List<String> _searchFilters = ['Sort', 'Aisle', 'Brand', 'Deals'];

  bool _showSearchListView = true;
  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPrice;
  List<String> _selectedFilters = [];
  String? _selectedSort;

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
          textInputAction: TextInputAction.search,
          controller: _searchController,
          // autofocus: true,
          onChanged: (value) {
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              if (value != null) {
                final lowerCaseValue = value.toLowerCase();

                for (var productCategory in widget.store.productCategories) {
                  for (var product in productCategory.products) {
                    if (product.name.toLowerCase().contains(lowerCaseValue)) {
                      _searchResults.add(product);
                    }
                  }
                }

                setState(() {});
              }
            });
          },
          hintText: 'Search ${widget.store.name}',
          radius: 50,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _searchController.clear();
              });
            },
            child: const Icon(Icons.cancel),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.search),
          ),
        ),
      ),
      body: Visibility(
        replacement: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall,
          ),
          child: Column(
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
                    if (_searchFilters.indexOf(newFilter) == 3) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          late int temp;

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
                                        // if (value.isNotEmpty) {
                                        //   _onFilterScreen = true;
                                        // } else {
                                        //   _onFilterScreen = false;
                                        // }
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
                                                element == _searchFilters[3],
                                          );

                                          _selectedFilters = temp;
                                          _selectedDeliveryFeeIndex = null;

                                          // if (temp.isNotEmpty) {
                                          //   _onFilterScreen = true;
                                          // } else {
                                          //   _onFilterScreen = false;
                                          // }
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
                    } else if (_searchFilters.indexOf(newFilter) == 4) {
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
                                        // if (value.isNotEmpty) {
                                        //   _onFilterScreen = true;
                                        // } else {
                                        //   _onFilterScreen = false;
                                        // }
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
                                                element == _searchFilters[4],
                                          );
                                          _selectedFilters = temp;
                                          _selectedRatingIndex = null;
                                          // if (temp.isNotEmpty) {
                                          //   _onFilterScreen = true;
                                          // } else {
                                          //   _onFilterScreen = false;
                                          // }
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
                    } else if (_searchFilters.indexOf(newFilter) == 5) {
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
                                      _selectedPrice = temp;

                                      navigatorKey.currentState!.pop();
                                      setState(() {
                                        _selectedFilters = value;
                                        // if (value.isNotEmpty) {
                                        //   _onFilterScreen = true;
                                        // } else {
                                        //   _onFilterScreen = false;
                                        // }
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
                                                element == _searchFilters[5],
                                          );
                                          _selectedFilters = temp;
                                          _selectedPrice = null;
                                          // if (value.isNotEmpty) {
                                          //   _onFilterScreen = true;
                                          // } else {
                                          //   _onFilterScreen = false;
                                          // }
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
                    } else if (_searchFilters.indexOf(newFilter) == 7) {
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
                                        // if (value.isNotEmpty) {
                                        //   _onFilterScreen = true;
                                        // } else {
                                        //   _onFilterScreen = false;
                                        // }
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
                                                element == _searchFilters[7],
                                          );
                                          _selectedFilters = temp;
                                          _selectedSort = null;
                                          // if (value.isNotEmpty) {
                                          //   _onFilterScreen = true;
                                          // } else {
                                          //   _onFilterScreen = false;
                                          // }
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
              AppText(text: '${_searchResults.length} results'),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final product = _searchResults.elementAt(index);
                    return GrocerySearchProductGridTile(product: product);
                  },
                  //Implement you may also like Column widget in between grid
                  /*
                final mayAlsoLike =  widget.store.productCategories[Random().nextInt(widget.store.productCategories.length)];
                  Column(children:[
                    AppText(text:'You may also like ${mayAlsoLike.name}'),
                    ListView.separated(itemBuilder: (context, index){
                      final product = mayAlsoLike.products[index];
                      return GrocerySearchProductGridTile(product: product);
                    },itemCount: mayAlsoLike.products.length,scrollDirection: Axis.horizontal, separatorBuilder: (context, index) => const Gap(10), )
                  ])
                  */
                ),
              )
            ],
          ),
        ),
        visible: _showSearchListView,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: _searchController.text.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),
                    const AppText(
                      text: 'Popular searches',
                      size: AppSizes.body,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                _searchController.text =
                                    _popularSearches[index];
                                _showSearchListView = false;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.search),
                            title: AppText(text: _popularSearches[index]),
                          );
                        },
                        itemCount: _popularSearches.length,
                      ),
                    )
                  ],
                )
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
                      title:
                          AppText(text: _searchResults.elementAt(index).name),
                    );
                  },
                  itemCount:
                      _searchResults.length < 10 ? _searchResults.length : 10),
        ),
      ),
    );
  }
}

class GrocerySearchProductGridTile extends StatelessWidget {
  const GrocerySearchProductGridTile({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: product.imageUrls.first,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
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
            //  TODO: To uncomment: quantity is not yet mandatory, its nullable
            // AppText(text: '• ${product.quantity}',color: AppColors.neutral500)
          ],
        ),
        AppText(
          text: product.name,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (product.promoPrice != null)
          AppTextBadge(
              text:
                  '${(((product.initialPrice - product.promoPrice!) / product.initialPrice) * 100).toStringAsFixed(0)}% off'),
        if (product.isSponsored ?? false)
          const AppText(text: 'Sponsored', color: AppColors.neutral500)
      ],
    );
  }
}
