import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

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
import '../../sign_in/views/drop_off_options_screen.dart';
import '../../some_kind_of_section/advert_screen.dart';
import '../../store/store_screen.dart';

class PharmacyScreen extends ConsumerStatefulWidget {
  const PharmacyScreen({super.key});

  @override
  ConsumerState<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends ConsumerState<PharmacyScreen> {
  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPriceCategory;
  List<String> _selectedDietaryOptions = [];
  List<String> _selectedFilters = [];
  String? _selectedSort;

  final List<Store> _pharmacyStores = [];

  Future<void> _getPharmacyStores() async {
    var query = await FirebaseFirestore.instance
        .collection(FirestoreCollections.stores)
        .get();
    // var query = FirebaseFirestore.instance
    //     .collection(FirestoreCollections.stores)
    //     .where('type', isEqualTo: 'Pharmacy');
    // var snapshot = await query.get();
    var pharmacyStoresSnapshot = query.docs;
    for (var pharmacyStore in pharmacyStoresSnapshot) {
      _pharmacyStores.add(Store.fromJson(pharmacyStore.data()));
    }
  }

  @override
  void initState() {
    super.initState();
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
                            AssetNames.pharmacy,
                            height: 70,
                          )
                        ],
                      ),
                    ),

                    // titlePadding: const EdgeInsets.symmetric(
                    //     horizontal: AppSizes.horizontalPaddingSmall),
                    // expandedTitleScale: 2,
                    title: const AppText(
                      text: 'Pharmacy',
                      weight: FontWeight.w600,
                      size: AppSizes.heading6,
                    ),
                    expandedTitleScale: 1.2,
                  ),
                )
              ];
            },
            body: FutureBuilder(
                future: _getPharmacyStores(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                          itemCount: 2,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                subtitle: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(text: 'jklsakllajlkjasdklfla'),
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
                                // if (_onFilterScreen == false) {
                                //   _onFilterScreen = true;
                                // }
                              }
                            });
                          } else if (OtherConstants.filters
                                  .indexOf(newFilter) ==
                              1) {
                            setState(() {
                              if (_selectedFilters.contains(newFilter)) {
                                _selectedFilters.remove(newFilter);
                              } else {
                                _selectedFilters.add(newFilter);
                                // if (_onFilterScreen == false) {
                                //   _onFilterScreen = true;
                                // }
                              }
                            });
                          } else if (OtherConstants.filters
                                  .indexOf(newFilter) ==
                              2) {
                            setState(() {
                              if (_selectedFilters.contains(newFilter)) {
                                _selectedFilters.remove(newFilter);
                              } else {
                                _selectedFilters.add(newFilter);
                                // if (_onFilterScreen == false) {
                                //   _onFilterScreen = true;
                                // }
                              }
                            });
                          } else if (OtherConstants.filters
                                  .indexOf(newFilter) ==
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
                                            padding: const EdgeInsets.all(25.0),
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
                                              _selectedDeliveryFeeIndex = temp;
                                              // logger.d(_selectedDeliveryFeeIndex);
                                              //                      setState(() {
                                              //   _currentlySelectedFilters = value;
                                              // });

                                              setStateWithModal(
                                                  value, newFilter);
                                            },
                                          ),
                                          Center(
                                            child: AppTextButton(
                                              size: AppSizes.bodySmall,
                                              text: 'Reset',
                                              callback: () {
                                                _selectedDeliveryFeeIndex =
                                                    null;
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
                          } else if (OtherConstants.filters
                                  .indexOf(newFilter) ==
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
                                            padding: const EdgeInsets.all(25.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children:
                                                  OtherConstants.ratingsFilters
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

                                              setStateWithModal(
                                                  value, newFilter);
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
                          } else if (OtherConstants.filters
                                  .indexOf(newFilter) ==
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
                                                choiceItems: C2Choice.listFrom<
                                                    String, String>(
                                                  source: OtherConstants
                                                      .pricesFilters,
                                                  value: (i, v) => v,
                                                  label: (i, v) => v,
                                                ),
                                                wrapped: true,
                                                alignment:
                                                    WrapAlignment.spaceBetween,
                                                choiceStyle: C2ChipStyle.filled(
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

                                                setStateWithModal(
                                                    value, newFilter);
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
                          } else if (OtherConstants.filters
                                  .indexOf(newFilter) ==
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
                                                        temp.add('Vegetarian');
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
                                                _selectedDietaryOptions = temp;

                                                setStateWithModal(
                                                    value, newFilter);
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
                          } else if (OtherConstants.filters
                                  .indexOf(newFilter) ==
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
                                            itemCount: 3,
                                            itemBuilder: (context, index) {
                                              final sortOption = OtherConstants
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

                                                setStateWithModal(
                                                    value, newFilter);
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
                      const Gap(10),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: AppText(
                          text: 'Results',
                          weight: FontWeight.bold,
                          size: AppSizes.heading6,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _pharmacyStores.length,
                          itemBuilder: (context, index) {
                            final pharmacyStore = _pharmacyStores[index];
                            final bool isClosed = timeOfDayNow.hour <
                                    pharmacyStore.openingTime.hour ||
                                (timeOfDayNow.hour >=
                                        pharmacyStore.closingTime.hour &&
                                    timeOfDayNow.minute >=
                                        pharmacyStore.closingTime.minute);
                            return ListTile(
                                titleAlignment: ListTileTitleAlignment.top,
                                onTap: () => navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          StoreScreen(pharmacyStore),
                                    )),
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
                                        imageUrl: pharmacyStore.logo,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.fill,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, right: 5),
                                        child: FavouriteButton(
                                          store: pharmacyStore,
                                          size: 20,
                                          color: AppColors.neutral300,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                title: AppText(
                                  text: pharmacyStore.name,
                                  size: AppSizes.bodySmall,
                                  weight: FontWeight.bold,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                trailing: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: AppColors.neutral200,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: AppText(
                                      text: pharmacyStore.rating.averageRating
                                          .toStringAsFixed(1)),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Visibility(
                                            visible:
                                                pharmacyStore.delivery.fee < 1,
                                            child: Image.asset(
                                              AssetNames.uberOneSmall,
                                              height: 10,
                                            )),
                                        AppText(
                                            text: isClosed
                                                ? pharmacyStore.openingTime
                                                                .hour -
                                                            timeOfDayNow.hour >
                                                        1
                                                    ? 'Available at ${AppFunctions.formatDate(pharmacyStore.openingTime.toString(), format: 'h:i A')}'
                                                    : 'Available in ${pharmacyStore.openingTime.hour - timeOfDayNow.hour == 1 ? '1 hr' : '${(pharmacyStore.openingTime.minute - timeOfDayNow.minute).abs()} mins'}'
                                                : '\$${pharmacyStore.delivery.fee} Delivery Fee',
                                            color: pharmacyStore.delivery.fee <
                                                        1 &&
                                                    !isClosed
                                                ? const Color.fromARGB(
                                                    255, 163, 133, 42)
                                                : null),
                                      ],
                                    ),
                                    AppText(
                                        text:
                                            '${pharmacyStore.delivery.estimatedDeliveryTime} min'),
                                    if (pharmacyStore.offers != null &&
                                        pharmacyStore.offers!.isNotEmpty)
                                      OfferText(store: pharmacyStore)
                                  ],
                                ));
                          },
                        ),
                      )
                    ],
                  );
                })),
      ),
    );
  }

  void setStateWithModal(List<String> value, String newFilter) {
    navigatorKey.currentState!.pop();
    setState(() {
      if (!_selectedFilters.contains(newFilter)) {
        _selectedFilters.add(newFilter);
      }

      // _onFilterScreen = true;
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
}
