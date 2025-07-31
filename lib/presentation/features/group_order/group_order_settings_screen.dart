import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/models/group_order/group_order_model.dart';
import 'package:uber_eats_clone/models/order/order_model.dart';
import 'package:uuid/uuid.dart';

import '../../../main.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../constants/asset_names.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/widgets.dart';
import '../../services/sign_in_view_model.dart';
import 'group_order_complete_screen.dart';
import 'group_order_name_screen.dart';
import 'order_deadline_screen.dart';
import 'order_payment_screen.dart';
import 'repeat_group_order_screen.dart';

class GroupOrderSettingsScreen extends StatefulWidget {
  final Store store;
  const GroupOrderSettingsScreen({required this.store, super.key});

  @override
  State<GroupOrderSettingsScreen> createState() =>
      _GroupOrderSettingsScreenState();
}

class _GroupOrderSettingsScreenState extends State<GroupOrderSettingsScreen> {
  late String _displayName;
  late final Map _userInfo;
  late String _userPlaceDescription;
  late String _groupOrderName;
  DateTime? _orderByDeadline;
  String _orderPlacementSetting = 'Remind me to place the order';
  String _whoPays = "You pay for everyone";
  String _spendingLimit = '';

  String? _frequency;

  DateTime? _firstOrderSchedule;
  DateTime? _endDate;

  final _automaticShowCaseNotice = GlobalKey();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    _displayName = _userInfo['displayName'];

