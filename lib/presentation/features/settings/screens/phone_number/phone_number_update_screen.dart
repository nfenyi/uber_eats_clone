import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/widgets.dart';
import '../../../../services/sign_in_view_model.dart';
import '../../../sign_in/views/verify_phone_number.dart';

class PhoneNumberUpdateScreen extends StatefulWidget {
  const PhoneNumberUpdateScreen({super.key});

  @override
  State<PhoneNumberUpdateScreen> createState() =>
      _PhoneNumberUpdateScreenState();
}

class _PhoneNumberUpdateScreenState extends State<PhoneNumberUpdateScreen> {
  late final Iterable<Country> _countries;
  late Country? _selectedCountry;
  Timer? _debounce;

  final _formKey = GlobalKey<FormState>();

  final _phoneNumberController = TextEditingController();

  bool _isPhoneNumberUpdated = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _countries = Country.values.where(
      (country) => !(country.name.toLowerCase().contains('satellite') ||
          country.name.toLowerCase().contains('network')),
    );
    _selectedCountry = _countries.firstWhereOrNull(
          (country) =>
              country.code == Hive.box(AppBoxes.appState).get('country')!.code,
        ) ??
        _countries.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Uber account',
          size: AppSizes.bodySmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            const AppText(
              text: 'Phone number',
              weight: FontWeight.bold,
              size: AppSizes.heading6,
            ),
            const Gap(10),
            const AppText(
                text:
                    'You\'ll use this number to get notifications, sign in and recover your account.'),
            const Gap(20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 45,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<Country>(
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down,
                            size: 20, color: Colors.black),
                      ),
                      items: _countries
                          .map((country) => DropdownMenuItem(
                                value: country,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  leading: CountryFlag.fromCountryCode(
                                    country.code,
                                    width: 50,
                                    // height: 80,
                                  ),
                                  title: Text(country.name),
                                  trailing: Text(country.dialCode),
                                ),
                              ))
                          .toList(),
                      value: _selectedCountry,
                      onChanged: (value) async {
                        setState(() {
                          _selectedCountry = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: AppSizes.dropDownBoxHeight,
                        decoration: BoxDecoration(
                          color: AppColors.neutral100,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        width: Adaptive.w(90),
                        maxHeight: 350,
                        elevation: 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onMenuStateChange: (isOpen) {
                        if (isOpen) {
                          // logger.d(isOpen);
                          showInfoToast('Loading countries...',
                              context: context);
                        }
                      },
                      // isExpanded: true,
                      selectedItemBuilder: (context) => _countries
                          .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6.0,
                              ),
                              child: CountryFlag.fromCountryCode(
                                _selectedCountry!.code,
                                width: 40,
                                // height: 80,
                              )))
                          .toList(),
                      menuItemStyleData: const MenuItemStyleData(
                          // height: 40.0,
                          ),
                    ),
                  ),
                ),
                const Gap(10),
                Form(
                  key: _formKey,
                  child: Expanded(
                      //TODO: add input formatter
                      child: AppTextFormField(
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) {
                        _debounce?.cancel();
                      }
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        setState(() {});
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Please provide a phone number')
                    ]),
                    // inputFormatters: [
                    //   // _PhoneNumberFormatter(),
                    // ],
                    keyboardType: const TextInputType.numberWithOptions(),
                    controller: _phoneNumberController,
                    constraintWidth: 50,
                    hintText: "123 456 789",
                    prefixIcon: AppText(
                      text: _selectedCountry?.dialCode ?? '!',
                    ),
                    suffixIcon: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const Iconify(Ic.baseline_person),
                        Container(
                          color: AppColors.neutral100,
                          width: 14.5,
                          height: 12,
                        ),
                        const Icon(Icons.key, size: 15, color: Colors.black)
                      ],
                    ),
                  )),
                )
              ],
            ),
            const AppText(
              text: 'A verification code will be sent to this number',
              size: AppSizes.bodySmallest,
            ),
            const Gap(40),
            AppButton(
              text: 'Update',
              callback: _phoneNumberController.text.isEmpty
                  ? null
                  : () async {
                      try {
                        final phoneNumber = _phoneNumberController.text
                                .startsWith('0')
                            ? '${_selectedCountry?.dialCode}${_phoneNumberController.text.substring(1)}'
                            : '${_selectedCountry?.dialCode}${_phoneNumberController.text}';
                        showInfoToast('Verifying phone number..',
                            context: context,
                            icon: const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              ),
                            ));
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phoneNumber,
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                            //WARNING: phone number change not implemented by firebase
                            await FirebaseAuth.instance.currentUser!
                                .updatePhoneNumber(credential);
                            _isPhoneNumberUpdated = true;
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            showInfoToast(e.code, context: context);
                          },
                          codeSent:
                              (String verificationId, int? resendToken) async {
                            _isPhoneNumberUpdated = await navigatorKey
                                .currentState!
                                .push(MaterialPageRoute(
                              builder: (context) => VerifyPhoneNumberScreen(
                                justUpdatingPhoneNumber: true,
                                verificationId: verificationId,
                                phoneNumber: phoneNumber,
                              ),
                            ));
                          },
                          timeout: const Duration(minutes: 1),
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );

                        if (_isPhoneNumberUpdated == true) {
                          String udid = await FlutterUdid.consistentUdid;
                          final deviceUsersDetails = await FirebaseFirestore
                              .instance
                              .collection(FirestoreCollections.devices)
                              .doc(udid)
                              .get();
                          final userCredential =
                              FirebaseAuth.instance.currentUser!;
                          final deviceUserDetails =
                              deviceUsersDetails.data()![userCredential.uid];
                          deviceUserDetails['phoneNumber'] = phoneNumber;
                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.devices)
                              .doc(udid)
                              .update({
                            userCredential.uid: deviceUserDetails,
                          }).then(
                            (value) {
                              showInfoToast(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  'Phone number updated',
                                  context: navigatorKey.currentContext);
                              if (context.mounted) {
                                navigatorKey.currentState!.pop(true);
                              }
                            },
                          );
                        }
                      } on Exception catch (e) {
                        if (context.mounted) {
                          await showAppInfoDialog(
                              description: e.toString(), context);
                        }
                      }
                    },
            )
          ],
        ),
      ),
    );
  }
}
