import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';

class ThankYouModal extends StatelessWidget {
  const ThankYouModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Help',
          size: AppSizes.heading6,
        ),
        leading: GestureDetector(
            onTap: () {
              navigatorKey.currentState!.pop();
              navigatorKey.currentState!.pop();
            },
            child: const Icon(Icons.close)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AssetNames.helpThankYou,
            width: double.infinity,
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Submitted',
                  weight: FontWeight.bold,
                  size: AppSizes.heading6,
                ),
                const Gap(20),
                AppButton(
                  text: 'OK',
                  callback: () {
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pop();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
