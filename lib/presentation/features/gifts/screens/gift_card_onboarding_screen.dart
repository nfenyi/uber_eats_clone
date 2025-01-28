import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_card_screen.dart';

import '../../../../main.dart';

class GiftCardOnboardingScreen extends StatelessWidget {
  const GiftCardOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      children: [
        Image.asset(
          AssetNames.giftCardOnboarding,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                leading: Icon(
                  FontAwesomeIcons.gift,
                  size: 15,
                ),
                title: AppText(
                  text: 'Personalize your gift',
                  size: AppSizes.bodySmall,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.mail,
                  size: 15,
                ),
                title: AppText(
                  text: 'Send via message or email',
                  size: AppSizes.bodySmall,
                ),
              ),
              const ListTile(
                leading: Iconify(
                  Bx.heart_square,
                  size: 15,
                ),
                title: AppText(
                  text: 'Gifts can be used for Uber rides or Eats orders',
                  size: AppSizes.bodySmall,
                ),
              ),
              const Gap(40),
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: AppButton(
                  callback: () {
                    navigatorKey.currentState!.pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const GiftCardScreen(),
                            settings:
                                const RouteSettings(name: '/giftCardScreen')));
                  },
                  borderRadius: 50,
                  width: 120,
                  height: 40,
                  text: 'Get started',
                  icon: const Icon(
                    FontAwesomeIcons.arrowRight,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    )));
  }
}
