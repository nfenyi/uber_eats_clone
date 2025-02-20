import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/features/group_order/order_deadline_screen.dart';
import 'package:uber_eats_clone/presentation/features/group_order/payment_screen.dart';
import 'package:uber_eats_clone/presentation/features/group_order/repeat_group_order_screen.dart';

import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/widgets.dart';
import '../home/home_screen.dart';
import 'group_order_name_screen.dart';

class GroupOrderCompleteScreen extends ConsumerStatefulWidget {
  final Store store;
  const GroupOrderCompleteScreen(this.store, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderCompleteScreenState();
}

class _GroupOrderCompleteScreenState
    extends ConsumerState<GroupOrderCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: navigatorKey.currentState!.pop,
            child: const Icon(Icons.close)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              AssetNames.groupOrderComplete,
              width: 300,
            ),
          ),
          ListTile(
            title: const AppText(
              text: "Repeat group order scheduled",
              size: AppSizes.heading6,
            ),
            trailing: GestureDetector(
              onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const GroupOrderNameScreen(),
              )),
              child: const Icon(
                Icons.edit,
                color: AppColors.neutral500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppText(
                text:
                    'You can invite guests by sharing a link below. Make changes or cancel this repeat order from your cart.'),
          ),
        ],
      ),
      persistentFooterButtons: [
        AppButton(callback: () {}, text: 'Invite guests')
      ],
    );
  }
}
