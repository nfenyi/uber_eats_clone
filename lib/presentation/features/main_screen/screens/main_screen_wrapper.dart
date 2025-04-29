import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uber_eats_clone/main.dart';

import '../../../../app_functions.dart';
import '../../../../state/user_location_providers.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import 'main_screen.dart';

class MainScreenWrapper extends ConsumerStatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainScreenWrapperScreenState();
}

class _MainScreenWrapperScreenState extends ConsumerState<MainScreenWrapper> {
  Future<bool> _fetchStoredUserLocation() async {
    Map? storedUserInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    if (storedUserInfo == null) {
      await AppFunctions.getOnlineUserInfo();
    }

    await ref
        .read(userCurrentGeoLocationProvider.notifier)
        .getCurrentGeoLocation();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchStoredUserLocation(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return ShowCaseWidget(builder: (context) {
              return const MainScreen();
            });
          }
          return Scaffold(
            backgroundColor: snapshot.hasError
                ? Colors.white
                : const Color.fromARGB(255, 3, 189, 106),
            body: SafeArea(
              child: Builder(builder: (context) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText(
                          text: snapshot.error.toString(),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LinearProgressIndicator(
                        color: AppColors.neutral600,
                        backgroundColor: AppColors.neutral300,
                      ),
                      Image.asset(
                        AssetNames.appLogo,
                        width: Adaptive.w(40),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                    ],
                  );
                }
              }),
            ),
          );
        });
  }
}
