import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/features/group_order/group_order_complete_screen.dart';
import 'package:uber_eats_clone/presentation/features/group_order/order_deadline_screen.dart';
import 'package:uber_eats_clone/presentation/features/group_order/payment_screen.dart';
import 'package:uber_eats_clone/presentation/features/group_order/repeat_group_order_screen.dart';

import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/widgets.dart';
import '../home/home_screen.dart';
import 'group_order_name_screen.dart';

class GroupOrderScreen extends ConsumerStatefulWidget {
  final Store store;
  const GroupOrderScreen(this.store, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderScreenState();
}

class _GroupOrderScreenState extends ConsumerState<GroupOrderScreen> {
  bool _isAutomatic = true;
  List<String> _groupOrders = ['hia'];

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _groupOrders.isEmpty,
      replacement: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () => navigatorKey.currentState!.pop(),
              child: const Icon(Icons.close)),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(right: AppSizes.horizontalPaddingSmall),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () =>
                          navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) =>
                                GroupOrderScreen(widget.store),
                          )),
                      child: const Icon(Icons.group_add)),
                  const Gap(10),
                  GestureDetector(
                      onTap: () =>
                          navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) =>
                                GroupOrderScreen(widget.store),
                          )),
                      child: const Icon(Icons.settings)),
                ],
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const AppText(
              text: "Nana's group order",
              size: AppSizes.heading5,
              weight: FontWeight.w600,
            ),
            const Gap(5),
            const Row(
              children: [
                Icon(
                  Icons.store,
                  size: 20,
                ),
                Gap(5),
                AppText(text: "From McDonald's (Menlo Park)")
              ],
            ),
            const Gap(5),
            const Row(
              children: [
                Icon(
                  Icons.pin_drop_outlined,
                  size: 20,
                ),
                Gap(5),
                AppText(text: "Deliver to 1226 University Dr")
              ],
            ),
            const Gap(5),
            const Row(
              children: [
                Icon(
                  Icons.store,
                  size: 20,
                ),
                Gap(5),
                AppText(text: "Monthly on first _ _ _")
              ],
            ),
            const Gap(5),
            const Divider(
              thickness: 4,
            ),
            const Gap(5),
            const AppText(
              text: "Up next",
              size: AppSizes.heading5,
              weight: FontWeight.w600,
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.store.cardImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.black12,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.group_outlined,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Wed,May 1',
                        ),
                        AppText(
                          text: '0 items',
                        ),
                        AppText(
                          text: 'Edit by 5/1 8:00 AM',
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.keyboard_arrow_right)
              ],
            ),
            const Divider(
              indent: 70,
            )
          ]),
        ),
      ),
      child: Scaffold(
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
                size: AppSizes.heading5,
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
      ),
    );
  }
}
