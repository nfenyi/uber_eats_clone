import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:location_platform_interface/location_platform_interface.dart'
    show LocationData;
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';

import '../../../../main.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/other_constants.dart';
import '../../../core/app_text.dart';
import '../../../core/widgets.dart';
import '../../sign_in/views/drop_off_options_screen.dart';

class MapScreen extends StatefulWidget {
  final List<Store> filteredStores;
  final List<String>? selectedFilters;
  final int? selectedDeliveryFeeIndex;
  final int? selectedRatingIndex;
  final String? selectedPriceCategory;
  final List<String>? selectedDietaryOptions;
  final String? selectedSort;
  final LocationData userLocation;
  const MapScreen(
      {super.key,
      required this.filteredStores,
      required this.userLocation,
      this.selectedFilters,
      this.selectedDeliveryFeeIndex,
      this.selectedRatingIndex,
      this.selectedPriceCategory,
      this.selectedSort,
      this.selectedDietaryOptions});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late List<String> _selectedFilters;
  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  final Completer<GoogleMapController> _mapController = Completer();

  List<String>? _selectedDietaryOptions;
  String? _selectedSort;
  late lt.Distance _distance;
  List<Store> _stores = [];
  late final Set<Marker> _markers = {};

  Timer? _debounce;

  final _carouselController = CarouselSliderController();

  String? _selectedPriceCategory;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
    _selectedFilters = widget.selectedFilters!;
    _selectedPriceCategory = widget.selectedPriceCategory;

