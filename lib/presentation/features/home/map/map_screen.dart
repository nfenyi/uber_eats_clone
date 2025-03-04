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

class MapScreen extends StatefulWidget {
  final List<Store> filteredStores;
  final List<String>? selectedFilters;
  final LocationData userLocation;
  const MapScreen(
      {super.key,
      required this.filteredStores,
      required this.userLocation,
      this.selectedFilters});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final List<String> _selectedFilters;
  int? _selectedDeliveryFeeIndex;
  int? _selectedRatingIndex;
  final Completer<GoogleMapController> _mapController = Completer();
  String? _selectedPrice;
  List<String> _selectedDietaryOptions = [];
  String? _selectedSort;
  late lt.Distance _distance;
  List<Store> _stores = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
    _selectedFilters = widget.selectedFilters!;
    _distance = const lt.Distance(
      roundResult: true,
    );
    _stores = widget.filteredStores;
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
            markers: _stores
                .map(
                  (e) => Marker(
                      markerId: MarkerId(e.name),
                      position: LatLng(e.location.latlng.latitude,
                          e.location.latlng.longitude)),
                )
                .toSet(),
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
                    onChanged: (value) {},
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppSizes.horizontalPaddingSmall),
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child:
                            InkWell(child: Ink(child: const Icon(Icons.list)))),
                  ),
                  const Gap(15),
                  CarouselSlider.builder(
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
