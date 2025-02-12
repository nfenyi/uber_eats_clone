import 'package:country_ip/country_ip.dart' show CountryIp;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../../models/country/country_ip_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../sign_in/sign_in_screen.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      fontSize: AppSizes.heading5, fontWeight: FontWeight.w600),
                ),
                const Gap(10),
                AppButton(
                  isLoading: _isLoading,
                  buttonColor: AppColors.primary2,
                  text: "Continue",
                  textSize: AppSizes.bodySmall,
                  callback: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final countryResponse = await CountryIp.find();

                    await Hive.box(AppBoxes.appState).put('onboarded', true);
                    await Hive.box(AppBoxes.appState).put(
                        'country',
                        HiveCountryResponse(
                            ip: countryResponse?.ip,
                            code: countryResponse?.countryCode,
                            country: countryResponse?.country));
                    navigatorKey.currentState!.pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
