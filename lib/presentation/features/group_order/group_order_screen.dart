import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/order/order_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:collection/collection.dart';
import 'package:uber_eats_clone/presentation/features/group_order/group_order_settings_screen.dart';
import 'package:uuid/uuid.dart';
import '../../../app_functions.dart';
import '../../../models/group_order/group_order_model.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/widgets.dart';
import '../../services/sign_in_view_model.dart';

class GroupOrderScreen extends ConsumerStatefulWidget {
  final Iterable<String> groupOrderPaths;

  final Store store;
  const GroupOrderScreen({
    required this.store,
    super.key,
    required this.groupOrderPaths,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderScreenState();
}

class _GroupOrderScreenState extends ConsumerState<GroupOrderScreen> {
  late final Store _store;
  final List<GroupOrder> _groupOrders = [];

  @override
  void initState() {
    super.initState();
    _store = widget.store;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _makeGroupOrderQueries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                    onTap: () => navigatorKey.currentState!.pop(),
                    child: const Icon(Icons.close)),
              ),
              body: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                    onTap: () => navigatorKey.currentState!.pop(),
                    child: const Icon(Icons.close)),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: AppText(text: snapshot.error.toString()),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                  onTap: () => navigatorKey.currentState!.pop(),
                  child: const Icon(Icons.close)),
              actions: (_groupOrders.first.storeIds.length == 1)
                  ? [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: AppSizes.horizontalPaddingSmall),
                        child: Row(
                          children: [
                            GestureDetector(
                                //TODO:implement member view screen. here you can delete orders
                                // onTap: () =>
                                //     navigatorKey.currentState!.push(MaterialPageRoute(
                                //       builder: (context) => GroupOrderCompleteScreen(groupOrder:

                                //               widget.groupOrder!),
                                //     )),
                                child: const Icon(Icons.group_outlined)),
                            const Gap(10),
                            GestureDetector(
                                onTap: () => navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          GroupOrderSettingsScreen(
                                              store: _store),
                                    )),
                                child: const Icon(Icons.settings)),
                          ],
                        ),
                      )
                    ]
                  : null,
            ),
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: _groupOrders.first.name!,
                            size: AppSizes.heading3,
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
                                  text: _groupOrders.first.storeIds.length == 1
                                      ? 'From ${_store.name}'
                                      : '${_groupOrders.first.storeIds.length} available stores')
                            ],
                          ),
                          const Gap(5),
                          if (_groupOrders.first.storeIds.length == 1)
                            Row(
                              children: [
                                const Icon(
                                  Icons.pin_drop_outlined,
                                  size: 20,
                                ),
                                const Gap(5),
                                AppText(
                                    text:
                                        'Deliver to ${_groupOrders.first.location!}')
                              ],
                            ),
                          if (_groupOrders.first.storeIds.length != 1)
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
                                            child: AppText(text: 'mkamklal'));
                                      } else if (snapshot.hasData) {
                                        return AppText(
                                            text: snapshot.error.toString());
                                      }

                                      return AppText(
                                          text:
                                              'Created by ${snapshot.data!.split(' ').first}');
                                    })
                              ],
                            ),
                          const Gap(5),
                          if (_groupOrders.first.frequency != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.refresh,
                                  size: 20,
                                ),
                                const Gap(5),
                                AppText(
                                    text:
                                        "${_groupOrders.first.frequency}, ${AppFunctions.formatDate(_groupOrders.first.firstOrderSchedule.toString(), format: 'g:i A')} - ${AppFunctions.formatDate(_groupOrders.first.firstOrderSchedule!.add(const Duration(minutes: 30)).toString(), format: 'g:i A')}")
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
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final orderSchedule =
                              _groupOrders.first.orderSchedules[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                child: AppText(
                                  text: orderSchedule.deliveryDate
                                              .difference(DateTime.now()) <
                                          const Duration(days: 7)
                                      ? "Up next"
                                      : 'Coming soon',
                                  size: AppSizes.heading6,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              const Gap(10),
                              ListTile(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    context: context,
                                    builder: (context) {
                                      final partitionedOrderItems = groupBy(
                                          orderSchedule.orderItems,
                                          (orderItem) =>
                                              orderItem?.person == 'Nana');

                                      final personalOrderItem =
                                          partitionedOrderItems[true] ?? [];
                                      final otherOrderItems =
                                          partitionedOrderItems[false] ?? [];
                                      return Container(
                                        height: double.infinity,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                AppBar(
                                                  actions: [
                                                    GestureDetector(
                                                        // onTap: () {
                                                        //   navigatorKey.currentState!
                                                        //       .push(MaterialPageRoute(
                                                        //     builder: (context) =>
                                                        //         GroupOrderCompleteScreen(
                                                        //             orderSchedule.store),
                                                        //   ));
                                                        // },
                                                        child: const Icon(Icons
                                                            .person_add_alt_1)),
                                                    const Gap(10),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          right: AppSizes
                                                              .horizontalPaddingSmall),
                                                      child: GestureDetector(
                                                          onTap: () {},
                                                          child: const Icon(
                                                              Icons
                                                                  .more_horiz)),
                                                    )
                                                  ],
                                                  leading: GestureDetector(
                                                      onTap: () => navigatorKey
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
                                                          text: _groupOrders
                                                              .first.name!,
                                                          weight:
                                                              FontWeight.w600,
                                                          size:
                                                              AppSizes.heading4,
                                                        ),
                                                        const Gap(15),
                                                        Row(
                                                          children: [
                                                            const AppText(
                                                                text: 'From '),
                                                            AppText(
                                                              text: _store.name,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ],
                                                        ),
                                                        AppText(
                                                            text:
                                                                'Deliver by ${AppFunctions.formatDate(orderSchedule.deliveryDate.toString(), format: r'D, M j')} at ${AppFunctions.formatDate(orderSchedule.deliveryDate.toString(), format: 'g:i A')} to ${_groupOrders.first.location}'),
                                                        const Gap(10),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 10),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: AppColors
                                                                      .neutral100),
                                                          child: ListTile(
                                                            trailing: GestureDetector(
                                                                onTap: () {},
                                                                child: const Icon(
                                                                    Icons
                                                                        .edit)),
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            leading: const Icon(
                                                              Icons.watch_later,
                                                            ),
                                                            title: AppText(
                                                              text:
                                                                  'Everyone must order by ${AppFunctions.formatDate(orderSchedule.deliveryDate.subtract(const Duration(minutes: 90)).toString(), format: r'M j')} at ${AppFunctions.formatDate(orderSchedule.deliveryDate.subtract(const Duration(minutes: 90)).toString(), format: r'g:i A')}',
                                                              weight: FontWeight
                                                                  .w600,
                                                              // size: AppSizes.bodySmall,
                                                            ),
                                                          ),
                                                        ),
                                                        const Gap(20),
                                                        const AppText(
                                                          text: 'Your items',
                                                          size: AppSizes
                                                              .bodySmall,
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                        const Gap(10),
                                                        if (personalOrderItem
                                                            .isNotEmpty)
                                                          ExpansionTile(
                                                            tilePadding:
                                                                EdgeInsets.zero,
                                                            title: AppText(
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                                text:
                                                                    '${personalOrderItem.first.person} (You)'),
                                                            subtitle: AppText(
                                                                text:
                                                                    "${personalOrderItem.first.productsAndQuantities.length.toString()} ${personalOrderItem.first.productsAndQuantities.length == 1 ? 'item' : 'items'}"),
                                                            leading: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                child:
                                                                    Image.asset(
                                                                  AssetNames
                                                                      .fastFoodBNW,
                                                                  width: 30,
                                                                )),
                                                            children: const [
                                                              // ListView.separated(
                                                              //     physics:
                                                              //         const NeverScrollableScrollPhysics(),
                                                              //     shrinkWrap: true,
                                                              //     itemBuilder:
                                                              //         (context, index) {
                                                              //       final productNQuantity =
                                                              //           personalOrderItem
                                                              //               .first
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
                                                              //                       ListView
                                                              //                           .builder(
                                                              //                         itemBuilder:
                                                              //                             (context, index) {
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
                                                              //                         itemCount:
                                                              //                             productNQuantity.key.options!.length,
                                                              //                       )
                                                              //                     ],
                                                              //                   )
                                                              //                 : null,
                                                              //         leading: Container(
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
                                                              //                   .key.name,
                                                              //           weight: FontWeight
                                                              //               .w600,
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
                                                              //         (context, index) =>
                                                              //             const Divider(),
                                                              //     itemCount: personalOrderItem
                                                              //         .first
                                                              //         .productsAndQuantities
                                                              //         .length)
                                                            ],
                                                          ),
                                                        const Divider(),
                                                        const Gap(5),
                                                        const AppText(
                                                            text:
                                                                'Others in the group',
                                                            weight:
                                                                FontWeight.w600,
                                                            size: AppSizes
                                                                .bodySmall),
                                                        AppText(
                                                            text:
                                                                '${orderSchedule.orderItems.length} of ${_groupOrders.first.persons.length} people have added items'),
                                                        ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final otherOrderItem =
                                                                otherOrderItems[
                                                                    index];
                                                            return ExpansionTile(
                                                              tilePadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              title: AppText(
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                  text:
                                                                      '${otherOrderItem.person} (You)'),
                                                              subtitle: AppText(
                                                                  text:
                                                                      "${otherOrderItem.productsAndQuantities.length.toString()} ${otherOrderItem.productsAndQuantities.length == 1 ? 'item' : 'items'}"),
                                                              leading:
                                                                  ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50),
                                                                      child: Image
                                                                          .asset(
                                                                        AssetNames
                                                                            .fastFoodBNW,
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
                                                                  onTap: () {
                                                                    //TODO: Implement removal of person
                                                                  },
                                                                  child: Ink(
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .delete_outline,
                                                                          color: Colors
                                                                              .red
                                                                              .shade900,
                                                                        ),
                                                                        const AppText(
                                                                            text:
                                                                                ' Remove person'),
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
                                                              EdgeInsets.zero,
                                                          title: const AppText(
                                                            text: 'Subtotal',
                                                            weight:
                                                                FontWeight.w600,
                                                            size: AppSizes
                                                                .bodySmall,
                                                          ),
                                                          trailing: AppText(
                                                              size: AppSizes
                                                                  .bodySmall,
                                                              weight: FontWeight
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
                                                      text: 'Go to checkout'),
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
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: AppColors.neutral500,
                                ),
                                title: AppText(
                                  text: AppFunctions.formatDate(
                                      orderSchedule.deliveryDate.toString(),
                                      format: r'D, M j'),
                                  weight: FontWeight.w600,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text:
                                          '${orderSchedule.orderItems.length} items • US\$${orderSchedule.totalFee.toStringAsFixed(2)}',
                                    ),
                                    AppText(
                                      text:
                                          'Edit by ${AppFunctions.formatDate(orderSchedule.deliveryDate.subtract(const Duration(minutes: 90)).toString(), format: r'n/j g:i A')}',
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
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
                        itemCount: _groupOrders.first.orderSchedules.length),
                  ]),
            ),
          );
        });
  }

  Future<String> _getGroupOwner() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(_groupOrders.first.ownerId)
        .get();
    if (snapshot.exists && snapshot.data()!.isNotEmpty) {
      return snapshot.data()!['displayName'];
    } else {
      return 'User not found';
    }
  }

  Future<void> _makeGroupOrderQueries() async {
    for (var groupOrderPath in widget.groupOrderPaths) {
      var groupOrderSnapshot =
          await FirebaseFirestore.instance.doc(groupOrderPath).get();
      _groupOrders.add(GroupOrder.fromJson(groupOrderSnapshot.data()!));
    }
    for (var groupOrder in _groupOrders) {
      if (groupOrder.frequency != null &&
          groupOrder.orderSchedules
              .where(
                (element) => element.deliveryDate.isAfter(DateTime.now()),
              )
              .isEmpty) {
        //calculating next delivery date
        final dateTimeNow = DateTime.now();
        DateTime? nextDeliveryDate;
        groupOrder.frequency!.startsWith('Daily')
            ? nextDeliveryDate = dateTimeNow.add(const Duration(days: 1))
            : groupOrder.frequency!.startsWith('Every weekday')
                ? (dateTimeNow.weekday != DateTime.sunday ||
                        dateTimeNow.weekday != DateTime.saturday)
                    ? nextDeliveryDate =
                        dateTimeNow.add(const Duration(days: 1))
                    : nextDeliveryDate = null
                : groupOrder.frequency!.startsWith('Weekly')
                    ? nextDeliveryDate =
                        dateTimeNow.add(const Duration(days: 7))
                    : groupOrder.frequency!.startsWith('Bi-weekly')
                        ? nextDeliveryDate =
                            dateTimeNow.add(const Duration(days: 14))
                        : nextDeliveryDate =
                            dateTimeNow.add(const Duration(days: 30));
        if (nextDeliveryDate != null) {
          final weekday = groupOrder.firstOrderSchedule!.weekday;
          while (nextDeliveryDate!.weekday != weekday) {
            nextDeliveryDate = nextDeliveryDate.add(const Duration(days: 1));
          }
          final newOrderSchedule = OrderSchedule(
            deliveryDate: nextDeliveryDate,
            storeId: groupOrder.storeIds.first,
            orderNumber: const Uuid().v7(),
            orderItems: [],
            status: 'Processing',
          );
          final groupOrderSnapshot = await FirebaseFirestore.instance
              .collection(FirestoreCollections.groupOrders)
              .doc(groupOrder.id)
              .update({
            'orderSchedules': FieldValue.arrayUnion([newOrderSchedule])
          });
        }
      }
    }
  }
}
