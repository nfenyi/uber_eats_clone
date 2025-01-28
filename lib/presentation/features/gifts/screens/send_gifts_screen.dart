import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';

import '../../../core/app_colors.dart';

class SendGiftsScreen extends ConsumerStatefulWidget {
  const SendGiftsScreen({super.key});

  @override
  ConsumerState<SendGiftsScreen> createState() => _SendGiftsState();
}

class _SendGiftsState extends ConsumerState<SendGiftsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                AssetNames.sendGifts,
              ),
              InkWell(
                onTap: navigatorKey.currentState!.pop,
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    Icons.close,
                    weight: 6,
                  ),
                ),
              )
            ],
          ),
          const Gap(20),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppText(
              text: 'Send gifts on Uber',
              size: AppSizes.heading2,
              weight: FontWeight.w600,
            ),
          ),
          const Gap(10),
          const ListTile(
            leading: Iconify(Ic.outline_maps_home_work),
            title: AppText(
              text: 'Set recipient address',
              weight: FontWeight.w600,
              size: AppSizes.body,
            ),
            subtitle: AppText(
              text:
                  'Then browse the best local gifts based on their delivery location.',
              color: AppColors.neutral500,
            ),
          ),
          const ListTile(
            leading: Iconify(Ic.outline_maps_home_work),
            title: AppText(
              text: 'Customize sharing link',
              weight: FontWeight.w600,
              size: AppSizes.body,
            ),
            subtitle: AppText(
              text: 'Add a personalized video message or note.',
              color: AppColors.neutral500,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.edit),
            title: AppText(
              text: 'Share with recipient',
              weight: FontWeight.w600,
              size: AppSizes.body,
            ),
            subtitle: AppText(
              text:
                  'Send the special link to let them know a gift is on the way.',
              color: AppColors.neutral500,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppButton(
              text: 'Browse gifts',
              callback: () {
                navigatorKey.currentState!.pop();
                ref.read(bottomNavIndexProvider.notifier).showGiftScreen();
              },
            ),
          ),
          const Gap(15)
        ],
      )),
    );
  }
}
