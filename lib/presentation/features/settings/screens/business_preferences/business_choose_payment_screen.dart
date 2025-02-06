import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/link_an_expense_program_screen.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';

class BusinessChoosePaymentScreen extends StatelessWidget {
  const BusinessChoosePaymentScreen({super.key});

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
              text: 'Choose payment',
              weight: FontWeight.bold,
              size: AppSizes.heading4,
            ),
            const Gap(30),
            const AppText(text: 'You can switch to a different payment method'),
            const Gap(30),
            ListTile(
              onTap: () {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const LinkAnExpenseProgramScreen(),
                ));
              },
              contentPadding: EdgeInsets.zero,
              leading: Image.asset(
                AssetNames.masterCardLogo,
                width: 30,
                height: 30,
                fit: BoxFit.fitWidth,
              ),
              title: const AppText(text: 'Mastercard ••••4320'),
            ),
            const Gap(20),
            GestureDetector(
                onTap: () {},
                child: const AppText(
                  text: 'Add payment method',
                  color: Colors.green,
                )),
            const Gap(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              decoration: const BoxDecoration(color: AppColors.neutral100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Gap(8),
                      Image.asset(
                        AssetNames.creditCard,
                        width: 40,
                      ),
                    ],
                  ),
                  const Gap(15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            weight: FontWeight.bold,
                            size: AppSizes.bodySmall,
                            text:
                                'Use your Amex Corporate Green, Gold or Platinum Card, earn Uber Cash'),
                        Gap(5),
                        AppText(
                            color: AppColors.neutral500,
                            size: AppSizes.bodySmall,
                            text:
                                'Earn Uber Cash for personal use when you ride with Uber or order with Uber Eats for business.')
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
