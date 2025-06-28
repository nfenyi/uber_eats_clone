import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../../utils/result.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../sign_in/sign_in_screen.dart';
import 'get_started_view_model.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> {
  final viewModel = GetStartedViewModel();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white54, // Color for this screen
        statusBarIconBrightness: Brightness.dark, // Icon brightness
      ),
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                Expanded(
                  child: Image.asset(
                    AssetNames.getStarted,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Get started with Uber Eats',
                    style: TextStyle(
                        fontSize: AppSizes.heading6,
                        fontWeight: FontWeight.w600),
                  ),
                  const Gap(10),
                  AppButton(
                    isLoading: viewModel.isLoading,
                    buttonColor: AppColors.primary2,
                    text: "Continue",
                    textSize: AppSizes.bodySmall,
                    callback: () async {
                      final result = await viewModel.getStarted();
                      if (result is RError) {
                        await showAppInfoDialog(navigatorKey.currentContext!,
                            description: result.errorMessage);
                      } else {
                        await navigatorKey.currentState!.pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
