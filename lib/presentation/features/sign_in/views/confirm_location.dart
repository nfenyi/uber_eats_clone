import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../core/app_colors.dart';

class ConfirmLocationScreen extends ConsumerStatefulWidget {
  const ConfirmLocationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmLocationState();
}

class _ConfirmLocationState extends ConsumerState<ConfirmLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Adaptive.h(70),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: AppColors.neutral300,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: InkWell(
                      onTap: () => navigatorKey.currentState!.pop(),
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Gap(20),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Confirm delivery address',
                          size: AppSizes.heading6,
                        ),
                        Gap(10),
                        AppText(
                            text:
                                'Move the pin to highlight the correct door or entrance to help drivers deliver orders faster.'),
                      ],
                    ),
                    Column(
                      children: [AppButton(text: 'Confirm Location'), Gap(10)],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
