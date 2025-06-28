import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/octicon.dart';

import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:marquee_list/marquee_list.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/features/uber_one/join_uber_one_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_functions.dart';
import '../../../main.dart';
import '../../../models/store/store_model.dart';
import '../../constants/asset_names.dart';
import '../../constants/weblinks.dart';
import '../../core/app_text.dart';
import '../../../models/place_detail/place_detail_model.dart';

class StoreDetailsScreen extends StatefulWidget {
  final Store store;
  final double distance;
  final PlaceLocation location;
  final BitmapDescriptor markerIcon;
  const StoreDetailsScreen({
    super.key,
    required this.location,
    required this.distance,
    required this.markerIcon,
    required this.store,
  });

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  late final LatLng _setLatLng;
  bool _timeExpanded = false;
  late LatLng _initialCameraPositionTarget;
  late GeoPoint _storeGeoPoint;
  final Set<Polyline> _polylines = {};
  late final LatLng _storeLatLng;

  @override
  void initState() {
    super.initState();
    _setLatLng = LatLng(widget.location.lat!, widget.location.lng!);
    _storeGeoPoint = widget.store.location.latlng as GeoPoint;
    _storeLatLng = LatLng(_storeGeoPoint.latitude, _storeGeoPoint.longitude);

    _initialCameraPositionTarget = LatLng(
        (widget.location.lat! + _storeGeoPoint.latitude) / 2,
        (widget.location.lng! + _storeGeoPoint.longitude) / 2);
    _polylines.add(Polyline(
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: 3,
        geodesic: true,
        jointType: JointType.round,
        zIndex: 2,
        polylineId: const PolylineId("polyline"),
        color: Colors.black,
        points: MapsCurvedLines.getPointsOnCurve(_storeLatLng, _setLatLng)));
    _polylines.add(Polyline(
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: 1,
        jointType: JointType.round,
        polylineId: const PolylineId("polyline"),
        color: AppColors.neutral300,
        points: [_storeLatLng, _setLatLng]));
  }

