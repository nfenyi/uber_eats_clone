import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/services/google_maps_services.dart';
import 'package:latlong2/latlong.dart' as lt;

import '../../../constants/asset_names.dart';
import '../../../services/place_detail_model.dart';

class ConfirmLocationScreen extends ConsumerStatefulWidget {
  final LatLng initialLocation;

  final BitmapDescriptor markerIcon;

  const ConfirmLocationScreen(
      {super.key, required this.initialLocation, required this.markerIcon});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmLocationState();
}

class _ConfirmLocationState extends ConsumerState<ConfirmLocationScreen>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _mapController = Completer();
  late AnimationController _animationController;
  late Animation<double> _translation;
  late LatLng _setLocation;
  final _outOfBoundsString = 'Out of bounds of initially set location';

  bool _showLocationName = true;

  String _locationName = ' ■ ';

  Color _labelColor = Colors.black;

  String? _resultName;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjust duration for speed
    ); // Repeat the animation back and forth

    _translation = Tween<double>(begin: 0, end: -5).animate(
      // Adjust value for hop height
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut), // Smooth animation
    );
    _setLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Adaptive.h(70),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    children: [
                      GoogleMap(
                        circles: {
                          Circle(
                              circleId: const CircleId('set_location'),
                              strokeColor: Colors.black,
                              strokeWidth: 2,
                              radius: 500,
                              center: widget.initialLocation)
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: true,
                        minMaxZoomPreference:
                            const MinMaxZoomPreference(10, 30),
                        onMapCreated: (controller) {
                          _mapController.complete(controller);
                        },
                        onCameraMove: (position) {
                          _setLocation = position.target;
                        },
                        onCameraIdle: () async {
                          setState(() {
                            _showLocationName = true;
                          });
                          const distance = lt.Distance(roundResult: true);
                          final distanceResult = distance(
                              lt.LatLng(widget.initialLocation.latitude,
                                  widget.initialLocation.longitude),
                              lt.LatLng(_setLocation.latitude,
                                  _setLocation.longitude));
                          await _animationController.reverse();
                          if (distanceResult <= 500) {
                            final result = await GoogleMapsServices()
                                .fetchDetailsFromLatlng(latlng: _setLocation);
                            final List<PlaceResult> payload = result.payload;
                            _resultName = payload.first.formattedAddress;
                            if (_resultName == null) {
                              _locationName = ' ■ ';
                            } else {
                              var strings = _resultName!.split(',');

                              if (strings.length > 2) {
                                if (strings.length == 3) {
                                  _locationName = '${strings[0]},${strings[1]}';
                                } else {
                                  _locationName =
                                      '${strings[0]},${strings[1]},${strings[2]}';
                                }
                              } else {
                                _locationName = '${strings[0]},${strings[1]}';
                              }
                              _labelColor = Colors.black;
                            }
                          } else {
                            _locationName = _outOfBoundsString;
                            _labelColor = Colors.red.shade900;
                          }
                        },
                        onCameraMoveStarted: () {
                          _animationController.forward();
                          setState(() {
                            _showLocationName = false;
                          });
                        },
                        initialCameraPosition: CameraPosition(
                            target: widget.initialLocation, zoom: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => navigatorKey.currentState!.pop(),
                                  child: Ink(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Icon(Icons.arrow_back),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible:
                                  _setLocation.latitude.toStringAsFixed(5) !=
                                          widget.initialLocation.latitude
                                              .toStringAsFixed(5) &&
                                      _setLocation.longitude
                                              .toStringAsExponential(5) !=
                                          widget.initialLocation.longitude
                                              .toStringAsFixed(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      final controller =
                                          await _mapController.future;

                                      await controller.moveCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target:
                                                      widget.initialLocation,
                                                  zoom: 15)));
                                    },
                                    child: Ink(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Icon(Icons.my_location),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  //So that the tip of the marker is on the point of reference not the top of the marker
                  AnimatedBuilder(
                      animation: _translation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _translation.value),
                          child: child,
                        );
                      },
                      child: Transform.translate(
                        offset: const Offset(0, -25),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Image.asset(
                              AssetNames.mapMarker,
                              height: 45,
                            ),
                            Transform.translate(
                              offset: const Offset(0, 2),
                              child: AnimatedContainer(
                                padding: const EdgeInsets.all(5),
                                duration: const Duration(milliseconds: 100),
                                decoration: BoxDecoration(
                                    color: _labelColor,
                                    borderRadius: BorderRadius.circular(50)),
                                child: AppText(
                                  textAlign: _showLocationName
                                      ? TextAlign.center
                                      : TextAlign.start,
                                  text:
                                      _showLocationName ? _locationName : ' ■ ',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            const Gap(20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Confirm delivery address',
                          size: AppSizes.heading6,
                        ),
                        Gap(10),
                        AppText(
                            text:
                                'Move the pin to highlight the correct door or entrance to help drivers deliver orders faster.'),
                      ],
                    ),
                    Column(
                      children: [
                        AppButton(
                          text: 'Confirm Location',
                          callback: _resultName == null ||
                                  _locationName == _outOfBoundsString
                              ? null
                              : () {
                                  navigatorKey.currentState!
                                      .pop([_setLocation, _resultName]);
                                },
                        ),
                        const Gap(10)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
