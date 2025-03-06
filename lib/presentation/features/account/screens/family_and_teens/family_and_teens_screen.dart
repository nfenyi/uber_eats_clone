import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/family_and_teens/teen/add_teen_screen.dart';

import '../../../../../main.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';

class FamilyAndTeensScreen extends StatelessWidget {
  const FamilyAndTeensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(
            AssetNames.family,
            width: double.infinity,
          ),
          const Gap(10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            text: 'Take care of your family with Uber',
                            weight: FontWeight.bold,
                            size: AppSizes.heading4),
                        Gap(15),
                        AppText(
                            text:
                                'Want to pay for your loved ones? Invite a family member (ages 18+) to create a Family profile. You can:'),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AppText(
                              text: 'Pay for your family',
                              size: AppSizes.bodySmaller,
                            ),
                            subtitle: AppText(
                              text: 'Use a shared payment method',
                              color: AppColors.neutral500,
                            ),
                            leading: Icon(Icons.favorite)),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AppText(
                              text: 'Get updates',
                              size: AppSizes.bodySmaller,
                            ),
                            subtitle: AppText(
                              text:
                                  'Receive notifications when a member uses the Family profile',
                              color: AppColors.neutral500,
                            ),
                            leading: Icon(Icons.notifications_outlined)),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AppText(
                              text: 'Manage family members',
                              size: AppSizes.bodySmaller,
                            ),
                            subtitle: AppText(
                              text:
                                  'Add up to 10 people that can use the Family profile',
                              color: AppColors.neutral500,
                            ),
                            leading: Icon(Icons.settings)),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                    children: [
                      AppButton(
                        text: 'Invite family',
                        callback: () {
                          showModalBottomSheet(
                            isScrollControlled: false,
                            context: context,
                            builder: (context) {
                              String? selectedOption = 'Adult';
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        child: AppText(
                                          text: 'Add an adult or teen?',
                                          weight: FontWeight.w600,
                                          size: AppSizes.heading6,
                                        ),
                                      ),
                                      const Divider(),
                                      RadioListTile.adaptive(
                                        dense: true,
                                        title: const AppText(
                                          text: 'Adult',
                                          size: AppSizes.bodySmall,
                                        ),
                                        subtitle: const AppText(
                                          text: 'Adults are 18 and older',
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        secondary: const Iconify(Uil.i_18_plus),
                                        value: 'Adult',
                                        groupValue: selectedOption,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedOption = value;
                                          });
                                        },
                                      ),
                                      const Divider(
                                        indent: 60,
                                      ),
                                      RadioListTile.adaptive(
                                        title: const AppText(
                                          text: 'Teen',
                                          size: AppSizes.bodySmall,
                                        ),
                                        subtitle: const AppText(
                                          text: 'Teens are ages 13 to 17',
                                        ),
                                        dense: true,
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        secondary:
                                            const Iconify(Mdi.human_male_child),
                                        value: 'Teen',
                                        groupValue: selectedOption,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedOption = value;
                                          });
                                        },
                                      ),
                                      const Gap(10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        child: Column(
                                          children: [
                                            AppButton(
                                              text: 'Continue',
                                              callback: () {
                                                navigatorKey.currentState!
                                                    .pop();
                                                if (selectedOption == 'Teen') {
                                                  navigatorKey.currentState!
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AddTeenScreen(),
                                                  ));
                                                }
                                              },
                                            ),
                                            const Gap(10),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                            },
                          );
                        },
                      ),
                      const Gap(10)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
