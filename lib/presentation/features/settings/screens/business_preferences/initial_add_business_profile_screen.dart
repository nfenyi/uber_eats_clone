import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/whats_your_business_email.dart';

import '../../../../constants/app_sizes.dart';

class InitialAddBusinessProfileScreen extends StatelessWidget {
  const InitialAddBusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(
            AssetNames.initialAddBusinessPreference,
            width: double.infinity,
          ),
          const Gap(10),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                AppText(
                  text: 'Unlock ride and meal perks with Uber for Business',
                  weight: FontWeight.bold,
                  size: AppSizes.heading4,
                ),
                Gap(10),
              ],
            ),
          ),
          const ListTile(
            leading: Icon(Icons.receipt_long),
            title: AppText(
              text: 'Seamless expensing',
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
            subtitle: AppText(
              text:
                  'Save valuable time with automatic receipt uploads through expense integrations. Submitting an expense report has never been easier',
              color: AppColors.neutral500,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.receipt_long),
            title: AppText(
              text: 'Separate business from personal',
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
            subtitle: AppText(
              text:
                  'It is simple to switch between business and personal profiles, ensuring that your expenses are properly split and the correct payment method is used.',
              color: AppColors.neutral500,
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Column(
          children: [
            AppButton(
              text: 'Check pending invites',
              callback: () {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const WhatsYourBusinessEmail(),
                ));
              },
            ),
            const Gap(10),
            AppTextButton(
              text: 'I have a pin code',
              callback: () {},
            )
          ],
        )
      ],
    );
  }
}
