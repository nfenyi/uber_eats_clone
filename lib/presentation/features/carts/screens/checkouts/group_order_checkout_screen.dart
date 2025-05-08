import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/hive_adapters/cart_item/cart_item_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/other_constants.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';

import '../../../../../hive_adapters/geopoint/geopoint_adapter.dart';
import '../../../../../main.dart';
import '../../../../../models/promotion/promotion_model.dart';
import '../../../../../models/store/store_model.dart';
import '../../../../../state/user_location_providers.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import '../../../address/screens/addresses_screen.dart';
import '../../../payment_options/payment_options_screen.dart';
import '../../../address/screens/schedule_delivery_screen.dart';
import '../../../promotion/promo_screen.dart';
import '../../../settings/screens/phone_number/phone_number_update_screen.dart';
import '../../../sign_in/views/add_a_credit_card/add_a_credit_card_screen.dart';
import '../../../sign_in/views/confirm_location.dart';

class GroupOrderCheckoutScreen extends ConsumerStatefulWidget {
  final Promotion? promotion;

  final BitmapDescriptor markerIcon;
  final Store store;
  const GroupOrderCheckoutScreen(
      {super.key,
      required this.markerIcon,
      required this.promotion,
      required this.store});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderCheckoutScreenState();
}

class _GroupOrderCheckoutScreenState
    extends ConsumerState<GroupOrderCheckoutScreen> {
  late LatLng _setLocation;

  late String _placeDescription;
  late String _addressLabel;
  late String _instruction;
  late String? _phoneNumber;
  late HiveCartItem _cartItem;
  late int _redeemedPromosCount;
  late bool _isClosed;
  late bool _hasUberOne;

  late String _dropOffOption;

  late double _deliveryFee;

  late double _serviceFee;
  late final double _taxes;
  // late final DocumentReference _storeRef ;

  bool _isLoading = false;

  bool _isPriority = false;
  Promotion? _activatedPromo;

  String? _activatedPromoId;

  @override
  void initState() {
    super.initState();
    Map<dynamic, dynamic> userInfo =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    _hasUberOne = userInfo['uberOneStatus']['hasUberOne'] ?? false;
    Map<dynamic, dynamic> selectedAddress = userInfo['selectedAddress'];
    HiveGeoPoint temp = selectedAddress['latlng'];
    _placeDescription = selectedAddress['placeDescription'];
    _setLocation = LatLng(temp.latitude, temp.longitude);
    _addressLabel = selectedAddress['addressLabel'];
    _dropOffOption = selectedAddress['dropoffOption'];
    _instruction = selectedAddress['instruction'];
    _phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    _cartItem = Hive.box<HiveCartItem>(AppBoxes.carts).get(widget.store.id)!;
    _redeemedPromosCount = userInfo['redeemedPromos'].length;
    final timeOfDayNow = TimeOfDay.now();
    _isClosed = timeOfDayNow.isBefore(widget.store.openingTime) ||
        timeOfDayNow.isAfter(widget.store.closingTime);
    const distance = lt.Distance(roundResult: true);
    final storeLocation = widget.store.location.latlng as GeoPoint;
    final distanceBetweenShopAndSetLocationResult = distance.as(
        lt.LengthUnit.Kilometer,
        lt.LatLng(storeLocation.latitude, storeLocation.longitude),
        lt.LatLng(_setLocation.latitude, _setLocation.longitude));
    _deliveryFee = distanceBetweenShopAndSetLocationResult * 1;
    _serviceFee = 2 + (OtherConstants.serviceFee * _cartItem.products.length);
    _activatedPromo = widget.promotion;
    _taxes = OtherConstants.tax * _cartItem.subtotal;
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.read(userCurrentGeoLocationProvider);
    final schedule = ref.watch(deliveryScheduleProvider);

    double total = _cartItem.subtotal +
        _serviceFee +
        _taxes +
        _deliveryFee -
        (_activatedPromo?.discount ?? 0) -
        (_hasUberOne
            ? (OtherConstants.uberOneDiscount * _cartItem.subtotal)
            : 0);
    if (_isPriority) {
      total += 1.99;
    }
    total = double.parse(total.toStringAsFixed(2));
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverAppBar.medium(
                  title: AppText(
                    text: 'Checkout',
                    size: AppSizes.heading6,
                    weight: FontWeight.bold,
                  ),
                )
              ],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: GoogleMap(
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        markers: {
                          Marker(
                              markerId: const MarkerId('set_location'),
                              icon: widget.markerIcon,
                              position: _setLocation)
                        },
                        initialCameraPosition:
                            CameraPosition(target: _setLocation, zoom: 15),
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            final List? setLocationDetails = await navigatorKey
                                .currentState!
                                .push(MaterialPageRoute(
                              builder: (context) => ConfirmLocationScreen(
                                  markerIcon: widget.markerIcon,
                                  initialLocation: _setLocation),
                            ));
                            if (setLocationDetails != null) {
                              setState(() {
                                _setLocation = setLocationDetails.first;
                                _placeDescription = setLocationDetails.last;
                              });
                            }
                          },
                          child: Ink(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const AppText(text: 'Edit pin')),
                          ),
                        ),
                        const Gap(10)
                      ],
                    )
                  ],
                ),
                ListTile(
                  dense: true,
                  onTap: () async =>
                      navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => const AddressesScreen(),
                  )),
                  leading: _addressLabel == 'Work'
                      ? const Iconify(
                          Mdi.briefcase_outline,
                          color: AppColors.neutral500,
                        )
                      : const Icon(
                          Icons.person_outline,
                          color: AppColors.neutral500,
                        ),
                  title: AppText(
                    text: _addressLabel,
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.neutral500,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: _placeDescription.split(',').first,
                        size: AppSizes.bodySmallest,
                      ),
                      Builder(builder: (context) {
                        const distance = lt.Distance(roundResult: true);
                        final distanceResult = distance.as(
                            lt.LengthUnit.Meter,
                            lt.LatLng(currentLocation!.latitude!,
                                currentLocation.longitude!),
                            lt.LatLng(
                                _setLocation.latitude, _setLocation.longitude));

                        return distanceResult > 400
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(
                                        255, 253, 242, 220)),
                                padding: const EdgeInsets.all(5),
                                child: const AppText(
                                    text: 'Address seems far away'),
                              )
                            : const SizedBox.shrink();
                      })
                    ],
                  ),
                ),
                const Divider(
                  indent: 55,
                ),
                ListTile(
                  onTap: () async =>
                      navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => const AddressesScreen(),
                  )),
                  dense: true,
                  trailing: const Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.neutral500,
                  ),
                  leading: const Icon(Icons.person_outline),
                  title: AppText(
                    text: _dropOffOption,
                  ),
                  subtitle: AppText(
                    text: _instruction.isEmpty
                        ? 'Add delivery instructions'
                        : _instruction,
                    size: AppSizes.bodySmallest,
                    color: _instruction.isEmpty ? Colors.green : null,
                  ),
                ),
                const Divider(
                  indent: 55,
                ),
                ListTile(
                  onTap: () async =>
                      navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => const PhoneNumberUpdateScreen(),
                  )),
                  dense: true,
                  leading: const Icon(
                    Icons.phone_outlined,
                    color: AppColors.neutral500,
                  ),
                  title: AppText(
                    text: _phoneNumber ?? 'Add phone number',
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.neutral500,
                  ),
                ),
                const Divider(
                  indent: 55,
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.watch_later_outlined,
                    color: AppColors.neutral500,
                  ),
                  title: const AppText(text: 'Delivery time'),
                  trailing: AppText(
                      color: AppColors.neutral500,
                      text: schedule == null
                          ? _isClosed
                              ? ''
                              : '${widget.store.delivery.estimatedDeliveryTime} min'
                          : '${AppFunctions.formatDate(schedule.toString(), format: 'G:i A')} - ${AppFunctions.formatDate(schedule.add(const Duration(minutes: 30)).toString(), format: 'G:i A')}'),
                ),
                const Gap(5),
                SizedBox(
                  height: 110,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (!_isClosed)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isPriority = true;
                                });
                                ref
                                    .read(deliveryScheduleProvider.notifier)
                                    .state = null;
                              },
                              child: Ink(
                                child: Container(
                                  width: 180,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: _isPriority ? 2 : 1.5,
                                          color: _isPriority
                                              ? Colors.black
                                              : AppColors.neutral300),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          AppText(
                                            text: 'Priority',
                                            weight: FontWeight.bold,
                                          ),
                                          Gap(5),
                                          Icon(
                                            Icons.bolt_outlined,
                                            color: Colors.green,
                                          )
                                        ],
                                      ),
                                      Builder(builder: (context) {
                                        final reducedTime1 = widget.store
                                            .delivery.estimatedDeliveryTime
                                            .split('-')
                                            .first;
                                        final reducedTime2 = widget.store
                                            .delivery.estimatedDeliveryTime
                                            .split('-')
                                            .last;
                                        return AppText(
                                            size: AppSizes.bodySmallest,
                                            color: _isClosed
                                                ? Colors.grey.shade500
                                                : AppColors.neutral500,
                                            text:
                                                '${(int.parse(reducedTime1) - 5).toString()}-${(int.parse(reducedTime2) - 5).toString()} min');
                                      }),
                                      const AppText(
                                        text: 'Direct to you',
                                        color: Colors.green,
                                        size: AppSizes.bodySmallest,
                                      ),
                                      const AppText(
                                        text: '+ US\$1.99',
                                        size: AppSizes.bodySmallest,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                          ],
                        ),
                      InkWell(
                        onTap: _isClosed
                            ? null
                            : () {
                                if (_isPriority) {
                                  setState(() {
                                    _isPriority = false;
                                  });
                                }
                                ref
                                    .read(deliveryScheduleProvider.notifier)
                                    .state = null;
                              },
                        child: Ink(
                          child: Container(
                            width: 180,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: schedule == null &&
                                            !_isClosed &&
                                            !_isPriority
                                        ? 2
                                        : 1.5,
                                    color: schedule == null &&
                                            !_isClosed &&
                                            !_isPriority
                                        ? Colors.black
                                        : AppColors.neutral300),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'Standard',
                                  weight: FontWeight.bold,
                                  color:
                                      _isClosed ? Colors.grey.shade500 : null,
                                ),
                                AppText(
                                    size: AppSizes.bodySmallest,
                                    color: _isClosed
                                        ? Colors.grey.shade500
                                        : AppColors.neutral500,
                                    text: _isClosed
                                        ? 'Currently closed'
                                        : widget.store.delivery
                                            .estimatedDeliveryTime)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        onTap: () async {
                          await navigatorKey.currentState!
                              .push(MaterialPageRoute(
                            builder: (context) => const ScheduleDeliveryScreen(
                              isFromGiftScreen: false,
                            ),
                          ))
                              .then(
                            (value) {
                              if (schedule != null) {
                                setState(() {
                                  _isPriority = false;
                                });
                              }
                            },
                          );
                        },
                        child: Ink(
                          child: Container(
                            width: 180,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: schedule != null ? 2 : 1.5,
                                    color: schedule == null
                                        ? AppColors.neutral300
                                        : Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText(
                                  text: 'Schedule',
                                  weight: FontWeight.bold,
                                ),
                                AppText(
                                    size: AppSizes.bodySmallest,
                                    color: AppColors.neutral500,
                                    text: schedule == null
                                        ? 'Choose a time'
                                        : '${schedule.day - DateTime.now().day != 0 ? '${AppFunctions.formatDate(schedule.toString(), format: 'D, M j')}\n' : ''}${AppFunctions.formatDate(schedule.toString(), format: 'G:i A')} - ${AppFunctions.formatDate(schedule.add(const Duration(minutes: 30)).toString(), format: 'G:i A')}'),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  thickness: 3,
                ),
                ValueListenableBuilder(
                    valueListenable: Hive.box(AppBoxes.appState)
                        .listenable(keys: [BoxKeys.activatedPromoId]),
                    builder: (context, appState, child) {
                      _activatedPromoId =
                          appState.get(BoxKeys.activatedPromoId);
                      return Column(
                        children: [
                          _activatedPromoId == null
                              ? ListTile(
                                  dense: true,
                                  leading: const Iconify(
                                    AntDesign.tag_outline,
                                    color: AppColors.neutral500,
                                  ),
                                  title: AppText(
                                    text: _activatedPromoId == null
                                        ? 'Apply a promotion'
                                        : '$_redeemedPromosCount ${_redeemedPromosCount == 1 ? 'promotion' : 'promotions'} available',
                                    weight: FontWeight.bold,
                                  ),
                                  onTap: () => navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => const PromoScreen(),
                                  )),
                                  trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: AppColors.neutral500,
                                  ),
                                )
                              : FutureBuilder(
                                  future: AppFunctions.loadPromoReference(
                                      FirebaseFirestore.instance
                                          .collection(
                                              FirestoreCollections.promotions)
                                          .doc(_activatedPromoId!)),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      _activatedPromo = snapshot.data!;

                                      return ListTile(
                                        // titleAlignment: ListTileTitleAlignment.top,
                                        dense: true,
                                        leading: Iconify(
                                          AntDesign.tag_outline,
                                          color: Colors.green.shade900,
                                        ),
                                        title: AppText(
                                          text: _activatedPromo!.title,
                                          color: Colors.green.shade900,
                                        ),
                                        onTap: () => navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const PromoScreen(),
                                        )),
                                        trailing: const Icon(
                                          Icons.keyboard_arrow_right,
                                          color: AppColors.neutral500,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return AppText(
                                        text: snapshot.error.toString(),
                                      );
                                    } else {
                                      return const Skeletonizer(
                                        enabled: true,
                                        child: ListTile(
                                          dense: true,
                                          leading: Iconify(
                                            AntDesign.tag_outline,
                                            color: AppColors.neutral500,
                                          ),
                                          title: AppText(
                                            text:
                                                'njajasjkljakljjlksafjjlkajskljafsljlkafjkjlafkjslfs',
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                          ListTile(
                            dense: true,
                            title: const AppText(
                              text: 'Subtotal',
                              color: AppColors.neutral500,
                            ),
                            trailing: AppText(
                              text:
                                  'US\$${(_cartItem.subtotal - (_activatedPromo?.discount ?? 0) - (_hasUberOne ? (OtherConstants.uberOneDiscount * _cartItem.subtotal) : 0)).toStringAsFixed(2)}',
                              color: AppColors.neutral500,
                            ),
                          ),
                          ListTile(
                            dense: true,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Gap(10),
                                      const AppText(
                                        text: 'What\'s a delivery fee?',
                                        weight: FontWeight.bold,
                                        size: AppSizes.body,
                                      ),
                                      const Gap(5),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                AppSizes.horizontalPaddingSmall,
                                            vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const AppText(
                                                text:
                                                    'This fee helps cover delivery costs. The amount varies for each store based on things like your location and availability of nearby couriers.'),
                                            const Gap(15),
                                            AppButton(
                                              text: 'Close',
                                              callback: () => navigatorKey
                                                  .currentState!
                                                  .pop(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            title: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  text: 'Delivery fee',
                                  color: AppColors.neutral500,
                                ),
                                Gap(5),
                                Icon(
                                  Icons.info_outline,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                            trailing: AppText(
                              text: 'US\$${_deliveryFee.toStringAsFixed(2)}',
                              color: AppColors.neutral500,
                            ),
                          ),
                          ListTile(
                            dense: true,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Gap(10),
                                      const AppText(
                                        text: 'What\'s included?',
                                        weight: FontWeight.bold,
                                        size: AppSizes.body,
                                      ),
                                      const Gap(5),
                                      const Divider(),
                                      const Gap(5),
                                      ListTile(
                                        dense: true,
                                        title: const AppText(
                                          text: 'Service Fee and Other Fees',
                                          weight: FontWeight.bold,
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppText(
                                              text:
                                                  'US\$${_serviceFee.toStringAsFixed(2)}',
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                        subtitle: const AppText(
                                            text:
                                                'These fees vary based on factors like cart size and help cover costs related to your order including marketplace services and delivery services'),
                                      ),
                                      ListTile(
                                        dense: true,
                                        title: const AppText(
                                          text: 'Taxes',
                                          weight: FontWeight.bold,
                                        ),
                                        trailing: AppText(
                                          text:
                                              'US\$${_taxes.toStringAsFixed(2)}',
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(5),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        child: AppButton(
                                          text: 'Got it',
                                          callback: () =>
                                              navigatorKey.currentState!.pop(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            title: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  text: 'Taxes & Other Fees',
                                  color: AppColors.neutral500,
                                ),
                                Gap(5),
                                Icon(
                                  size: 15,
                                  Icons.info_outline,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                            titleAlignment: ListTileTitleAlignment.top,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  text:
                                      'US\$${(_serviceFee + _taxes).toStringAsFixed(2)}',
                                  color: AppColors.neutral500,
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            dense: true,
                            title: const AppText(
                              text: 'Total',
                              weight: FontWeight.bold,
                            ),
                            trailing: AppText(
                              text: 'US\$$total',
                            ),
                          ),
                        ],
                      );
                    }),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: PaymentOptionWidget(),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        color: AppColors.neutral500,
                        text:
                            'Commission: Restaurants are charged a commission up to 15% of the subtotal',
                        size: AppSizes.bodyTiny,
                      ),
                      AppText(
                        color: AppColors.neutral500,
                        text: 'Prices may be lower in store',
                        size: AppSizes.bodyTiny,
                      ),
                    ],
                  ),
                ),
                const Gap(20),
              ],
            ),
          )),
      persistentFooterButtons: [
        AppButton(isLoading: _isLoading, text: 'Next', callback: null

            // () async {
            //   if (_isClosed && schedule == null) {
            //     showInfoToast('Please select a delivery time', context: context);
            //     return;
            //   }

            //   final paymentOption = ref.read(paymentOptionProvider);
            //   if (paymentOption == null) {
            //     showInfoToast('Select a payment method', context: context);
            //   }
            //   setState(() {
            //     _isLoading = true;
            //   });
            //   List<CartProduct> cartProducts =
            //       AppFunctions.transformHiveProductToCartProduct(_cartItem);

            //   final order = IndividualOrder(
            //       userUid: FirebaseAuth.instance.currentUser!.uid,
            //       isPriority: _isPriority,
            //       products: cartProducts,
            //       deliveryDate: schedule ?? DateTime.now(),
            //       orderNumber: Random().nextInt(4294967296).toString(),
            //       placeDescription: _placeDescription,
            //       serviceFee: _serviceFee,
            //       tax: _taxes,
            //       status: schedule == null ? 'Completed' : 'Ongoing',
            //       deliveryFee: _deliveryFee,
            //       totalFee: total,
            //       promoApplied: _activatedPromoId == null
            //           ? null
            //           : FirebaseFirestore.instance
            //               .collection(FirestoreCollections.promotions)
            //               .doc(_activatedPromoId),
            //       payments: [
            //         Payment(
            //             creditCardType: paymentOption!.creditCardType!,
            //             paymentMethodName: 'Debit or Credit Card',
            //             amountPaid: total,
            //             cardNumber:
            //                 '••••${paymentOption.cardNumber.substring(6)}',
            //             datePaid: DateTime.now())
            //       ],
            //       promoDiscount: _activatedPromo?.discount,
            //       storeId: widget.store.id,
            //       membershipBenefit: _hasUberOne
            //           ? OtherConstants.uberOneDiscount * _cartItem.subtotal
            //           : null);
            //   //update uberOneStatus if user has uber one
            //   final userDetailsSnapshot = await FirebaseFirestore.instance
            //       .collection(FirestoreCollections.users)
            //       .doc(FirebaseAuth.instance.currentUser!.uid)
            //       .get();
            //   final userDetails = userDetailsSnapshot.data()!;
            //   userDetails['uberOneStatus']['moneySaved'] =
            //       userDetails['uberOneStatus']['moneySaved'] +
            //           (OtherConstants.uberOneDiscount * _cartItem.subtotal);

            //   await FirebaseFirestore.instance
            //       .collection(FirestoreCollections.individualOrders)
            //       .doc(order.orderNumber)
            //       .set(order.toJson());
            //   for (var product in _cartItem.products) {
            //     await product.delete();
            //   }
            //   await _cartItem.delete();

            //   await FirebaseFirestore.instance
            //       .collection(FirestoreCollections.users)
            //       .doc(FirebaseAuth.instance.currentUser!.uid)
            //       .update({
            //     if (_hasUberOne) 'uberOneStatus': userDetails,
            //     if (_activatedPromoId != null)
            //       'redeemedPromos': FieldValue.arrayRemove([_activatedPromoId]),
            //     if (_activatedPromoId != null)
            //       'usedPromos': FieldValue.arrayUnion([_activatedPromoId])
            //   });

            //   await AppFunctions.getOnlineUserInfo();

            //   setState(() {
            //     _isLoading = false;
            //   });
            //   navigatorKey.currentState!.pop();
            //   navigatorKey.currentState!.pop();
            //   await navigatorKey.currentState!.push(MaterialPageRoute(
            //     builder: (context) => const OrdersScreen(),
            //   ));
            // },

            )
      ],
    );
  }
}

class PaymentOptionWidget extends ConsumerWidget {
  const PaymentOptionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPaymentMethod = ref.watch(paymentOptionProvider);
    final types = selectedPaymentMethod != null
        ? detectCCType(selectedPaymentMethod.cardNumber)
        : null;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      onTap: () async {
        // final CreditCardDetails? result =
        await showModalBottomSheet(
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return const PaymentOptionsScreen(
              showOnlyPaymentMethods: true,
            );
          },
        );
      },
      leading:
          selectedPaymentMethod == null ? null : CreditCardLogo(types: types!),
      // contentPadding: EdgeInsets.symmetric(
      //     horizontal: AppSizes.horizontalPaddingSmall),
      title: AppText(
        text: selectedPaymentMethod == null
            ? 'Select Payment'
            : '${selectedPaymentMethod.creditCardType!}••••${selectedPaymentMethod.cardNumber.substring(6)}',
        weight: FontWeight.w600,
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        weight: 3,
      ),
    );
  }
}
