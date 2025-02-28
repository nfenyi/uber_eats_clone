import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:country_flags/country_flags.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
import 'package:uber_eats_clone/presentation/features/sign_in/views/whats_your_email_screen.dart';

import '../../../../core/app_colors.dart';
import '../../../../services/sign_in_view_model.dart';
import '../../../main_screen/screens/main_screen.dart';
import '../email_address_screen.dart';
import '../email_sent_screen.dart';
import '../phone_number_screen.dart';
import 'sign_in_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late Country? _selectedCountry;

  final _phoneNumberController = TextEditingController();
  late final Iterable<Country> _countries;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

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
                    setState(() {
                      _isLoading = true;
                    });
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber:
                          '${_selectedCountry!.dialCode}${_phoneNumberController.text.trim()}',
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        final snapshot = await FirebaseFirestore.instance
                            .collection(FirestoreCollections.users)
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();

                        if (snapshot.exists &&
                            snapshot.data() != null &&
                            snapshot.data()!['onboarded'] == true) {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ));
                        } else {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) => const EmailAddressScreen(),
                          ));
                        }
                      },
                      // autoRetrievedSmsCodeForTesting: '',
                      verificationFailed: (FirebaseAuthException e) {
                        showAppInfoDialog(
                          context,
                          description: '${e.code}${e.code}',
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => VerifyPhoneNumber(
                            verificationId: verificationId,
                            phoneNumber:
                                '${_selectedCountry?.dialCode}${_phoneNumberController.text}',
                          ),
                        ));
                      },
                      timeout: const Duration(minutes: 2),
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
                  await ref.read(signInProvider.notifier).signInWithGoogle();
                  final providerState = ref.read(signInProvider);
                  switch (providerState.status) {
                    case AuthStatus.success:
                      try {
                        final snapshot = await FirebaseFirestore.instance
                            .collection(FirestoreCollections.users)
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();

                        if (snapshot.exists &&
                            snapshot.data() != null &&
                            snapshot.data()!['onboarded'] == true) {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => const MainScreen()));
                        } else {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => const PhoneNumberScreen()));
                        }
                      } catch (e) {
                        showAppInfoDialog(context, description: e.toString());
                      }
                      break;
                    case AuthStatus.failure:
                      if (mounted) {
                        await showAppInfoDialog(
                            description: providerState.payload, context);
                      }
                      break;
                    default:
                      return;
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
                  // await ref.read(signInProvider.notifier).signInApple();
                  // final providerState = ref.read(signInProvider);
                  // switch (providerState.status) {
                  //   case AuthStatus.success:
                  // final snapshot = await FirebaseFirestore.instance
                  //         .collection(FirestoreCollections.users)
                  //         .doc(FirebaseAuth.instance.currentUser!.uid)
                  //         .get();

                  //     if (snapshot.exists &&
                  //         snapshot.data() != null &&
                  //         snapshot.data()!['onboarded'] == true) {
                  //       navigatorKey.currentState!.push(MaterialPageRoute(
                  //         builder: (context) => const MainScreen(),
                  //       ));
                  //     } else {
                  //       navigatorKey.currentState!.push(MaterialPageRoute(
                  //         builder: (context) => const EmailAddressScreen(),
                  //       ));
                  //     }

                  //     break;
                  //   case AuthStatus.failure:
                  //     if (mounted) {
                  //       showAppInfoDialog(
                  //           description: providerState.payload, context);
                  //     }
                  //     break;
                  //   default:
                  //     return;
                  // }
                },
                iconFirst: true,
                icon: const Icon(Icons.apple),
                text: 'Continue with Apple',
                isSecondary: true,
              ),
              const Gap(10),
              AppButton(
                callback: () async {
                  navigatorKey.currentState!.push(MaterialPageRoute(
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
                  buttonColor: Colors.transparent,
                  iconFirst: true,
                  icon: const Icon(Icons.search),
                  isSecondary: true,
                  text: 'Find my account',
                  callback: () async {
                    FirebaseDynamicLinks.instance.onLink
                        .listen((dynamicLinkData) async {
                      if (FirebaseAuth.instance.isSignInWithEmailLink(
                          dynamicLinkData.link.toString())) {
                        logger.d(FirebaseAuth.instance.isSignInWithEmailLink(
                            dynamicLinkData.link.toString()));
                        logger.d(Hive.box(AppBoxes.appState).get('email'));
                        // The client SDK will parse the code from the link for you.
                        await FirebaseAuth.instance
                            .signInWithEmailLink(
                                email: Hive.box(AppBoxes.appState).get('email'),
                                emailLink: dynamicLinkData.link.toString())
                            .then((credential) async {
                          await Hive.box(AppBoxes.appState).delete('email');

                          await Hive.box(AppBoxes.appState)
                              .put('isVerifiedViaLink', true);
                          // try {
                          //   final snapshot = await FirebaseFirestore.instance
                          //       .collection(FirestoreCollections.users)
                          //       .doc(FirebaseAuth.instance.currentUser!.uid)
                          //       .get();

                          //   if (snapshot.exists &&
                          //       snapshot.data() != null &&
                          //       snapshot.data()!['onboarded'] == true) {
                          //     navigatorKey.currentState!.push(
                          //         MaterialPageRoute(builder: (context) => const MainScreen()));
                          //   } else {
                          //     if (Hive.box(AppBoxes.appState)
                          //         .get(BoxKeys.addedEmailToPhoneNumber)) {
                          //       navigatorKey.currentState!.push(MaterialPageRoute(
                          //           builder: (context) => const NameScreen()));
                          //     } else {
                          //       navigatorKey.currentState!.push(MaterialPageRoute(
                          //           builder: (context) => const PhoneNumberScreen()));
                          //     }
                          //   }
                          // } catch (e) {
                          //   showAppInfoDialog(context, description: e.toString());
                          // }
                        }, onError: (error) {
                          if (mounted) {
                            showAppInfoDialog(context,
                                description: error.toString());
                          }
                        });
                      } else {
                        showAppInfoDialog(navigatorKey.currentContext!,
                            description:
                                'Seems the link in the email has not been acknowledged.');
                      }
                    }).onError((error) {
                      showAppInfoDialog(navigatorKey.currentContext!,
                          description: error.toString());
                    });
                  }

                  //  {
                  //   late String deviceId;
                  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                  //   if (Platform.isAndroid) {
                  //     AndroidDeviceInfo androidInfo =
                  //         await deviceInfo.androidInfo;
                  //     deviceId = androidInfo.id;
                  //     // Unique ID on Android (may not persist across factory resets)
                  //     // Other potentially useful properties on AndroidDeviceInfo:
                  //     // androidInfo.androidId; // More likely to persist, but not guaranteed
                  //     // androidInfo.imei;       // International Mobile Equipment Identity (if available) - requires permissions
                  //     // androidInfo.meid;       // Mobile Equipment Identifier (if available) - requires permissions
                  //   } else if (Platform.isIOS) {
                  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                  //     deviceId = iosInfo
                  //         .identifierForVendor!; // A unique ID for the *vendor* (your app developer), persists across app reinstalls, but changes if all apps by the vendor are uninstalled.
                  //     // iosInfo.utsname.machine; // This could be used, but it's not a unique identifier.
                  //   }

                  //   final contacts = await FirebaseFirestore.instance
                  //       .collection(FirestoreCollections.devices)
                  //       .doc(deviceId)
                  //       .get();
                  //   if (contacts.exists && contacts.data() != null) {
                  //     if (contacts['phoneNumber'] != null) {
                  //       await FirebaseAuth.instance.verifyPhoneNumber(
                  //         phoneNumber:
                  //             '${_selectedCountry!.dialCode}${_phoneNumberController.text.trim()}',
                  //         verificationCompleted:
                  //             (PhoneAuthCredential credential) async {
                  //           await FirebaseAuth.instance
                  //               .signInWithCredential(credential);
                  //           final snapshot = await FirebaseFirestore.instance
                  //               .collection(FirestoreCollections.users)
                  //               .doc(FirebaseAuth.instance.currentUser!.uid)
                  //               .get();

                  //           if (snapshot.exists &&
                  //               snapshot.data() != null &&
                  //               snapshot.data()!['onboarded'] == true) {
                  //             navigatorKey.currentState!.push(MaterialPageRoute(
                  //               builder: (context) => const MainScreen(),
                  //             ));
                  //           } else {
                  //             navigatorKey.currentState!.push(MaterialPageRoute(
                  //               builder: (context) => const EmailAddressScreen(),
                  //             ));
                  //           }
                  //         },
                  //         // autoRetrievedSmsCodeForTesting: '',
                  //         verificationFailed: (FirebaseAuthException e) {
                  //           showAppInfoDialog(
                  //             context,
                  //             description: '${e.code}${e.code}',
                  //           );
                  //           setState(() {
                  //             _isLoading = false;
                  //           });
                  //         },
                  //         codeSent: (String verificationId, int? resendToken) {
                  //           navigatorKey.currentState!.push(MaterialPageRoute(
                  //             builder: (context) => VerifyPhoneNumber(
                  //               verificationId: verificationId,
                  //               phoneNumber:
                  //                   '${_selectedCountry?.dialCode}${_phoneNumberController.text}',
                  //             ),
                  //           ));
                  //         },
                  //         timeout: const Duration(minutes: 2),
                  //         codeAutoRetrievalTimeout: (String verificationId) {},
                  //       );
                  //     } else if (contacts['email'] != null) {
                  //       await FirebaseAuth.instance.currentUser!
                  //           .verifyBeforeUpdateEmail(
                  //               contacts['email'],
                  //               ActionCodeSettings(
                  //                   // URL you want to redirect back to. The domain (www.example.com) for this
                  //                   // URL must be whitelisted in the Firebase Console.
                  //                   url:
                  //                       'https://ubereatsclone.page.link/email-verification-link',
                  //                   // This must be true
                  //                   handleCodeInApp: true,
                  //                   iOSBundleId: 'com.example.uberEatsClone',
                  //                   androidPackageName:
                  //                       'com.example.uber_eats_clone',
                  //                   // installIfNotAvailable
                  //                   androidInstallApp: true,
                  //                   // minimumVersion
                  //                   androidMinimumVersion: '12'))
                  //           .then((value) async {
                  //         // await Hive.box(AppBoxes.appState).put(
                  //         //     BoxKeys.email, _emailController.text);
                  //         await Hive.box(AppBoxes.appState)
                  //             .put(BoxKeys.addedEmailToPhoneNumber, true);

                  //         navigatorKey.currentState!.push(MaterialPageRoute(
                  //           builder: (context) => EmailSentScreen(
                  //             email: contacts['email'],
                  //           ),
                  //         ));
                  //       }, onError: (e) {
                  //         if (e is FirebaseAuthException) {
                  //           return showAppInfoDialog(
                  //               title: 'Error sending email verification:',
                  //               description: '${e.message}',
                  //               context);
                  //         } else {
                  //           return showAppInfoDialog(
                  //               title: 'Error sending email verification:',
                  //               description: '$e',
                  //               context);
                  //         }
                  //       });
                  //     }
                  //   } else {
                  //     showInfoToast(
                  //         'You don\'t seem to have a contact with us yet.',
                  //         context: context);
                  //   }
                  // },

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
