import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';

import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_card_screen.dart';

import '../../../../main.dart';

class GiftCardOnboardingScreen extends StatelessWidget {
  const GiftCardOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
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
                  leading: Iconify(
                    Bi.gift_fill,
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
                  child: TextButton(
                      onPressed: () {
                        navigatorKey.currentState!.pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const GiftCardScreen(),
                                settings: const RouteSettings(
                                    name: '/giftCardScreen')));
                        Hive.box(AppBoxes.appState)
                            .put(BoxKeys.isOnboardedToUberGifts, true);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        backgroundColor: Colors.black,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            text: 'Get started',
                            color: Colors.white,
                          ),
                          Gap(10),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
