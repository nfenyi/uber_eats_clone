import 'package:collection/collection.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/verify_phone_number.dart';

import '../../../../core/app_colors.dart';
import '../email_address_screen.dart';
import 'sign_in_view_models.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  // final List<CountryCode> _countryCodes = [
  //   CountryCode(flag: AssetNames.ghanaFlag, countryName: "Ghana", code: '+233'),
  //   CountryCode(flag: AssetNames.usaFlag, countryName: "USA", code: '+1'),
  // ];
  late Country? _selectedCountry;

  final _phoneNumberController = TextEditingController();
  late final Iterable<Country> _countries;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      )),
    );
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Enter your mobile number',
              size: AppSizes.heading5,
            ),
            const Gap(15),
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
                      // isExpanded: true,
                      selectedItemBuilder: (context) => _countries
                          .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                                horizontal: 20,
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
            const Gap(15),
            AppButton(
              text: 'Continue',
              buttonColor: Colors.black,
              callback: () async {
                if (_formKey.currentState!.validate()) {
                  if (_selectedCountry?.dialCode == null) {
                    showInfoToast('Please select a country', context: context);
                    return;
                  }

                  // final result = await ref
                  //     .read(signInProvider.notifier)
                  //     .verifyPhoneNumber(
                  //         '${_selectedCountry!.dialCode}${_phoneNumberController.text.trim()}');
                  // if (result.response == Result.success) {
                  //   navigatorKey.currentState!.push(MaterialPageRoute(
                  //     builder: (context) => const VerifyPhoneNumber(),
                  //   ));
                  // }
                  // if (mounted && result.response == Result.failure) {
                  //   showInfoToast(result.payload.toString(), context: context);
                  // }
                  // await FirebaseAuth.instance
                  //     .setSettings(forceRecaptchaFlow: true);
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber:
                        '${_selectedCountry!.dialCode}${_phoneNumberController.text.trim()}',
                    verificationCompleted:
                        (PhoneAuthCredential credential) async {
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const EmailAddressScreen(),
                      ));
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      showInfoToast(e.code, context: context);
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => VerifyPhoneNumber(verificationId),
                      ));
                    },
                    timeout: const Duration(minutes: 1),
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                }
              },
            ),
            const Gap(15),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Divider(
                  color: AppColors.neutral500,
                )),
                Gap(10),
                AppText(
                  text: 'or',
                  size: AppSizes.bodySmall,
                  color: AppColors.neutral500,
                ),
                Gap(10),
                Expanded(
                    child: Divider(
                  color: AppColors.neutral500,
                ))
              ],
            ),
            const Gap(15),
            AppButton(
              callback: () async {
                await ref.read(signInProvider.notifier).logInWithGoogle();
              },
              iconFirst: true,
              icon: Image.asset(
                AssetNames.googleLogo,
                height: 18,
              ),
              text: 'Continue with Google',
              isSecondary: true,
            ),
            const Gap(10),
            AppButton(
              callback: () {
                showInfoToast('Coming soon', context: context);
              },
              iconFirst: true,
              icon: const Icon(Icons.apple),
              text: 'Continue with Apple',
              isSecondary: true,
            ),
            const Gap(10),
            AppButton(
              callback: () {
                //  FirebaseAuth.instance.sendSignInLinkToEmail(email: email, actionCodeSettings: actionCodeSettings)
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const EmailAddressScreen(),
                ));
              },
              iconFirst: true,
              icon: const Icon(Icons.mail),
              text: 'Continue with Email',
              isSecondary: true,
            ),
            const Gap(30),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Divider(
                  color: AppColors.neutral500,
                )),
                Gap(10),
                AppText(
                  text: 'or',
                  size: AppSizes.bodySmall,
                  color: AppColors.neutral500,
                ),
                Gap(10),
                Expanded(
                    child: Divider(
                  color: AppColors.neutral500,
                ))
              ],
            ),
            const Gap(10),
            AppButton(
              buttonColor: Colors.transparent,
              iconFirst: true,
              icon: const Icon(Icons.search),
              isSecondary: true,
              text: 'Find my account',
              callback: () {},
            ),
            const Gap(15),
            const AppText(
                color: Colors.grey,
                text:
                    'By proceeding, you consent to get calls, WhatsApp or SMS messages, including by automated dialer, from Uber and its affiliates to the number provided. Text "STOP" to 89203 to opt out.')
          ],
        ),
      ),
    );
  }
}

class CountryCode {
  final String flag;
  final String countryName;
  final String code;

  CountryCode(
      {required this.flag, required this.countryName, required this.code});
}

// class _PhoneNumberFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final newText = newValue.text;

//     if (newText.isEmpty) {
//       return newValue;
//     }

//     // Basic formatting: Add spaces after every 3 digits (adjust as needed)
//     final formattedText = StringBuffer();
//     for (int i = 0; i < newText.length; i++) {
//       formattedText.write(newText[i]);
//       if ((i + 1) % 3 == 0 && i != newText.length - 1) {
//         formattedText.write(' ');
//       }
//     }

//     return newValue.copyWith(
//       text: formattedText.toString(),
//       selection: TextSelection.collapsed(offset: formattedText.length),
//     );
//   }
// }
