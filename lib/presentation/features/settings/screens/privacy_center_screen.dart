import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/payment_options_screen.dart';

import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';

class PrivacyCenterScreen extends StatelessWidget {
  const PrivacyCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.neutral100,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall, vertical: 30),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Privacy Center',
                    size: AppSizes.heading3,
                    weight: FontWeight.bold,
                  ),
                  Gap(15),
                  AppText(
                      size: AppSizes.bodySmall,
                      text:
                          'Take control of your privacy and learn how we protect it.'),
                ],
              ),
            ),
            const Gap(20),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                text: 'Your data and privacy at Uber',
                size: AppSizes.bodySmall,
                weight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: 230,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral200),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: Image.asset(
                            AssetNames.dataNPrivacy1,
                            width: double.infinity,
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  text:
                                      'Would you like to see a summary of how you use Uber?',
                                  weight: FontWeight.bold,
                                ),
                                AppButton2(text: 'See summary', callback: () {})
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Gap(20),
                  Container(
                    width: 230,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral200),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: Image.asset(
                            AssetNames.dataNPrivacy2,
                            width: double.infinity,
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  text:
                                      'Would you like a copy of your personal data?',
                                  weight: FontWeight.bold,
                                ),
                                AppButton2(text: 'Request', callback: () {})
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            const Gap(10),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                text: 'Ads and Data',
                weight: FontWeight.bold,
                size: AppSizes.heading6,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.bolt),
              title: const AppText(
                text: 'Offers and Promos from Uber',
                weight: FontWeight.bold,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
              subtitle: const AppText(
                text: 'Control personalized offers and promos from Uber',
                color: AppColors.neutral500,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Iconify(Mdi.gift),
              title: const AppText(
                text: 'Data Tracking',
                weight: FontWeight.bold,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
              subtitle: const AppText(
                text: 'Control Data Tracking for Personalized Ads',
                color: AppColors.neutral500,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Iconify(AntDesign.tag_fill),
              title: const AppText(
                text: 'Ads on Uber Eats',
                weight: FontWeight.bold,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
              subtitle: const AppText(
                text: 'Control personalized ads you see in Eats',
                color: AppColors.neutral500,
              ),
            ),
            const Divider(),
            const Gap(10),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                text: 'Location sharing',
                weight: FontWeight.bold,
                size: AppSizes.heading6,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.pin_drop),
              title: const AppText(
                text: 'Live location',
                weight: FontWeight.bold,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
              subtitle: const AppText(
                text: 'Control how Uber shares your live location with others',
                color: AppColors.neutral500,
              ),
            ),
            const Divider(),
            const Gap(10),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                text: 'Account security',
                weight: FontWeight.bold,
                size: AppSizes.heading6,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Iconify(IconParkSolid.people_delete_one),
              title: const AppText(
                text: 'Account Deletion',
                weight: FontWeight.bold,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
            ),
            const Divider(),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'How do we approach privacy at Uber?',
                    weight: FontWeight.bold,
                    size: AppSizes.heading6,
                  ),
                  AppButton2(
                    text: 'Check out Privacy Overview Page',
                    callback: () {},
                  ),
                  AppButton2(
                    text: 'Submit a privacy inquiry',
                    callback: () {},
                  ),
                ],
              ),
            ),
            const Gap(30),
            Image.asset(
              AssetNames.dataNPrivacyBottomImage,
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }
}