  @override
  Widget build(BuildContext context) {
    final timeOfDayNow = TimeOfDay.now();
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar.medium(
                automaticallyImplyLeading: false,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      // Container(
                      //   width: double.infinity,
                      //   height: double.infinity,
                      //   color: Colors.grey,
                      // ),
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: GoogleMap(
                          liteModeEnabled: true,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: true,
                          tiltGesturesEnabled: false,
                          polylines: _polylines,
                          markers: {
                            Marker(
                                markerId: const MarkerId('set_location'),
                                icon: widget.markerIcon,
                                anchor: const Offset(0.4, 0),
                                position: _setLatLng),
                            Marker(
                                markerId: const MarkerId('store_location'),
                                icon: widget.markerIcon,
                                anchor: const Offset(0.4, 0),
                                infoWindow:
                                    InfoWindow(title: '${widget.distance} km'),
                                position: _storeLatLng)
                          },
                          initialCameraPosition: CameraPosition(
                              target: _initialCameraPositionTarget, zoom: 13),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              AppSizes.horizontalPaddingSmall),
                          child: InkWell(
                              onTap: navigatorKey.currentState!.pop,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Icon(Icons.arrow_back),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                pinned: true,
                floating: true,
                title: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          navigatorKey.currentState!.pop();
                        },
                        child: Ink(child: const Icon(Icons.arrow_back))),
                    const Gap(10),
                    AppText(
                      text: widget.store.name,
                      size: AppSizes.heading6,
                    ),
                  ],
                ),
              )
            ];
          },
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
                child: MarqueeList(
                  scrollDuration: const Duration(seconds: 15),
                  children: [
                    AppText(
                        color: AppColors.neutral600,
                        text: widget.store.location.countryOfOrigin),
                    AppText(
                        color: AppColors.neutral600,
                        text: " • ${widget.store.type}"),
                    if (widget.store.groupSize != null)
                      const AppText(
                          color: AppColors.neutral600,
                          text: ' • Group Friendly'),
                    AppText(
                        color: AppColors.neutral600,
                        text: " • ${widget.store.priceCategory}")
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.pin_drop_outlined,
                ),
                title: AppText(text: widget.store.location.streetAddress),
                trailing: InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(
                        text: widget.store.location.streetAddress));
                  },
                  child: Ink(
                    child: const Icon(
                      Icons.copy,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const Divider(
                indent: 55,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  onExpansionChanged: (value) {
                    setState(() {
                      _timeExpanded = value;
                    });
                  },
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.centerLeft,
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 55),
                  leading: const Icon(
                    Icons.watch_later,
                  ),
                  title: AppText(
                      text: timeOfDayNow.isBefore(widget.store.openingTime) ||
                              timeOfDayNow.isAfter(widget.store.closingTime)
                          ? "Opens at ${AppFunctions.formatDate(widget.store.openingTime.toString(), format: 'h:i A')}"
                          : "Opens until ${AppFunctions.formatDate(widget.store.closingTime.toString(), format: 'h:i A')}"),
                  trailing: _timeExpanded
                      ? const Iconify(
                          Octicon.dash_16,
                          size: 20,
                        )
                      : const Icon(
                          Icons.add_outlined,
                          size: 20,
                        ),
                  children: [
                    const AppText(
                      text: 'Sunday',
                    ),
                    AppText(
                      text:
                          "${AppFunctions.formatDate(widget.store.openingTime.toString(), format: 'h:i A')} - ${AppFunctions.formatDate(widget.store.closingTime.toString(), format: 'h:i A')}",
                      color: AppColors.neutral500,
                    ),
                    const AppText(text: 'Monday - Friday'),
                    AppText(
                      text:
                          "${AppFunctions.formatDate(widget.store.openingTime.toString(), format: 'h:i A')} - ${AppFunctions.formatDate(widget.store.closingTime.toString(), format: 'h:i A')}",
                      color: AppColors.neutral500,
                    ),
                    const AppText(text: 'Saturday'),
                    AppText(
                      text:
                          "${AppFunctions.formatDate(widget.store.openingTime.toString(), format: 'h:i A')} - ${AppFunctions.formatDate(widget.store.closingTime.toString(), format: 'h:i A')}",
                      color: AppColors.neutral500,
                    ),
                    const Gap(10),
                  ],
                ),
              ),
              const Divider(
                indent: 55,
              ),
              ListTile(
                onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const JoinUberOneScreen(),
                )),
                leading: Image.asset(
                  AssetNames.uberOneSmall,
                  width: 21,
                ),
                title: const AppText(
                    text: 'Get a \$0 Delivery Fee + up to 10% off'),
                subtitle: const AppText(
                  text: 'Try Uber One to save on eligible orders',
                  color: AppColors.neutral500,
                ),
              ),
              const Divider(
                indent: 55,
              ),
              ListTile(
                leading: const Icon(
                  Icons.star_outline,
                ),
                title: AppText(
                    text:
                        "${widget.store.rating.averageRating} (${widget.store.rating.averageRating}+ ratings)"),
              ),
              const Divider(),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: RichText(
                  text: TextSpan(
                      text:
                          "WARNING: Certain foods and beverages sold or served here canexpose you to chemicals including acrylamide in many fried orbaked foods, and mercury in fish, which are known to the State ofCalifornia to cause cancer and birth defects or other reproductiveharm. For more information go to ",
                      style: const TextStyle(
                        fontSize: AppSizes.bodySmallest,
                        color: AppColors.neutral500,
                      ),
                      children: [
                        TextSpan(
                          text: 'www.P65Warnings.ca.gov/restaurant.',
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await launchUrl(Uri.parse(Weblinks.p65Warnings));
                            },
                        ),
                      ]),
                ),
              ),
            ],
          )),
    );
  }
}
