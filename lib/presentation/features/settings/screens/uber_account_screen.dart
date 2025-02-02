import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/name_edit_screen.dart';

import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';

class UberAccountScreen extends StatelessWidget {
  final bool _isVerified = true;

  const UberAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Uber Account',
          size: AppSizes.body,
        ),
      ),
      body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                isScrollable: true,
                tabs: [
                  AppText(
                    text: 'Account Info',
                    size: AppSizes.bodySmall,
                  ),
                  AppText(
                    text: 'Security',
                    size: AppSizes.bodySmall,
                  ),
                  AppText(
                    text: 'Privacy & Data',
                    size: AppSizes.bodySmall,
                  ),
                ],
                tabAlignment: TabAlignment.start,
              ),
              Expanded(
                  child: TabBarView(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: AppText(
                        text: 'Account Info',
                        weight: FontWeight.w600,
                        size: AppSizes.heading4,
                      ),
                    ),
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  gradient: const RadialGradient(stops: [
                                    0.6,
                                    1.0
                                  ], colors: [
                                    Colors.white,
                                    AppColors.neutral200,
                                  ]),
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(0, -8),
                                child: Image.asset(
                                  AssetNames.noProfilePic,
                                  width: 55,
                                ),
                              ),
                            ],
                          ),
                          Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: AppColors.neutral200,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                    const Gap(30),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: AppText(
                        text: 'Basic Info',
                        weight: FontWeight.w600,
                        size: AppSizes.heading6,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const NameEditScreen(),
                        ));
                      },
                      title: const AppText(
                        text: 'Name',
                        size: AppSizes.bodySmall,
                        weight: FontWeight.w600,
                      ),
                      subtitle: const AppText(text: 'Nana Fenyi'),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.neutral500,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: const AppText(
                        text: 'Phone number',
                        size: AppSizes.bodySmall,
                        weight: FontWeight.w600,
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.neutral500,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: const AppText(
                        text: 'Email',
                        size: AppSizes.bodySmall,
                        weight: FontWeight.w600,
                      ),
                      subtitle: Row(
                        children: [
                          const AppText(text: 'nanafenyim@gmail.com'),
                          if (_isVerified)
                            const Row(
                              children: [
                                Gap(5),
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Colors.green,
                                ),
                              ],
                            )
                        ],
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
                const Column(),
                const Column()
              ]))
            ],
          )),
    );
  }
}
