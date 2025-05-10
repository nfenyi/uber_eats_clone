import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/models/uber_one_status/uber_one_status_model.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../app_functions.dart';
import '../../../../../main.dart';
import '../../../../../state/delivery_schedule_provider.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../constants/weblinks.dart';
import '../../../../core/app_colors.dart';
import '../../../../services/sign_in_view_model.dart';
import '../../../address/screens/addresses_screen.dart';
import '../../../payment_options/payment_options_screen.dart';
import '../../../sign_in/views/add_a_credit_card/add_a_credit_card_screen.dart';

class SwitchToAnnualPlanScreen extends StatefulWidget {
  final UberOneStatus uberOneStatus;
  const SwitchToAnnualPlanScreen({super.key, required this.uberOneStatus});

  @override
  State<SwitchToAnnualPlanScreen> createState() =>
      _SwitchToAnnualPlanScreenState();
}

class _SwitchToAnnualPlanScreenState extends State<SwitchToAnnualPlanScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        //   statusBarIconBrightness: Brightness.dark,
        //   statusBarColor: Colors.white,
        // ));
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Image.asset(
                  AssetNames.switchToAnnual,
                  width: double.infinity,
                ),
                GestureDetector(
                  onTap: () {
                    navigatorKey.currentState!.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: AppSizes.horizontalPaddingSmall),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const AppText(
                          text: 'Save 20% with an Uber One annual plan',
                          size: AppSizes.heading4,
                          color: Colors.white,
                          weight: FontWeight.bold,
                        ),
                        const Row(
                          children: [
                            AppText(
                              text: '\$9.99/mo',
                              size: AppSizes.bodySmallest,
                              color: AppColors.neutral500,
                              decoration: TextDecoration.lineThrough,
                            ),
                            AppText(
                              size: AppSizes.bodySmallest,
                              text: ' \$8.00/mo (billed at \$96.00/yr)',
                              color: Colors.white,
                            )
                          ],
                        ),
                        const Gap(20),
                        const AppText(
                            color: Colors.white,
                            text:
                                "Switch plans and pay 20% less than what monthly plan members pay each year. That's like getting 2 months free!"),
                        const Gap(20),
                        RichText(
                          text: TextSpan(
                              text:
                                  "You agree to be charged \$96.00 today. Your plan will switch on ${AppFunctions.formatDate(widget.uberOneStatus.expirationDate.toString(), format: 'M j, Y')} and you will be charged yearly until you cancel. ",
                              style: const TextStyle(
                                fontSize: AppSizes.bodySmallest,
                                color: AppColors.neutral300,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms apply',
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppColors.neutral100),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await launchUrl(
                                          Uri.parse(Weblinks.uberOneTerms));
                                    },
                                ),
                              ]),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final selectedPaymentMethod =
                                ref.watch(paymentOptionProvider);

                            final types = selectedPaymentMethod != null
                                ? detectCCType(selectedPaymentMethod.cardNumber)
                                : null;

                            return ListTile(
                              leading: selectedPaymentMethod == null
                                  ? null
                                  : CreditCardLogo(types: types!),
                              title: AppText(
                                color: Colors.white,
                                text: selectedPaymentMethod == null
                                    ? 'Select Payment'
                                    : '${selectedPaymentMethod.creditCardType!}••••${selectedPaymentMethod.cardNumber.substring(6)}',
                                weight: FontWeight.w600,
                              ),
                              subtitle: const AppText(
                                color: Colors.white70,
                                text: 'Any Uber Cash will be applied',
                              ),
                              trailing: AppButton2(
                                  backgroundColor: AppColors.neutral200,
                                  text: selectedPaymentMethod == null
                                      ? 'Select  >'
                                      : 'Switch',
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
                          },
                        ),
                        Consumer(builder: (context, ref, child) {
                          return AppButton(
                            isLoading: _isLoading,
                            buttonColor: AppColors.uberOneGold,
                            text: 'Switch to annual plan',
                            callback: () async {
                              try {
                                if (ref.read(paymentOptionProvider) == null) {
                                  showInfoToast('Select a payment method',
                                      context: context);
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                final oldUberOneStatus = widget.uberOneStatus;
                                final newUberOneStatus =
                                    oldUberOneStatus.copyWith(
                                  plan: 'Annual',
                                );
                                await FirebaseFirestore.instance
                                    .collection(FirestoreCollections.users)
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  'uberOneStatus': newUberOneStatus.toJson(),
                                });

                                await AppFunctions.getOnlineUserInfo();
                                navigatorKey.currentState!.pop();
                              } on Exception catch (e) {
                                showInfoToast(e.toString(),
                                    context: navigatorKey.currentContext);
                              }
                            },
                          );
                        }),
                        const Gap(10)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
