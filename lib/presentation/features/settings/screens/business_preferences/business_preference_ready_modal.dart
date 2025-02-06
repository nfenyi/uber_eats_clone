import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../constants/asset_names.dart';
import '../../../../core/app_colors.dart';

class BusinessPreferenceReadyModal extends StatelessWidget {
  const BusinessPreferenceReadyModal({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onPopInvokedWithResult: (didPop, result) {
      //   navigatorKey.currentState!.popUntil(
      //       (route) => route.settings.name == '/manageBusinessPreference');
      // },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                navigatorKey.currentState!.popUntil((route) =>
                    route.settings.name == '/manageBusinessPreference');
              },
              child: const Icon(Icons.clear)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: "You're ready to eat",
                    weight: FontWeight.bold,
                    size: AppSizes.heading4,
                  ),
                  Image.asset(
                    AssetNames.businessPreferenceReady,
                    width: double.infinity,
                  ),
                  const Gap(10),
                  const AppText(
                    textAlign: TextAlign.center,
                    text:
                        "Now when you order meals, switch to Business to put your new features to work.",
                    color: AppColors.neutral500,
                  ),
                ],
              ),
              Column(
                children: [
                  AppButton(
                    text: 'Go to Business Hub',
                    callback: () {
                      navigatorKey.currentState!.popUntil((route) =>
                          route.settings.name == '/manageBusinessPreference');
                    },
                  ),
                  const Gap(10)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
