import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/add_card.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod('Venmo', AssetNames.venmoLogo),
    PaymentMethod('Credit or Debit', AssetNames.creditCard),
    PaymentMethod('PayPal', AssetNames.paypal),
    PaymentMethod('Gift Card', AssetNames.uberLogo),
    PaymentMethod('Klarna', AssetNames.klarnaLogo),
    PaymentMethod('S3 Health Benefits Card', AssetNames.s3HealthBenLogo),
    PaymentMethod('CVS Pharmacy', AssetNames.cvsPharmLogo),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: AppSizes.horizontalPaddingSmall),
            child: InkWell(
              onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const AddCardScreen(),
              )),
              child: Ink(
                child: const AppText(
                  text: 'Skip',
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Select your preferred payment method',
              size: AppSizes.heading5,
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
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(
                        paymentMethod.assetImage,
                        height: 15,
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

class PaymentMethod {
  final String name;
  final String assetImage;
  final String? cardNumber;

  PaymentMethod(this.name, this.assetImage, {this.cardNumber});
}
