import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/hive_adapters/cart_item/cart_item_model.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/order/order_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:collection/collection.dart';
import '../../../app_functions.dart';
import '../../../models/group_order/group_order_model.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/widgets.dart';
import '../../services/sign_in_view_model.dart';
import '../address/screens/addresses_screen.dart';
import 'group_order_complete_screen.dart';

class GroupOrderScreen extends ConsumerStatefulWidget {
  final GroupOrder groupOrder;
  final Store store;
  const GroupOrderScreen({
    super.key,
    required this.groupOrder,
    required this.store,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderScreenState();
}

class _GroupOrderScreenState extends ConsumerState<GroupOrderScreen> {
  late final Store _store;
  late final GroupOrder _groupOrder;
  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isSkipping = false;

  @override
  void initState() {
    super.initState();
    _store = widget.store;
    _groupOrder = widget.groupOrder;
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
            child: Row(
              children: [
                GestureDetector(
                    //TODO:implement member view screen. here you can delete orders
                    onTap: () =>
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => GroupOrderCompleteScreen(
                            store: widget.store,
                            groupOrder: _groupOrder,
                          ),
                        )),
                    child: const Icon(Icons.group_outlined)),
                const Gap(10),
                // if (_groupOrder.ownerId ==
                //     FirebaseAuth.instance.currentUser!.uid)
                //   GestureDetector(
                //       onTap: () async => await showModalBottomSheet(
                //           isScrollControlled: true,
                //           useSafeArea: true,
                //           barrierColor: Colors.transparent,
                //           context: navigatorKey.currentContext!,
                //           builder: (context) =>
                //               ShowCaseWidget(builder: (context) {
                //                 return GroupOrderSettingsScreen(
                //                   store: _store,
                //                 );
                //               })),
                //       child: const Icon(
                //         Icons.settings,
                //       )),i
              ],
            ),
          )
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: widget.groupOrder.name,
                size: AppSizes.heading5,
                weight: FontWeight.w600,
              ),
              const Gap(5),
              Row(
                children: [
                  const Icon(
                    Icons.store,
                    size: 20,
                  ),
                  const Gap(5),
                  AppText(
                    text: 'From ${_store.name}',
                  )
                ],
              ),
              const Gap(5),
              Row(
                children: [
                  const Icon(
                    Icons.pin_drop_outlined,
                    size: 20,
                  ),
                  const Gap(5),
                  AppText(text: 'Deliver to ${_groupOrder.placeDescription}')
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.person_2_outlined,
                    size: 20,
                  ),
                  const Gap(5),
                  FutureBuilder<String>(
                      future: _getGroupOwner(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Skeletonizer(
                              child: AppText(text: 'mkamklaljlljl'));
                        } else if (snapshot.hasError) {
                          return AppText(text: snapshot.error.toString());
                        }

                        return AppText(text: 'Created by ${snapshot.data!}');
                      })
                ],
              ),
              const Gap(5),
              if (_groupOrder.frequency != null)
                Row(
                  children: [
                    const Icon(
                      Icons.refresh,
                      size: 20,
                    ),
                    const Gap(5),
                    AppText(
                        text:
                            "${_groupOrder.frequency}, ${AppFunctions.formatDate(_groupOrder.firstOrderSchedule.toString(), format: 'g:i A')} - ${AppFunctions.formatDate(_groupOrder.firstOrderSchedule!.add(const Duration(minutes: 30)).toString(), format: 'g:i A')}")
                  ],
                ),
              const Gap(5),
            ],
          ),
        ),
        const Divider(
          thickness: 4,
        ),
        const Gap(5),
        Expanded(
          child: FutureBuilder<List<OrderSchedule>>(
              future: _getOrderSchedules(_groupOrder.orderScheduleRefs),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final orderSchedules = snapshot.data!;
                  return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final orderSchedule = orderSchedules[index];
                        final isUpNext =
                            orderSchedule.orderDate.difference(DateTime.now()) <
                                const Duration(days: 7);
                        if (orderSchedule.skippedBy.contains(_userId)) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              child: AppText(
                                text: isUpNext ? "Up next" : 'Coming soon',
                                size: AppSizes.heading6,
                                weight: FontWeight.w600,
                              ),
                            ),
                            const Gap(10),
                            ValueListenableBuilder(
                                valueListenable:
                                    Hive.box<HiveCartItem>(AppBoxes.carts)
                                        .listenable(keys: [_store.name]),
                                builder: (context, cartsBox, child) {
                                  Map<dynamic, dynamic> userInfo =
                                      Hive.box(AppBoxes.appState)
                                          .get(BoxKeys.userInfo);
                                  final String displayName =
                                      userInfo['displayName'];
                                  final partitionedOrderItems = groupBy(
                                      orderSchedule.orderItems,
                                      (orderItem) =>
                                          orderItem.person == displayName);

                                  var personalOrderItem =
                                      partitionedOrderItems[true] ?? [];
                                  final otherOrderItems =
                                      partitionedOrderItems[false] ?? [];
                                  final personalCartItem =
                                      cartsBox.get(_store.id);
                                  if (personalCartItem != null) {
                                    personalOrderItem = [
                                      GroupOrderItem(
                                          person: _userId,
                                          productsAndQuantities: {})
                                    ];
                                  }
                                  return ListTile(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: double.infinity,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    AppBar(
                                                      actions: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              navigatorKey
                                                                  .currentState!
                                                                  .push(
                                                                      MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        GroupOrderCompleteScreen(
                                                                  store: widget
                                                                      .store,
                                                                  groupOrder:
                                                                      _groupOrder,
                                                                ),
                                                              ));
                                                            },
                                                            child: const Icon(Icons
                                                                .person_add_alt_1)),
                                                        const Gap(10),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              right: AppSizes
                                                                  .horizontalPaddingSmall),
                                                          child:
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child:
                                                                              ListTile(
                                                                            onTap:
                                                                                () async {
                                                                              if (_groupOrder.orderScheduleRefs.isEmpty) {
                                                                                await _deleteGroupOrder();
                                                                              } else {
                                                                                final lastScheduleRef = _groupOrder.orderScheduleRefs.last as DocumentReference;
                                                                                final lastSchedule = await AppFunctions.loadOrderScheduleReference(lastScheduleRef);
                                                                                if (lastSchedule.deliveryDate == null || lastSchedule.deliveryDate!.isBefore(DateTime.now())) {
                                                                                  await _deleteGroupOrder();
                                                                                } else {
                                                                                  showInfoToast('Please try again when the most recent schedule has been fulfilled.', context: navigatorKey.currentContext);
                                                                                }
                                                                              }
                                                                            },
                                                                            leading:
                                                                                Icon(
                                                                              Icons.delete,
                                                                              color: Colors.red.shade900,
                                                                            ),
                                                                            title:
                                                                                const AppText(
                                                                              text: 'Delete group order',
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .more_horiz)),
                                                        )
                                                      ],
                                                      leading: GestureDetector(
                                                          onTap: () =>
                                                              navigatorKey
                                                                  .currentState!
                                                                  .pop(),
                                                          child: const Icon(
                                                              Icons.clear)),
                                                    ),
                                                    SingleChildScrollView(
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: AppSizes
                                                                .horizontalPaddingSmall),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AppText(
                                                              text: _groupOrder
                                                                  .name,
                                                              weight: FontWeight
                                                                  .w600,
                                                              size: AppSizes
                                                                  .heading5,
                                                            ),
                                                            const Gap(15),
                                                            Row(
                                                              children: [
                                                                const AppText(
                                                                    text:
                                                                        'From '),
                                                                AppText(
                                                                  text: _store
                                                                      .name,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ],
                                                            ),
                                                            AppText(
                                                                text:
                                                                    'Deliver by ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: r'D, M j')} at ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: 'g:i A')} to ${_groupOrder.placeDescription}'),
                                                            const Gap(10),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                              decoration: const BoxDecoration(
                                                                  color: AppColors
                                                                      .neutral100),
                                                              child: ListTile(
                                                                trailing: GestureDetector(
                                                                    onTap:
                                                                        () {},
                                                                    child: const Icon(
                                                                        Icons
                                                                            .edit)),
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                leading:
                                                                    const Icon(
                                                                  Icons
                                                                      .watch_later,
                                                                ),
                                                                title: AppText(
                                                                  text:
                                                                      'Everyone must order by ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: r'M j')} at ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: r'g:i A')}',
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                  // size: AppSizes.bodySmall,
                                                                ),
                                                              ),
                                                            ),
                                                            const Gap(20),
                                                            const AppText(
                                                              text:
                                                                  'Your items',
                                                              size: AppSizes
                                                                  .bodySmall,
                                                              weight: FontWeight
                                                                  .w600,
                                                            ),
                                                            const Gap(10),
                                                            Theme(
                                                              data: Theme.of(
                                                                      context)
                                                                  .copyWith(
                                                                      dividerColor:
                                                                          Colors
                                                                              .transparent),
                                                              child:
                                                                  ExpansionTile(
                                                                tilePadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                title: AppText(
                                                                    weight:
                                                                        FontWeight
                                                                            .w600,
                                                                    text:
                                                                        '${personalOrderItem.first.person} (You)'),
                                                                subtitle: AppText(
                                                                    text:
                                                                        "${personalOrderItem.first.productsAndQuantities.length.toString()} ${personalOrderItem.first.productsAndQuantities.length == 1 ? 'item' : 'items'}"),
                                                                leading:
                                                                    ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                50),
                                                                        child: Image
                                                                            .asset(
                                                                          AssetNames
                                                                              .groupOrderItemLeading,
                                                                          width:
                                                                              30,
                                                                        )),
                                                                children: [
                                                                  // ListView.separated(
                                                                  //     physics: const NeverScrollableScrollPhysics(),
                                                                  //     shrinkWrap: true,
                                                                  //     itemBuilder: (context, index) {
                                                                  //       final productNQuantity = personalOrderItem
                                                                  //           .first
                                                                  //           .productsAndQuantities
                                                                  //           .entries
                                                                  //           .elementAt(index);
                                                                  //       return ListTile(
                                                                  //         subtitle: productNQuantity.key.options != null
                                                                  //             ? Column(
                                                                  //                 mainAxisSize: MainAxisSize.min,
                                                                  //                 children: [
                                                                  //                   ListView.builder(
                                                                  //                     itemBuilder: (context, index) {
                                                                  //                       final option = productNQuantity.key.options![index];
                                                                  //                       return Column(
                                                                  //                         children: [
                                                                  //                           AppText(text: 'Item !: ${option.name}'),
                                                                  //                           if (option.subOptions != null)
                                                                  //                             AppText(
                                                                  //                               text: option.subOptions!.first.name,
                                                                  //                               color: AppColors.neutral500,
                                                                  //                             ),
                                                                  //                         ],
                                                                  //                       );
                                                                  //                     },
                                                                  //                     itemCount: productNQuantity.key.options!.length,
                                                                  //                   )
                                                                  //                 ],
                                                                  //               )
                                                                  //             : null,
                                                                  //         leading:
                                                                  //             Container(
                                                                  //           padding:
                                                                  //               const EdgeInsets.all(5),
                                                                  //           color:
                                                                  //               AppColors.neutral100,
                                                                  //           child:
                                                                  //               AppText(text: productNQuantity.value.toString()),
                                                                  //         ),
                                                                  //         title:
                                                                  //             AppText(
                                                                  //           text:
                                                                  //               productNQuantity.key.name,
                                                                  //           weight:
                                                                  //               FontWeight.w600,
                                                                  //           size:
                                                                  //               AppSizes.bodySmaller,
                                                                  //         ),
                                                                  //         contentPadding: const EdgeInsets
                                                                  //             .only(
                                                                  //             left: 50),
                                                                  //         trailing:
                                                                  //             Column(
                                                                  //           mainAxisAlignment:
                                                                  //               MainAxisAlignment.start,
                                                                  //           mainAxisSize:
                                                                  //               MainAxisSize.min,
                                                                  //           children: [
                                                                  //             AppText(color: AppColors.neutral600, text: 'US\$${((productNQuantity.key.promoPrice ?? productNQuantity.key.initialPrice) * productNQuantity.value).toStringAsFixed(2)}'),
                                                                  //           ],
                                                                  //         ),
                                                                  //       );
                                                                  //     },
                                                                  //     separatorBuilder: (context, index) => const Divider(),
                                                                  //     itemCount: personalOrderItem.first.productsAndQuantities.length)
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(),
                                                            const Gap(5),
                                                            const AppText(
                                                                text:
                                                                    'Others in the group',
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                                size: AppSizes
                                                                    .bodySmall),
                                                            AppText(
                                                                text:
                                                                    '${orderSchedule.orderItems.length} of ${_groupOrder.persons.length} people have added items'),
                                                            ListView.builder(
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final otherOrderItem =
                                                                    otherOrderItems[
                                                                        index];
                                                                return ExpansionTile(
                                                                  tilePadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  title: AppText(
                                                                      weight: FontWeight
                                                                          .w600,
                                                                      text:
                                                                          '${otherOrderItem.person} (You)'),
                                                                  subtitle: AppText(
                                                                      text:
                                                                          "${otherOrderItem.productsAndQuantities.length.toString()} ${otherOrderItem.productsAndQuantities.length == 1 ? 'item' : 'items'}"),
                                                                  leading:
                                                                      ClipRRect(
                                                                          borderRadius: BorderRadius.circular(
                                                                              50),
                                                                          child:
                                                                              Image.asset(
                                                                            AssetNames.fastFoodBNW,
                                                                            width:
                                                                                30,
                                                                          )),
                                                                  children: [
                                                                    // ListView.separated(
                                                                    //     physics:
                                                                    //         const NeverScrollableScrollPhysics(),
                                                                    //     shrinkWrap: true,
                                                                    //     itemBuilder:
                                                                    //         (context, index) {
                                                                    //       final productNQuantity =
                                                                    //           otherOrderItem
                                                                    //               .productsAndQuantities
                                                                    //               .entries
                                                                    //               .elementAt(
                                                                    //                   index);
                                                                    //       return ListTile(
                                                                    //         subtitle:
                                                                    //             productNQuantity
                                                                    //                         .key
                                                                    //                         .options !=
                                                                    //                     null
                                                                    //                 ? Column(
                                                                    //                     mainAxisSize:
                                                                    //                         MainAxisSize.min,
                                                                    //                     children: [
                                                                    //                       ListView.builder(
                                                                    //                         itemBuilder: (context, index) {
                                                                    //                           final option = productNQuantity.key.options![index];
                                                                    //                           return Column(
                                                                    //                             children: [
                                                                    //                               AppText(text: 'Item !: ${option.name}'),
                                                                    //                               if (option.subOptions != null)
                                                                    //                                 AppText(
                                                                    //                                   text: option.subOptions!.first.name,
                                                                    //                                   color: AppColors.neutral500,
                                                                    //                                 ),
                                                                    //                             ],
                                                                    //                           );
                                                                    //                         },
                                                                    //                         itemCount: productNQuantity.key.options!.length,
                                                                    //                       )
                                                                    //                     ],
                                                                    //                   )
                                                                    //                 : null,
                                                                    //         leading:
                                                                    //             Container(
                                                                    //           padding:
                                                                    //               const EdgeInsets
                                                                    //                   .all(5),
                                                                    //           color: AppColors
                                                                    //               .neutral100,
                                                                    //           child: AppText(
                                                                    //               text: productNQuantity
                                                                    //                   .value
                                                                    //                   .toString()),
                                                                    //         ),
                                                                    //         title: AppText(
                                                                    //           text:
                                                                    //               productNQuantity
                                                                    //                   .key
                                                                    //                   .name,
                                                                    //           weight:
                                                                    //               FontWeight
                                                                    //                   .w600,
                                                                    //           size: AppSizes
                                                                    //               .bodySmaller,
                                                                    //         ),
                                                                    //         contentPadding:
                                                                    //             const EdgeInsets
                                                                    //                 .only(
                                                                    //                 left: 50),
                                                                    //         trailing: Column(
                                                                    //           mainAxisAlignment:
                                                                    //               MainAxisAlignment
                                                                    //                   .start,
                                                                    //           mainAxisSize:
                                                                    //               MainAxisSize
                                                                    //                   .min,
                                                                    //           children: [
                                                                    //             AppText(
                                                                    //                 color: AppColors
                                                                    //                     .neutral600,
                                                                    //                 text:
                                                                    //                     'US\$${((productNQuantity.key.promoPrice ?? productNQuantity.key.initialPrice) * productNQuantity.value).toStringAsFixed(2)}'),
                                                                    //           ],
                                                                    //         ),
                                                                    //       );
                                                                    //     },
                                                                    //     separatorBuilder:
                                                                    //         (context,
                                                                    //                 index) =>
                                                                    //             const Divider(),
                                                                    //     itemCount: otherOrderItem
                                                                    //         .productsAndQuantities
                                                                    //         .length),

                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        //TODO: Implement removal of person
                                                                      },
                                                                      child:
                                                                          Ink(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.delete_outline,
                                                                              color: Colors.red.shade900,
                                                                            ),
                                                                            const AppText(text: ' Remove person'),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                              itemCount:
                                                                  otherOrderItems
                                                                      .length,
                                                            ),
                                                            const Divider(),
                                                            ListTile(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              title:
                                                                  const AppText(
                                                                text:
                                                                    'Subtotal',
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                                size: AppSizes
                                                                    .bodySmall,
                                                              ),
                                                              trailing: AppText(
                                                                  size: AppSizes
                                                                      .bodySmall,
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                  text:
                                                                      'US\$ ${orderSchedule.totalFee.toStringAsFixed(2)}'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: AppSizes
                                                          .horizontalPaddingSmall),
                                                  child: Column(
                                                    children: [
                                                      AppButton(
                                                          callback: () {},
                                                          text:
                                                              'Go to checkout'),
                                                      const Gap(10),
                                                      AppButton(
                                                        text: 'Add items',
                                                        isSecondary: true,
                                                        callback: () {},
                                                      ),
                                                      const Gap(20),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Stack(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: _store.cardImage,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            color: Colors.black38,
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
                                    trailing: isUpNext
                                        ? const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: AppColors.neutral500,
                                          )
                                        : AppButton2(
                                            text: _isSkipping
                                                ? 'Skipping...'
                                                : 'Skip',
                                            callback: _isSkipping
                                                ? null
                                                : () async {
                                                    setState(() {
                                                      _isSkipping = true;
                                                    });
                                                    final orderScheduleRef =
                                                        _groupOrder.orderScheduleRefs[
                                                                index]
                                                            as DocumentReference;
                                                    await orderScheduleRef
                                                        .update({
                                                      'skippedBy':
                                                          FieldValue.arrayUnion(
                                                              [_userId])
                                                    });
                                                    setState(() {
                                                      _isSkipping = false;
                                                    });
                                                  }),
                                    title: AppText(
                                      text: AppFunctions.formatDate(
                                          orderSchedule.orderDate.toString(),
                                          format: r'D, M j'),
                                      weight: FontWeight.w600,
                                    ),
                                    subtitle: isUpNext
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                size: AppSizes.bodySmallest,
                                                text:
                                                    '${orderSchedule.orderItems.length} items • US\$${orderSchedule.totalFee.toStringAsFixed(2)}',
                                              ),
                                              AppText(
                                                size: AppSizes.bodySmallest,
                                                text:
                                                    'Edit by ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: r'n/j g:i A')}',
                                                color: Colors.green,
                                              ),
                                            ],
                                          )
                                        : _groupOrder.frequency != null
                                            ? AppText(
                                                size: AppSizes.bodySmallest,
                                                text:
                                                    'Add items starting ${AppFunctions.formatDate(orderSchedule.orderDate.toString())}',
                                              )
                                            : const SizedBox.shrink(),
                                  );
                                }),
                            //TODO: implement this better
                            if (index == 1 - 1)
                              const Divider(
                                indent: 70,
                              )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                            thickness: 4,
                          ),
                      itemCount: orderSchedules.length);
                } else if (snapshot.hasError) {
                  AppText(
                    text: snapshot.error.toString(),
                  );
                }
                return const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }),
        ),
      ]),
    );
  }

  Future<void> _deleteGroupOrder() async {
    navigatorKey.currentState!.pop();
    showInfoToast('Deleting your group order. This will take a few seconds.',
        context: context);
    for (var orderSchedule in _groupOrder.orderScheduleRefs) {
      final orderAsDocRef = orderSchedule as DocumentReference;
      await orderAsDocRef.delete();
    }

    await FirebaseFirestore.instance
        .collection(FirestoreCollections.groupOrders)
        .doc(_groupOrder.id)
        .delete();
  }

  Future<String> _getGroupOwner() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(_groupOrder.ownerId)
        .get();
    if (snapshot.exists && snapshot.data()!.isNotEmpty) {
      return snapshot.data()!['displayName'];
    } else {
      return 'User not found';
    }
  }

  // Future<void> _makeGroupOrderQueries() async {
  //   // for (var groupOrderPath in widget.groupOrderPaths) {
  //   //   var groupOrderSnapshot =
  //   //       await FirebaseFirestore.instance.doc(groupOrderPath).get();
  //   //   _groupOrders.add(GroupOrder.fromJson(groupOrderSnapshot.data()!));
  //   // }
  //   // for (var groupOrder in _groupOrders) {
  //   //   if (groupOrder.frequency != null &&
  //   //       groupOrder.orderScheduleRefs
  //   //           .where(
  //   //             (element) => element.deliveryDate.isAfter(DateTime.now()),
  //   //           )
  //   //           .isEmpty) {
  //   //     //calculating next delivery date
  //   //     final dateTimeNow = DateTime.now();
  //   //     DateTime? nextDeliveryDate;
  //   //     groupOrder.frequency!.startsWith('Daily')
  //   //         ? nextDeliveryDate = dateTimeNow.add(const Duration(days: 1))
  //   //         : groupOrder.frequency!.startsWith('Every weekday')
  //   //             ? (dateTimeNow.weekday != DateTime.sunday ||
  //   //                     dateTimeNow.weekday != DateTime.saturday)
  //   //                 ? nextDeliveryDate =
  //   //                     dateTimeNow.add(const Duration(days: 1))
  //   //                 : nextDeliveryDate = null
  //   //             : groupOrder.frequency!.startsWith('Weekly')
  //   //                 ? nextDeliveryDate =
  //   //                     dateTimeNow.add(const Duration(days: 7))
  //   //                 : groupOrder.frequency!.startsWith('Bi-weekly')
  //   //                     ? nextDeliveryDate =
  //   //                         dateTimeNow.add(const Duration(days: 14))
  //   //                     : nextDeliveryDate =
  //   //                         dateTimeNow.add(const Duration(days: 30));
  //   //     if (nextDeliveryDate != null) {
  //   //       final weekday = groupOrder.firstOrderSchedule!.weekday;
  //   //       while (nextDeliveryDate!.weekday != weekday) {
  //   //         nextDeliveryDate = nextDeliveryDate.add(const Duration(days: 1));
  //   //       }
  //   //       final newOrderSchedule = OrderSchedule(
  //   //         deliveryDate: nextDeliveryDate,
  //   //         storeRef: groupOrder.storeRefs.first,
  //   //         orderNumber: const Uuid().v7(),
  //   //         orderItems: [],
  //   //         status: 'Processing',
  //   //       );
  //   //       final groupOrderSnapshot = await FirebaseFirestore.instance
  //   //           .collection(FirestoreCollections.groupOrders)
  //   //           .doc(groupOrder.id)
  //   //           .update({
  //   //         'orderSchedules': FieldValue.arrayUnion([newOrderSchedule])
  //   //       });
  //   //     }
  //   //   }
  //   // }
  // }

  Future<List<OrderSchedule>> _getOrderSchedules(
      List<Object> orderScheduleRefs) async {
    List<OrderSchedule> orderSchedules = [];
    for (var ref in orderScheduleRefs) {
      final json =
          await AppFunctions.loadDocReference(ref as DocumentReference);
      orderSchedules.add(OrderSchedule.fromJson(json));
    }
    return orderSchedules;
  }
}