    _userPlaceDescription =
        _userInfo['selectedAddress']['placeDescription'].split(',').first;
    _groupOrderName = "${_displayName.split(' ').first}'s group order";
    _orderPlacementSetting = 'Remind me to place the order';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => navigatorKey.currentState!.pop(),
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
                                  size: AppSizes.bodySmall,
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
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    var temp =
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) =>
                          GroupOrderNameScreen(_groupOrderName),
                    ));
                    if (temp != null) {
                      setState(() {
                        _groupOrderName = temp;
                      });
                    }
                  },
                  child: Ink(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          text: _groupOrderName,
                          size: AppSizes.heading5,
                        ),
                        const Gap(5),
                        const Icon(
                          Icons.edit,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: "From ",
                      style: const TextStyle(
                          fontFamily: 'UberMove',
                          color: AppColors.neutral500,
                          fontSize: AppSizes.bodySmaller),
                      children: [
                        TextSpan(
                          text: widget.store.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ]),
                ),
                const Gap(5),
                RichText(
                  text: TextSpan(
                      text: 'Deliver to ',
                      style: const TextStyle(
                          fontFamily: 'UberMove',
                          color: AppColors.neutral500,
                          fontSize: AppSizes.bodySmaller),
                      children: [
                        TextSpan(
                          text: _userPlaceDescription,
                          style: const TextStyle(color: Colors.black),
                        ),
                        if (_firstOrderSchedule != null)
                          TextSpan(
                              style: const TextStyle(color: Colors.black),
                              text:
                                  ' on ${AppFunctions.formatDate(_firstOrderSchedule.toString(), format: 'l, M d • g:i A')} - ${AppFunctions.formatDate(_firstOrderSchedule!.add(const Duration(minutes: 30)).toString(), format: 'g:i A')}'),
                      ]),
                ),

                // Row(
                //   children: [
                //     const AppText(
                //       text: 'Deliver to ',
                //       color: AppColors.neutral500,
                //     ),
                //     AppText(text: _userPlaceDescription),
                //   ],
                // ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                ListTile(
                  onTap: () async {
                    var temp =
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => OrderDeadlineScreen(
                        firstOrderSchedule: _firstOrderSchedule,
                        setDeadline: _orderByDeadline,
                        orderPlacementSetting: _orderPlacementSetting,
                      ),
                    ));
                    if (temp != null) {
                      setState(() {
                        _orderByDeadline = temp['setDeadline'];
                        _orderPlacementSetting = temp['orderPlacementSetting'];
                      });
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_orderPlacementSetting ==
                          'Automatically place the order') {
                        ShowCaseWidget.of(context)
                            .startShowCase([_automaticShowCaseNotice]);
                      }
                    });
                    // Automatically dismiss the showcase after 2 seconds
                    Future.delayed(const Duration(seconds: 3), () {
                      if (context.mounted) {
                        //check if the widget is still in the tree
                        ShowCaseWidget.of(context).dismiss();
                      }
                    });
                  },
                  leading: const Icon(Icons.watch_later, size: 20),
                  title: AppText(
                    text: _firstOrderSchedule == null
                        ? _orderByDeadline == null
                            ? 'People can order at any time'
                            : 'Order by ${AppFunctions.formatDate(_orderByDeadline.toString(), format: 'D, M j, g:i A')}'
                        : 'Order 1 hour before delivery time',
                    size: AppSizes.bodySmall,
                  ),
                  subtitle: Builder(builder: (context) {
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   if (_orderPlacementSetting != null) {
                    //     ShowCaseWidget.of(context)
                    //         .startShowCase([_automaticShowCaseNotice]);
                    //     // Future.delayed(const Duration(seconds: 2), () {
                    //     //   if (context.mounted) {
                    //     //     ShowCaseWidget.of(context).dismiss();
                    //     //   }
                    //     // });
                    //   }
                    // });
                    return Showcase(
                      overlayOpacity: 0,
                      key: _automaticShowCaseNotice,
                      tooltipBorderRadius: BorderRadius.circular(5),
                      disableMovingAnimation: true,
                      textColor: Colors.white,
                      tooltipBackgroundColor: Colors.black87,
                      // decoration: const BoxDecoration(color: Colors.black45),
                      // triggerMode: TooltipTriggerMode.manual,
                      description:
                          'This order will be placed automatically at the deadline',

                      child: AppText(
                        text: _orderByDeadline == null
                            ? 'No deadline set'
                            : _orderPlacementSetting,
                        color: AppColors.neutral500,
                      ),
                    );
                  }),
                  trailing: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.black38,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    Map? temp =
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => GroupOrderPaymentScreen(
                        spendingLimit: _spendingLimit,
                        whoPays: _whoPays,
                      ),
                    ));
                    if (temp != null) {
                      setState(() {
                        _whoPays = temp['whoPays'];
                        _spendingLimit = temp['spendingLimit'];
                      });
                    }
                  },
                  leading: const Iconify(Ph.money_bold, size: 20),
                  title: AppText(
                    text: _whoPays,
                    size: AppSizes.bodySmall,
                  ),
                  subtitle: AppText(
                    text: _whoPays == 'You pay for everyone'
                        ? _spendingLimit.isEmpty
                            ? 'No spending limit'
                            : '\$$_spendingLimit spending limit per person'
                        : 'Up to 18 people',
                    color: AppColors.neutral500,
                  ),
                  trailing: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.black38,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    var temp =
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => RepeatGroupOrderScreen(
                        endDate: _endDate,
                        frequency: _frequency,
                        orderByDeadline: _orderByDeadline,
                      ),
                    ));
                    if (temp != null) {
                      setState(() {
                        _frequency = temp['frequency'];
                        _endDate = temp['endDate'];
                        _firstOrderSchedule = temp['firstOrderSchedule'];
                      });
                    }
                  },
                  leading: const Icon(Icons.refresh, size: 20),
                  title: AppText(
                    text: _frequency == null ? "Does not repeat" : _frequency!,
                    size: AppSizes.bodySmall,
                  ),
                  subtitle: AppText(
                    text: _firstOrderSchedule == null
                        ? 'Set as a repeat group order to place recurring times'
                        : '${AppFunctions.formatDate(_firstOrderSchedule.toString(), format: 'g:i A')} - ${AppFunctions.formatDate(_firstOrderSchedule!.add(const Duration(minutes: 30)).toString(), format: 'g:i A')}\nStarts ${AppFunctions.formatDate(_firstOrderSchedule.toString(), format: 'n/j/Y')}${_endDate == null ? '. No end date' : '. Ends ${AppFunctions.formatDate(_endDate.toString(), format: 'n/j/Y')}'}',
                    color: AppColors.neutral500,
                  ),
                  trailing: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        AppButton(
            isLoading: _isLoading,
            callback: () async {
              setState(() {
                _isLoading = true;
              });
              try {
                var groupOrderId = '${widget.store.id}${const Uuid().v4()}';
                final List<DocumentReference> orderScheduleRefs = [];
                final matchingStores = await FirebaseFirestore.instance
                    .collection(FirestoreCollections.stores)
                    .where('id', isEqualTo: widget.store.id)
                    .get();
                if (_frequency != null) {
                  String orderNumber = Random().nextInt(4294967296).toString();
                  final firstOrderSchedule = OrderSchedule(
                    orderItems: [],
                    storeRef: matchingStores.docs.first.reference,
                    orderDate: _firstOrderSchedule!,
                    orderNumber: orderNumber,
                  );
                  final scheduleRef = FirebaseFirestore.instance
                      .collection(FirestoreCollections.orderSchedules)
                      .doc(orderNumber);
                  await scheduleRef.set(firstOrderSchedule.toJson());
                  orderScheduleRefs.add(scheduleRef);
                }

                var currentUser = FirebaseAuth.instance.currentUser!;

                var groupOrder = GroupOrder(
                    createdAt: DateTime.now(),
                    //TODO: may have to add applied promos and chosen payment method here

                    orderScheduleRefs: orderScheduleRefs,
                    id: groupOrderId,
                    endDate: _endDate,
                    firstOrderSchedule: _firstOrderSchedule,
                    frequency: _frequency,
                    placeDescription: _userPlaceDescription,
                    name: _groupOrderName,
                    orderByDeadline:
                        _orderByDeadline == null && _firstOrderSchedule != null
                            ? _firstOrderSchedule!.add(const Duration(hours: 2))
                            : _orderByDeadline,
                    orderPlacementSetting: _orderPlacementSetting,
                    ownerId: currentUser.uid,
                    spendingLimit: double.tryParse(_spendingLimit),
                    storeRef: matchingStores.docs.first.reference,
                    persons: [
                      GroupOrderPerson(
                          id: currentUser.uid, name: currentUser.displayName!)
                    ],
                    whoPays: _whoPays);
                await FirebaseFirestore.instance
                    .collection(FirestoreCollections.groupOrders)
                    .doc(groupOrderId)
                    .set(groupOrder.toJson());

                await FirebaseFirestore.instance
                    .collection(FirestoreCollections.users)
                    .doc(currentUser.uid)
                    .update({
                  'groupOrders': FieldValue.arrayUnion([groupOrderId])
                });
                await AppFunctions.getOnlineUserInfo();

                await navigatorKey.currentState!
                    .pushReplacement(MaterialPageRoute(
                        builder: (context) => GroupOrderInvitationScreen(
                              store: widget.store,
                              groupOrder: groupOrder,
                            )));
              } on Exception catch (e) {
                await showAppInfoDialog(navigatorKey.currentContext!,
                    description: e.toString());
              }
              setState(() {
                _isLoading = true;
              });
            },
            text: 'Invite guests')
      ],
    );
  }
}
