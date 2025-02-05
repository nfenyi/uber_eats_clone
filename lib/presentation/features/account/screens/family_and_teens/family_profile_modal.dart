import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/family_and_teens/new_family_contact_screen.dart';

class FamilyProfileModal extends StatelessWidget {
  const FamilyProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => navigatorKey.currentState!.pop(),
            child: const Icon(Icons.close)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Family profile',
                  size: AppSizes.heading4,
                ),
                Gap(20),
                AppText(
                  text: 'Members',
                  weight: FontWeight.bold,
                  size: AppSizes.heading6,
                ),
                AppText(
                  text:
                      'Add or remove people that can use your Family profile.',
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => const NewFamilyContactScreen(),
            )),
            dense: true,
            leading: const Icon(Icons.add_circle),
            title: const AppText(
              text: 'Add new member',
              size: AppSizes.bodySmall,
            ),
            subtitle: const AppText(
              text: 'Teens or adults',
              color: AppColors.neutral500,
            ),
          ),
          const Divider(
            thickness: 4,
          ),
          const ListTile(
            dense: true,
            leading: Icon(Icons.person),
            title: AppText(
              text: 'Nana Fenyi',
              size: AppSizes.bodySmall,
            ),
            subtitle: AppText(
              text: 'Organizer',
              color: AppColors.neutral500,
            ),
          ),
          const Divider(
            color: AppColors.neutral200,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Settings',
                  weight: FontWeight.bold,
                  size: AppSizes.heading6,
                ),
                AppText(
                  text:
                      "Choose your family's shared payment method and where you want to get receipts.",
                  // weight: FontWeight.bold,
                  // size: AppSizes.heading6,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            leading: const Icon(Icons.email),
            title: const AppText(
              text: 'Email for receipt',
              size: AppSizes.bodySmall,
            ),
            subtitle: const AppText(
              text: 'nanafenyim@gmail.com',
              color: AppColors.neutral500,
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.neutral500,
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            leading: const Icon(Icons.credit_card),
            title: const AppText(
              text: 'Payment method',
              size: AppSizes.bodySmall,
            ),
            subtitle: const AppText(
              text: 'MASTERCARD 4320',
              color: AppColors.neutral500,
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.neutral500,
            ),
          ),
          const Divider(
            thickness: 4,
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppButton(
              text: 'Delete Family profile',
              isSecondary: true,
              callback: () {},
              textColor: Colors.red.shade900,
              iconFirst: true,
              icon: Icon(
                Icons.cancel,
                color: Colors.red.shade900,
              ),
            ),
          )
        ],
      ),
    );
  }
}
