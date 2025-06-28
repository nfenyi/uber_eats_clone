import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/device_info/device_info_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/screens/main_screen_wrapper.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/sign_in/sign_in_view_model.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/verify_phone_number/verify_phone_number_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/whats_your_email_screen.dart';
import 'package:uber_eats_clone/services/hive_services.dart';
import 'package:uber_eats_clone/utils/enums.dart';

import '../../../../../utils/result.dart';
import '../../../../core/app_colors.dart';
import '../email_address/email_address_screen.dart';
import '../email_sent_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final signInViewModel = SignInViewModel();
  late Country? _selectedCountry;

  final _phoneNumberController = TextEditingController();
  late final Iterable<Country> _countries;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool _isRetrievingDeviceInfo = false;

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
          (country) => country.code == HiveServices.getCountry?.code,
        ) ??
        _countries.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: 'Enter your mobile number',
                size: AppSizes.heading6,
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
                                      width: 40, height: 20,
                                      // height: 80,
                                    ),
                                    title: Text(country.name),
                                    trailing: Text(country.dialCode),
                                  ),
                                ))
                            .toList(),
                        value: _selectedCountry,
                        onChanged: (value) {
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
                                  vertical: 10.0,
                                  horizontal: 20,
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
                isLoading: _isLoading,
                text: 'Continue',
                buttonColor: Colors.black,
                callback: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedCountry?.dialCode == null) {
                      showInfoToast('Please select a country',
                          context: context);
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });
                    await _verifyPhoneNumber(_phoneNumberController.text
                            .startsWith('0')
                        ? '${_selectedCountry?.dialCode}${_phoneNumberController.text.substring(1)}'
                        : '${_selectedCountry?.dialCode}${_phoneNumberController.text}');
                    setState(() {
                      _isLoading = false;
                    });
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
                  final result = await signInViewModel.signInWithGoogle();
                  if (result is RError) {
                    if (context.mounted) {
                      await showAppInfoDialog(context,
                          description: (result as RError).errorMessage);
                    }
                  } else {
                    switch ((result as Ok).value) {
                      case AuthState.authenticated:
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const MainScreenWrapper(),
                        ));
                        break;
                      case AuthState.unAuthenticated:
                        if (context.mounted) {
                          await showAppInfoDialog(context,
                              description: (result as RError).errorMessage);
                        }
                        break;
                      case AuthState.federatedRegistration:
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const EmailAddressScreen(),
                        ));
                        break;
                    }
                  }
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
                callback: () async {
                  showInfoToast(
                      context: context, 'I haven\'t paid \$99 yet 🙃');

                  final result = await signInViewModel.signInWithApple();
                  if (result is RError) {
                    if (context.mounted) {
                      await showAppInfoDialog(context,
                          description: (result as RError).errorMessage);
                    }
                  } else {
                    switch ((result as Ok).value) {
                      case AuthState.authenticated:
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const MainScreenWrapper(),
                        ));
                        break;
                      case AuthState.unAuthenticated:
                        if (context.mounted) {
                          await showAppInfoDialog(context,
                              description: (result as RError).errorMessage);
                        }
                        break;
                      case AuthState.federatedRegistration:
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const EmailAddressScreen(),
                        ));
                        break;
                    }
                  }
                },
                iconFirst: true,
                icon: const Icon(Icons.apple),
                text: 'Continue with Apple',
                isSecondary: true,
              ),
              const Gap(10),
              AppButton(
                callback: () async {
                  await navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => const WhatsYourEmailScreen(),
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
                isLoading: _isRetrievingDeviceInfo,
                buttonColor: Colors.transparent,
                iconFirst: true,
                icon: const Icon(Icons.search),
                isSecondary: true,
                text: 'Find my account',
                callback: () async {
                  setState(() {
                    _isRetrievingDeviceInfo = true;
                  });
                  final result = await signInViewModel.findMyAccount();
                  if (result is RError) {
                    showInfoToast((result as RError).errorMessage.toString(),
                        context: navigatorKey.currentContext!);
                  }
                  final info =
                      (result as Ok<Map<String, DeviceUserInfo>>).value;
                  setState(() {
                    _isRetrievingDeviceInfo = false;
                  });
                  if (info.isNotEmpty) {
                    if (context.mounted) {
                      await showModalBottomSheet(
                          shape: const RoundedRectangleBorder(),
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) {
                            var isLoggingInValues = List.generate(
                              info.length,
                              (index) => false,
                            );
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: AppText(
                                      text: 'Continue with account',
                                      size: AppSizes.heading6,
                                    ),
                                  ),
                                  const Divider(),
                                  ListView.separated(
                                    // padding: const EdgeInsets.symmetric(
                                    //     horizontal:
                                    //         AppSizes.horizontalPaddingSmall),
                                    itemBuilder: (context, index) {
                                      final item = info.values.elementAt(index);
                                      return ListTile(
                                        dense: true,
                                        onTap: () async {
                                          setState(() {
                                            isLoggingInValues[index] = true;
                                          });
                                          if (item.phoneNumber != null) {
                                            await _verifyPhoneNumber(
                                                item.phoneNumber!);
                                          } else if (item.email != null) {
                                            final result = await signInViewModel
                                                .sendSignInLinkToEmail(
                                                    item.email!);

                                            setState(() {
                                              isLoggingInValues[index] = false;
                                            });

                                            if (result is Error) {
                                              return showAppInfoDialog(
                                                  description:
                                                      'Error sending email verification: ${(result as RError).errorMessage}',
                                                  navigatorKey.currentContext!);
                                            } else {
                                              await navigatorKey.currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    EmailSentScreen(
                                                  email: item.email!,
                                                ),
                                              ));
                                            }
                                          }
                                        },
                                        trailing: isLoggingInValues[index]
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator
                                                    .adaptive(),
                                              )
                                            : null,
                                        leading: CircleAvatar(
                                          radius: 15,
                                          child: item.profilePic == null
                                              ? Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        gradient:
                                                            const RadialGradient(
                                                                stops: [
                                                              0.6,
                                                              1.0
                                                            ],
                                                                colors: [
                                                              Colors.white,
                                                              AppColors
                                                                  .neutral200,
                                                            ]),
                                                      ),
                                                    ),
                                                    Transform.translate(
                                                      offset:
                                                          const Offset(0, -4),
                                                      child: Image.asset(
                                                        AssetNames.noProfilePic,
                                                        width: 25,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: CachedNetworkImage(
                                                      width: 45,
                                                      height: 45,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          item.profilePic!),
                                                ),
                                        ),
                                        title: item.name == null
                                            ? null
                                            : AppText(
                                                text: item.name!,
                                                size: AppSizes.body,
                                              ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (item.phoneNumber != null)
                                              AppText(text: item.phoneNumber!),
                                            if (item.email != null)
                                              AppText(text: item.email!),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: info.length,
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      indent: 50,
                                    ),
                                  ),
                                  const Divider(
                                    indent: 50,
                                  ),
                                  ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.person),
                                    title: const AppText(
                                      text: 'Use another account',
                                      size: AppSizes.body,
                                    ),
                                    onTap: navigatorKey.currentState!.pop,
                                  )
                                ],
                              );
                            });
                          },
                          isScrollControlled: true);
                    }
                  } else {
                    showInfoToast(
                        'Seems this device does not have an account with us yet.',
                        context: navigatorKey.currentContext!);
                  }
                },
              ),
              const Gap(15),
              const AppText(
                  color: Colors.grey,
                  text:
                      'By proceeding, you consent to get calls, WhatsApp or SMS messages, including by automated dialer, from Uber and its affiliates to the number provided. Text "STOP" to 89203 to opt out.')
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    final result = await signInViewModel.verifyPhoneNumber(
      phoneNumber,
    );
    if (result is RError) {
      await showAppInfoDialog(
          description: result.errorMessage, navigatorKey.currentContext!);
      return;
    }

    if ((result as Ok).value == AuthState.authenticated) {
      await navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => const MainScreenWrapper(),
      ));
    } else {
      await navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => VerifyPhoneNumberScreen(
          verificationId: result.value,
          phoneNumber: phoneNumber,
        ),
      ));
    }
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
