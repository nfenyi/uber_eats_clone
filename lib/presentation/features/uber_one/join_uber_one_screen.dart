import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';

class JoinUberOneScreen extends StatelessWidget {
  const JoinUberOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: 'Uber One',
                      size: AppSizes.heading6,
                      weight: FontWeight.w600,
                    ),
                    Row(children: [
                      AppText(
                        text: '\$9.99/mo',
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.neutral500,
                      ),
                      Gap(5),
                      AppText(
                        text: '4 weeks free',
                        color: AppColors.uberOneGold,
                      ),
                    ]),
                  ],
                ),
              ),
              const Gap(10),
              ListTile(
                leading: Image.asset(
                  AssetNames.uberOneGiftBag,
                  width: 50,
                ),
                title: const AppText(
                  text:
                      '\$0 Delivery Fee on eligible food, groceries, and more',
                ),
              ),
              ListTile(
                leading: Image.asset(
                  AssetNames.uberOneTag,
                  width: 50,
                ),
                title: const AppText(
                  text: 'Up to 10% off eligible deliveries and pickup orders',
                ),
              ),
              ListTile(
                leading: Image.asset(
                  AssetNames.uberOneCar,
                  width: 50,
                ),
                title: const AppText(
                  text:
                      'Earn 6% uber Cash and get top-rated drivers on eligible rides',
                ),
              ),
              ListTile(
                leading: Image.asset(
                  AssetNames.uberOneCalendar,
                  width: 50,
                ),
                title: const AppText(
                  text: 'Cancel without fees or penalties',
                ),
              ),
              const Gap(10),
              const Divider(),
              const Gap(10),
              Image.asset(
                AssetNames.uberOneSmall,
                width: 100,
              ),
              const Gap(10),
              const AppText(
                text: 'Save \$25 every month',
                color: AppColors.uberOneGold,
                size: AppSizes.bodySmall,
              ),
              const Gap(10),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: AppText(
                  size: AppSizes.bodySmall,
                  textAlign: TextAlign.center,
                  text:
                      "That's how much people save on average from member pricing, cash back, and promos in your country",
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: AppText(
                    size: AppSizes.bodySmaller,
                    color: AppColors.neutral500,
                    text:
                        '*Benefits available only for eligible stores and rides marked with the uber One icon, Participating restaurants and non-grocery'),
              ),
            ],
          ),
          Column(
            children: [
              AppButton(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                text: 'Join Uber One',
                callback: () {},
              ),
              const Gap(10),
            ],
          )
        ],
      ),
    );
  }
}
