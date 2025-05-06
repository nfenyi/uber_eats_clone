import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/order/order_model.dart';
import '../../../app_functions.dart';
import '../../../models/group_order/group_order_model.dart';
import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../services/sign_in_view_model.dart';

class GroupOrdersByUserScreen extends ConsumerStatefulWidget {
  final List<GroupOrder> groupOrders;

  const GroupOrdersByUserScreen({
    super.key,
    required this.groupOrders,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderByUserScreenState();
}

class _GroupOrderByUserScreenState
    extends ConsumerState<GroupOrdersByUserScreen> {
  final List<GroupOrder> _groupOrders = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _makeGroupOrderQueries(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                  onTap: () => navigatorKey.currentState!.pop(),
                  child: const Icon(Icons.close)),
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
                            text:
                                '${_groupOrders.first.placeDescription} Group Orders',
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
                                  text:
                                      '${_groupOrders.length} available stores')
                            ],
                          ),
                          const Gap(5),
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
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 4,
                    ),
                    const Gap(5),
                    FutureBuilder<List<OrderSchedule>>(
                        future: _getOrderSchedules(_groupOrders),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final orderSchedules = snapshot.data!;
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final orderSchedule = orderSchedules[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        child: AppText(
                                          text: AppFunctions.formatDate(
                                              orderSchedule.orderDate
                                                  .toString(),
                                              format: 'D, M j'),
                                          size: AppSizes.heading6,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                      const Gap(10),
                                      FutureBuilder(
                                          future:
                                              AppFunctions.loadStoreReference(
                                                  orderSchedule.storeRef
                                                      as DocumentReference),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final store = snapshot.data!;
                                              return ListTile(
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppText(
                                                        text:
                                                            '${orderSchedule.orderItems.length} items • US\$${orderSchedule.totalFee.toStringAsFixed(2)}',
                                                      ),
                                                      AppText(
                                                        text:
                                                            'Edit by ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: r'n/j g:i A')}',
                                                        color: Colors.green,
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    //TODO: lift from other group order screen
                                                    // showModalBottomSheet(
                                                    //   isScrollControlled: true,
                                                    //   useSafeArea: true,
                                                    //   context: context,
                                                    //   builder: (context) {
                                                    //     final partitionedOrderItems =
                                                    //         groupBy(
                                                    //             orderSchedule.orderItems,
                                                    //             (orderItem) =>
                                                    //                 orderItem.person ==
                                                    //                 'Nana');

                                                    //     final personalOrderItem =
                                                    //         partitionedOrderItems[true] ??
                                                    //             [];
                                                    //     final otherOrderItems =
                                                    //         partitionedOrderItems[
                                                    //                 false] ??
                                                    //             [];
                                                    //     return Container(
                                                    //       height: double.infinity,
                                                    //       decoration: const BoxDecoration(
                                                    //           color: Colors.white,
                                                    //           borderRadius:
                                                    //               BorderRadius.only(
                                                    //                   topLeft: Radius
                                                    //                       .circular(10),
                                                    //                   topRight:
                                                    //                       Radius.circular(
                                                    //                           10))),
                                                    //       child: Column(
                                                    //         mainAxisAlignment:
                                                    //             MainAxisAlignment
                                                    //                 .spaceBetween,
                                                    //         crossAxisAlignment:
                                                    //             CrossAxisAlignment.start,
                                                    //         children: [
                                                    //           Column(
                                                    //             children: [
                                                    //               AppBar(
                                                    //                 actions: [
                                                    //                   GestureDetector(
                                                    //                       // onTap: () {
                                                    //                       //   navigatorKey.currentState!
                                                    //                       //       .push(MaterialPageRoute(
                                                    //                       //     builder: (context) =>
                                                    //                       //         GroupOrderCompleteScreen(
                                                    //                       //             orderSchedule.store),
                                                    //                       //   ));
                                                    //                       // },
                                                    //                       child: const Icon(
                                                    //                           Icons
                                                    //                               .person_add_alt_1)),
                                                    //                   const Gap(10),
                                                    //                   Padding(
                                                    //                     padding: const EdgeInsets
                                                    //                         .only(
                                                    //                         right: AppSizes
                                                    //                             .horizontalPaddingSmall),
                                                    //                     child: GestureDetector(
                                                    //                         onTap: () {},
                                                    //                         child: const Icon(
                                                    //                             Icons
                                                    //                                 .more_horiz)),
                                                    //                   )
                                                    //                 ],
                                                    //                 leading: GestureDetector(
                                                    //                     onTap: () =>
                                                    //                         navigatorKey
                                                    //                             .currentState!
                                                    //                             .pop(),
                                                    //                     child: const Icon(
                                                    //                         Icons.clear)),
                                                    //               ),
                                                    //               SingleChildScrollView(
                                                    //                 child: Padding(
                                                    //                   padding:
                                                    //                       const EdgeInsets
                                                    //                           .symmetric(
                                                    //                           horizontal:
                                                    //                               AppSizes
                                                    //                                   .horizontalPaddingSmall),
                                                    //                   child: Column(
                                                    //                     crossAxisAlignment:
                                                    //                         CrossAxisAlignment
                                                    //                             .start,
                                                    //                     children: [
                                                    //                       AppText(
                                                    //                         text:
                                                    //                             _groupOrders
                                                    //                                 .first
                                                    //                                 .name,
                                                    //                         weight:
                                                    //                             FontWeight
                                                    //                                 .w600,
                                                    //                         size: AppSizes
                                                    //                             .heading4,
                                                    //                       ),
                                                    //                       const Gap(15),
                                                    //                       Row(
                                                    //                         children: [
                                                    //                           const AppText(
                                                    //                               text:
                                                    //                                   'From '),
                                                    //                           AppText(
                                                    //                             text: _store
                                                    //                                 .name,
                                                    //                             color: Colors
                                                    //                                 .green,
                                                    //                           ),
                                                    //                         ],
                                                    //                       ),
                                                    //                       AppText(
                                                    //                           text:
                                                    //                               'Deliver by ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: r'D, M j')} at ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: 'g:i A')} to ${_groupOrders.first.placeDescription}'),
                                                    //                       const Gap(10),
                                                    //                       Container(
                                                    //                         padding: const EdgeInsets
                                                    //                             .symmetric(
                                                    //                             horizontal:
                                                    //                                 15,
                                                    //                             vertical:
                                                    //                                 10),
                                                    //                         decoration:
                                                    //                             const BoxDecoration(
                                                    //                                 color:
                                                    //                                     AppColors.neutral100),
                                                    //                         child:
                                                    //                             ListTile(
                                                    //                           trailing: GestureDetector(
                                                    //                               onTap:
                                                    //                                   () {},
                                                    //                               child: const Icon(
                                                    //                                   Icons.edit)),
                                                    //                           contentPadding:
                                                    //                               EdgeInsets
                                                    //                                   .zero,
                                                    //                           leading:
                                                    //                               const Icon(
                                                    //                             Icons
                                                    //                                 .watch_later,
                                                    //                           ),
                                                    //                           title:
                                                    //                               AppText(
                                                    //                             text:
                                                    //                                 'Everyone must order by ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: r'M j')} at ${AppFunctions.formatDate(orderSchedule.orderDate.toString(), format: r'g:i A')}',
                                                    //                             weight: FontWeight
                                                    //                                 .w600,
                                                    //                             // size: AppSizes.bodySmall,
                                                    //                           ),
                                                    //                         ),
                                                    //                       ),
                                                    //                       const Gap(20),
                                                    //                       const AppText(
                                                    //                         text:
                                                    //                             'Your items',
                                                    //                         size: AppSizes
                                                    //                             .bodySmall,
                                                    //                         weight:
                                                    //                             FontWeight
                                                    //                                 .w600,
                                                    //                       ),
                                                    //                       const Gap(10),
                                                    //                       if (personalOrderItem
                                                    //                           .isNotEmpty)
                                                    //                         ExpansionTile(
                                                    //                           tilePadding:
                                                    //                               EdgeInsets
                                                    //                                   .zero,
                                                    //                           title: AppText(
                                                    //                               weight: FontWeight
                                                    //                                   .w600,
                                                    //                               text:
                                                    //                                   '${personalOrderItem.first.person} (You)'),
                                                    //                           subtitle:
                                                    //                               AppText(
                                                    //                                   text:
                                                    //                                       "${personalOrderItem.first.productsAndQuantities.length.toString()} ${personalOrderItem.first.productsAndQuantities.length == 1 ? 'item' : 'items'}"),
                                                    //                           leading: ClipRRect(
                                                    //                               borderRadius: BorderRadius.circular(50),
                                                    //                               child: Image.asset(
                                                    //                                 AssetNames
                                                    //                                     .fastFoodBNW,
                                                    //                                 width:
                                                    //                                     30,
                                                    //                               )),
                                                    //                           children: const [
                                                    //                             // ListView.separated(
                                                    //                             //     physics:
                                                    //                             //         const NeverScrollableScrollPhysics(),
                                                    //                             //     shrinkWrap: true,
                                                    //                             //     itemBuilder:
                                                    //                             //         (context, index) {
                                                    //                             //       final productNQuantity =
                                                    //                             //           personalOrderItem
                                                    //                             //               .first
                                                    //                             //               .productsAndQuantities
                                                    //                             //               .entries
                                                    //                             //               .elementAt(
                                                    //                             //                   index);
                                                    //                             //       return ListTile(
                                                    //                             //         subtitle:
                                                    //                             //             productNQuantity
                                                    //                             //                         .key
                                                    //                             //                         .options !=
                                                    //                             //                     null
                                                    //                             //                 ? Column(
                                                    //                             //                     mainAxisSize:
                                                    //                             //                         MainAxisSize.min,
                                                    //                             //                     children: [
                                                    //                             //                       ListView
                                                    //                             //                           .builder(
                                                    //                             //                         itemBuilder:
                                                    //                             //                             (context, index) {
                                                    //                             //                           final option = productNQuantity.key.options![index];
                                                    //                             //                           return Column(
                                                    //                             //                             children: [
                                                    //                             //                               AppText(text: 'Item !: ${option.name}'),
                                                    //                             //                               if (option.subOptions != null)
                                                    //                             //                                 AppText(
                                                    //                             //                                   text: option.subOptions!.first.name,
                                                    //                             //                                   color: AppColors.neutral500,
                                                    //                             //                                 ),
                                                    //                             //                             ],
                                                    //                             //                           );
                                                    //                             //                         },
                                                    //                             //                         itemCount:
                                                    //                             //                             productNQuantity.key.options!.length,
                                                    //                             //                       )
                                                    //                             //                     ],
                                                    //                             //                   )
                                                    //                             //                 : null,
                                                    //                             //         leading: Container(
                                                    //                             //           padding:
                                                    //                             //               const EdgeInsets
                                                    //                             //                   .all(5),
                                                    //                             //           color: AppColors
                                                    //                             //               .neutral100,
                                                    //                             //           child: AppText(
                                                    //                             //               text: productNQuantity
                                                    //                             //                   .value
                                                    //                             //                   .toString()),
                                                    //                             //         ),
                                                    //                             //         title: AppText(
                                                    //                             //           text:
                                                    //                             //               productNQuantity
                                                    //                             //                   .key.name,
                                                    //                             //           weight: FontWeight
                                                    //                             //               .w600,
                                                    //                             //           size: AppSizes
                                                    //                             //               .bodySmaller,
                                                    //                             //         ),
                                                    //                             //         contentPadding:
                                                    //                             //             const EdgeInsets
                                                    //                             //                 .only(
                                                    //                             //                 left: 50),
                                                    //                             //         trailing: Column(
                                                    //                             //           mainAxisAlignment:
                                                    //                             //               MainAxisAlignment
                                                    //                             //                   .start,
                                                    //                             //           mainAxisSize:
                                                    //                             //               MainAxisSize
                                                    //                             //                   .min,
                                                    //                             //           children: [
                                                    //                             //             AppText(
                                                    //                             //                 color: AppColors
                                                    //                             //                     .neutral600,
                                                    //                             //                 text:
                                                    //                             //                     'US\$${((productNQuantity.key.promoPrice ?? productNQuantity.key.initialPrice) * productNQuantity.value).toStringAsFixed(2)}'),
                                                    //                             //           ],
                                                    //                             //         ),
                                                    //                             //       );
                                                    //                             //     },
                                                    //                             //     separatorBuilder:
                                                    //                             //         (context, index) =>
                                                    //                             //             const Divider(),
                                                    //                             //     itemCount: personalOrderItem
                                                    //                             //         .first
                                                    //                             //         .productsAndQuantities
                                                    //                             //         .length)
                                                    //                           ],
                                                    //                         ),
                                                    //                       const Divider(),
                                                    //                       const Gap(5),
                                                    //                       const AppText(
                                                    //                           text:
                                                    //                               'Others in the group',
                                                    //                           weight:
                                                    //                               FontWeight
                                                    //                                   .w600,
                                                    //                           size: AppSizes
                                                    //                               .bodySmall),
                                                    //                       AppText(
                                                    //                           text:
                                                    //                               '${orderSchedule.orderItems.length} of ${_groupOrders.first.persons.length} people have added items'),
                                                    //                       ListView
                                                    //                           .builder(
                                                    //                         physics:
                                                    //                             const NeverScrollableScrollPhysics(),
                                                    //                         shrinkWrap:
                                                    //                             true,
                                                    //                         itemBuilder:
                                                    //                             (context,
                                                    //                                 index) {
                                                    //                           final otherOrderItem =
                                                    //                               otherOrderItems[
                                                    //                                   index];
                                                    //                           return ExpansionTile(
                                                    //                             tilePadding:
                                                    //                                 EdgeInsets
                                                    //                                     .zero,
                                                    //                             title: AppText(
                                                    //                                 weight: FontWeight
                                                    //                                     .w600,
                                                    //                                 text:
                                                    //                                     '${otherOrderItem.person} (You)'),
                                                    //                             subtitle:
                                                    //                                 AppText(
                                                    //                                     text: "${otherOrderItem.productsAndQuantities.length.toString()} ${otherOrderItem.productsAndQuantities.length == 1 ? 'item' : 'items'}"),
                                                    //                             leading: ClipRRect(
                                                    //                                 borderRadius: BorderRadius.circular(50),
                                                    //                                 child: Image.asset(
                                                    //                                   AssetNames.fastFoodBNW,
                                                    //                                   width:
                                                    //                                       30,
                                                    //                                 )),
                                                    //                             children: [
                                                    //                               // ListView.separated(
                                                    //                               //     physics:
                                                    //                               //         const NeverScrollableScrollPhysics(),
                                                    //                               //     shrinkWrap: true,
                                                    //                               //     itemBuilder:
                                                    //                               //         (context, index) {
                                                    //                               //       final productNQuantity =
                                                    //                               //           otherOrderItem
                                                    //                               //               .productsAndQuantities
                                                    //                               //               .entries
                                                    //                               //               .elementAt(
                                                    //                               //                   index);
                                                    //                               //       return ListTile(
                                                    //                               //         subtitle:
                                                    //                               //             productNQuantity
                                                    //                               //                         .key
                                                    //                               //                         .options !=
                                                    //                               //                     null
                                                    //                               //                 ? Column(
                                                    //                               //                     mainAxisSize:
                                                    //                               //                         MainAxisSize.min,
                                                    //                               //                     children: [
                                                    //                               //                       ListView.builder(
                                                    //                               //                         itemBuilder: (context, index) {
                                                    //                               //                           final option = productNQuantity.key.options![index];
                                                    //                               //                           return Column(
                                                    //                               //                             children: [
                                                    //                               //                               AppText(text: 'Item !: ${option.name}'),
                                                    //                               //                               if (option.subOptions != null)
                                                    //                               //                                 AppText(
                                                    //                               //                                   text: option.subOptions!.first.name,
                                                    //                               //                                   color: AppColors.neutral500,
                                                    //                               //                                 ),
                                                    //                               //                             ],
                                                    //                               //                           );
                                                    //                               //                         },
                                                    //                               //                         itemCount: productNQuantity.key.options!.length,
                                                    //                               //                       )
                                                    //                               //                     ],
                                                    //                               //                   )
                                                    //                               //                 : null,
                                                    //                               //         leading:
                                                    //                               //             Container(
                                                    //                               //           padding:
                                                    //                               //               const EdgeInsets
                                                    //                               //                   .all(5),
                                                    //                               //           color: AppColors
                                                    //                               //               .neutral100,
                                                    //                               //           child: AppText(
                                                    //                               //               text: productNQuantity
                                                    //                               //                   .value
                                                    //                               //                   .toString()),
                                                    //                               //         ),
                                                    //                               //         title: AppText(
                                                    //                               //           text:
                                                    //                               //               productNQuantity
                                                    //                               //                   .key
                                                    //                               //                   .name,
                                                    //                               //           weight:
                                                    //                               //               FontWeight
                                                    //                               //                   .w600,
                                                    //                               //           size: AppSizes
                                                    //                               //               .bodySmaller,
                                                    //                               //         ),
                                                    //                               //         contentPadding:
                                                    //                               //             const EdgeInsets
                                                    //                               //                 .only(
                                                    //                               //                 left: 50),
                                                    //                               //         trailing: Column(
                                                    //                               //           mainAxisAlignment:
                                                    //                               //               MainAxisAlignment
                                                    //                               //                   .start,
                                                    //                               //           mainAxisSize:
                                                    //                               //               MainAxisSize
                                                    //                               //                   .min,
                                                    //                               //           children: [
                                                    //                               //             AppText(
                                                    //                               //                 color: AppColors
                                                    //                               //                     .neutral600,
                                                    //                               //                 text:
                                                    //                               //                     'US\$${((productNQuantity.key.promoPrice ?? productNQuantity.key.initialPrice) * productNQuantity.value).toStringAsFixed(2)}'),
                                                    //                               //           ],
                                                    //                               //         ),
                                                    //                               //       );
                                                    //                               //     },
                                                    //                               //     separatorBuilder:
                                                    //                               //         (context,
                                                    //                               //                 index) =>
                                                    //                               //             const Divider(),
                                                    //                               //     itemCount: otherOrderItem
                                                    //                               //         .productsAndQuantities
                                                    //                               //         .length),

                                                    //                               InkWell(
                                                    //                                 onTap:
                                                    //                                     () {
                                                    //                                   //TODO: Implement removal of person
                                                    //                                 },
                                                    //                                 child:
                                                    //                                     Ink(
                                                    //                                   child:
                                                    //                                       Row(
                                                    //                                     children: [
                                                    //                                       Icon(
                                                    //                                         Icons.delete_outline,
                                                    //                                         color: Colors.red.shade900,
                                                    //                                       ),
                                                    //                                       const AppText(text: ' Remove person'),
                                                    //                                     ],
                                                    //                                   ),
                                                    //                                 ),
                                                    //                               )
                                                    //                             ],
                                                    //                           );
                                                    //                         },
                                                    //                         itemCount:
                                                    //                             otherOrderItems
                                                    //                                 .length,
                                                    //                       ),
                                                    //                       const Divider(),
                                                    //                       ListTile(
                                                    //                         contentPadding:
                                                    //                             EdgeInsets
                                                    //                                 .zero,
                                                    //                         title:
                                                    //                             const AppText(
                                                    //                           text:
                                                    //                               'Subtotal',
                                                    //                           weight:
                                                    //                               FontWeight
                                                    //                                   .w600,
                                                    //                           size: AppSizes
                                                    //                               .bodySmall,
                                                    //                         ),
                                                    //                         trailing: AppText(
                                                    //                             size: AppSizes
                                                    //                                 .bodySmall,
                                                    //                             weight: FontWeight
                                                    //                                 .w600,
                                                    //                             text:
                                                    //                                 'US\$ ${orderSchedule.totalFee.toStringAsFixed(2)}'),
                                                    //                       ),
                                                    //                     ],
                                                    //                   ),
                                                    //                 ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //           Padding(
                                                    //             padding: const EdgeInsets
                                                    //                 .symmetric(
                                                    //                 horizontal: AppSizes
                                                    //                     .horizontalPaddingSmall),
                                                    //             child: Column(
                                                    //               children: [
                                                    //                 AppButton(
                                                    //                     callback: () {},
                                                    //                     text:
                                                    //                         'Go to checkout'),
                                                    //                 const Gap(10),
                                                    //                 AppButton(
                                                    //                   text: 'Add items',
                                                    //                   isSecondary: true,
                                                    //                   callback: () {},
                                                    //                 ),
                                                    //                 const Gap(20),
                                                    //               ],
                                                    //             ),
                                                    //           )
                                                    //         ],
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    // );
                                                  },
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Stack(
                                                      children: [
                                                        FutureBuilder(
                                                            future: AppFunctions
                                                                .loadStoreReference(
                                                                    orderSchedule
                                                                            .storeRef
                                                                        as DocumentReference),
                                                            builder: (context,
                                                                snapshot) {
                                                              final store =
                                                                  snapshot
                                                                      .data!;
                                                              return AppFunctions
                                                                  .displayNetworkImage(
                                                                store.cardImage,
                                                                width: 50,
                                                                height: 50,
                                                                fit: BoxFit
                                                                    .cover,
                                                              );
                                                            }),
                                                        Container(
                                                          color: Colors.black38,
                                                          width: 50,
                                                          height: 50,
                                                          child: const Icon(
                                                            Icons
                                                                .group_outlined,
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
                                                    text: store.name,
                                                    weight: FontWeight.w600,
                                                  ));
                                            } else if (snapshot.hasError) {
                                              return AppText(
                                                  text: snapshot.error
                                                      .toString());
                                            } else {
                                              return Skeletonizer(
                                                  enabled: true,
                                                  child: ListTile(
                                                      title: const AppText(
                                                        text: 'hoahjajlasf',
                                                      ),
                                                      subtitle: const AppText(
                                                          text:
                                                              'haljlkajkljaflkjkafjlaf'),
                                                      leading: Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ))));
                                            }
                                          }),

                                      //TODO: implement this better
                                      if (index == 1 - 1)
                                        const Divider(
                                          indent: 70,
                                        )
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      thickness: 4,
                                    ),
                                itemCount: orderSchedules.length);
                          } else if (snapshot.hasError) {
                            AppText(
                              text: snapshot.error.toString(),
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
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
    // for (var groupOrderPath in widget.groupOrderPaths) {
    //   var groupOrderSnapshot =
    //       await FirebaseFirestore.instance.doc(groupOrderPath).get();
    //   _groupOrders.add(GroupOrder.fromJson(groupOrderSnapshot.data()!));
    // }
    // for (var groupOrder in _groupOrders) {
    //   if (groupOrder.frequency != null &&
    //       groupOrder.orderScheduleRefs
    //           .where(
    //             (element) => element.deliveryDate.isAfter(DateTime.now()),
    //           )
    //           .isEmpty) {
    //     //calculating next delivery date
    //     final dateTimeNow = DateTime.now();
    //     DateTime? nextDeliveryDate;
    //     groupOrder.frequency!.startsWith('Daily')
    //         ? nextDeliveryDate = dateTimeNow.add(const Duration(days: 1))
    //         : groupOrder.frequency!.startsWith('Every weekday')
    //             ? (dateTimeNow.weekday != DateTime.sunday ||
    //                     dateTimeNow.weekday != DateTime.saturday)
    //                 ? nextDeliveryDate =
    //                     dateTimeNow.add(const Duration(days: 1))
    //                 : nextDeliveryDate = null
    //             : groupOrder.frequency!.startsWith('Weekly')
    //                 ? nextDeliveryDate =
    //                     dateTimeNow.add(const Duration(days: 7))
    //                 : groupOrder.frequency!.startsWith('Bi-weekly')
    //                     ? nextDeliveryDate =
    //                         dateTimeNow.add(const Duration(days: 14))
    //                     : nextDeliveryDate =
    //                         dateTimeNow.add(const Duration(days: 30));
    //     if (nextDeliveryDate != null) {
    //       final weekday = groupOrder.firstOrderSchedule!.weekday;
    //       while (nextDeliveryDate!.weekday != weekday) {
    //         nextDeliveryDate = nextDeliveryDate.add(const Duration(days: 1));
    //       }
    //       final newOrderSchedule = OrderSchedule(
    //         deliveryDate: nextDeliveryDate,
    //         storeRef: groupOrder.storeRefs.first,
    //         orderNumber: const Uuid().v7(),
    //         orderItems: [],
    //         status: 'Processing',
    //       );
    //       final groupOrderSnapshot = await FirebaseFirestore.instance
    //           .collection(FirestoreCollections.groupOrders)
    //           .doc(groupOrder.id)
    //           .update({
    //         'orderSchedules': FieldValue.arrayUnion([newOrderSchedule])
    //       });
    //     }
    //   }
    // }
  }

  Future<List<OrderSchedule>> _getOrderSchedules(
      List<GroupOrder> groupOrders) async {
    List<OrderSchedule> orderSchedules = [];
    for (var groupOrder in groupOrders) {
      for (var ref in groupOrder.orderScheduleRefs) {
        final orderSchedule = await AppFunctions.loadOrderScheduleReference(
            ref as DocumentReference);
        orderSchedules.add(orderSchedule);
      }
    }
    orderSchedules.sort(
      (a, b) => b.orderDate.compareTo(a.orderDate),
    );

    return orderSchedules;
  }
}
