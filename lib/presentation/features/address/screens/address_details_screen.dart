import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/states/onboarding_state_model.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/confirm_location.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';
import 'package:uber_eats_clone/presentation/services/place_detail_model.dart';

import '../../../../app_functions.dart';
import '../../../../hive_adapters/geopoint/geopoint_adapter.dart';
import '../../../constants/app_sizes.dart';
import '../../../services/sign_in_view_model.dart';
import '../../sign_in/views/payment_method_screen.dart';

class AddressDetailsScreen extends ConsumerStatefulWidget {
  final String placeDescription;
  final PlaceLocation location;
  final bool addressesAlreadyExist;
  final String? instruction;
  final String? apartment;
  final String? addressLabel;
  final String? building;
  final String? dropOffOption;
  final bool? navigatedWithAddressListTile;

  final BitmapDescriptor markerIcon;

  const AddressDetailsScreen(
      {super.key,
      this.instruction,
      this.apartment,
      this.navigatedWithAddressListTile,
      required this.addressesAlreadyExist,
      required this.location,
      required this.placeDescription,
      required this.markerIcon,
      this.addressLabel,
      this.building,
      this.dropOffOption});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends ConsumerState<AddressDetailsScreen> {
  late LatLng _setLocation;
  Timer? _debounce;
  late String _placeDescription;
  final _instructionsController = TextEditingController();
  final _aptController = TextEditingController();
  final _addressLabelController = TextEditingController();
  final _buildingNameController = TextEditingController();
  late String _dropOffOption;

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setLocation = LatLng(widget.location.lat!, widget.location.lng!);
    _placeDescription = widget.placeDescription;
    if (widget.navigatedWithAddressListTile == true) {
      _instructionsController.text = widget.instruction!;
      _aptController.text = widget.apartment!;
      _addressLabelController.text = widget.addressLabel!;
      _buildingNameController.text = widget.building!;
    }
    _dropOffOption = widget.navigatedWithAddressListTile == true
        ? widget.dropOffOption!
        : 'Meet at my door';
  }

