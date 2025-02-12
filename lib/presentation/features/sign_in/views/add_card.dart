import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/uber_one_screen.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import 'payment_method_screen.dart';
import 'sign_in/sign_in_screen.dart';

class AddCardScreen extends ConsumerStatefulWidget {
  const AddCardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends ConsumerState<AddCardScreen> {
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
      appBar: AppBar(
        title: const AppText(
          text: 'Add Card',
          size: AppSizes.body,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        text: 'Card Number',
                      ),
                      const Gap(15),
                      AppTextFormField(
                        prefixIcon: Image.asset(AssetNames.creditCard),
                        suffixIcon: const Icon(Icons.camera_alt),
                      ),
                      const Gap(15),
                      const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'Exp. Date',
                                ),
                                Gap(5),
                                AppTextFormField(
                                  hintText: 'MM/YY',
                                  suffixIcon: Icon(Icons.help),
                                ),
                              ],
                            ),
                          ),
                          Gap(15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'CVV',
                                ),
                                Gap(5),
                                AppTextFormField(
                                  hintText: '123',
                                  suffixIcon: Icon(Icons.help),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const AppText(text: 'Country'),
                      SizedBox(
                        height: 50,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<CountryCode>(
                            iconStyleData: const IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down_outlined,
                                  size: 20, color: Colors.black),
                            ),
                            items: _countryCodes
                                .map((countryCode) => DropdownMenuItem(
                                      value: countryCode,
                                      child: SizedBox(
                                        height: 10,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          leading: Image.asset(
                                            fit: BoxFit.fitWidth,
                                            width: 15,
                                            countryCode.flag,
                                          ),
                                          title: Row(
                                            children: [
                                              Text(countryCode.countryName),
                                              const Gap(10),
                                              Text(countryCode.code)
                                            ],
                                          ),
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

                                color: AppColors.neutral100,

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
                            isExpanded: true,
                            selectedItemBuilder: (context) => _countryCodes
                                .map(
                                  (e) =>
                                      //  Padding(
                                      //       padding: const EdgeInsets.symmetric(
                                      //           vertical: 6.0),
                                      //       child: Image.asset(
                                      //         _selectedCountryCode?.flag ??
                                      //             AssetNames.ghanaFlag,
                                      //         fit: BoxFit.fitWidth,
                                      //         width: 40,
                                      //       ),
                                      //     ))
                                      ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Image.asset(
                                      e.flag
                                      //  ??
                                      // AssetNames.ghanaFlag,
                                      // fit: BoxFit.fitWidth,
                                      ,
                                      width: 40,
                                    ),
                                    title: AppText(text: e.countryName),
                                  ),
                                )
                                .toList(),
                            menuItemStyleData: const MenuItemStyleData(
                                // height: 40.0,
                                ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Zip Code',
                          ),
                          Gap(5),
                          AppTextFormField(),
                        ],
                      ),
                      const Gap(10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Nickname (optional)',
                          ),
                          Gap(5),
                          AppTextFormField(
                            hintText: 'e.g. joint account or work card',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
            child: AppButton(
              text: 'Next',
              callback: () {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const UberOneScreen(),
                ));
              },
            ),
          )
        ],
      ),
    );
  }
}
