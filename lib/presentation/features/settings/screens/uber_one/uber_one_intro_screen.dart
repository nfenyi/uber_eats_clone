import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/constants/other_constants.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/uber_one_all_set_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/uber_one_screen2.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app_functions.dart';
import '../../../../../models/uber_one_status/uber_one_status_model.dart';
import '../../../../../state/delivery_schedule_provider.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/weblinks.dart';
import '../../../../core/widgets.dart';
import '../../../../services/sign_in_view_model.dart';
import '../../../payment_options/payment_options_screen.dart';
import '../../../sign_in/views/add_a_credit_card/add_a_credit_card_screen.dart';

class UberOneIntroScreen extends StatefulWidget {
  final UberOneStatus uberOneStatus;
  const UberOneIntroScreen(this.uberOneStatus, {super.key});

  @override
  State<UberOneIntroScreen> createState() => _UberOneIntroScreenState();
}

class _UberOneIntroScreenState extends State<UberOneIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AssetNames.uberOneSmall,
                          width: 40,
                        ),
                        const AppText(
                          text: 'Uber One',
                          size: AppSizes.heading4,
                          weight: FontWeight.w600,
                        )
                      ],
                    ),
                    const Row(
                      children: [
                        AppText(
                          text: '\$9.99/mo',
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.neutral500,
                        ),
                        AppText(
                          text: ' 4 weeks free',
                          color: Colors.brown,
                        ),
                      ],
                    ),
                    const Gap(10),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: OtherConstants.benefits.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 205,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        final benefit = OtherConstants.benefits[index];
                        return Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.neutral300)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                benefit.assetImage,
                                height: 50,
                              ),
                              const Gap(15),
                              AppText(
                                text: benefit.title,
                                size: AppSizes.bodySmall,
                                weight: FontWeight.w600,
                              ),
                              const Gap(5),
                              AppText(
                                text: benefit.message,
                                size: AppSizes.bodySmallest,
                                color: AppColors.neutral500,
                                // size: AppSizes.bodySmall,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => UberOneScreen2(widget.uberOneStatus),
                  ));
                },
                title: const AppText(
                  text: 'See terms and benefit details',
                  weight: FontWeight.bold,
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
              const Divider(
                thickness: 4,
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      Image.asset(
                        AssetNames.uberOneSmall,
                        width: 50,
                      ),
                      const Gap(5),
                      const AppText(
                        text: 'Save \$25 every month',
                        color: Colors.brown,
                        size: AppSizes.bodySmall,
                      ),
                      const Gap(10),
                      const AppText(
                        text:
                            "That's how much people save on average from Uber One and promos in your country",
                        color: AppColors.neutral500,
                        textAlign: TextAlign.center,
                        size: AppSizes.bodySmallest,
                      ),
                      const Gap(20)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        AppButton(
            text: 'Join Uber One',
            callback: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (context) => const JoinUberOneModal(),
              );
            })
      ],
    );
  }
}

class JoinUberOneModal extends StatefulWidget {
  const JoinUberOneModal({super.key});

  @override
  State<JoinUberOneModal> createState() => _JoinUberOneModalState();
}

class _JoinUberOneModalState extends State<JoinUberOneModal> {
  late Plan? selectedBilling;
  bool _isLoading = false;
  final billings = OtherConstants.billings;

  late UberOneStatus _uberOneStatus;

