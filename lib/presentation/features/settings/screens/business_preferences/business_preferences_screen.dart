import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ep.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/business_profile/business_profile_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/manage_business_preferences_screen.dart';

import '../../../../core/app_colors.dart';

class BusinessPreferencesScreen extends StatefulWidget {
  final BusinessProfile selectedBusinessProfile;
  const BusinessPreferencesScreen(this.selectedBusinessProfile, {super.key});

  @override
  State<BusinessPreferencesScreen> createState() =>
      _BusinessPreferencesScreenState();
}

class _BusinessPreferencesScreenState extends State<BusinessPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  AssetNames.businessPreferences2,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15),
                  child: InkWell(
                    onTap: navigatorKey.currentState!.pop,
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
            ListTile(
              title: const AppText(
                text: 'Business',
                weight: FontWeight.bold,
                size: AppSizes.heading6,
              ),
              subtitle: AppText(
                text: widget.selectedBusinessProfile.email ??
                    'Email not provided',
                color: AppColors.neutral500,
              ),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue),
                child: const Iconify(
                  Mdi.briefcase,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const Divider(
              thickness: 4,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                text: 'Uber for Business perks',
                weight: FontWeight.bold,
                size: AppSizes.heading4,
              ),
            ),
            const ListTile(
              leading: Icon(Icons.receipt_long),
              title: AppText(
                text: 'Seamless expensing',
                weight: FontWeight.bold,
              ),
              subtitle: AppText(
                  text:
                      'Auto receipt forwarding to leading expense providers.'),
            ),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              onTap: () {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  settings:
                      const RouteSettings(name: '/manageBusinessPreference'),
                  builder: (context) => const ManageBusinessPreferencesScreen(),
                ));
              },
              leading: const Icon(Icons.settings),
              title: const AppText(
                text: 'Manage profiles and payment methods',
                weight: FontWeight.bold,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Iconify(Ep.help),
              title: const AppText(
                text: 'Contact support',
                weight: FontWeight.bold,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
            ),
            const Gap(20),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                  color: AppColors.neutral500,
                  text:
                      "Details shown above are not guaranteed and may not reflect all workplace program details. Please refer to your company's policies for complete program details and information. Program details may be subject to change without notice."),
            )
          ],
        ),
      ),
    );
  }
}
