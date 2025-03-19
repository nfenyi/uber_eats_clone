import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepcopy/deepcopy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:google_places_autocomplete/google_places_autocomplete.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:location/location.dart';
import 'package:uber_eats_clone/hive_adapters/geopoint/geopoint_adapter.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/payment_options_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/schedule_delivery_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/states/onboarding_state_model.dart';
import 'package:uber_eats_clone/presentation/services/google_location_model.dart';
import 'package:uber_eats_clone/presentation/services/google_maps_services.dart';
import 'package:uber_eats_clone/presentation/services/place_detail_model.dart';

import '../../../../app_functions.dart';
import '../../../../state/delivery_schedule_provider.dart'
    show deliveryScheduleProvider;
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import 'address_details_screen.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  // late final GooglePlacesAutocomplete _googlePlaces;
  final Location _location = Location();

  late bool _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _userLocationData;
  bool _isLoading = false;

  List<Prediction> _predictions = [];
  Timer? _debounce;

  final _addressController = TextEditingController();

  late String _accountType;

  Future<void> _getCurrentLocation() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _userLocationData = await _location.getLocation();
  }

  String? _selectedAddressLabel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? schedule = ref.watch(deliveryScheduleProvider);
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Addresses',
          size: AppSizes.heading6,
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable:
              Hive.box(AppBoxes.appState).listenable(keys: [BoxKeys.userInfo]),
          builder: (context, value, child) {
            Map? storedUserInfo =
                Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
            List<AddressDetails> recentAddresses = [];
            if (storedUserInfo != null) {
              List addressesAsList = storedUserInfo['addresses'];
              var hiveJsonAddresses = addressesAsList.deepcopy();

              for (var hiveJsonAddress in hiveJsonAddresses) {
                //converting hivegeopoint to geopoint
                hiveJsonAddress['latlng'] = GeoPoint(
                    hiveJsonAddress['latlng'].latitude,
                    hiveJsonAddress['latlng'].longitude);
                hiveJsonAddress as Map<dynamic, dynamic>;
                //🙄
                Map<String, dynamic> stringedKeyMap =
                    hiveJsonAddress.map((key, value) {
                  return MapEntry(key.toString(), value);
                });
                recentAddresses.add(AddressDetails.fromJson(stringedKeyMap));
              }

              _selectedAddressLabel =
                  storedUserInfo['selectedAddress']['addressLabel'];
              _accountType = storedUserInfo['type'];
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                    children: [
                      if (recentAddresses.isEmpty)
                        const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                size: AppSizes.heading6,
                                text: 'Find what you need near you',
                                weight: FontWeight.w600,
                              ),
                              Gap(10),
                              AppText(
                                size: AppSizes.bodySmall,
                                text:
                                    'We use your address to help you find the best spots nearby.',
                              ),
                              Gap(25),
                            ]),
                      TextFormField(
                        onChanged: (value) async {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 500),
                              () async {
                            final result = await GoogleMapsServices()
                                .fetchPredictions(
                                    query: value, location: _userLocationData);
                            _predictions = result.payload;

                            setState(() {});
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search for an address',
                            filled: true,
                            fillColor: AppColors.neutral100,
                            prefixIcon: const Icon(Icons.search),
                            suffixIconConstraints:
                                const BoxConstraints.tightFor(height: 20),
                            suffixIcon: _addressController.text.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          _addressController.clear();
                                          setState(() {});
                                        },
                                        child: const Icon(Icons.cancel)),
                                  )
                                : null,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)))),
                        controller: _addressController,
                      ),
                      const Gap(20),
                      _addressController.text.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const AppText(
                                  text: 'Explore nearby',
                                  weight: FontWeight.w600,
                                  size: AppSizes.heading6,
                                ),
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 15),
                                  leading: const Iconify(
                                    Bi.cursor,
                                    size: 15,
                                  ),
                                  titleAlignment: ListTileTitleAlignment.center,
                                  // dense: true,
                                  title: const AppText(
                                    text: 'Use current location',
                                    size: AppSizes.bodySmall,
                                  ),
                                  trailing: AppButton2(
                                    text: _isLoading
                                        ? 'Please wait...'
                                        : 'Enable',
                                    callback: () async {
                                      if (_permissionGranted !=
                                              PermissionStatus.granted &&
                                          _permissionGranted !=
                                              PermissionStatus.grantedLimited) {
                                        await showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            bool allowButtonIsLoading = false;
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      AppSizes
                                                          .horizontalPaddingSmall),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Center(
                                                        child: AppText(
                                                          text:
                                                              'Allow location access',
                                                          size:
                                                              AppSizes.heading6,
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const Gap(5),
                                                      const Divider(),
                                                      const Gap(5),
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AppText(
                                                                    text:
                                                                        'This lets us show you which restaurants and stores you can order from'),
                                                                Gap(15),
                                                                AppText(
                                                                    text:
                                                                        'Please go to permissions → Location and allow access'),
                                                              ],
                                                            ),
                                                          ),
                                                          Image.asset(
                                                            AssetNames
                                                                .allowLocation,
                                                            width: 60,
                                                          ),
                                                        ],
                                                      ),
                                                      const Gap(20),
                                                      AppButton(
                                                        isLoading:
                                                            allowButtonIsLoading,
                                                        text: 'Allow',
                                                        callback: () async {
                                                          setState(() {
                                                            allowButtonIsLoading =
                                                                true;
                                                          });
                                                          await _getCurrentLocation();

                                                          final result = await GoogleMapsServices()
                                                              .fetchDetailsFromLatlng(
                                                                  latlng: LatLng(
                                                                      _userLocationData!
                                                                          .latitude!,
                                                                      _userLocationData!
                                                                          .longitude!));
                                                          final List<
                                                                  PlaceResult>
                                                              payload =
                                                              result.payload;
                                                          final location =
                                                              payload
                                                                  .first
                                                                  .geometry!
                                                                  .location;
                                                          final BitmapDescriptor
                                                              bitmapDescriptor =
                                                              await BitmapDescriptor
                                                                  .asset(
                                                            const ImageConfiguration(
                                                                size: Size(30,
                                                                    46)), // Adjust size as needed
                                                            AssetNames
                                                                .mapMarker, // Path to your asset
                                                          );
                                                          navigatorKey
                                                              .currentState!
                                                              .pop();

                                                          await navigatorKey
                                                              .currentState!
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) {
                                                              return AddressDetailsScreen(
                                                                  addressesAlreadyExist:
                                                                      recentAddresses
                                                                          .isNotEmpty,
                                                                  placeDescription: result
                                                                      .payload[
                                                                          1]
                                                                      .formattedAddress,
                                                                  markerIcon:
                                                                      bitmapDescriptor,
                                                                  location:
                                                                      location!);
                                                            },
                                                          ));
                                                        },
                                                      ),
                                                      const Gap(10),
                                                      Center(
                                                        child: AppTextButton(
                                                          text: 'Close',
                                                          callback: () =>
                                                              navigatorKey
                                                                  .currentState!
                                                                  .pop(),
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
                                          _isLoading = true;
                                        });
                                        await _getCurrentLocation();
                                        // logger.d(_userLocationData);
                                        final result =
                                            await GoogleMapsServices()
                                                .fetchDetailsFromLatlng(
                                                    latlng: LatLng(
                                                        _userLocationData!
                                                            .latitude!,
                                                        _userLocationData!
                                                            .longitude!));
                                        final List<PlaceResult> payload =
                                            result.payload;
                                        final location =
                                            payload.first.geometry!.location;
                                        final BitmapDescriptor
                                            bitmapDescriptor =
                                            await BitmapDescriptor.asset(
                                          const ImageConfiguration(
                                              size: Size(30,
                                                  46)), // Adjust size as needed
                                          AssetNames
                                              .mapMarker, // Path to your asset
                                        );
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        await navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return AddressDetailsScreen(
                                                addressesAlreadyExist:
                                                    recentAddresses.isNotEmpty,
                                                placeDescription: result
                                                    .payload[1]
                                                    .formattedAddress,
                                                markerIcon: bitmapDescriptor,
                                                location: location!);
                                          },
                                        ));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final prediction = _predictions[index];
                                return ListTile(
                                  onTap: () async {
                                    try {
                                      final result = await GoogleMapsServices()
                                          .fetchDetailsFromPlaceID(
                                              id: prediction.placeId!);
                                      final List<PlaceResult> payload =
                                          result.payload;
                                      final location =
                                          payload.first.geometry!.location;
                                      final BitmapDescriptor bitmapDescriptor =
                                          await BitmapDescriptor.asset(
                                        const ImageConfiguration(
                                            size: Size(30,
                                                46)), // Adjust size as needed
                                        AssetNames
                                            .mapMarker, // Path to your asset
                                      );
                                      await navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return AddressDetailsScreen(
                                              addressesAlreadyExist:
                                                  recentAddresses.isNotEmpty,
                                              placeDescription:
                                                  prediction.description!,
                                              markerIcon: bitmapDescriptor,
                                              location: location!);
                                        },
                                      ));
                                    } on Exception catch (e) {
                                      await showAppInfoDialog(
                                          navigatorKey.currentContext!,
                                          description: e.toString());
                                    }
                                  },
                                  titleAlignment: ListTileTitleAlignment.center,
                                  horizontalTitleGap: 0,
                                  leading: const Iconify(
                                    size: 20,
                                    Ph.map_pin,
                                    color: AppColors.neutral500,
                                  ),
                                  title: AppText(
                                    text: prediction
                                        .structuredFormatting!.mainText!,
                                    weight: FontWeight.bold,
                                  ),
                                  subtitle: AppText(
                                      text: prediction.structuredFormatting
                                              ?.secondaryText ??
                                          "null"),
                                );
                              },
                              itemCount: _predictions.length <= 10
                                  ? _predictions.length
                                  : 10,
                            ),
                    ],
                  ),
                ),
                if (recentAddresses.isNotEmpty)
                  Form(
                    canPop: recentAddresses.any(
                      (element) =>
                          element.addressLabel == _selectedAddressLabel,
                    ),
                    onPopInvokedWithResult: (didPop, result) {
                      if (!didPop) {
                        showInfoToast(
                            seconds: 5,
                            'No active locaton set. Select an address from the Recent Addresses list.',
                            context: context);
                      }
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(10),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: AppText(
                              size: AppSizes.heading6,
                              text: 'Recent Addresses',
                              weight: FontWeight.w600,
                            ),
                          ),
                          const Gap(10),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: recentAddresses.length,
                            itemBuilder: (context, index) {
                              final address = recentAddresses[index];

                              return ListTile(
                                onTap: () async {
                                  if (_selectedAddressLabel !=
                                      address.addressLabel) {
                                    var temp = storedUserInfo!.deepcopy();
                                    for (var address in temp['addresses']) {
                                      address['latlng'] = HiveGeoPoint(
                                          latitude: address['latlng'].latitude,
                                          longitude:
                                              address['latlng'].longitude);
                                    }
                                    //Use address.copyWith instead?
                                    temp['selectedAddress'] = address.toJson();

                                    temp['selectedAddress']['latlng'] =
                                        HiveGeoPoint(
                                            latitude: address.latlng.latitude,
                                            longitude:
                                                address.latlng.longitude);
                                    await Hive.box(AppBoxes.appState)
                                        .put(BoxKeys.userInfo, temp);
                                    // setState(() {
                                    //   _selectedAddressLabel = address.addressLabel;
                                    // });
                                    navigatorKey.currentState!.pop(true);
                                  }
                                },
                                onLongPress: () async {
                                  await showAppInfoDialog(context,
                                      title: 'Delete?',
                                      description:
                                          'Are you sure you want to delete \'${address.addressLabel}\' address?');
                                },
                                leading: const Icon(
                                  Icons.pin_drop,
                                ),
                                tileColor: _selectedAddressLabel ==
                                        address.addressLabel
                                    ? AppColors.neutral100
                                    : null,
                                title: AppText(
                                  text: address.addressLabel,
                                  size: AppSizes.bodySmall,
                                ),
                                trailing: InkWell(
                                  onTap: () async {
                                    final BitmapDescriptor bitmapDescriptor =
                                        await BitmapDescriptor.asset(
                                      const ImageConfiguration(
                                          size: Size(
                                              30, 46)), // Adjust size as needed
                                      AssetNames
                                          .mapMarker, // Path to your asset
                                    );
                                    await navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          AddressDetailsScreen(
                                              addressLabel:
                                                  address.addressLabel,
                                              apartment: address.apartment,
                                              building: address.building,
                                              dropOffOption:
                                                  address.dropoffOption,
                                              instruction: address.instruction,
                                              navigatedWithAddressListTile:
                                                  true,
                                              addressesAlreadyExist: true,
                                              location: PlaceLocation(
                                                  lat: address.latlng.latitude,
                                                  lng:
                                                      address.latlng.longitude),
                                              placeDescription:
                                                  address.placeDescription,
                                              markerIcon: bitmapDescriptor),
                                    ));
                                  },
                                  child: Ink(
                                    child: const Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: AppColors.neutral500,
                                    ),
                                  ),
                                ),
                                subtitle: AppText(
                                  text: AppFunctions.formatPlaceDescription(
                                      address.placeDescription),
                                  color: AppColors.neutral500,
                                ),
                              );
                            },
                          ),
                          const Gap(15),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: AppText(
                              size: AppSizes.heading6,
                              text: 'Time preference',
                              weight: FontWeight.w600,
                            ),
                          ),
                          const Gap(10),
                          ListTile(
                            onTap: () async {
                              await navigatorKey.currentState!
                                  .push(MaterialPageRoute(
                                builder: (context) =>
                                    const ScheduleDeliveryScreen(),
                              ));
                            },
                            leading: const Icon(
                              Icons.watch_later_outlined,
                              color: AppColors.neutral500,
                            ),
                            title: AppText(
                              text: schedule == null
                                  ? 'Deliver now'
                                  : '${AppFunctions.formatDate(schedule.toString(), format: 'D, G:i A')} - ${AppFunctions.formatDate(schedule.add(const Duration(minutes: 30)).toString(), format: 'G:i A')}',
                              size: AppSizes.bodySmall,
                            ),
                            trailing: AppButton2(
                              text:
                                  schedule == null ? 'Schedule' : 'Deliver now',
                              callback: () async {
                                if (schedule == null) {
                                  await navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ScheduleDeliveryScreen(),
                                  ));
                                } else {
                                  ref
                                      .read(deliveryScheduleProvider.notifier)
                                      .state = null;
                                }
                              },
                            ),
                          ),
                          const Gap(10),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: AppText(
                              size: AppSizes.heading6,
                              text: 'Profile',
                              weight: FontWeight.w600,
                            ),
                          ),
                          const Gap(10),
                          ListTile(
                            onTap: () {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) =>
                                    const PaymentOptionsScreen(),
                              ));
                            },
                            leading: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: AppColors.neutral200,
                              padding: EdgeInsets.zero,
                              thumbColor: _accountType == 'Personal'
                                  ? Colors.black
                                  : Colors.green,
                              children: _accountType == 'Personal'
                                  ? const {
                                      0: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      1: Icon(
                                        FontAwesomeIcons.briefcase,
                                        size: 12,
                                      )
                                    }
                                  : const {
                                      0: Icon(
                                        Icons.person,
                                        size: 12,
                                      ),
                                      1: Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 3),
                                          child: Icon(
                                            FontAwesomeIcons.briefcase,
                                            color: Colors.white,
                                            size: 20,
                                          ))
                                    },
                              groupValue: _accountType == 'Personal' ? 0 : 1,
                              onValueChanged: (value) {},
                            ),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                            title: AppText(
                              text: _accountType,
                              size: AppSizes.bodySmall,
                            ),
                          ),
                        ]),
                  ),
              ],
            );
          }),
    );
  }
}

class AppButton2 extends StatefulWidget {
  final String text;
  final VoidCallback callback;
  final OutlinedBorder? shape;
  final Color color;

  const AppButton2({
    required this.text,
    required this.callback,
    this.shape,
    this.color = AppColors.neutral100,
    super.key,
  });

  @override
  State<AppButton2> createState() => _AppButton2State();
}

class _AppButton2State extends State<AppButton2> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.callback,
      style: TextButton.styleFrom(
        backgroundColor: widget.color,
        shape: widget.shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: AppText(
        text: widget.text,
        size: AppSizes.bodySmall,
      ),
    );
  }
}
