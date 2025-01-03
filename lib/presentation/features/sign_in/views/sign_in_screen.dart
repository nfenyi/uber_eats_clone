import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/verify_phone_number.dart';

import '../../../core/app_colors.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final List<CountryCode> _countryCodes = [
    CountryCode(flag: AssetNames.ghanaFlag, countryName: "Ghana", code: '+233'),
    CountryCode(flag: AssetNames.usaFlag, countryName: "USA", code: '+1'),
  ];
  late CountryCode? _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = _countryCodes.first;
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
              children: [
                SizedBox(
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<CountryCode>(
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down,
                            size: 20, color: Colors.black),
                      ),
                      items: _countryCodes
                          .map((countryCode) => DropdownMenuItem(
                                value: countryCode,
                                child: SizedBox(
                                  height: 10,
                                  width: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    leading: Image.asset(
                                      fit: BoxFit.fitWidth,
                                      width: 15,
                                      countryCode.flag,
                                    ),
                                    title: Text(countryCode.countryName),
                                    trailing: Text(countryCode.code),
                                  ),
                                ),
                              ))
                          .toList(),
                      value: _selectedCountryCode,
                      onChanged: (value) async {
                        setState(() {
                          _selectedCountryCode = value;
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

                          color: Colors.black12,

                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
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
                      selectedItemBuilder: (context) => _countryCodes
                          .map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Image.asset(
                                  _selectedCountryCode?.flag ??
                                      AssetNames.ghanaFlag,
                                  fit: BoxFit.fitWidth,
                                  width: 40,
                                ),
                              ))
                          .toList(),
                      menuItemStyleData: const MenuItemStyleData(
                          // height: 40.0,
                          ),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                    child: AppTextFormField(
                  constraintWidth: 50,
                  hintText: "123 456 789",
                  prefixIcon: Text(
                    _selectedCountryCode?.code ?? "233",

                    // color: Colors.black,
                  ),
                  suffixIcon: const Iconify(Ic.baseline_person),
                ))
              ],
            ),
            const Gap(15),
            AppButton(
              text: 'Continue',
              buttonColor: Colors.black,
              callback: () => navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const VerifyPhoneNumber(),
              )),
            ),
            const Gap(15),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Divider(
                  color: AppColors.neutral300,
                )),
                Gap(10),
                AppText(
                  text: 'or',
                  size: AppSizes.bodySmall,
                  color: AppColors.neutral300,
                ),
                Gap(10),
                Expanded(
                    child: Divider(
                  color: AppColors.neutral300,
                ))
              ],
            ),
            const Gap(15),
            AppButton(
              iconFirst: true,
              icon: Image.asset(
                AssetNames.googleLogo,
                height: 18,
              ),
              text: 'Continue with Google',
              isSecondary: true,
            ),
            const Gap(10),
            const AppButton(
              iconFirst: true,
              icon: Icon(Icons.apple),
              text: 'Continue with Google',
              isSecondary: true,
            ),
            const Gap(10),
            const AppButton(
              iconFirst: true,
              icon: Icon(Icons.mail),
              text: 'Continue with Google',
              isSecondary: true,
            ),
            const Gap(30),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Divider(
                  color: AppColors.neutral300,
                )),
                Gap(10),
                AppText(
                  text: 'or',
                  size: AppSizes.bodySmall,
                  color: AppColors.neutral300,
                ),
                Gap(10),
                Expanded(
                    child: Divider(
                  color: AppColors.neutral300,
                ))
              ],
            ),
            AppButton(
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
