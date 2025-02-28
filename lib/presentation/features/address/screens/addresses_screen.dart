import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_autocomplete/google_places_autocomplete.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:location/location.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/payment_options_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/schedule_delivery_screen.dart';
import 'package:uber_eats_clone/presentation/services/google_location_model.dart';
import 'package:uber_eats_clone/presentation/services/google_maps_services.dart';
import 'package:uber_eats_clone/presentation/services/place_detail_model.dart';

import '../../../../app_functions.dart';
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
  bool _firstLogIn = true;
  List<Prediction> _predictions = [];
  Timer? _debounce;
  final List<Address> _recentAddresses = [
    Address(name: '222 NY-59', location: 'Suffen, NY'),
    Address(name: 'My Home', location: '1226 University Dr')
  ];
  final _addressController = TextEditingController();

  String _profile = 'Personal';

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

  DateTime? _timePreference;

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
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Addresses',
          size: AppSizes.heading6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_firstLogIn)
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
                _debounce = Timer(const Duration(milliseconds: 500), () async {
                  final result = await GoogleMapsServices().fetchPredictions(
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
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
              controller: _addressController,
            ),
            Visibility(
                visible: _addressController.text.isNotEmpty,
                child: Column(
                  children: [
                    const Gap(10),
                    //  TODO: wrap widget with flexible or expanded to account for popping of
                    //keyboard to prevent overflow and allow user to scroll to see content 'behind'
                    //keyboard
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final prediction = _predictions[index];
                        return ListTile(
                          onTap: () async {
                            try {
                              final result = await GoogleMapsServices()
                                  .fetchDetailsFromPlaceID(
                                      id: prediction.placeId!);
                              final List<PlaceResult> payload = result.payload;
                              final location = payload.first.geometry!.location;
                              final BitmapDescriptor bitmapDescriptor =
                                  await BitmapDescriptor.asset(
                                const ImageConfiguration(
                                    size:
                                        Size(30, 46)), // Adjust size as needed
                                AssetNames.mapMarker, // Path to your asset
                              );
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) {
                                  return AddressDetailsScreen(
                                      placeDescription: prediction.description!,
                                      markerIcon: bitmapDescriptor,
                                      location: location!);
                                },
                              ));
                            } on Exception catch (e) {
                              showAppInfoDialog(context,
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
                            text: prediction.structuredFormatting!.mainText!,
                            weight: FontWeight.bold,
                          ),
                          subtitle: AppText(
                              text: prediction
                                      .structuredFormatting?.secondaryText ??
                                  "null"),
                        );
                      },
                      itemCount:
                          _predictions.length <= 10 ? _predictions.length : 10,
                    ),
                  ],
                )),
            const Gap(20),
            Visibility(
              visible: _addressController.text.isEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'Explore nearby',
                    weight: FontWeight.w600,
                    size: AppSizes.heading6,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 15),
                    leading: const Iconify(
                      Bi.cursor,
                      size: 15,
                    ),
                    titleAlignment: ListTileTitleAlignment.center,
                    // dense: true,
                    title: const AppText(
                      text: 'Use current location',
                      size: AppSizes.bodySmaller,
                    ),
                    trailing: AppButton2(
                      text: _isLoading ? 'Please wait...' : 'Enable',
                      callback: () async {
                        if (_permissionGranted != PermissionStatus.granted &&
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
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        AppSizes.horizontalPaddingSmall),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: AppText(
                                            text: 'Allow location access',
                                            size: AppSizes.heading6,
                                            weight: FontWeight.w600,
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
                                                    CrossAxisAlignment.start,
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
                                              AssetNames.allowLocation,
                                              width: 60,
                                            ),
                                          ],
                                        ),
                                        const Gap(20),
                                        AppButton(
                                          isLoading: allowButtonIsLoading,
                                          text: 'Allow',
                                          callback: () async {
                                            setState(() {
                                              allowButtonIsLoading = true;
                                            });
                                            await _getCurrentLocation();

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
                                            final location = payload
                                                .first.geometry!.location;
                                            final BitmapDescriptor
                                                bitmapDescriptor =
                                                await BitmapDescriptor.asset(
                                              const ImageConfiguration(
                                                  size: Size(30,
                                                      46)), // Adjust size as needed
                                              AssetNames
                                                  .mapMarker, // Path to your asset
                                            );
                                            navigatorKey.currentState!.pop();
                                            navigatorKey.currentState!
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return AddressDetailsScreen(
                                                    placeDescription: result
                                                        .payload[1]
                                                        .formattedAddress,
                                                    markerIcon:
                                                        bitmapDescriptor,
                                                    location: location!);
                                              },
                                            ));
                                          },
                                        ),
                                        const Gap(10),
                                        Center(
                                          child: AppTextButton(
                                            text: 'Close',
                                            callback: () => navigatorKey
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
                          final result = await GoogleMapsServices()
                              .fetchDetailsFromLatlng(
                                  latlng: LatLng(_userLocationData!.latitude!,
                                      _userLocationData!.longitude!));
                          final List<PlaceResult> payload = result.payload;
                          final location = payload.first.geometry!.location;
                          final BitmapDescriptor bitmapDescriptor =
                              await BitmapDescriptor.asset(
                            const ImageConfiguration(
                                size: Size(30, 46)), // Adjust size as needed
                            AssetNames.mapMarker, // Path to your asset
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) {
                              return AddressDetailsScreen(
                                  placeDescription:
                                      result.payload[1].formattedAddress,
                                  markerIcon: bitmapDescriptor,
                                  location: location!);
                            },
                          ));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (!_firstLogIn)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Gap(10),
                const AppText(
                  size: AppSizes.heading6,
                  text: 'Recent Addresses',
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _recentAddresses.length,
                  itemBuilder: (context, index) {
                    final address = _recentAddresses[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.pin_drop,
                      ),
                      title: AppText(
                        text: address.name,
                        size: AppSizes.bodySmall,
                      ),
                      trailing: const Icon(
                        Icons.edit,
                        color: AppColors.neutral500,
                      ),
                      subtitle: AppText(
                        text: address.location,
                        color: AppColors.neutral500,
                      ),
                    );
                  },
                ),
                const Gap(15),
                const AppText(
                  size: AppSizes.heading6,
                  text: 'Time preference',
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.watch_later_outlined,
                  ),
                  title: AppText(
                    text: _timePreference == null
                        ? 'Deliver now'
                        : '${AppFunctions.formatDate(_timePreference.toString(), format: 'G:i A')} - ${AppFunctions.formatDate(_timePreference!.add(const Duration(minutes: 30)).toString(), format: 'G:i A')}',
                    size: AppSizes.bodySmall,
                  ),
                  trailing: AppButton2(
                    text: _timePreference == null ? 'Schedule' : 'Deliver now',
                    callback: () async {
                      if (_timePreference == null) {
                        _timePreference = await navigatorKey.currentState!
                            .push(MaterialPageRoute(
                          builder: (context) => const ScheduleDeliveryScreen(),
                        ));
                        setState(() {});
                      } else {
                        setState(() {
                          _timePreference = null;
                        });
                      }
                    },
                  ),
                ),
                const Gap(10),
                const AppText(
                  size: AppSizes.heading6,
                  text: 'Profile',
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                ListTile(
                  onTap: () {
                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const PaymentOptionsScreen(),
                    ));
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: AppColors.neutral200,
                    padding: EdgeInsets.zero,
                    thumbColor:
                        _profile == 'Personal' ? Colors.black : Colors.green,
                    children: _profile == 'Personal'
                        ? const {
                            0: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            1: Icon(
                              FontAwesomeIcons.briefcase,
                              size: 15,
                            )
                          }
                        : const {
                            0: Icon(
                              Icons.person,
                              size: 15,
                            ),
                            1: Padding(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Icon(
                                  FontAwesomeIcons.briefcase,
                                  color: Colors.white,
                                  size: 20,
                                ))
                          },
                    groupValue: _profile == 'Personal' ? 0 : 1,
                    onValueChanged: (value) {},
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  title: AppText(
                    text: _profile,
                    size: AppSizes.bodySmall,
                  ),
                ),
              ]),
          ],
        ),
      ),
    );
  }
}

class Address {
  final String name;
  final String location;

  Address({required this.name, required this.location});
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
      ),
    );
  }
}
