import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/add_card.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import 'uber_one_screen.dart';

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
            child: AppTextButton(
              callback: () => navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const UberOneScreen(),
              )),
              text: 'Skip',
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
                      onTap: () {
                        if (paymentMethod.name == 'Credit or Debit') {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => AddCardScreen()));
                        } else {
                          navigatorKey.currentState!.push(MaterialPageRoute(
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

class PaymentMethod {
  final String name;
  final String assetImage;
  final String? cardNumber;

  PaymentMethod(this.name, this.assetImage, {this.cardNumber});
}
