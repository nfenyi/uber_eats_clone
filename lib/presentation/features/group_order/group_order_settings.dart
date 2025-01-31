import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../main.dart';
import '../../constants/app_sizes.dart';
import '../../constants/asset_names.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/widgets.dart';
import '../home/home_screen.dart';
import 'group_order_complete_screen.dart';
import 'group_order_name_screen.dart';
import 'order_deadline_screen.dart';
import 'payment_screen.dart';
import 'repeat_group_order_screen.dart';

class GroupOrderSettings extends StatefulWidget {
  final Store store;
  const GroupOrderSettings({required this.store, super.key});

  @override
  State<GroupOrderSettings> createState() => _GroupOrderSettingsState();
}

class _GroupOrderSettingsState extends State<GroupOrderSettings> {
  bool _isAutomatic = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => navigatorKey.currentState!.pop,
            child: const Icon(Icons.close)),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: AppSizes.horizontalPaddingSmall),
            child: GestureDetector(
                onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                // horizontal:
                                AppSizes.horizontalPaddingSmall),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                    child: AppText(
                                  text: 'Create group order',
                                  size: AppSizes.body,
                                  weight: FontWeight.w600,
                                )),
                                const Gap(5),
                                const Divider(),
                                const Gap(15),
                                const AppText(
                                    text:
                                        'Customize your group order settings. Then invite people to join with a link.'),
                                const Gap(15),
                                AppButton(
                                  text: 'Got it',
                                  callback: () =>
                                      navigatorKey.currentState!.pop(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                child: const Icon(Icons.help)),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              AssetNames.groupOrder,
              width: 300,
            ),
          ),
          ListTile(
            title: const AppText(
              text: "Nana's group order",
              size: AppSizes.heading3,
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
            child: AppText(text: 'From ${widget.store.name}'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppText(text: 'Deliver to 1226 University Dr'),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                Tooltip(
                  // triggerMode: TooltipTriggerMode.manual,
                  message: _isAutomatic
                      ? 'This order will be placed automatically at the deadline'
                      : null,
                  child: ListTile(
                    leading: const Icon(Icons.watch_later, size: 20),
                    title: const AppText(
                      text: "People can order at any time",
                      size: AppSizes.body,
                    ),
                    subtitle: const AppText(
                      text: 'No deadline set',
                      color: AppColors.neutral500,
                    ),
                    trailing: GestureDetector(
                      onTap: () =>
                          navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const OrderDeadlineScreen(),
                      )),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.moneyBill, size: 20),
                  title: const AppText(
                    text: "You pay for everyone",
                    size: AppSizes.body,
                  ),
                  subtitle: const AppText(
                    text: 'No spending limit',
                    color: AppColors.neutral500,
                  ),
                  trailing: GestureDetector(
                    onTap: () =>
                        navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const GroupOrderPaymentScreen(),
                    )),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.neutral500,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.refresh, size: 20),
                  title: const AppText(
                    text: "Does not repeat",
                    size: AppSizes.body,
                  ),
                  subtitle: const AppText(
                    text:
                        'Set as a repeat group order to place recurring times',
                    color: AppColors.neutral500,
                  ),
                  trailing: GestureDetector(
                    onTap: () =>
                        navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const RepeatGroupOrderScreen(),
                    )),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.neutral500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        AppButton(
            callback: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) =>
                      GroupOrderCompleteScreen(widget.store)));
            },
            text: 'Invite guests')
      ],
    );
  }
}
