import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';

import '../../../../main.dart';
import '../../../constants/other_constants.dart';
import '../../../core/app_text.dart';
import '../../../core/widgets.dart';
import '../../sign_in/views/drop_off_options_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<String> _selectedFilters = [];
  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPrice;
  List<String> _selectedDietaryOptions = [];
  String? _selectedSort;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.grey,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => navigatorKey.currentState!.pop(),
                          child: Ink(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                        ),
                        const Gap(20),
                        const Expanded(
                          child: AppTextFormField(
                            enabled: false,
                            hintText: 'Search',
                            radius: 50,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                        size: AppSizes.bodySmall,
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
                                        size: AppSizes.bodySmall,
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
                                        size: AppSizes.bodySmall,
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
                                          size: AppSizes.bodySmall,
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
                                          size: AppSizes.bodySmall,
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
                                        size: AppSizes.bodySmall,
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
                                          size: AppSizes.bodySmall,
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
                      color: Colors.white,
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: AppSizes.horizontalPaddingSmall),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: const Iconify(
                          Bi.cursor,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child:
                          InkWell(child: Ink(child: const Icon(Icons.list)))),
                  const Gap(15),
                  CarouselSlider.builder(
                    itemCount: 5,
                    itemBuilder: (context, index, realIndex) {
                      // final account = user.accounts![index];

                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        width: Adaptive.w(65),
                        height: Adaptive.h(20),
                      );
                    },
                    options: CarouselOptions(
                        // enlargeCenterPage: true,
                        // height: 200,
                        aspectRatio: 2,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          // _valueNotifier.value = user.accounts![index];
                        },
                        viewportFraction: 0.85),
                  ),
                  const Gap(15),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