  @override
  void initState() {
    super.initState();
    selectedBilling = billings.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                const AppText(
                  text: 'Join Uber One',
                  size: AppSizes.heading6,
                  weight: FontWeight.w600,
                ),
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close))
              ],
            ),
          ),
          const Gap(5),
          const Divider(),
          const Gap(5),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:
                              selectedBilling?.period == billings.first.period
                                  ? Colors.black
                                  : AppColors.neutral300)),
                  child: RadioListTile.adaptive(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: '4 weeks free',
                          color: Colors.brown,
                        ),
                        Row(
                          children: [
                            AppText(
                                size: AppSizes.bodySmallest,
                                color: AppColors.neutral500,
                                text:
                                    '\$${billings.first.bill.toStringAsFixed(2)}/mo'),
                          ],
                        ),
                      ],
                    ),
                    title: AppText(
                      text: billings.first.period,
                      size: AppSizes.bodySmall,
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: billings.first.period,
                    groupValue: selectedBilling?.period,
                    onChanged: (value) {
                      setState(() {
                        selectedBilling = billings.firstWhere(
                          (element) => element.period == value,
                        );
                      });
                    },
                  ),
                ),
                const Gap(10),
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 5, bottom: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: selectedBilling?.period == billings.last.period
                              ? Colors.black
                              : AppColors.neutral300)),
                  child: Column(
                    children: [
                      RadioListTile.adaptive(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(
                              text: '4 weeks free',
                              color: Colors.brown,
                            ),
                            Row(
                              children: [
                                AppText(
                                    size: AppSizes.bodySmallest,
                                    color: AppColors.neutral500,
                                    text:
                                        '\$${billings.last.bill.toStringAsFixed(2)}/mo'),
                                AppText(
                                    size: AppSizes.bodySmallest,
                                    color: AppColors.neutral500,
                                    text:
                                        ' (billed at \$${(billings.last.bill * 12).toStringAsFixed(2)}/yr)')
                              ],
                            ),
                          ],
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 2),
                              decoration: BoxDecoration(
                                  color: AppColors.uberOneGold,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const AppText(
                                text: 'Best value',
                                color: Colors.white,
                                size: AppSizes.bodyTiny,
                              ),
                            ),
                            AppText(
                              text: billings.last.period,
                              size: AppSizes.bodySmall,
                            ),
                          ],
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: billings.last.period,
                        groupValue: selectedBilling?.period,
                        onChanged: (value) {
                          setState(() {
                            selectedBilling = billings.firstWhere(
                              (element) => element.period == value,
                            );
                          });

                          // showInfoToast('Switched to $_selectedBilling',
                          //     icon: const Icon(
                          //       Icons.person,
                          //       size: 18,
                          //       color: Colors.white,
                          //     ),
                          //     context: context);
                        },
                      ),
                      ListTile(
                        leading: Image.asset(
                          AssetNames.uberOneTag,
                          width: 30,
                        ),
                        title: const AppText(
                          size: AppSizes.bodySmallest,
                          text:
                              'Save an extra 20% each year compared to a monthly plan',
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                AppText(
                    text:
                        'Billing starts ${AppFunctions.formatDate(DateTime.now().add(const Duration(days: 28)).toString(), format: 'M j, Y')} for \$${selectedBilling?.bill.toStringAsFixed(2)}/mo. Cancel without fees or penalties.'),
                const Gap(10),
                RichText(
                  text: TextSpan(
                      text:
                          "By joining Uber One, you authorize Uber to charge \$${selectedBilling?.bill.toStringAsFixed(2)} on any payment method on your account, and monthly thereafter, based on the terms, until you cancel. To avoid charges cancel up to 48 hours before ${AppFunctions.formatDate(DateTime.now().add(const Duration(days: 28)).toString(), format: 'M j, Y')} in the app. ",
                      style: const TextStyle(
                        fontSize: AppSizes.bodySmallest,
                        color: AppColors.neutral500,
                      ),
                      children: [
                        TextSpan(
                          text: 'View terms and conditions',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await launchUrl(Uri.parse(Weblinks.uberOneTerms));
                            },
                        ),
                      ]),
                ),
                const UberOnePaymentMethodWidget(),
                const Gap(10),
                Consumer(builder: (context, ref, child) {
                  return AppButton(
                    isLoading: _isLoading,
                    text: 'Try for free',
                    callback: () async {
                      try {
                        if (ref.read(paymentOptionProvider) == null) {
                          showInfoToast('Select a payment method',
                              context: context);
                          return;
                        }
                        if (selectedBilling == null) {
                          showInfoToast('Please select a plan',
                              context: context);
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });

                        _uberOneStatus = UberOneStatus(
                            hasUberOne: true,
                            plan: selectedBilling!.period,
                            expirationDate: selectedBilling?.period == 'Monthly'
                                ? DateTime.now().add(const Duration(days: 58))
                                : DateTime.now()
                                    .add(const Duration(days: 393)));
                        await FirebaseFirestore.instance
                            .collection(FirestoreCollections.users)
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'uberOneStatus': _uberOneStatus.toJson(),
                        });

                        await AppFunctions.getOnlineUserInfo();
                        navigatorKey.currentState!.pop();
                        await navigatorKey.currentState!
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const UberOneAllSetScreen(),
                        ));
                        setState(() {
                          _isLoading = false;
                        });
                      } on Exception catch (e) {
                        showInfoToast(e.toString(),
                            context: navigatorKey.currentContext);
                      }
                    },
                  );
                }),
                const Gap(20),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UberOnePaymentMethodWidget extends ConsumerWidget {
  const UberOnePaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPaymentMethod = ref.watch(paymentOptionProvider);

    final types = selectedPaymentMethod != null
        ? detectCCType(selectedPaymentMethod.cardNumber)
        : null;

    return ListTile(
      leading:
          selectedPaymentMethod == null ? null : CreditCardLogo(types: types!),
      title: AppText(
        text: selectedPaymentMethod == null
            ? 'Select Payment'
            : '${selectedPaymentMethod.creditCardType!}••••${selectedPaymentMethod.cardNumber.substring(6)}',
        weight: FontWeight.w600,
      ),
      subtitle: const AppText(
        text: 'Any Uber Cash will be applied',
      ),
      trailing: AppButton2(
          text: selectedPaymentMethod == null ? 'Select  >' : 'Switch',
          callback: () {
            showModalBottomSheet(
                isScrollControlled: true,
                useSafeArea: true,
                barrierColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return const PaymentOptionsScreen(
                    showOnlyPaymentMethods: true,
                  );
                });
          }),
    );
  }
}