  @override
  void dispose() {
    _debounce?.cancel();

    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Address Details',
          size: AppSizes.heading6,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                InkWell(
                  onTap: () async {
                    final List? setLocationDetails =
                        await navigatorKey.currentState!.push(MaterialPageRoute(
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
                    child: Stack(
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
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const AppText(text: 'Edit pin')),
                            const Gap(10)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          size: AppSizes.heading6,
                          text: _placeDescription,
                          weight: FontWeight.w600,
                        ),
                        const Gap(15),
                        AppTextFormField(
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                          onChanged: (value) async {
                            if (_debounce?.isActive ?? false) {
                              _debounce?.cancel();
                            }
                            _debounce =
                                Timer(const Duration(milliseconds: 500), () {
                              setState(() {});
                            });
                          },
                          controller: _aptController,
                          hintText: 'Apt/Suite/Floor',
                          suffixIcon: Visibility(
                            //TODO: add if it is in focus so it disappears when not in focus
                            visible: _aptController.text.isNotEmpty,
                            child: GestureDetector(
                                onTap: () => _aptController.clear(),
                                child: const Icon(Icons.cancel)),
                          ),
                        ),
                        const Gap(15),
                        AppTextFormField(
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                          onChanged: (value) async {
                            if (_debounce?.isActive ?? false) {
                              _debounce?.cancel();
                            }
                            _debounce =
                                Timer(const Duration(milliseconds: 500), () {
                              setState(() {});
                            });
                          },
                          suffixIcon: Visibility(
                            visible: _buildingNameController.text.isNotEmpty,
                            child: GestureDetector(
                                onTap: () => _buildingNameController.clear(),
                                child: const Icon(Icons.cancel)),
                          ),
                          controller: _buildingNameController,
                          hintText: 'Business or building name',
                        ),
                        const Gap(20),
                        const Divider(),
                        const Gap(15),
                        const AppText(
                          text: 'Dropoff options',
                          size: AppSizes.body,
                          weight: FontWeight.w600,
                        ),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                              decoration: BoxDecoration(
                                  // border: Border.all(),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Image.asset(
                                AssetNames.carrierBag,
                                height: 40,
                              )),
                          title: AppText(
                            text: _dropOffOption,
                          ),
                          subtitle: const Row(
                            children: [
                              AppTextBadge(
                                text: 'More options available',
                              ),
                            ],
                          ),
                          trailing: AppButton2(
                              text: 'Edit',
                              callback: () async {
                                List? newEntry = await navigatorKey
                                    .currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => DropOffOptionsScreen(
                                      instructions:
                                          _instructionsController.text,
                                      placeDescription: _placeDescription,
                                      selectedGroupValue: _dropOffOption),
                                ));
                                if (newEntry != null) {
                                  setState(() {
                                    _dropOffOption = newEntry.first;
                                    _instructionsController.text =
                                        newEntry.last;
                                  });
                                }
                              }),
                        ),
                        // const Gap(20),
                        const ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            // titleAlignment: ListTileTitleAlignment.top,
                            title: AppText(
                              text: 'Instructions for delivery person',
                            ),
                            trailing: AppTextBadge(text: 'Needs review')),
                        AppTextFormField(
                          controller: _instructionsController,
                          minLines: 4,
                          enabled: false,

                          maxLines: 15,
                          // textAlign: TextAlign.start,
                          // height: 50,
                          hintText:
                              'Example: Please knock instead of using the doorbell',
                        ),
                        const Gap(15),
                        const Divider(),
                        const Gap(15),
                        const AppText(
                          text: 'Address Label',
                        ),
                        const Gap(10),
                        AppTextFormField(
                          controller: _addressLabelController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText:
                                    'This field cannot be empty. eg. Home, Work')
                          ]),
                          suffixIcon: Visibility(
                            //TODO: add if it is in focus so it disappears when not in focus
                            visible: _instructionsController.text.isNotEmpty,
                            child: GestureDetector(
                                onTap: () => _instructionsController.clear(),
                                child: const Icon(Icons.cancel)),
                          ),
                        ),
                        const Gap(15),
                        const Divider(),
                        const Gap(10)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
            child: AppButton(
              isLoading: _isLoading,
              text: widget.addressesAlreadyExist ? 'Save' : 'Save and continue',
              callback: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  var addressDetails = AddressDetails(
                      placeDescription: _placeDescription,
                      instruction: _instructionsController.text,
                      apartment: _aptController.text,
                      latlng: GeoPoint(
                          _setLocation.latitude, _setLocation.longitude),
                      addressLabel: _addressLabelController.text,
                      building: _buildingNameController.text,
                      dropoffOption: _dropOffOption);

                  try {
                    if (widget.addressesAlreadyExist) {
                      if (widget.navigatedWithAddressListTile == true) {
                        var oldAddressDetails = AddressDetails(
                            instruction: widget.instruction!,
                            apartment: widget.apartment!,
                            latlng: GeoPoint(
                                widget.location.lat!, widget.location.lng!),
                            addressLabel: widget.addressLabel!,
                            placeDescription: widget.placeDescription,
                            building: widget.building!,
                            dropoffOption: widget.dropOffOption!);
                        await FirebaseFirestore.instance
                            .collection(FirestoreCollections.users)
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'addresses': FieldValue.arrayRemove(
                              [oldAddressDetails.toJson()])
                        });
                        await FirebaseFirestore.instance
                            .collection(FirestoreCollections.users)
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'addresses':
                              FieldValue.arrayUnion([addressDetails.toJson()])
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection(FirestoreCollections.users)
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'addresses':
                              FieldValue.arrayUnion([addressDetails.toJson()])
                        });
                      }
                      await AppFunctions.getUserInfo();
                      navigatorKey.currentState!.pop();
                    } else {
                      await FirebaseFirestore.instance
                          .collection(FirestoreCollections.users)
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'selectedAddress': addressDetails.toJson(),
                        'addresses': [addressDetails.toJson()]
                      }, SetOptions(merge: true));
                      var addressDetailsForHive = addressDetails.toJson();
                      var storelatLng = addressDetails.latlng as GeoPoint;
                      addressDetailsForHive['latlng'] = HiveGeoPoint(
                          latitude: storelatLng.latitude,
                          longitude: storelatLng.longitude);

                      await Hive.box(AppBoxes.appState)
                          .put('addressDetailsSaved', true);
                      await navigatorKey.currentState!.pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PaymentMethodScreen()), (r) {
                        return false;
                      });
                    }
                  } on FirebaseException catch (e) {
                    await showAppInfoDialog(navigatorKey.currentContext!,
                        description: e.code);
                    setState(() {
                      _isLoading = false;
                    });
                  } on Exception catch (e) {
                    await showAppInfoDialog(navigatorKey.currentContext!,
                        description: e.toString());
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
