import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/family_and_teens/teen/select_a_teen_screen.dart';

import '../../../../../../main.dart';

class AddTeenScreen extends StatelessWidget {
  const AddTeenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Add a teen',
          size: AppSizes.heading6,
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Image.asset(
                AssetNames.teenImage1,
                width: 200,
                // height: 200,
                // fit: BoxFit.cover,
              ),
              const Gap(3),
              Image.asset(
                AssetNames.teenImage2,
                width: 200,
                // height: 200,
                // fit: BoxFit.cover,
              ),
            ],
          ),
          const Gap(10),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                    text: 'Invite your teenager to Uber',
                    weight: FontWeight.bold,
                    size: AppSizes.heading4),
                Gap(15),
                AppText(
                    text:
                        "Now you can let your teen (ages 13-17) have their own account. Whether they're taking rides or placing orders, they'll have built-in safety features like:"),
              ],
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text: 'Top-rated drivers only',
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text: 'Live trip tracking',
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text: 'PIN verification',
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: AppText(
              text: '•',
              size: AppSizes.heading1,
              weight: FontWeight.bold,
            ),
            title: AppText(
              text: 'Unexpected event sensing',
              size: AppSizes.bodySmall,
              weight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                    text:
                        "Choose a teen to add to your Family profile, and we'll send them an invitation."),
                Gap(20),
                AppText(
                  weight: FontWeight.bold,
                  text: 'Learn more about teen accounts',
                  decoration: TextDecoration.underline,
                )
              ],
            ),
          )
        ],
      ),
      persistentFooterButtons: [
        AppButton(
          text: 'Choose contact',
          callback: () {
            navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => const SelectATeenScreen(),
            ));
          },
        )
      ],
    );
  }
}
