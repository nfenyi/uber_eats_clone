import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';

import '../../../../app_functions.dart';
import '../../../../main.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/other_constants.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

import '../../../core/widgets.dart';
import '../../home/home_screen.dart';
import '../../main_screen/screens/main_screen.dart';
import '../../sign_in/views/drop_off_options_screen.dart';

class GenericCategoryScreen extends ConsumerStatefulWidget {
  const GenericCategoryScreen({super.key});

  @override
  ConsumerState<GenericCategoryScreen> createState() =>
      _GenericCategoryScreenState();
}

class _GenericCategoryScreenState extends ConsumerState<GenericCategoryScreen> {
  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPriceCategory;
  List<String> _selectedDietaryOptions = [];
  List<String> _selectedFilters = [];
  String? _selectedSort;

  List<Store> _categoryStores = [];

  late final String _selectedCategory;

  List<Store> _filteredStores = [];

  final _filters = OtherConstants.filters;

  Future<void> _getCategoryStores() async {
    // var query = await FirebaseFirestore.instance
    //     .collection(FirestoreCollections.stores)
    //     .get();
    // var query = FirebaseFirestore.instance
    //     .collection(FirestoreCollections.stores)
    //     .where('type', isEqualTo: 'Pharmacy');
    // var snapshot = await query.get();
    // var categoryStoresSnapshot = query.docs;
    // for (var categoryStore in categoryStoresSnapshot) {
    //   _categoryStores.add(Store.fromJson(categoryStore.data()));
    // }
    _categoryStores = allStores
        .where(
          (element) => element.type
              .toLowerCase()
              .contains(_selectedCategory.toLowerCase()),
        )
        .toList();
    if (_selectedFilters.isEmpty) {
      _filteredStores = _categoryStores;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = ref.read(categoryProvider)!;
  }

  @override
  Widget build(BuildContext context) {
    final timeOfDayNow = TimeOfDay.now();
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          ref.read(bottomNavIndexProvider.notifier).updateIndex(1);
        },
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  leading: GestureDetector(
                      onTap: () => ref
                          .read(bottomNavIndexProvider.notifier)
                          .updateIndex(1),
                      child: const Icon(Icons.arrow_back)),
                  pinned: true,
                  floating: true,
                  expandedHeight: 150,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 40),
                      color: AppColors.neutral100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            _selectedCategory == 'Pharmacy'
                                ? AssetNames.pharmacy
                                : _selectedCategory == 'Retail'
                                    ? AssetNames.retail
                                    : _selectedCategory == 'Pet Supplies'
                                        ? AssetNames.petSupplies
                                        : _selectedCategory == 'Flowers'
                                            ? AssetNames.flowers
                                            : _selectedCategory == 'Convenience'
                                                ? AssetNames.convenience
                                                : _selectedCategory == 'Baby'
                                                    ? AssetNames.babyBottle
                                                    : _selectedCategory ==
                                                            'Specialty Foods'
                                                        ? AssetNames
                                                            .specialtyFoods
                                                        : AssetNames.alcohol,
                            height: 70,
                          )
                        ],
                      ),
                    ),

                    // titlePadding: const EdgeInsets.symmetric(
                    //     horizontal: AppSizes.horizontalPaddingSmall),
                    // expandedTitleScale: 2,
                    title: AppText(
                      text: _selectedCategory,
                      weight: FontWeight.w600,
                      size: AppSizes.heading6,
                    ),
                    expandedTitleScale: 1.2,
                  ),
                )
              ];
            },
            body: Column(
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
                      return const Icon(Icons.keyboard_arrow_down_sharp);
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
                    } else {
                      tappedFilter = value.first;
                    }

                    if (_filters.indexOf(tappedFilter) == 3) {
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

                                        _setStateWithModal(tappedFilter);
                                      },
                                    ),
                                    Center(
                                      child: AppTextButton(
                                        size: AppSizes.bodySmall,
                                        text: 'Reset',
                                        callback: () {
                                          _selectedDeliveryFeeIndex = null;
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
                    } else if (_filters.indexOf(tappedFilter) == 4) {
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
                                                        : '5'),
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
                                            // logger.d(temp);
                                          });
                                        }),
                                    AppButton(
                                      text: 'Apply',
                                      callback: () {
                                        _selectedRatingIndex = temp;

                                        _setStateWithModal(tappedFilter);
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
                    } else if (_filters.indexOf(tappedFilter) == 5) {
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
                                        if (temp != null) {
                                          _selectedPriceCategory = temp;

                                          _setStateWithModal(tappedFilter);
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
                    } else if (_filters.indexOf(tappedFilter) == 6) {
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
                                        if (temp.isNotEmpty) {
                                          _selectedDietaryOptions = temp;

                                          _setStateWithModal(tappedFilter);
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
                    } else if (OtherConstants.filters.indexOf(tappedFilter) ==
                        7) {
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
                                      itemCount:
                                          OtherConstants.sortOptions.length,
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

                                          _setStateWithModal(tappedFilter);
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
                        }
                        _getFilterdStores(selectedFilters: _selectedFilters);
                      });
                    }
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
                const Gap(10),
                Expanded(
                  child: FutureBuilder(
                      future: _getCategoryStores(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Skeletonizer(
                            enabled: true,
                            child: ListView.builder(
                                itemCount: 2,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.neutral100,
                                        ),
                                        width: 40,
                                        height: 40,
                                      ),
                                      title: const AppText(
                                        text: 'njanfkjm',
                                        size: AppSizes.bodySmall,
                                        weight: FontWeight.bold,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: AppSizes
                                                  .horizontalPaddingSmall),
                                      subtitle: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                              text: 'jklsakllajlkjasdklfla'),
                                          AppText(text: 'jklnjs'),
                                        ],
                                      ));
                                }),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: AppText(text: snapshot.error.toString()),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              child: AppText(
                                text: 'Results (${_filteredStores.length})',
                                weight: FontWeight.bold,
                                size: AppSizes.heading6,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _filteredStores.length,
                                itemBuilder: (context, index) {
                                  final categoryStore = _filteredStores[index];
                                  final bool isClosed = timeOfDayNow.isBefore(
                                          categoryStore.openingTime) ||
                                      timeOfDayNow
                                          .isAfter(categoryStore.closingTime);
                                  return ListTile(
                                      titleAlignment:
                                          ListTileTitleAlignment.top,
                                      onTap: () async {
                                        await AppFunctions
                                            .navigateToStoreScreen(
                                                categoryStore);
                                      },
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              color: AppColors.neutral100,
                                              width: 70,
                                              height: 70,
                                            ),
                                            CachedNetworkImage(
                                              imageUrl: categoryStore.logo,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.fill,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, right: 5),
                                              child: FavouriteButton(
                                                store: categoryStore,
                                                size: 20,
                                                color: AppColors.neutral300,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      title: AppText(
                                        text: categoryStore.name,
                                        size: AppSizes.bodySmall,
                                        weight: FontWeight.bold,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: AppSizes
                                                  .horizontalPaddingSmall),
                                      trailing: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: AppColors.neutral200,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: AppText(
                                            text: categoryStore
                                                .rating.averageRating
                                                .toStringAsFixed(1)),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Visibility(
                                                  visible: categoryStore
                                                          .delivery.fee <
                                                      1,
                                                  child: Image.asset(
                                                    AssetNames.uberOneSmall,
                                                    height: 10,
                                                  )),
                                              AppText(
                                                  text: isClosed
                                                      ? categoryStore.openingTime
                                                                      .hour -
                                                                  timeOfDayNow
                                                                      .hour >
                                                              1
                                                          ? 'Available at ${AppFunctions.formatTimeOFDay(categoryStore.openingTime)}'
                                                          : 'Available in ${categoryStore.openingTime.hour - timeOfDayNow.hour == 1 ? '1 hr' : '${(categoryStore.openingTime.minute - timeOfDayNow.minute).abs()} mins'}'
                                                      : '\$${categoryStore.delivery.fee} Delivery Fee',
                                                  color: categoryStore.delivery
                                                                  .fee <
                                                              1 &&
                                                          !isClosed
                                                      ? const Color.fromARGB(
                                                          255, 163, 133, 42)
                                                      : null),
                                            ],
                                          ),
                                          AppText(
                                              text:
                                                  '${categoryStore.delivery.estimatedDeliveryTime} min'),
                                          if (categoryStore.offers != null &&
                                              categoryStore.offers!.isNotEmpty)
                                            StoreOffersText(
                                              categoryStore,
                                              color: Colors.green,
                                            )
                                        ],
                                      ));
                                },
                              ),
                            )
                          ],
                        );
                      }),
                ),
              ],
            )),
      ),
    );
  }

  void _setStateWithModal(String newFilter) {
    navigatorKey.currentState!.pop();
    setState(() {
      if (!_selectedFilters.contains(newFilter)) {
        _selectedFilters.add(newFilter);
      }
      _getFilterdStores(selectedFilters: _selectedFilters);
    });
  }

  void _resetFilter(
    List<String> value,
    int filterIndex,
  ) {
    navigatorKey.currentState!.pop();
    setState(() {
      List<String> temp = List<String>.from(value);

      temp.removeWhere(
        (element) => element == _filters[filterIndex],
      );

      _selectedFilters = temp;
      _getFilterdStores(selectedFilters: _selectedFilters);
    });
  }

  void _getFilterdStores({required List<String> selectedFilters}) {
    Iterable<Store> storesIterable = _categoryStores;

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
      }
    }
    _filteredStores = storesIterable.toList();
  }
}
