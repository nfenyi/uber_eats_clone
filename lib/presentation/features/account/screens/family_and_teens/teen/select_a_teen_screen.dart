import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/family_and_teens/family_profile_modal.dart';

import '../../../../../constants/app_sizes.dart';

class SelectATeenScreen extends StatelessWidget {
  const SelectATeenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> _teens = [];

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: AppSizes.horizontalPaddingSmall),
            child: GestureDetector(
                onTap: () => showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return Container(
                            height: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: const FamilyProfileModal());
                      },
                    ),
                child: const Icon(Icons.person_add)),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Select a teen',
                  weight: FontWeight.bold,
                  size: AppSizes.heading4,
                ),
                if (_teens.isNotEmpty)
                  const AppTextFormField(
                    hintText: 'Search name or number',
                    prefixIcon: Icon(Icons.search),
                  ),
              ],
            ),
          ),
          const Gap(20),
          Expanded(
            child: Visibility(
                replacement: Transform.translate(
                    offset: const Offset(0, -60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AssetNames.noContactQuestionMark,
                                  width: 60,
                                ),
                                const AppText(
                                  text: 'No contacts',
                                  weight: FontWeight.bold,
                                  size: AppSizes.bodySmall,
                                ),
                                const Gap(10),
                                const AppText(
                                  textAlign: TextAlign.center,
                                  text:
                                      "Looks like you have no contacts in your device's address book.",
                                  color: AppColors.neutral500,
                                  // size: AppSizes.bodySmall,
                                ),
                                const Gap(10),
                                AppButton(
                                  text: 'New contact',
                                  width: 130,
                                  height: 40,
                                  icon: const Icon(
                                    Icons.person_add,
                                    size: 18,
                                  ),
                                  callback: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                            height: double.infinity,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
                                            child: const FamilyProfileModal());
                                      },
                                    );
                                  },
                                  borderRadius: 50,
                                  isSecondary: true,
                                  iconFirst: true,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                visible: _teens.isNotEmpty,
                child: const Column(
                  children: [Placeholder()],
                )),
          )
        ],
      ),
    );
  }
}
