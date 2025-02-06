import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/business_preference_ready_modal.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';

class LinkAnExpenseProgramScreen extends StatelessWidget {
  const LinkAnExpenseProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _expensePrograms = <ExpenseProgram>[
      ExpenseProgram(
          imageUrl:
              'https://cdn6.aptoide.com/imgs/b/d/2/bd25bfdd2ddb8f893e0b785883589e8b_icon.png',
          name: 'Certify'),
      ExpenseProgram(
          imageUrl:
              'https://play-lh.googleusercontent.com/ZZfA95i7cRksnMUmaiFep9rg4ip3w05cRQT9MY3dZmdK0zlzzIKb_RhJ_0LvPpkE1ZQ',
          name: 'Chrome River'),
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Link an expense program',
              weight: FontWeight.bold,
              size: AppSizes.heading4,
            ),
            const AppText(
                size: AppSizes.bodySmall,
                color: AppColors.neutral500,
                text:
                    "We'll automatically upload receipts to your expensing software after each business meal."),
            const Gap(20),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final expenseProgram = _expensePrograms[index];
                  return ListTile(
                    onTap: () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) =>
                            const BusinessPreferenceReadyModal(),
                      ));
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: CachedNetworkImage(
                      imageUrl: expenseProgram.imageUrl,
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                    title: AppText(text: expenseProgram.name),
                  );
                },
                itemCount: _expensePrograms.length,
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: AppSizes.horizontalPaddingSmall),
            child: InkWell(
              onTap: () {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const BusinessPreferenceReadyModal(),
                ));
              },
              child: const Padding(
                padding: EdgeInsets.all(3),
                child: AppText(text: 'SKIP'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ExpenseProgram {
  final String imageUrl;
  final String name;

  ExpenseProgram({required this.imageUrl, required this.name});
}
