import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app_functions.dart';
import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/other_constants.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

import '../../../core/widgets.dart';
import '../../home/home_screen.dart';
import '../../sign_in/views/drop_off_options_screen.dart';

class PharmacyScreen extends StatefulWidget {
  final List<Store> pharmacyStores;
  const PharmacyScreen({super.key, required this.pharmacyStores});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  late final List<Store> _featuredStores;
  final List<Color> _featuredStoresColors = [];
  bool _onFilterScreen = false;
  List<String> _selectedFilters = [];

  // final FocusNode _focus = FocusNode();

  List<Store> _filteredStores = [];

  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPrice;
  List<String> _selectedDietaryOptions = [];
  String? _selectedSort;

  @override
  void initState() {
    super.initState();

    _featuredStores = widget.pharmacyStores;
    for (var i = 0; i < _featuredStores.length; i++) {
      _featuredStoresColors.add(Color.fromARGB(50, Random().nextInt(256),
          Random().nextInt(256), Random().nextInt(256)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeOfDayNow = TimeOfDay.now();
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 170,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 40),
                        color: AppColors.neutral100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              AssetNames.pharmacy,
                              height: 80,
                            )
                          ],
                        ),
                      ),
                    ),

                    // titlePadding: const EdgeInsets.symmetric(
                    //     horizontal: AppSizes.horizontalPaddingSmall),
                    // expandedTitleScale: 2,
                    title: const AppText(
                      text: 'Pharmacy',
                      weight: FontWeight.w600,
                      size: AppSizes.body,
                    ),
                    expandedTitleScale: 1.5,
                  ),
                )
              ];
            },
            body: Visibility(
              visible: widget.pharmacyStores.isNotEmpty,
              replacement: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    // fit: BoxFit.fitHeight,
                    AssetNames.store,
                    height: 100,
                  ),
                  const Gap(10),
                  const AppText(
                    text: 'Stores coming soon',
                  ),
                ],
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
                        if (OtherConstants.filters.indexOf(newFilter) == 3) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              late int temp;
                              logger.d(_selectedDeliveryFeeIndex);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            if (value.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
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
                                                    element ==
                                                    OtherConstants.filters[3],
                                              );

                                              _selectedFilters = temp;
                                              _selectedDeliveryFeeIndex = null;

                                              if (temp.isNotEmpty) {
                                                _onFilterScreen = true;
                                              } else {
                                                _onFilterScreen = false;
                                              }
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
                        } else if (OtherConstants.filters.indexOf(newFilter) ==
                            4) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              late int temp;
                              logger.d(_selectedRatingIndex);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            if (value.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
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
                                                    element ==
                                                    OtherConstants.filters[4],
                                              );
                                              _selectedFilters = temp;
                                              _selectedRatingIndex = null;
                                              if (temp.isNotEmpty) {
                                                _onFilterScreen = true;
                                              } else {
                                                _onFilterScreen = false;
                                              }
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
                        } else if (OtherConstants.filters.indexOf(newFilter) ==
                            5) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                          child: AppText(
                                        text: 'Price',
                                        size: AppSizes.body,
                                        weight: FontWeight.w600,
                                      )),
                                      Center(
                                        child: ChipsChoice.single(
                                            choiceItems: C2Choice.listFrom<
                                                String, String>(
                                              source:
                                                  OtherConstants.pricesFilters,
                                              value: (i, v) => v,
                                              label: (i, v) => v,
                                            ),
                                            wrapped: true,
                                            alignment:
                                                WrapAlignment.spaceBetween,
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
                                            if (value.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
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
                                                    element ==
                                                    OtherConstants.filters[5],
                                              );
                                              _selectedFilters = temp;
                                              _selectedPrice = null;
                                              if (value.isNotEmpty) {
                                                _onFilterScreen = true;
                                              } else {
                                                _onFilterScreen = false;
                                              }
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
                        } else if (OtherConstants.filters.indexOf(newFilter) ==
                            6) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              List<String> temp = _selectedDietaryOptions;

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
                                        size: AppSizes.body,
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
                                          _selectedDietaryOptions = temp;

                                          navigatorKey.currentState!.pop();
                                          setState(() {
                                            _selectedFilters = value;
                                            if (value.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
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
                                              List<String> temp2 =
                                                  List<String>.from(value);
                                              temp2.removeWhere(
                                                (element) =>
                                                    element ==
                                                    OtherConstants.filters[6],
                                              );
                                              _selectedFilters = temp2;
                                              _selectedDietaryOptions = [];
                                              if (value.isNotEmpty) {
                                                _onFilterScreen = true;
                                              } else {
                                                _onFilterScreen = false;
                                              }
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
                        } else if (OtherConstants.filters.indexOf(newFilter) ==
                            7) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            if (value.isNotEmpty) {
                                              _onFilterScreen = true;
                                            } else {
                                              _onFilterScreen = false;
                                            }
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
                                                    element ==
                                                    OtherConstants.filters[7],
                                              );
                                              _selectedFilters = temp;
                                              _selectedSort = null;
                                              if (value.isNotEmpty) {
                                                _onFilterScreen = true;
                                              } else {
                                                _onFilterScreen = false;
                                              }
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
                  const Padding(
                    padding: EdgeInsets.all(AppSizes.horizontalPaddingSmall),
                    child: Row(
                      children: [
                        AppText(
                          text: 'Featured stores',
                          size: AppSizes.heading6,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      cacheExtent: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      separatorBuilder: (context, index) => const Gap(10),
                      scrollDirection: Axis.horizontal,
                      itemCount: _featuredStores.length,
                      itemBuilder: (context, index) {
                        final store = _featuredStores[index];
                        final bool isClosed =
                            timeOfDayNow.hour < store.openingTime.hour ||
                                (timeOfDayNow.hour >= store.closingTime.hour &&
                                    timeOfDayNow.minute >=
                                        store.closingTime.minute);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // navigatorKey.currentState!.push(MaterialPageRoute(
                              //   builder: (context) => StoreScreen(store),
                              // ));
                            },
                            child: Ink(
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(12),
                              // ),

                              child: Stack(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 20),
                                    color: _featuredStoresColors[index],
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: store.logo,
                                          width: 200,
                                          height: 50,
                                          // fit: BoxFit.fitWidth,
                                        ),
                                        Column(
                                          children: [
                                            AppText(
                                              text: store.name,
                                              weight: FontWeight.w600,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                    visible:
                                                        store.delivery.fee < 1,
                                                    child: Image.asset(
                                                      AssetNames.uberOneSmall,
                                                      height: 10,
                                                    )),
                                                Visibility(
                                                    visible:
                                                        store.delivery.fee < 1,
                                                    child: const AppText(
                                                        text: ' •')),
                                                AppText(
                                                    text:
                                                        " ${store.delivery.estimatedDeliveryTime} min")
                                              ],
                                            ),
                                            //TODO: offers available text
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  isClosed
                                      ? Container(
                                          color: Colors.black.withOpacity(0.5),
                                          width: 150,
                                          height: 150,
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
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              width: 150,
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  HomeScreenTopic(
                      callback: () {},
                      title: 'Prep brunch for Mum',
                      subtitle: 'From ${stores[6].name}',
                      imageUrl: stores[6].logo),
                  SizedBox(
                    height: 200,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: stores[6]
                          .productCategories
                          .map((productCategory) => SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                sliver: SliverList.separated(
                                  separatorBuilder: (context, index) =>
                                      const Gap(10),
                                  itemBuilder: (context, index) =>
                                      ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          // TODO: find a way to do lazy loading and remove shrinkWrap
                                          shrinkWrap: true,
                                          itemCount:
                                              productCategory.products.length,
                                          separatorBuilder: (context, index) =>
                                              const Gap(15),
                                          itemBuilder: (context, index) {
                                            final product =
                                                productCategory.products[index];
                                            return ProductGridTile(
                                                product: product,
                                                store: stores[6]);
                                          }),
                                  itemCount: 1,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  HomeScreenTopic(callback: () {}, title: 'All Stores'),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final store = widget.pharmacyStores[index];
                        final bool isClosed =
                            timeOfDayNow.hour < store.openingTime.hour ||
                                (timeOfDayNow.hour >= store.closingTime.hour &&
                                    timeOfDayNow.minute >=
                                        store.closingTime.minute);
                        return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: AppColors.neutral200)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: store.logo,
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            title: AppText(text: store.name),
                            contentPadding: EdgeInsets.zero,
                            trailing: Icon(
                              store.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: AppColors.neutral300,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Visibility(
                                        visible: store.delivery.fee < 1,
                                        child: Image.asset(
                                          AssetNames.uberOneSmall,
                                          height: 10,
                                        )),
                                    AppText(
                                        text: isClosed
                                            ? store.openingTime.hour -
                                                        timeOfDayNow.hour >
                                                    1
                                                ? 'Available at ${AppFunctions.formatTime(store.openingTime)}'
                                                : 'Available in ${store.openingTime.hour - timeOfDayNow.hour == 1 ? '1 hr' : '${store.openingTime.minute - timeOfDayNow.minute} mins'}'
                                            : '\$${store.delivery.fee} Delivery Fee',
                                        color: store.delivery.fee < 1
                                            ? const Color.fromARGB(
                                                255, 163, 133, 42)
                                            : null),
                                    AppText(
                                        text:
                                            ' • ${store.delivery.estimatedDeliveryTime} min'),
                                  ],
                                ),
                                const AppText(
                                  text: 'Offers available',
                                  color: Colors.green,
                                )
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) => const Divider(
                            indent: 30,
                          ),
                      itemCount: widget.pharmacyStores.length),
                ],
              ),
            )));
  }
}
