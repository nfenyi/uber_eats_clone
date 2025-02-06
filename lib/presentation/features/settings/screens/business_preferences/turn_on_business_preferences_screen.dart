import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/business_preferences_screen.dart';

import '../../../../constants/app_sizes.dart';

class TurnOnBusinessPreferencesScreen extends StatelessWidget {
  const TurnOnBusinessPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  text: 'Business Preferences',
                  size: AppSizes.heading4,
                ),
                const Gap(15),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color.fromARGB(255, 241, 247, 238),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AssetNames.businessPreferences,
                            width: 60,
                          ),
                          const Gap(20),
                          const Expanded(
                            child: AppText(
                              text: 'Get more with business meals',
                              weight: FontWeight.bold,
                              size: AppSizes.heading5,
                            ),
                          )
                        ],
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.check),
                        title: AppText(
                          text: 'Quicker, easier expensing',
                          weight: FontWeight.bold,
                        ),
                        subtitle: AppText(
                          size: AppSizes.bodySmall,
                          text: 'Automatically sync with expensing apps',
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.check),
                        title: AppText(
                          text: 'Keep work meals separate',
                          weight: FontWeight.bold,
                        ),
                        subtitle: AppText(
                          size: AppSizes.bodySmall,
                          text: 'Get receipts at your work email',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Column(
              children: [
                AppButton(
                  text: 'Turn on',
                  callback: () {
                    navigatorKey.currentState!
                        .pushReplacement(MaterialPageRoute(
                      builder: (context) => const BusinessPreferencesScreen(),
                    ));
                  },
                ),
                const Gap(10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
