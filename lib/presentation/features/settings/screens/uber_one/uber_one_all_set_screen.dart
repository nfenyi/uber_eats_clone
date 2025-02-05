import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/exclusive_offers_screen.dart';

import '../../../../../main.dart';
import '../../../../constants/asset_names.dart';

class UberOneAllSetScreen extends StatelessWidget {
  const UberOneAllSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Image.asset(AssetNames.uberOneImage),
                GestureDetector(
                  onTap: navigatorKey.currentState!.pop,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: AppSizes.horizontalPaddingSmall),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                )
              ],
            ),
            const Gap(20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "You're all set with Uber One!",
                          weight: FontWeight.bold,
                          size: AppSizes.heading3,
                        ),
                        Gap(30),
                        AppText(
                          text:
                              'Enjoy member pricing and benefits on rides, meals, and grocery.',
                          size: AppSizes.bodySmall,
                        ),
                        Gap(20),
                        AppText(
                          text:
                              'Just look for the uber One icon to know when you can save.',
                          size: AppSizes.bodySmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        AppButton(
                          text: 'Start saving now',
                          callback: () {
                            navigatorKey.currentState!
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) =>
                                  const ExclusiveOffersScreen(),
                            ));
                          },
                        ),
                        const Gap(10)
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
