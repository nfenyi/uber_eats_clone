import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../../../../app_functions.dart';
import '../../../../main.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/other_constants.dart';
import '../../../core/app_text.dart';
import '../../../core/widgets.dart';
import '../../main_screen/screens/main_screen.dart';
import '../../sign_in/views/drop_off_options_screen.dart';

class MapScreen extends StatefulWidget {
  final BitmapDescriptor markerIcon;
  final List<Store> filteredStores;
  final List<String> selectedFilters;
  final List<BitmapDescriptor> storeMarkerIcons;
  final int? selectedDeliveryFeeIndex;
  final int? selectedRatingIndex;
  final String? selectedPriceCategory;
  final List<String> selectedDietaryOptions;

  final GeoPoint userLocation;
  const MapScreen(
      {super.key,
      required this.filteredStores,
      required this.storeMarkerIcons,
      required this.userLocation,
      required this.markerIcon,
      this.selectedFilters = const [],
      this.selectedDeliveryFeeIndex,
      this.selectedRatingIndex,
      this.selectedPriceCategory,
      this.selectedDietaryOptions = const []});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late List<String> _selectedFilters;
  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  final Completer<GoogleMapController> _mapController = Completer();

  List<String> _selectedDietaryOptions = [];

  late lt.Distance _distance;
  List<Store> _filteredStores = [];
  late final Set<Marker> _markers = {};

  final _carouselController = CarouselSliderController();

  String? _selectedPriceCategory;
  List<Store> _storesToFilter = [];
  late List<String> _filters = [];

