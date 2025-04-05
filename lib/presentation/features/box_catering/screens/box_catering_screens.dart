import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/entypo.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../../app_functions.dart';
import '../../../../main.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/other_constants.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

import '../../../core/widgets.dart';
import '../../main_screen/screens/main_screen.dart';
import '../../sign_in/views/drop_off_options_screen.dart';

class BoxCateringScreen extends StatefulWidget {
  final List<Store> boxCateringStores;
  const BoxCateringScreen({super.key, required this.boxCateringStores});

  @override
  State<BoxCateringScreen> createState() => _BoxCateringScreenState();
}

class _BoxCateringScreenState extends State<BoxCateringScreen> {
  bool _onFilterScreen = false;
  List<String> _selectedFilters = [];

  // final FocusNode _focus = FocusNode();

  List<Store> _filteredStores = [];

  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  String? _selectedPrice;
  List<String> _selectedDietaryOptions = [];

  String? _selectedGroupSize;

  String? _selectedSort;

  @override
  void initState() {
    super.initState();
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
                  expandedHeight: 150,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 40),
                        color: const Color.fromARGB(255, 246, 239, 233),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              AssetNames.boxCatering,
                              fit: BoxFit.cover,
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
                      text: 'Box Catering',
                      weight: FontWeight.w600,
                      size: AppSizes.bodySmall,
                    ),
                    expandedTitleScale: 1.5,
                  ),
                )
              ];
            },
            body: Visibility(
              visible: widget.boxCateringStores.isNotEmpty,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChipsChoice<String>.multiple(
                    choiceLeadingBuilder: (item, i) {
                      if (i < 2) {
                        return const AppText(text: '');
                      } else if (i == 2) {
                        return const Iconify(
                          Ph.tag_fill,
                          size: 15,
                        );
                      } else {
                        return const Iconify(
                          Entypo.medal,
                          size: 15,
                        );
                      }
                    },
                    choiceLabelBuilder: (item, i) {
                      if (i == 0) {
                        if (_selectedGroupSize == null) {
                          return AppText(
                            text: item.label,
                          );
                        } else {
                          return AppText(text: _selectedGroupSize!);
                        }
                      } else if (i == 1) {
                        if (_selectedSort == null) {
                          return AppText(
                            text: item.label,
                          );
                        } else {
                          return AppText(text: _selectedSort!);
                        }
                      } else {
                        return AppText(
                          text: item.label,
                        );
                      }
                    },
                    choiceTrailingBuilder: (item, i) {
                      if (i < 2) {
                        return const Icon(Icons.keyboard_arrow_down_sharp);
                      }
                      return null;
                    },
                    wrapped: false,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
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
                        }
                        // if (OtherConstants.filters.indexOf(newFilter) == 3) {
                        //   showModalBottomSheet(
                        //     context: context,
                        //     builder: (context) {
                        //       late int temp;
                        //       logger.d(_selectedDeliveryFeeIndex);
                        //       if (_selectedDeliveryFeeIndex == null) {
                        //         temp = 3;
                        //       } else {
                        //         temp = _selectedDeliveryFeeIndex!;
                        //       }
                        //       return Container(
                        //         color: Colors.white,
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(
                        //               // horizontal:
                        //               AppSizes.horizontalPaddingSmall),
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               const Center(
                        //                   child: AppText(
                        //                 text: 'Delivery fee',
                        //                 size: AppSizes.bodySmall,
                        //                 weight: FontWeight.w600,
                        //               )),
                        //               AppText(
                        //                   text: temp == 0
                        //                       ? 'Under \$1'
                        //                       : temp == 1
                        //                           ? 'Under \$3'
                        //                           : temp == 2
                        //                               ? 'Under \$5'
                        //                               : 'Any amount'),
                        //               Padding(
                        //                 padding: const EdgeInsets.all(25.0),
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: OtherConstants
                        //                       .deliveryPriceFilters
                        //                       .map(
                        //                         (e) => AppText(text: e),
                        //                       )
                        //                       .toList(),
                        //                 ),
                        //               ),
                        //               Slider.adaptive(
                        //                   thumbColor: Colors.white,
                        //                   min: 0,
                        //                   max: OtherConstants
                        //                           .deliveryPriceFilters.length -
                        //                       1,
                        //                   divisions: OtherConstants
                        //                           .deliveryPriceFilters.length -
                        //                       1,
                        //                   value: temp.toDouble(),
                        //                   onChanged: (value) {
                        //                     setState(() {
                        //                       temp = value.toInt();
                        //                       logger.d(temp);
                        //                     });
                        //                   }),
                        //               AppButton(
                        //                 text: 'Apply',
                        //                 callback: () {
                        //                   _selectedDeliveryFeeIndex = temp;
                        //                   // logger.d(_selectedDeliveryFeeIndex);
                        //                   //                      setState(() {
                        //                   //   _currentlySelectedFilters = value;
                        //                   // });
                        //                   navigatorKey.currentState!.pop();
                        //                   setState(() {
                        //                     _selectedFilters = value;
                        //                     if (value.isNotEmpty) {
                        //                       _onFilterScreen = true;
                        //                     } else {
                        //                       _onFilterScreen = false;
                        //                     }
                        //                   });
                        //                 },
                        //               ),
                        //               Center(
                        //                 child: AppTextButton(
                        //                   size: AppSizes.bodySmall,
                        //                   text: 'Reset',
                        //                   callback: () {
                        //                     // setState(() {
                        //                     //   _currentlySelectedFilters =
                        //                     //       List.from(value);
                        //                     //   _currentlySelectedFilters.removeWhere(
                        //                     //     (element) =>
                        //                     //         element == 'Delivery fee',
                        //                     //   );
                        //                     // });
                        //                     navigatorKey.currentState!.pop();
                        //                     setState(() {
                        //                       List<String> temp =
                        //                           List<String>.from(value);

                        //                       temp.removeWhere(
                        //                         (element) =>
                        //                             element ==
                        //                             OtherConstants.filters[3],
                        //                       );

                        //                       _selectedFilters = temp;
                        //                       _selectedDeliveryFeeIndex = null;

                        //                       if (temp.isNotEmpty) {
                        //                         _onFilterScreen = true;
                        //                       } else {
                        //                         _onFilterScreen = false;
                        //                       }
                        //                     });
                        //                   },
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // } else if (OtherConstants.filters.indexOf(newFilter) ==
                        //     4) {
                        //   showModalBottomSheet(
                        //     context: context,
                        //     builder: (context) {
                        //       late int temp;
                        //       logger.d(_selectedRatingIndex);
                        //       if (_selectedRatingIndex == null) {
                        //         temp = 0;
                        //       } else {
                        //         temp = _selectedRatingIndex!;
                        //       }
                        //       return Container(
                        //         color: Colors.white,
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(
                        //               // horizontal:
                        //               AppSizes.horizontalPaddingSmall),
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               const Center(
                        //                   child: AppText(
                        //                 text: 'Rating',
                        //                 size: AppSizes.bodySmall,
                        //                 weight: FontWeight.w600,
                        //               )),
                        //               AppText(
                        //                   text: temp == 0
                        //                       ? 'Over 3'
                        //                       : temp == 1
                        //                           ? 'Over 3.5'
                        //                           : temp == 2
                        //                               ? 'Over 4'
                        //                               : temp == 3
                        //                                   ? 'Over 4.5'
                        //                                   : 'Over 5'),
                        //               Padding(
                        //                 padding: const EdgeInsets.all(25.0),
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children:
                        //                       OtherConstants.ratingsFilters
                        //                           .map(
                        //                             (e) => AppText(text: e),
                        //                           )
                        //                           .toList(),
                        //                 ),
                        //               ),
                        //               Slider.adaptive(
                        //                   thumbColor: Colors.white,
                        //                   min: 0,
                        //                   max: OtherConstants
                        //                           .ratingsFilters.length -
                        //                       1,
                        //                   divisions: OtherConstants
                        //                           .ratingsFilters.length -
                        //                       1,
                        //                   value: temp.toDouble(),
                        //                   onChanged: (value) {
                        //                     setState(() {
                        //                       temp = value.toInt();
                        //                       logger.d(temp);
                        //                     });
                        //                   }),
                        //               AppButton(
                        //                 text: 'Apply',
                        //                 callback: () {
                        //                   _selectedRatingIndex = temp;
                        //                   // logger.d(_selectedRatingIndex);
                        //                   //                      setState(() {
                        //                   //   _currentlySelectedFilters = value;
                        //                   // });
                        //                   navigatorKey.currentState!.pop();
                        //                   setState(() {
                        //                     _selectedFilters = value;
                        //                     if (value.isNotEmpty) {
                        //                       _onFilterScreen = true;
                        //                     } else {
                        //                       _onFilterScreen = false;
                        //                     }
                        //                   });
                        //                 },
                        //               ),
                        //               Center(
                        //                 child: AppTextButton(
                        //                   size: AppSizes.bodySmall,
                        //                   text: 'Reset',
                        //                   callback: () {
                        //                     // setState(() {
                        //                     //   _currentlySelectedFilters =
                        //                     //       List.from(value);
                        //                     //   _currentlySelectedFilters.removeWhere(
                        //                     //     (element) =>
                        //                     //         element == 'Delivery fee',
                        //                     //   );
                        //                     // });
                        //                     navigatorKey.currentState!.pop();
                        //                     setState(() {
                        //                       List<String> temp =
                        //                           List<String>.from(value);
                        //                       temp.removeWhere(
                        //                         (element) =>
                        //                             element ==
                        //                             OtherConstants.filters[4],
                        //                       );
                        //                       _selectedFilters = temp;
                        //                       _selectedRatingIndex = null;
                        //                       if (temp.isNotEmpty) {
                        //                         _onFilterScreen = true;
                        //                       } else {
                        //                         _onFilterScreen = false;
                        //                       }
                        //                     });
                        //                   },
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // } else if (OtherConstants.filters.indexOf(newFilter) ==
                        //     5) {
                        //   showModalBottomSheet(
                        //     context: context,
                        //     builder: (context) {
                        //       String? temp;
                        //       if (_selectedPrice != null) {
                        //         temp = _selectedPrice;
                        //       }

                        //       return Container(
                        //         color: Colors.white,
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(
                        //               // horizontal:
                        //               AppSizes.horizontalPaddingSmall),
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               const Center(
                        //                   child: AppText(
                        //                 text: 'Price',
                        //                 size: AppSizes.bodySmall,
                        //                 weight: FontWeight.w600,
                        //               )),
                        //               Center(
                        //                 child: ChipsChoice.single(
                        //                     choiceItems: C2Choice.listFrom<
                        //                         String, String>(
                        //                       source: OtherConstants.boxCateringFilters,
                        //                       value: (i, v) => v,
                        //                       label: (i, v) => v,
                        //                     ),
                        //                     wrapped: true,
                        //                     alignment:
                        //                         WrapAlignment.spaceBetween,
                        //                     choiceStyle: C2ChipStyle.filled(
                        //                       selectedStyle: const C2ChipStyle(
                        //                         foregroundColor: Colors.white,
                        //                         backgroundColor:
                        //                             AppColors.neutral900,
                        //                         borderRadius: BorderRadius.all(
                        //                           Radius.circular(100),
                        //                         ),
                        //                       ),
                        //                       height: 30,
                        //                       borderRadius:
                        //                           BorderRadius.circular(100),
                        //                       color: AppColors.neutral200,
                        //                     ),
                        //                     value: temp,
                        //                     onChanged: (value) {
                        //                       setState(() {
                        //                         temp = value;
                        //                       });
                        //                     }),
                        //               ),
                        //               const Gap(20),
                        //               AppButton(
                        //                 text: 'Apply',
                        //                 callback: () {
                        //                   _selectedPrice = temp;

                        //                   navigatorKey.currentState!.pop();
                        //                   setState(() {
                        //                     _selectedFilters = value;
                        //                     if (value.isNotEmpty) {
                        //                       _onFilterScreen = true;
                        //                     } else {
                        //                       _onFilterScreen = false;
                        //                     }
                        //                   });
                        //                 },
                        //               ),
                        //               Center(
                        //                 child: AppTextButton(
                        //                   size: AppSizes.bodySmall,
                        //                   text: 'Reset',
                        //                   callback: () {
                        //                     navigatorKey.currentState!.pop();

                        //                     setState(() {
                        //                       List<String> temp =
                        //                           List<String>.from(value);
                        //                       temp.removeWhere(
                        //                         (element) =>
                        //                             element ==
                        //                             OtherConstants.filters[5],
                        //                       );
                        //                       _selectedFilters = temp;
                        //                       _selectedPrice = null;
                        //                       if (value.isNotEmpty) {
                        //                         _onFilterScreen = true;
                        //                       } else {
                        //                         _onFilterScreen = false;
                        //                       }
                        //                     });
                        //                   },
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // } else if (OtherConstants.filters.indexOf(newFilter) ==
                        //     6) {
                        //   showModalBottomSheet(
                        //     context: context,
                        //     builder: (context) {
                        //       List<String> temp = _selectedDietaryOptions;

                        //       return Container(
                        //         color: Colors.white,
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(
                        //               // horizontal:
                        //               AppSizes.horizontalPaddingSmall),
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               const Center(
                        //                   child: AppText(
                        //                 text: 'Dietary',
                        //                 size: AppSizes.bodySmall,
                        //                 weight: FontWeight.w600,
                        //               )),
                        //               ListView(
                        //                 shrinkWrap: true,
                        //                 children: [
                        //                   AppCheckboxListTile(
                        //                     onChanged: (value) {
                        //                       setState(() {
                        //                         if (value != null) {
                        //                           if (value) {
                        //                             temp.add('Vegetarian');
                        //                           } else {
                        //                             temp.removeWhere(
                        //                               (element) =>
                        //                                   element ==
                        //                                   'Vegetarian',
                        //                             );
                        //                           }
                        //                         }
                        //                       });
                        //                     },
                        //                     value: 'Vegetarian',
                        //                     selectedOptions: temp,
                        //                   ),
                        //                   AppCheckboxListTile(
                        //                     onChanged: (value) {
                        //                       setState(() {
                        //                         if (value != null) {
                        //                           if (value) {
                        //                             temp.add('Vegan');
                        //                           } else {
                        //                             temp.removeWhere(
                        //                               (element) =>
                        //                                   element == 'Vegan',
                        //                             );
                        //                           }
                        //                         }
                        //                       });
                        //                     },
                        //                     value: 'Vegan',
                        //                     selectedOptions: temp,
                        //                   ),
                        //                   AppCheckboxListTile(
                        //                     onChanged: (value) {
                        //                       setState(() {
                        //                         if (value != null) {
                        //                           if (value) {
                        //                             temp.add('Gluten-free');
                        //                           } else {
                        //                             temp.removeWhere(
                        //                               (element) =>
                        //                                   element ==
                        //                                   'Gluten-free',
                        //                             );
                        //                           }
                        //                         }
                        //                       });
                        //                     },
                        //                     value: 'Gluten-free',
                        //                     selectedOptions: temp,
                        //                   ),
                        //                   AppCheckboxListTile(
                        //                     onChanged: (value) {
                        //                       setState(() {
                        //                         if (value != null) {
                        //                           if (value) {
                        //                             temp.add('Halal');
                        //                           } else {
                        //                             temp.removeWhere(
                        //                               (element) =>
                        //                                   element == 'Halal',
                        //                             );
                        //                           }
                        //                         }
                        //                       });
                        //                     },
                        //                     value: 'Halal',
                        //                     selectedOptions: temp,
                        //                   ),
                        //                 ],
                        //               ),
                        //               const Gap(20),
                        //               AppButton(
                        //                 text: 'Apply',
                        //                 callback: () {
                        //                   _selectedDietaryOptions = temp;

                        //                   navigatorKey.currentState!.pop();
                        //                   setState(() {
                        //                     _selectedFilters = value;
                        //                     if (value.isNotEmpty) {
                        //                       _onFilterScreen = true;
                        //                     } else {
                        //                       _onFilterScreen = false;
                        //                     }
                        //                   });
                        //                 },
                        //               ),
                        //               Center(
                        //                 child: AppTextButton(
                        //                   size: AppSizes.bodySmall,
                        //                   text: 'Reset',
                        //                   callback: () {
                        //                     navigatorKey.currentState!.pop();
                        //                     setState(() {
                        //                       List<String> temp2 =
                        //                           List<String>.from(value);
                        //                       temp2.removeWhere(
                        //                         (element) =>
                        //                             element ==
                        //                             OtherConstants.filters[6],
                        //                       );
                        //                       _selectedFilters = temp2;
                        //                       _selectedDietaryOptions = [];
                        //                       if (value.isNotEmpty) {
                        //                         _onFilterScreen = true;
                        //                       } else {
                        //                         _onFilterScreen = false;
                        //                       }
                        //                     });
                        //                   },
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // }
                        else if (OtherConstants.boxCateringFilters
                                .indexOf(newFilter) ==
                            0) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              String? temp;

                              return Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
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
                                        text: 'Group size',
                                        size: AppSizes.bodySmall,
                                        weight: FontWeight.w600,
                                      )),
                                      ListView(
                                        shrinkWrap: true,
                                        children: [
                                          AppRadioListTile(
                                            padding: EdgeInsets.zero,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            groupValue: temp,
                                            value: '1-10 people',
                                            onChanged: (value) {
                                              setState(() {
                                                temp = value;
                                              });
                                            },
                                          ),
                                          AppRadioListTile(
                                            padding: EdgeInsets.zero,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            groupValue: temp,
                                            value: '11-24 people',
                                            onChanged: (value) {
                                              setState(() {
                                                temp = value;
                                              });
                                            },
                                          ),
                                          AppRadioListTile(
                                            padding: EdgeInsets.zero,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            groupValue: temp,
                                            value: '25+ people',
                                            onChanged: (value) {
                                              setState(() {
                                                temp = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const Gap(20),
                                      AppButton(
                                        text: 'Apply',
                                        callback: () {
                                          _selectedGroupSize = temp;

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
                                              _selectedGroupSize = null;
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
                      source: OtherConstants.boxCateringFilters,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            size: AppSizes.heading6,
                            weight: FontWeight.w600,
                            text:
                                '${widget.boxCateringStores.length} ${widget.boxCateringStores.length == 1 ? 'Result' : 'Results'}'),
                        const Gap(20),
                        ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final store = widget.boxCateringStores[index];
                              final bool isClosed =
                                  timeOfDayNow.hour < store.openingTime.hour ||
                                      (timeOfDayNow.hour >=
                                              store.closingTime.hour &&
                                          timeOfDayNow.minute >=
                                              store.closingTime.minute);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: store.cardImage,
                                            width: double.infinity,
                                            height: 170,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        isClosed
                                            ? Container(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                width: double.infinity,
                                                height: 170,
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
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    width: double.infinity,
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
                                          child: InkWell(
                                            onTap: () {},
                                            child: Ink(
                                              child: Icon(
                                                favoriteStores.any((element) =>
                                                        element.id == store.id)
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                color: AppColors.neutral300,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Gap(5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: store.name,
                                        weight: FontWeight.w600,
                                      ),
                                      Image.asset(
                                        AssetNames.bestOverallWhBg,
                                        height: 25,
                                      )
                                    ],
                                  ),
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
                                            ? 'Closed • Available at ${AppFunctions.formatDate(store.openingTime.toString(), format: 'h:i A')}'
                                            : '\$${store.delivery.fee} Delivery Fee',
                                        // color: store.delivery.fee < 1
                                        //     ? const Color.fromARGB(
                                        //         255, 163, 133, 42)
                                        //     : null
                                      ),
                                      // AppText(
                                      //     text:
                                      //         ' • ${store.delivery.estimatedDeliveryTime} min'),
                                    ],
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => const Gap(10),
                            itemCount: widget.boxCateringStores.length),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
