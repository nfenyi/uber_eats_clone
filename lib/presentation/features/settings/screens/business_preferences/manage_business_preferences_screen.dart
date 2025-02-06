import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/initial_add_business_profile_screen.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';

class ManageBusinessPreferencesScreen extends StatelessWidget {
  const ManageBusinessPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppText(
              text: 'Business Preferences',
              weight: FontWeight.bold,
              size: AppSizes.heading4,
            ),
          ),
          ListTile(
            title: const AppText(
              text: 'Business',
              weight: FontWeight.bold,
              size: AppSizes.heading6,
            ),
            subtitle: const AppText(
              text: 'No payment method',
              color: AppColors.neutral500,
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.neutral500,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.blue),
              child: const Iconify(
                Mdi.briefcase,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          ListTile(
            onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => const InitialAddBusinessProfileScreen(),
            )),
            leading: const Icon(
              Icons.add,
            ),
            title: const AppText(text: 'Add another business profile'),
          )
        ],
      ),
    );
  }
}
