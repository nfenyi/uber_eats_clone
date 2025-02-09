import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../core/app_colors.dart';
import 'communication_email_screen.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final bool _changed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Communication',
          size: AppSizes.body,
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Marketing preferences',
                  weight: FontWeight.bold,
                  size: AppSizes.heading6,
                ),
                Gap(5),
                AppText(
                    color: AppColors.neutral500,
                    text:
                        'Choose how to get special offers, promos, personalized suggestions, and more'),
              ],
            ),
          ),
          ListTile(
            dense: true,
            onTap: () {},
            trailing: const Icon(Icons.keyboard_arrow_right),
            title: const AppText(
              text: 'Push notifications',
              size: AppSizes.bodySmall,
            ),
          ),
          const Divider(),
          ListTile(
            dense: true,
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const CommunicationEmailScreen(),
              ));
            },
            trailing: const Icon(Icons.keyboard_arrow_right),
            title: const AppText(
              text: 'Email',
              size: AppSizes.bodySmall,
            ),
          ),
          const Divider(),
        ],
      ),
      persistentFooterButtons: [
        Column(
          children: [
            if (_changed)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Changes may not apply for active trips',
                    size: AppSizes.bodySmall,
                    color: AppColors.neutral500,
                  ),
                  Gap(10),
                ],
              ),
            AppButton(
              text: 'Save Changes',
              callback: _changed ? () {} : null,
            ),
          ],
        )
      ],
    );
  }
}
