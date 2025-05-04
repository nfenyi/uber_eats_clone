import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/order_screen.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/screens/main_screen.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

import '../../../../app_functions.dart';
import '../../../../main.dart';
import '../../../../models/order/order_model.dart';
import '../../../constants/app_sizes.dart';
import '../../product/product_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<IndividualOrder> _ongoingOrders = [];
  List<IndividualOrder> _pastOrders = [];
  // final List<IndividualOrder> _anotherListOfOrders = [];

  @override
  Widget build(BuildContext context) {
    AppFunctions.getAllIndividualOrders();
    final dateTimeNow = DateTime.now();
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const SliverAppBar.medium(
                // toolbarHeight: 120,
                // collapsedHeight: 120,
                bottom: TabBar(
                  tabAlignment: TabAlignment.fill,
                  labelPadding: EdgeInsets.symmetric(vertical: 10),
                  tabs: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long),
                          Gap(5),
                          AppText(text: 'All Orders')
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh),
                          Gap(5),
                          AppText(text: 'Reorder')
                        ],
                      ),
                    )
                  ],
                ),
                title: AppText(
                  text: 'Orders',
                  size: AppSizes.heading4,
                  weight: FontWeight.w600,
                ),
              ),
            ];
          },
          body: FutureBuilder<List<IndividualOrder>>(
              future: AppFunctions.getAllIndividualOrders(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final allOrders = snapshot.data!;
                  final partitionedOrderItems = groupBy(allOrders,
                      (order) => order.deliveryDate.isAfter(dateTimeNow));
                  _ongoingOrders = partitionedOrderItems[true] ?? [];
                  _pastOrders = partitionedOrderItems[false] ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                            //allOrders
                            allOrders.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.translate(
                                        offset: const Offset(0, -90),
                                        child: SizedBox(
                                          width: 300,
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.receipt_long,
                                                size: 60,
                                                color: AppColors.neutral300,
                                              ),
                                              const Gap(10),
                                              const AppText(
                                                text: 'No orders yet',
                                                weight: FontWeight.w600,
                                                size: AppSizes.bodySmall,
                                              ),
                                              const Gap(10),
                                              const AppText(
                                                text:
                                                    "You'll be able to see your order history and reorder youor favorites here",
                                                textAlign: TextAlign.center,
                                              ),
                                              const Gap(10),
                                              AppButton(
                                                width: 120,
                                                borderRadius: 25,
                                                text: 'Start an order',
                                                callback: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : CustomScrollView(
                                    slivers: [
                                      if (_ongoingOrders.isNotEmpty)
                                        const SliverToBoxAdapter(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Gap(20),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: AppSizes
                                                        .horizontalPaddingSmall),
                                                child: AppText(
                                                  text: 'Ongoing Orders',
                                                  color: AppColors.neutral500,
                                                  size: AppSizes.bodySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (_ongoingOrders.isNotEmpty)
                                        SliverList.builder(
                                          itemBuilder: (context, index) {
                                            final ongoingOrder =
                                                _ongoingOrders[index];
                                            final store =
                                                allStores.firstWhereOrNull(
                                              (element) =>
                                                  element.id ==
                                                  ongoingOrder.storeId,
                                            );
                                            if (store == null) {
                                              return const AppText(
                                                  text:
                                                      'Associated store seems to be removed from Uber Eats');
                                            }
                                            return ListTile(
                                              onTap: () => showInfoToast(
                                                  'Map UI for delivery not provided. Will figure out something',
                                                  context: context),
                                              titleAlignment:
                                                  ListTileTitleAlignment.top,
                                              title: AppText(
                                                text: store.name,
                                                size: AppSizes.bodySmall,
                                                weight: FontWeight.w600,
                                              ),
                                              trailing: AppButton2(
                                                text: 'View store',
                                                callback: () async {
                                                  await AppFunctions
                                                      .navigateToStoreScreen(
                                                          store);
                                                },
                                              ),
                                              subtitle: AppText(
                                                  color: AppColors.neutral500,
                                                  text:
                                                      '${ongoingOrder.products.length} items • US\$${ongoingOrder.totalFee}\n${AppFunctions.formatDate(ongoingOrder.deliveryDate.toString(), format: ongoingOrder.deliveryDate.difference(dateTimeNow) < const Duration(days: 1) ? 'G:i A' : 'M j')} • ${ongoingOrder.status}'),
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: AppFunctions
                                                    .displayNetworkImage(
                                                  width: 60,
                                                  height: 60,
                                                  store.cardImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: _ongoingOrders.length,
                                        ),
                                      if (_pastOrders.isNotEmpty)
                                        const SliverToBoxAdapter(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Gap(20),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: AppSizes
                                                        .horizontalPaddingSmall),
                                                child: AppText(
                                                  text: 'Past Orders',
                                                  size: AppSizes.bodySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (_pastOrders.isNotEmpty)
                                        SliverList.builder(
                                          itemBuilder: (context, index) {
                                            final pastOrder =
                                                _pastOrders[index];
                                            final store =
                                                allStores.firstWhereOrNull(
                                              (element) =>
                                                  element.id ==
                                                  pastOrder.storeId,
                                            );
                                            if (store == null) {
                                              return const AppText(
                                                  text:
                                                      'Associated store seems to be removed from Uber Eats');
                                            }
                                            return ListTile(
                                              onTap: () => navigatorKey
                                                  .currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderScreen(
                                                        order: pastOrder),
                                              )),
                                              titleAlignment:
                                                  ListTileTitleAlignment.top,
                                              title: AppText(
                                                text: store.name,
                                                size: AppSizes.bodySmall,
                                                weight: FontWeight.w600,
                                              ),
                                              trailing: AppButton2(
                                                text: 'View store',
                                                callback: () async {
                                                  await AppFunctions
                                                      .navigateToStoreScreen(
                                                          store);
                                                },
                                              ),
                                              subtitle: AppText(
                                                  color: AppColors.neutral500,
                                                  text:
                                                      '${pastOrder.products.length} items • US\$${pastOrder.totalFee}\n${AppFunctions.formatDate(pastOrder.deliveryDate.toString(), format: 'M j')} • ${pastOrder.status}'),
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: AppFunctions
                                                    .displayNetworkImage(
                                                  width: 60,
                                                  height: 60,
                                                  store.cardImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: _pastOrders.length,
                                        ),
                                    ],
                                  ),
                            //completedorders
                            allOrders.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.translate(
                                        offset: const Offset(0, -90),
                                        child: SizedBox(
                                          width: 300,
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.receipt_long,
                                                size: 60,
                                                color: AppColors.neutral300,
                                              ),
                                              const Gap(10),
                                              const AppText(
                                                text: 'No orders yet',
                                                weight: FontWeight.w600,
                                                size: AppSizes.bodySmall,
                                              ),
                                              const Gap(10),
                                              const AppText(
                                                text:
                                                    "You'll be able to see your order history and reorder youor favorites here",
                                                textAlign: TextAlign.center,
                                              ),
                                              const Gap(10),
                                              AppButton(
                                                width: 120,
                                                borderRadius: 25,
                                                text: 'Start an order',
                                                callback: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : CustomScrollView(
                                    slivers: [
                                      SliverList.builder(
                                        itemCount: allOrders.length,
                                        itemBuilder: (context, index) {
                                          final order = allOrders[index];

                                          return Builder(builder: (context) {
                                            // if (order.status != 'Completed') {
                                            //   return const SizedBox.shrink();
                                            // }
                                            final store =
                                                allStores.firstWhereOrNull(
                                              (element) =>
                                                  element.id == order.storeId,
                                            );
                                            if (store == null) {
                                              return const AppText(
                                                  text:
                                                      'Associated store seems to be removed from Uber Eats');
                                            }
                                            final bool isClosed = dateTimeNow
                                                    .isBefore(
                                                        store.openingTime) ||
                                                dateTimeNow
                                                    .isAfter(store.closingTime);
                                            return Column(
                                              children: [
                                                ListTile(
                                                  onTap: () async {
                                                    await AppFunctions
                                                        .navigateToStoreScreen(
                                                            store);
                                                  },
                                                  trailing: const Icon(
                                                    Icons.keyboard_arrow_right,
                                                    color: AppColors.neutral500,
                                                  ),
                                                  title: AppText(
                                                    text: store.name,
                                                    weight: FontWeight.w600,
                                                    size: AppSizes.bodySmall,
                                                  ),
                                                  subtitle: AppText(
                                                    text:
                                                        '\$${order.deliveryFee} Delivery Fee${isClosed ? ' • Closed' : ''}',
                                                  ),
                                                  leading: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: AppFunctions
                                                          .displayNetworkImage(
                                                              height: 50,
                                                              width: 50,
                                                              fit: BoxFit.cover,
                                                              store.cardImage)),
                                                ),
                                                if (order.products.isNotEmpty)
                                                  SizedBox(
                                                    height: 170,
                                                    child: Scrollbar(
                                                      scrollbarOrientation:
                                                          ScrollbarOrientation
                                                              .bottom,
                                                      child: ListView.separated(
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                const Gap(5),
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: AppSizes
                                                                .horizontalPaddingSmall),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: order
                                                            .products.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final cartProduct =
                                                              order.products[
                                                                  index];
                                                          return FutureBuilder(
                                                              future: AppFunctions.loadProductReference(FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      FirestoreCollections
                                                                          .products)
                                                                  .doc(
                                                                      cartProduct
                                                                          .id)),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  final product =
                                                                      snapshot
                                                                          .data!;
                                                                  return InkWell(
                                                                    onTap: () => navigatorKey
                                                                        .currentState!
                                                                        .push(
                                                                            MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ProductScreen(
                                                                        product:
                                                                            product,
                                                                        store:
                                                                            store,
                                                                      ),
                                                                    )),
                                                                    child: Ink(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            115,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            AppFunctions.displayNetworkImage(
                                                                              product.imageUrls.first,
                                                                              width: 80,
                                                                              height: 80,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                            const Gap(5),
                                                                            AppText(
                                                                              text: product.name,
                                                                              maxLines: 3,
                                                                            ),
                                                                            const Gap(5),
                                                                            Row(
                                                                              children: [
                                                                                AppText(color: AppColors.neutral500, text: '\$${(product.promoPrice ?? product.initialPrice).toStringAsFixed(2)}'),
                                                                                if (product.calories != null) AppText(color: AppColors.neutral500, text: ' • ${product.calories}')
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else if (snapshot
                                                                    .hasError) {
                                                                  return AppText(
                                                                      text: snapshot
                                                                          .error
                                                                          .toString());
                                                                } else {
                                                                  return Skeletonizer(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          color:
                                                                              AppColors.neutral300,
                                                                          width:
                                                                              80,
                                                                          height:
                                                                              80,
                                                                        ),
                                                                        const Gap(
                                                                            5),
                                                                        const AppText(
                                                                          text:
                                                                              'lajklaflamfjsl>',
                                                                          maxLines:
                                                                              3,
                                                                        ),
                                                                        const Gap(
                                                                            5),
                                                                        const AppText(
                                                                            color:
                                                                                AppColors.neutral500,
                                                                            text: 'lkam'),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                              });
                                                        },
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            );
                                          });
                                        },
                                      )
                                    ],
                                  ),
                          ]))
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      snapshot.hasError
                          ? AppText(text: snapshot.error.toString())
                          : const CircularProgressIndicator.adaptive()
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
