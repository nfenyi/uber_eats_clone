import 'dart:async';

import 'package:collection/collection.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/name_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/verify_phone_number.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

class PhoneNumberScreen extends ConsumerStatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<PhoneNumberScreen> {
  late Country? _selectedCountry;
  Timer? _debounce;
  final _phoneNumberController = TextEditingController();
  late final Iterable<Country> _countries;
  final _formKey = GlobalKey<FormState>();

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
  void dispose() {
    _phoneNumberController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(30),
                  const AppText(
                    size: AppSizes.heading6,
                    text: "Enter your mobile number (Optional)",
                    weight: FontWeight.w600,
                  ),
                  const Gap(10),
                  const AppText(
                    text: 'Add your mobile to aid in account recovery',
                  ),
                  const Gap(30),
                  const RequiredText('Mobile'),
                  const Gap(10),
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
                                // _accounts[index].currency = value;
                                // _accounts[index].save();
                                // _accountsBox.values[index];
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: AppSizes.dropDownBoxHeight,
                              decoration: BoxDecoration(
                                // color: ((ref.watch(themeProvider) ==
                                //                 'System' ||
                                //             ref.watch(
                                //                     themeProvider) ==
                                //                 'Dark') &&
                                //         (MediaQuery
                                //                 .platformBrightnessOf(
                                //                     context) ==
                                //             Brightness.dark))
                                //     ? const Color.fromARGB(
                                //         255, 32, 25, 33)
                                //     : Colors.white,

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
                                // color:
                                // ((ref.watch(themeProvider) ==
                                //                 'System' ||
                                //             ref.watch(
                                //                     themeProvider) ==
                                //                 'Dark') &&
                                //         (MediaQuery
                                //                 .platformBrightnessOf(
                                //                     context) ==
                                //             Brightness.dark))
                                //     ? const Color.fromARGB(
                                //         255, 32, 25, 33)
                                //     : Colors.white,
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
                                    )
                                    // Image.asset(
                                    //   _selectedCountry?.flag ??
                                    //       AssetNames.ghanaFlag,
                                    //   fit: BoxFit.fitWidth,
                                    //   width: 40,
                                    // ),
                                    ))
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
                            _debounce =
                                Timer(const Duration(milliseconds: 500), () {
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
                              const Icon(Icons.key,
                                  size: 15, color: Colors.black)
                            ],
                          ),
                        )),
                      )
                    ],
                  ),
                  const Gap(15),
                  AppButton2(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      text: 'Skip',
                      callback: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const NameScreen(),
                        ));
                      })
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        onTap: () => navigatorKey.currentState!.pop(),
                        child: Ink(
                          child: Container(
                            padding:
                                const EdgeInsets.all(AppSizes.bodySmallest),
                            decoration: const BoxDecoration(
                              color: AppColors.neutral200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.arrowLeft,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _phoneNumberController.text.isEmpty
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: _phoneNumberController.text
                                            .startsWith('0')
                                        ? '${_selectedCountry?.dialCode}${_phoneNumberController.text.substring(1)}'
                                        : '${_selectedCountry?.dialCode}${_phoneNumberController.text}',
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) async {
                                      await FirebaseAuth.instance.currentUser!
                                          .updatePhoneNumber(credential);
                                      await navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const NameScreen(),
                                      ));
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      showInfoToast(e.code, context: context);
                                    },
                                    codeSent: (String verificationId,
                                        int? resendToken) {
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            VerifyPhoneNumberScreen(
                                          verificationId: verificationId,
                                          signedInWithEmail: true,
                                          phoneNumber: _phoneNumberController
                                                  .text
                                                  .startsWith('0')
                                              ? '${_selectedCountry?.dialCode}${_phoneNumberController.text.substring(1)}'
                                              : '${_selectedCountry?.dialCode}${_phoneNumberController.text}',
                                        ),
                                      ));
                                    },
                                    timeout: const Duration(minutes: 1),
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {},
                                  );
                                }
                              },
                        child: Ink(
                          child: Container(
                            padding:
                                const EdgeInsets.all(AppSizes.bodySmallest),
                            decoration: BoxDecoration(
                                color: _phoneNumberController.text.isEmpty
                                    ? AppColors.neutral200
                                    : Colors.black,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Row(
                              children: [
                                AppText(
                                  text: 'Next',
                                  color: _phoneNumberController.text.isEmpty
                                      ? null
                                      : Colors.white,
                                ),
                                const Gap(5),
                                Icon(
                                  FontAwesomeIcons.arrowRight,
                                  color: _phoneNumberController.text.isEmpty
                                      ? null
                                      : Colors.white,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(10)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
