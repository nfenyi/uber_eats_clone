import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/terms_and_privace_notice_screen.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  size: AppSizes.heading5,
                  text: "What's your name?",
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                const AppText(
                  size: AppSizes.body,
                  text: 'Let us know how to properly address you',
                ),
                const Gap(30),
                const RequiredText('First name'),
                const Gap(10),
                AppTextFormField(
                  hintText: 'Enter your first name',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const Gap(15),
                const RequiredText('Last name'),
                const Gap(10),
                AppTextFormField(
                  hintText: 'Enter your last name',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                )
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      onTap: () => navigatorKey.currentState!.pop(),
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.bodySmallest),
                          decoration: const BoxDecoration(
                            color: AppColors.neutral200,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.arrowLeft,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap:
                          // _emailController.text.isEmpty
                          //     ? null
                          //     :
                          () =>
                              navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const TermsNPrivacyNoticeScreen(),
                      )),
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.bodySmallest),
                          decoration: const BoxDecoration(
                              color: AppColors.neutral200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: const Row(
                            children: [
                              Text('Next'),
                              Gap(5),
                              Icon(
                                FontAwesomeIcons.arrowRight,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(10)
              ],
            )
          ],
        ),
      ),
    );
  }
}
