import 'dart:async';
import 'dart:math';
import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:country_flags/country_flags.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/cib.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/hive_adapters/country/country_ip_model.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/credit_card_details/credit_card_details_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/uber_one_screen.dart';

import '../../../../constants/app_sizes.dart';
import 'add_a_card_camera_view.dart';
import 'select_a_country_screen.dart';

class AddCardScreen extends ConsumerStatefulWidget {
  final bool isOnboarding;
  const AddCardScreen({super.key, this.isOnboarding = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends ConsumerState<AddCardScreen> {
  Timer? _debounce;

  final _cardNumberController = TextEditingController();
  final _expController = TextEditingController();
  final _cvvController = TextEditingController();
  late String _countryCode;
  final _countryController = TextEditingController();

  final _zipCodeController = TextEditingController();

  final _nickyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final _cardNumberNotifier = ValueNotifier<String>('');

  List<CreditCardType> _types = [];

  @override
  void initState() {
    super.initState();
    // _selectedCountryCode = _countryCodes.first;
    final HiveCountryResponse storedCountry = Hive.box(AppBoxes.appState).get(
      'country',
    );
    _countryController.text = storedCountry.country!;
    _countryCode = storedCountry.code!;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Add Card',
          size: AppSizes.heading6,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            if (value != null) {
                              if (_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }
                              _debounce =
                                  Timer(const Duration(milliseconds: 500), () {
                                _cardNumberNotifier.value = value;
                              });
                            }
                          },
                          keyboardType: const TextInputType.numberWithOptions(),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric()
                          ]),
                          controller: _cardNumberController,
                          removePrefixConstraints: true,
                          prefixIcon: ValueListenableBuilder(
                            valueListenable: _cardNumberNotifier,
                            builder: (context, value, child) {
                              if (value.isEmpty) {
                                return Image.asset(
                                  AssetNames.creditCard,
                                  width: 30,
                                  height: 20,
                                  fit: BoxFit.fitWidth,
                                );
                              }
                              _types = detectCCType(value);
                              return CreditCardLogo(types: _types);
                            },
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () async {
                                // List<CameraDescription> cameras =
                                //     await availableCameras();
                                // logger.d(cameras);

                                // const mainCamera = CameraDescription(
                                //     name: 'Main Camera',
                                //     lensDirection: CameraLensDirection.back,
                                //     sensorOrientation: 0);

                                // final controller = CameraController(
                                //     cameras.firstWhere(
                                //       (element) =>
                                //           element.lensDirection ==
                                //           CameraLensDirection.back,
                                //     ),
                                //     ResolutionPreset.max);
                                // logger.d('3');
                                // await controller.initialize().then((_) async {
                                //   await controller.lockCaptureOrientation(
                                //       DeviceOrientation.portraitUp);
                                //   if (context.mounted) {
                                //     final CreditCardModel? result =
                                //         await navigatorKey.currentState!
                                //             .push(MaterialPageRoute(
                                //       builder: (context) =>
                                //           const AddACardCameraView(),
                                //     ));

                                //     if (result != null) {
                                //       setState(() {
                                //         _cardNumberController.text =
                                //             result.number;
                                //         _cardNumberNotifier.value =
                                //             result.number;
                                //         _expController.text =
                                //             '${result.expirationMonth}/${result.expirationYear}';
                                //       });
                                //     }
                                //   } else {
                                //     await controller.dispose();
                                //   }
                                // }).catchError((Object e) async {
                                //   await controller.dispose();
                                //   if (e is CameraException) {
                                //     switch (e.code) {
                                //       case 'CameraAccessDenied':
                                //         if (context.mounted) {
                                //           await showAppInfoDialog(
                                //               title: 'Camera access denied',
                                //               description:
                                //                   'Grant camera access in order to read credit card',
                                //               context);
                                //         }
                                //         break;
                                //       default:
                                //         await showAppInfoDialog(context,
                                //             description:
                                //                 e.description ?? e.code);
                                //         break;
                                //     }
                                //   } else {
                                //     if (context.mounted) {
                                //       // throw e;
                                //       logger.d(e.toString());
                                //       await showAppInfoDialog(context,
                                //           description: e.toString());
                                //     }
                                //   }
                                // });
                                final CardInfo? result = await navigatorKey
                                    .currentState!
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const AddACardCameraView()));
                                if (result != null) {
                                  setState(() {
                                    _cardNumberController.text = result.number;
                                    _cardNumberNotifier.value = result.number;
                                    _expController.text = result.expiry;
                                  });
                                }
                              },
                              child: const Icon(Icons.camera_alt)),
                        ),
                        const Gap(25),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppText(
                                    text: 'Exp. Date',
                                  ),
                                  const Gap(5),
                                  AppTextFormField(
                                    inputFormatters: [
                                      CardNumberInputFormatter()
                                    ],
                                    keyboardType: TextInputType.number,
                                    maxLength: 5,
                                    validator: FormBuilderValidators.compose(
                                        [FormBuilderValidators.required()]),
                                    controller: _expController,
                                    hintText: 'MM/YY',
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: AppSizes
                                                            .horizontalPaddingSmall,
                                                        vertical: 20),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const AppText(
                                                            text:
                                                                'Expiration date',
                                                            weight:
                                                                FontWeight.bold,
                                                            size: AppSizes
                                                                .heading6,
                                                          ),
                                                          const Gap(10),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Expanded(
                                                                flex: 2,
                                                                child: AppText(
                                                                    size: AppSizes
                                                                        .bodySmall,
                                                                    text:
                                                                        'You should be able to find this date on the front of your card, under your card number.'),
                                                              ),
                                                              const Gap(10),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Image.asset(
                                                                  AssetNames
                                                                      .expDate,
                                                                  width: 100,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const Gap(10),
                                                          AppButton(
                                                            text: 'OK',
                                                            callback: navigatorKey
                                                                .currentState!
                                                                .pop,
                                                          )
                                                        ]));
                                              });
                                        },
                                        child: const Icon(Icons.help)),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppText(
                                    text: 'CVV',
                                  ),
                                  const Gap(5),
                                  AppTextFormField(
                                    maxLength: 3,
                                    validator: FormBuilderValidators.compose(
                                        [FormBuilderValidators.required()]),
                                    controller: _cvvController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                    hintText: '123',
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: AppSizes
                                                            .horizontalPaddingSmall,
                                                        vertical: 20),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const AppText(
                                                            text: 'CVV',
                                                            weight:
                                                                FontWeight.bold,
                                                            size: AppSizes
                                                                .heading6,
                                                          ),
                                                          const Gap(10),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Expanded(
                                                                flex: 2,
                                                                child: AppText(
                                                                    size: AppSizes
                                                                        .bodySmall,
                                                                    text:
                                                                        'A three-digit code on your credit card, you can find this on the back of your card.'),
                                                              ),
                                                              const Gap(10),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Image.asset(
                                                                  AssetNames
                                                                      .cvv,
                                                                  width: 100,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const Gap(10),
                                                          AppButton(
                                                            text: 'OK',
                                                            callback: navigatorKey
                                                                .currentState!
                                                                .pop,
                                                          )
                                                        ]));
                                              });
                                        },
                                        child: const Icon(Icons.help)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(25),
                        const AppText(text: 'Country'),
                        const Gap(15),
                        AppTextFormField(
                            prefixIcon: CountryFlag.fromCountryCode(
                              _countryCode,
                              width: 40,
                              height: 25,
                            ),
                            controller: _countryController,
                            onTap: () async {
                              final Country? country = await navigatorKey
                                  .currentState!
                                  .push(MaterialPageRoute(
                                builder: (context) =>
                                    const SelectACountryScreen(),
                              ));
                              if (country != null) {
                                setState(() {
                                  _countryController.text = country.name;
                                  _countryCode = country.code;
                                });
                              }
                            },
                            readOnly: true,
                            removePrefixConstraints: true,
                            suffixIcon: const Icon(Icons.keyboard_arrow_down)),

                        // SizedBox(
                        //   height: 50,
                        //   child: DropdownButtonHideUnderline(
                        //     child: DropdownButton2<CountryCode>(
                        //       iconStyleData: const IconStyleData(
                        //         icon: Icon(Icons.keyboard_arrow_down_outlined,
                        //             size: 20, color: Colors.black),
                        //       ),
                        //       items: _countryCodes
                        //           .map((countryCode) => DropdownMenuItem(
                        //                 value: countryCode,
                        //                 child: SizedBox(
                        //                   height: 10,
                        //                   child: ListTile(
                        //                     contentPadding: EdgeInsets.zero,
                        //                     dense: true,
                        //                     leading: Image.asset(
                        //                       fit: BoxFit.fitWidth,
                        //                       width: 15,
                        //                       countryCode.flag,
                        //                     ),
                        //                     title: Row(
                        //                       children: [
                        //                         Text(countryCode.countryName),
                        //                         const Gap(10),
                        //                         Text(countryCode.code)
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ))
                        //           .toList(),
                        //       value: _selectedCountryCode,
                        //       onChanged: (value) async {
                        //         setState(() {
                        //           _selectedCountryCode = value;
                        //           // _accounts[index].currency = value;
                        //           // _accounts[index].save();
                        //           // _accountsBox.values[index];
                        //         });
                        //       },
                        //       buttonStyleData: ButtonStyleData(
                        //         height: AppSizes.dropDownBoxHeight,
                        //         decoration: BoxDecoration(
                        //           // color: ((ref.watch(themeProvider) ==
                        //           //                 'System' ||
                        //           //             ref.watch(
                        //           //                     themeProvider) ==
                        //           //                 'Dark') &&
                        //           //         (MediaQuery
                        //           //                 .platformBrightnessOf(
                        //           //                     context) ==
                        //           //             Brightness.dark))
                        //           //     ? const Color.fromARGB(
                        //           //         255, 32, 25, 33)
                        //           //     : Colors.white,

                        //           color: AppColors.neutral100,

                        //           borderRadius: BorderRadius.circular(10.0),
                        //         ),
                        //       ),
                        //       dropdownStyleData: DropdownStyleData(
                        //         maxHeight: 350,
                        //         elevation: 1,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           // color:
                        //           // ((ref.watch(themeProvider) ==
                        //           //                 'System' ||
                        //           //             ref.watch(
                        //           //                     themeProvider) ==
                        //           //                 'Dark') &&
                        //           //         (MediaQuery
                        //           //                 .platformBrightnessOf(
                        //           //                     context) ==
                        //           //             Brightness.dark))
                        //           //     ? const Color.fromARGB(
                        //           //         255, 32, 25, 33)
                        //           //     : Colors.white,
                        //         ),
                        //       ),
                        //       isExpanded: true,
                        //       selectedItemBuilder: (context) => _countryCodes
                        //           .map(
                        //             (e) =>
                        //                 //  Padding(
                        //                 //       padding: const EdgeInsets.symmetric(
                        //                 //           vertical: 6.0),
                        //                 //       child: Image.asset(
                        //                 //         _selectedCountryCode?.flag ??
                        //                 //             AssetNames.ghanaFlag,
                        //                 //         fit: BoxFit.fitWidth,
                        //                 //         width: 40,
                        //                 //       ),
                        //                 //     ))
                        //                 ListTile(
                        //               contentPadding: EdgeInsets.zero,
                        //               leading: Image.asset(
                        //                 e.flag
                        //                 //  ??
                        //                 // AssetNames.ghanaFlag,
                        //                 // fit: BoxFit.fitWidth,
                        //                 ,
                        //                 width: 40,
                        //               ),
                        //               title: AppText(text: e.countryName),
                        //             ),
                        //           )
                        //           .toList(),
                        //       menuItemStyleData: const MenuItemStyleData(
                        //           // height: 40.0,
                        //           ),
                        //     ),
                        //   ),
                        // ),

                        const Gap(25),
                        const AppText(
                          text: 'Zip Code',
                        ),
                        const Gap(15),
                        AppTextFormField(
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                          controller: _zipCodeController,
                        ),
                        const Gap(25),
                        const AppText(
                          text: 'Nickname (optional)',
                        ),
                        const Gap(15),
                        AppTextFormField(
                          controller: _nickyController,
                          hintText: 'e.g. joint account or work card',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
            child: AppButton(
              isLoading: _isLoading,
              text: widget.isOnboarding ? 'Next' : 'Save',
              callback: () async {
                if (_formKey.currentState!.validate() &&
                    _countryController.text.isNotEmpty) {
                  var creditCardDetails = CreditCardDetails(
                      creditCardType: AppFunctions.getCreditCardName(
                          detectCCType(_cardNumberController.text)),
                      cardNumber: _cardNumberController.text,
                      expDate: _expController.text[2] == '/'
                          ? _expController.text
                          : '${_expController.text.substring(0, 3)}/${_expController.text.substring(2)}',
                      cvv: _cvvController.text,
                      country: _countryController.text,
                      zipCode: _zipCodeController.text,
                      nickName: _nickyController.text.trim());

                  // try {
                  // await FirebaseFirestore.instance
                  //     .collection(FirestoreCollections.users)
                  //     .doc(FirebaseAuth.instance.currentUser!.uid)
                  //     .set({
                  //   'credit cards': [creditCardDetails.toJson()]
                  // }, SetOptions(merge: true));
//TODO: to test:
                  await AppFunctions.addCreditCard(creditCardDetails);
                  if (widget.isOnboarding) {
                    await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const UberOneScreen(),
                    ));
                  } else {
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pop();
                  }

                  // } catch (e) {
                  //   await showAppInfoDialog(navigatorKey.currentContext!,
                  //       description: e.toString());
                  //   setState(() {
                  //     _isLoading = false;
                  //   });
                  // }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class CreditCardLogo extends StatelessWidget {
  const CreditCardLogo({
    super.key,
    required this.types,
  });

  final List<CreditCardType> types;

  @override
  Widget build(BuildContext context) {
    if (types.isEmpty) {
      return Image.asset(
        AssetNames.creditCard,
        width: 30,
        height: 20,
        fit: BoxFit.fitWidth,
      );
    } else {
      // logger.d(types.first.type);
      return Iconify(
        types.first == CreditCardType.visa()
            ? Logos.visa
            : types.first == CreditCardType.americanExpress()
                ? Cib.american_express
                : types.first == CreditCardType.discover()
                    ? Logos.discover
                    : Logos.mastercard,
        size: 12,
      );
    }
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text.replaceAll(RegExp(r'\D+'), '');
    final int newTextLength = newText.length;
    final StringBuffer buffer = StringBuffer();

    try {
      if (newTextLength > 0) {
        buffer.write(newText.substring(0, min(2, newTextLength)));
        if (newTextLength > 2) {
          buffer.write('/');
          buffer.write(newText.substring(2, min(4, newTextLength)));
        }
      }
    } catch (e) {
      logger.d('Error formatting input: $e');

      return oldValue;
    }

    final String formattedText = buffer.toString();

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