  late String _storeInFocus;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));

    _selectedPriceCategory = widget.selectedPriceCategory;

    _selectedDeliveryFeeIndex = widget.selectedDeliveryFeeIndex;
    _selectedRatingIndex = widget.selectedRatingIndex;
    _selectedDietaryOptions = widget.selectedDietaryOptions;
    _distance = const lt.Distance(
      roundResult: true,
    );
    _storesToFilter = widget.filteredStores;
    _filteredStores = widget.filteredStores;
    _selectedFilters = widget.selectedFilters
        .where(
          (element) => element != 'Pickup' && element != 'Sort',
        )
        .toList();
    _filters = OtherConstants.filters
        .where(
          (element) => element != 'Pickup' && element != 'Sort',
        )
        .toList();
    _storeInFocus = _filteredStores.first.name;
    _markers.add(
      Marker(
          icon: widget.markerIcon,
          markerId: const MarkerId('user_Location'),
          position: LatLng(
              widget.userLocation.latitude, widget.userLocation.longitude)),
    );
    for (var i = 0; i < _filteredStores.length; i++) {
      final storeLatlng = _filteredStores[i].location.latlng as GeoPoint;
      _markers.add(
        Marker(
            onTap: () async {
              final controller = await _mapController.future;

              await controller.moveCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target:
                          LatLng(storeLatlng.latitude, storeLatlng.longitude),
                      zoom: 15)));
              await _carouselController.animateToPage(i);
              // setState(() {
              _storeInFocus = _filteredStores[i].name;
              // });
              // _carouselController.jumpTo(e.)
            },
            icon: widget.storeMarkerIcons[i],
            markerId: MarkerId(_filteredStores[i].name),
            position: LatLng(storeLatlng.latitude, storeLatlng.longitude)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Builder(builder: (context) {
            // final storeLatlng =
            //     _filteredStores.first.location.latlng as GeoPoint;
            return GoogleMap(
              buildingsEnabled: false,
              markers: _markers.map(
                (e) {
                  //                 logger.d(e.markerId.value == _storeInFocus);
                  //                 if (e.markerId.value == _storeInFocus) {
                  //                   final store = _storesToFilter.firstWhere((element) => element.name == e.markerId.value,);
                  //                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                  // final selectedMarker =  await Transform.flip(
                  //                                             flipY: true,
                  //                                             child: Container(
                  //                                               padding:
                  //                                                   const EdgeInsets.all(10),
                  //                                               decoration: BoxDecoration(
                  //                                                   color: AppColors.neutral300,
                  //                                                   borderRadius:
                  //                                                       BorderRadius.circular(
                  //                                                           50)),
                  //                                               child:
                  //                                                          store .rating
                  //                                                           .averageRating >=
                  //                                                       4
                  //                                                   ? AppText(
                  //                                                       text: store
                  //                                                           .rating
                  //                                                           .averageRating
                  //                                                           .toStringAsFixed(1),
                  //                                                       color: Colors.black,
                  //                                                       weight: FontWeight.bold,
                  //                                                     )
                  //                                                   : Image.asset(
                  //                                                       width: 25,
                  //                                                       store
                  //                                                               .type
                  //                                                               .toLowerCase()
                  //                                                               .contains(
                  //                                                                   'grocery')
                  //                                                           ? AssetNames
                  //                                                               .groceryMarker
                  //                                                           : AssetNames
                  //                                                               .restaurantMarker),
                  //                                             )).toBitmapDescriptor();

                  //   });

                  //                   return Marker(
                  //                       icon: selectedMarker,  onTap: () async {
                  //                         final controller = await _mapController.future;

                  //                         await controller.moveCamera(
                  //                             CameraUpdate.newCameraPosition(CameraPosition(
                  //                                 target: LatLng(storeLatlng.latitude,
                  //                                     storeLatlng.longitude),
                  //                                 zoom: 15)));
                  //                       },
                  //                       markerId: MarkerId(_storeInFocus),
                  //                       position: LatLng(
                  //                           storeLatlng.latitude, storeLatlng.longitude));
                  //                 } else {
                  return e;
                  // }
                },
              ).toSet(),
              zoomControlsEnabled: false,
              mapType: MapType.terrain,
              minMaxZoomPreference: const MinMaxZoomPreference(10, 30),
              onMapCreated: (controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(widget.userLocation.latitude,
                      widget.userLocation.longitude),
                  zoom: 15),
            );
          }),
          SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => navigatorKey.currentState!.pop(),
                          child: Ink(
                            child: Container(
                              padding: const EdgeInsets.all(4),
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
                            height: 9,
                            fillColor: Colors.white,
                            textInputAction: TextInputAction.search,
                            onFieldSubmitted: (value) async {
                              if (value != null) {
                                _storesToFilter = allStores
                                    .where(
                                      (element) => element.name
                                          .toLowerCase()
                                          .contains(value.toLowerCase()),
                                    )
                                    .toList();
                                _markers.clear();
                                for (var i = 0;
                                    i < _storesToFilter.length;
                                    i++) {
                                  final storeLatlng = _storesToFilter[i]
                                      .location
                                      .latlng as GeoPoint;
                                  _markers.add(
                                    Marker(
                                        onTap: () async {
                                          final controller =
                                              await _mapController.future;

                                          await controller.moveCamera(
                                              CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                      target: LatLng(
                                                          storeLatlng.latitude,
                                                          storeLatlng
                                                              .longitude),
                                                      zoom: 15)));
                                          await _carouselController
                                              .animateToPage(i);
                                          // setState(() {
                                          _storeInFocus =
                                              _storesToFilter[i].name;
                                          // });
                                          // _carouselController.jumpTo(e.)
                                        },
                                        icon: await Transform.flip(
                                            flipY: true,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: _storesToFilter[i]
                                                          .rating
                                                          .averageRating >=
                                                      4
                                                  ? AppText(
                                                      text: _storesToFilter[i]
                                                          .rating
                                                          .averageRating
                                                          .toStringAsFixed(1),
                                                      color: Colors.black,
                                                      weight: FontWeight.bold,
                                                    )
                                                  : Image.asset(
                                                      width: 25,
                                                      _storesToFilter[i]
                                                              .type
                                                              .toLowerCase()
                                                              .contains(
                                                                  'grocery')
                                                          ? AssetNames
                                                              .groceryMarker
                                                          : AssetNames
                                                              .restaurantMarker),
                                            )).toBitmapDescriptor(),
                                        markerId:
                                            MarkerId(_storesToFilter[i].name),
                                        position: LatLng(storeLatlng.latitude,
                                            storeLatlng.longitude)),
                                  );
                                }

                                setState(() {
                                  _selectedFilters = [];
                                  _selectedDeliveryFeeIndex = null;
                                  _selectedDietaryOptions = [];
                                  _selectedPriceCategory = null;
                                  _selectedRatingIndex = null;
                                  _filteredStores = _storesToFilter;
                                  _storeInFocus = _filteredStores.first.name;
                                });
                              }
                            },
                            enabled: true,
                            hintText: 'Search Pickup',
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
                      if (i < 2) {
                        return AppText(
                          text: item.label,
                        );
                      } else if (i == 2) {
                        if (_selectedDeliveryFeeIndex == null) {
                          return AppText(
                            text: item.label,
                          );
                        } else {
                          return AppText(
                              text: OtherConstants.deliveryPriceFilters[
                                  _selectedDeliveryFeeIndex!]);
                        }
                      } else if (i == 3) {
                        if (_selectedRatingIndex == null) {
                          return AppText(
                            text: item.label,
                          );
                        } else {
                          return AppText(
                              text: OtherConstants
                                  .ratingsFilters[_selectedRatingIndex!]);
                        }
                      } else if (i == 4) {
                        if (_selectedPriceCategory == null) {
                          return AppText(
                            text: item.label,
                          );
                        } else {
                          return AppText(text: _selectedPriceCategory!);
                        }
                      } else {
                        if (_selectedDietaryOptions.isEmpty) {
                          return AppText(
                            text: item.label,
                          );
                        } else {
                          return AppText(
                              text:
                                  '${item.label}(${_selectedDietaryOptions.length})');
                        }
                      }
                    },
                    choiceTrailingBuilder: (item, i) {
                      if (i > 1) {
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

                      if (_filters.indexOf(tappedFilter) == 2) {
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
                      } else if (_filters.indexOf(tappedFilter) == 3) {
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
                                                          : '5'),
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
                      } else if (_filters.indexOf(tappedFilter) == 4) {
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
                      } else if (_filters.indexOf(tappedFilter) == 5) {
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
                      color: Colors.white,
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: AppSizes.horizontalPaddingSmall),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async {
                          final controller = await _mapController.future;

                          await controller.moveCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(widget.userLocation.latitude,
                                      widget.userLocation.longitude),
                                  zoom: 15)));
                          setState(() {});
                        },
                        child: Ink(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: const Iconify(
                              Bi.cursor_fill,
                              size: 15,
                              color: Colors.black,
                            ),
                          ),
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
                    itemCount: _filteredStores.length,
                    itemBuilder: (context, index, realIndex) {
                      final store = _filteredStores[index];
                      final storelatLng = store.location.latlng as GeoPoint;

                      return InkWell(
                        onTap: () async {
                          if (_storeInFocus == store.name) {
                            await AppFunctions.navigateToStoreScreen(store);
                          } else {
                            final controller = await _mapController.future;
                            final storelatLng = _filteredStores[index]
                                .location
                                .latlng as GeoPoint;

                            await controller.moveCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(storelatLng.latitude,
                                        storelatLng.longitude),
                                    zoom: 15)));
                            await _carouselController.animateToPage(index);
                            setState(() {
                              _storeInFocus = _filteredStores[index].name;
                            });
                          }
                        },
                        child: Ink(
                          child: Card(
                            color: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: AppFunctions.displayNetworkImage(
                                        width: double.infinity,
                                        store.cardImage,
                                        fit: BoxFit.cover,
                                        height: 105,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FavouriteButton(store: store),
                                    )
                                  ],
                                ),
                                ListTile(
                                  minTileHeight: 60,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
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
                                              '${store.delivery.estimatedDeliveryTime} min • ${_distance.as(lt.LengthUnit.Kilometer, lt.LatLng(storelatLng.latitude, storelatLng.longitude), lt.LatLng(widget.userLocation.latitude, widget.userLocation.longitude))} km'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                          final storelatLng = _filteredStores[index]
                              .location
                              .latlng as GeoPoint;

                          await controller.moveCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(storelatLng.latitude,
                                      storelatLng.longitude),
                                  zoom: 15)));
                          setState(() {
                            _storeInFocus = _filteredStores[index].name;
                          });
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
    Iterable<Store> storesIterable = _storesToFilter;
    storesIterable = storesIterable.where(
      (element) => element.doesPickup == true,
    );

    for (var filter in selectedFilters) {
      if (filter == 'Uber One') {
        storesIterable = storesIterable.where(
          (element) => element.isUberOneShop == true,
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
    _markers.clear();
    if (selectedFilters.isNotEmpty) {
      for (var i = 0; i < storesIterable.length; i++) {
        final storeLatlng =
            storesIterable.elementAt(i).location.latlng as GeoPoint;
        _markers.add(
          Marker(
              onTap: () async {
                final controller = await _mapController.future;

                await controller.moveCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target:
                            LatLng(storeLatlng.latitude, storeLatlng.longitude),
                        zoom: 15)));
                await _carouselController.animateToPage(i);
                // setState(() {
                _storeInFocus = storesIterable.elementAt(i).name;
                // });
                // _carouselController.jumpTo(e.)
              },
              icon: widget.storeMarkerIcons[i],
              markerId: MarkerId(storesIterable.elementAt(i).name),
              position: LatLng(storeLatlng.latitude, storeLatlng.longitude)),
        );
      }
    }
    _filteredStores = storesIterable.toList();
  }
}