    _selectedDeliveryFeeIndex = widget.selectedDeliveryFeeIndex;
    _selectedRatingIndex = widget.selectedRatingIndex;
    _selectedDietaryOptions = widget.selectedDietaryOptions;
    _distance = const lt.Distance(
      roundResult: true,
    );
    _stores = widget.filteredStores;
    for (var i = 0; i < _stores.length; i++) {
      _markers.add(
        Marker(
            onTap: () async {
              final controller = await _mapController.future;
              await controller.moveCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(_stores[i].location.latlng.latitude,
                          _stores[i].location.latlng.longitude),
                      zoom: 15)));
              await _carouselController.animateToPage(i);
              // _carouselController.jumpTo(e.)
            },
            markerId: MarkerId(_stores[i].name),
            position: LatLng(_stores[i].location.latlng.latitude,
                _stores[i].location.latlng.longitude)),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(10, 30),
            onMapCreated: (controller) {
              _mapController.complete(controller);
            },
            initialCameraPosition: CameraPosition(
                target: LatLng(_stores.first.location.latlng.latitude,
                    _stores.first.location.latlng.longitude),
                zoom: 15),
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
                        Expanded(
                          child: AppTextFormField(
                            onChanged: (value) {
                              if (_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }
                              _debounce =
                                  Timer(const Duration(seconds: 1), () async {
                                if (value != null) {
                                  setState(() {
                                    _stores = stores
                                        .where(
                                          (element) => element.name
                                              .toLowerCase()
                                              .contains(value.toLowerCase()),
                                        )
                                        .toList();
                                    _markers.clear();
                                    for (var i = 0; i < _stores.length; i++) {
                                      _markers.add(
                                        Marker(
                                            onTap: () async {
                                              final controller =
                                                  await _mapController.future;
                                              await controller.moveCamera(
                                                  CameraUpdate.newCameraPosition(
                                                      CameraPosition(
                                                          target: LatLng(
                                                              _stores[i]
                                                                  .location
                                                                  .latlng
                                                                  .latitude,
                                                              _stores[i]
                                                                  .location
                                                                  .latlng
                                                                  .longitude),
                                                          zoom: 15)));
                                              await _carouselController
                                                  .animateToPage(i);
                                              // _carouselController.jumpTo(e.)
                                            },
                                            markerId: MarkerId(_stores[i].name),
                                            position: LatLng(
                                                _stores[i]
                                                    .location
                                                    .latlng
                                                    .latitude,
                                                _stores[i]
                                                    .location
                                                    .latlng
                                                    .longitude)),
                                      );
                                    }
                                  });
                                }
                              });
                            },
                            enabled: false,
                            hintText: 'Search',
                            radius: 50,
                            constraintWidth: 40,
                            prefixIcon: const Padding(
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
                        if (_selectedPriceCategory == null) {
                          return AppText(
                            text: item.label,
                          );
                        } else {
                          return AppText(text: _selectedPriceCategory!);
                        }
                      } else if (i == 6) {
                        if (_selectedDietaryOptions == null ||
                            _selectedDietaryOptions!.isEmpty) {
                          return AppText(
                            text: item.label,
                          );
                        } else {
                          return AppText(
                              text:
                                  '${item.label}(${_selectedDietaryOptions!.length})');
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
                          }
                        });
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
                          1) {
                        setState(() {
                          if (_selectedFilters.contains(newFilter)) {
                            _selectedFilters.remove(newFilter);
                          } else {
                            _selectedFilters.add(newFilter);
                          }
                        });
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
                          2) {
                        setState(() {
                          if (_selectedFilters.contains(newFilter)) {
                            _selectedFilters.remove(newFilter);
                          } else {
                            _selectedFilters.add(newFilter);
                          }
                        });
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
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

                                          setStateWithModal(value, newFilter);
                                        },
                                      ),
                                      Center(
                                        child: AppTextButton(
                                          size: AppSizes.bodySmall,
                                          text: 'Reset',
                                          callback: () {
                                            _selectedDeliveryFeeIndex = null;
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
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
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

                                          setStateWithModal(value, newFilter);
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
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
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
                                          if (temp != null) {
                                            _selectedPriceCategory = temp;

                                            setStateWithModal(value, newFilter);
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
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
                          6) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            List<String> temp = _selectedDietaryOptions ?? [];

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

                                            setStateWithModal(value, newFilter);
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
                      } else if (OtherConstants.filters.indexOf(newFilter) ==
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
                                          final sortOption =
                                              OtherConstants.sortOptions[index];
                                          return RadioListTile<String>.adaptive(
                                            value: sortOption,
                                            title: AppText(text: sortOption),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: AppSizes.horizontalPaddingSmall),
                  //   child: Container(
                  //       padding: const EdgeInsets.all(5),
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(50)),
                  //       child:
                  //           InkWell(child: Ink(child: const Icon(Icons.list)))),
                  // ),
                  // const Gap(15),
                  CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: _stores.length,
                    itemBuilder: (context, index, realIndex) {
                      final store = _stores[index];

                      return Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    imageUrl: store.cardImage,
                                    fit: BoxFit.cover,
                                    height: 130,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FavouriteButton(store: store),
                                )
                              ],
                            ),
                            ListTile(
                              dense: true,
                              title: AppText(
                                text: store.name,
                              ),
                              subtitle: Row(
                                children: [
                                  if (store.isUberOneShop)
                                    Row(
                                      children: [
                                        Image.asset(
                                          AssetNames.uberOneSmall,
                                          height: 12,
                                          color: AppColors.uberOneGold,
                                        ),
                                        const AppText(text: ' • ')
                                      ],
                                    ),
                                  AppText(
                                      text:
                                          '${store.delivery.estimatedDeliveryTime} min • ${_distance.as(lt.LengthUnit.Kilometer, lt.LatLng(store.location.latlng.latitude, store.location.latlng.longitude), lt.LatLng(widget.userLocation.latitude!, widget.userLocation.longitude!))} km'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );

                      //  Container(
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10)),
                      //   width: Adaptive.w(65),
                      //   height: Adaptive.h(20),
                      // );
                    },
                    options: CarouselOptions(
                        // enlargeCenterPage: true,
                        // height: 200,
                        aspectRatio: 2,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) async {
                          final controller = await _mapController.future;
                          await controller.moveCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(
                                      _stores[index].location.latlng.latitude,
                                      _stores[index].location.latlng.longitude),
                                  zoom: 15)));
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

  void setStateWithModal(List<String> value, String newFilter) {
    navigatorKey.currentState!.pop();
    setState(() {
      if (!_selectedFilters.contains(newFilter)) {
        _selectedFilters.add(newFilter);
      }
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
    });
  }
}
