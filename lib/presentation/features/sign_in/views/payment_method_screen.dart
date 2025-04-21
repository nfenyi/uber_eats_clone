import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/add_a_credit_card/add_a_credit_card_screen.dart';

import '../../../../main.dart';
import '../../../../models/payment_method_model.dart';
import '../../../constants/app_sizes.dart';
import '../../gifts/screens/redeem_gift_card_screen.dart';
import 'uber_one_screen.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  final bool isOnboarding;
  const PaymentMethodScreen({super.key, this.isOnboarding = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  final List<PaymentMethod> _paymentMethods = [
    const PaymentMethod(name: 'Venmo', assetImage: AssetNames.venmoLogo),
    const PaymentMethod(
        name: 'Credit or Debit', assetImage: AssetNames.creditCard),
    const PaymentMethod(name: 'PayPal', assetImage: AssetNames.paypal),
    const PaymentMethod(name: 'Gift Card', assetImage: AssetNames.uberLogo),
    const PaymentMethod(name: 'Klarna', assetImage: AssetNames.klarnaLogo),
    const PaymentMethod(
        name: 'S3 Health Benefits Card',
        assetImage: AssetNames.s3HealthBenLogo),
    const PaymentMethod(
        name: 'CVS Pharmacy', assetImage: AssetNames.cvsPharmLogo),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: widget.isOnboarding
            ? [
                Padding(
                  padding: const EdgeInsets.only(
                      right: AppSizes.horizontalPaddingSmall),
                  child: AppTextButton(
                    callback: () =>
                        navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const UberOneScreen(),
                    )),
                    text: 'Skip',
                  ),
                )
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Select your preferred payment method',
              size: AppSizes.heading6,
              weight: FontWeight.w600,
            ),
            const Gap(40),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.green,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  )),
              title: const AppText(text: 'Bank account'),
            ),
            const Gap(5),
            const AppText(text: 'Connect quickly with Link'),
            const Gap(20),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    final paymentMethod = _paymentMethods[index];
                    return ListTile(
                      onTap: () async {
                        if (paymentMethod.name == 'Credit or Debit') {
                          await navigatorKey.currentState!
                              .push(MaterialPageRoute(
                                  builder: (context) => AddCardScreen(
                                        isOnboarding: widget.isOnboarding,
                                      )));
                        } else if (paymentMethod.name == 'Gift Card') {
                          await showModalBottomSheet(
                            useSafeArea: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return const RedeemGiftCardScreen();
                            },
                          );
                        } else {
                          await navigatorKey.currentState!
                              .push(MaterialPageRoute(
                            builder: (context) => const UberOneScreen(),
                          ));
                        }
                      },
                      titleAlignment: ListTileTitleAlignment.center,
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(
                        paymentMethod.assetImage,
                        fit: BoxFit.cover,
                        height: 15,
                        width: 30,
                      ),
                      title: AppText(text: paymentMethod.name),
                    );
                  },
                  itemCount: _paymentMethods.length),
            )
          ],
        ),
      ),
    );
  }
}
