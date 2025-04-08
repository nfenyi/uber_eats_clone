import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/models/store/store_model.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/order_screen.dart';

import '../../../../app_functions.dart';
import '../../../../main.dart';
import '../../../../models/order/order_model.dart';
import '../../../constants/app_sizes.dart';

class OrdersScreen extends StatefulWidget {
  final GeoPoint storedUserLocation;

  const OrdersScreen({super.key, required this.storedUserLocation});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<IndividualOrder> _allOrders = [
    // IndividualOrder(
    //     productsAndQuantities:
    //         stores[2].productCategories.first.productsAndQuantities,
    //     orderNumber: '15615613',
    //     deliveryDate: DateTime.now(),
    //     status: 'Completed',
    //     store: stores[2],
    //     tip: 5.2,
    //     courier: 'Dennis Osei',
    //     totalFee: 65.0,
    //     promo: Promotion(
    //         discount: 3,
    //         description: 'lajlasklfs',
    //         applicableLocation: 'Adenta',
    //         expirationDate: DateTime.now().add(const Duration(days: 3))),
    //     serviceFee: 2,
    //     tax: 1,
    //     deliveryFee: 4,
    //     payments: [
    //       Payment(
    //           datePaid: DateTime.now(),
    //           cardNumber: '6546516516216',
    //           paymentMethod: const PaymentMethod(
    //               name: 'Venmo', assetImage: AssetNames.venmoLogo),
    //           amountPaid: 99)
    //     ])
  ];
  List<IndividualOrder> _ongoingOrders = [];
  List<IndividualOrder> _pastOrders = [];
  // final List<IndividualOrder> _anotherListOfOrders = [];

  @override
  void initState() {
    super.initState();
    final partitionedOrderItems =
        groupBy(_allOrders, (order) => order.status == 'Ongoing');

    _ongoingOrders = partitionedOrderItems[true] ?? [];
    _pastOrders = partitionedOrderItems[false] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final timeOfDayNow = TimeOfDay.now();
    return Scaffold(
      appBar: AppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverAppBar.medium(
              title: AppText(
                text: 'Orders',
                size: AppSizes.heading4,
                weight: FontWeight.w600,
              ),
            )
          ];
        },
        body: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TabBar(
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(vertical: 10),
                tabs: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long),
                      Gap(5),
                      AppText(text: 'All Orders')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh),
                      Gap(5),
                      AppText(text: 'Reorder')
                    ],
                  )
                ],
              ),
              Expanded(
                  child: TabBarView(children: [
                _allOrders.isEmpty
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
                            SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Gap(20),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    child: AppText(
                                      text: 'Ongoing Orders',
                                      color: AppColors.neutral500,
                                      size: AppSizes.bodySmall,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final ongoingOrder =
                                          _ongoingOrders[index];
                                      return FutureBuilder<Store>(
                                          future:
                                              AppFunctions.loadStoreReference(
                                                  ongoingOrder.storeRef
                                                      as DocumentReference),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final store = snapshot.data!;
                                              return ListTile(
                                                title: AppText(
                                                  text: store.name,
                                                  size: AppSizes.bodySmall,
                                                  weight: FontWeight.w600,
                                                ),
                                                trailing: AppButton(
                                                  isSecondary: true,
                                                  borderRadius: 30,
                                                  height: 35,
                                                  width: 90,
                                                  text: 'View store',
                                                  callback: () async {
                                                    await AppFunctions
                                                        .navigateToStoreScreen(
                                                            store);
                                                  },
                                                ),
                                                subtitle: AppText(
                                                    text:
                                                        '${ongoingOrder.productsAndQuantities.length} items • ${ongoingOrder.totalFee}\n${AppFunctions.formatDate(ongoingOrder.deliveryDate.toString(), format: 'M j')} • ${ongoingOrder.status}'),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: AppFunctions
                                                      .displayNetworkImage(
                                                    width: 50,
                                                    height: 50,
                                                    store.cardImage,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return AppText(
                                                  text: snapshot.error
                                                      .toString());
                                            }
                                            return const SizedBox.shrink();
                                          });
                                    },
                                    itemCount: _ongoingOrders.length,
                                  ),
                                ],
                              ),
                            ),
                          if (_pastOrders.isNotEmpty)
                            SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Gap(20),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    child: AppText(
                                      text: 'Past Orders',
                                      size: AppSizes.bodySmall,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final pastOrder = _pastOrders[index];
                                      return FutureBuilder<Store>(
                                          future:
                                              AppFunctions.loadStoreReference(
                                                  pastOrder.storeRef
                                                      as DocumentReference),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final store = snapshot.data!;
                                              return ListTile(
                                                title: AppText(
                                                  text: store.name,
                                                  size: AppSizes.bodySmall,
                                                  weight: FontWeight.w600,
                                                ),
                                                trailing: AppButton(
                                                  isSecondary: true,
                                                  borderRadius: 30,
                                                  height: 35,
                                                  width: 90,
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
                                                        '${pastOrder.productsAndQuantities.length} items • ${pastOrder.totalFee}\n${AppFunctions.formatDate(pastOrder.deliveryDate.toString(), format: 'M j')} • ${pastOrder.status}'),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: AppFunctions
                                                      .displayNetworkImage(
                                                    width: 50,
                                                    height: 50,
                                                    store.cardImage,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              AppText(
                                                text: snapshot.error.toString(),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          });
                                    },
                                    itemCount: _pastOrders.length,
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                _allOrders.isEmpty
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
                    : Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                            itemCount: _allOrders.length,
                            itemBuilder: (context, index) {
                              final order = _allOrders[index];

                              return FutureBuilder<Store>(
                                  future: AppFunctions.loadStoreReference(
                                      order.storeRef as DocumentReference),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final store = snapshot.data!;
                                      final bool isClosed = timeOfDayNow.hour <
                                              store.openingTime.hour ||
                                          (timeOfDayNow.hour >=
                                                  store.closingTime.hour &&
                                              timeOfDayNow.minute >=
                                                  store.closingTime.minute);
                                      return InkWell(
                                          onTap: () => navigatorKey
                                                  .currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderScreen(order: order),
                                              )),
                                          child: Ink(
                                              child: Column(
                                            children: [
                                              ListTile(
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
                                                      '\$${order.deliveryFee} • ${isClosed ? 'Closed' : 'Open'}',
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
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: AppSizes
                                                        .horizontalPaddingSmall),
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: order
                                                      .productsAndQuantities
                                                      .length,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              120,
                                                          mainAxisExtent: 170,
                                                          mainAxisSpacing: 10,
                                                          crossAxisSpacing: 10),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item = order
                                                        .productsAndQuantities
                                                        .entries
                                                        .elementAt(index);
                                                    return const Column(
                                                      children: [
                                                        // AppFunctions.displayNetworkImage(

                                                        //       item.key.imageUrls.first,
                                                        //   width: 80,
                                                        //   height: 80,
                                                        //   fit: BoxFit.cover,
                                                        // ),
                                                        // const Gap(5),
                                                        // AppText(
                                                        //   text: item.key.name,
                                                        //   maxLines: 3,
                                                        // ),
                                                        // const Gap(5),
                                                        // Row(
                                                        //   children: [
                                                        //     AppText(
                                                        //         color:
                                                        //             AppColors.neutral500,
                                                        //         text:
                                                        //             '\$${(item.key.promoPrice ?? item.key.initialPrice).toStringAsFixed(2)}'),
                                                        //     if (item.key.calories != null)
                                                        //       AppText(
                                                        //           color: AppColors
                                                        //               .neutral500,
                                                        //           text:
                                                        //               ' • ${item.key.calories}')
                                                        //   ],
                                                        // ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          )));
                                    } else if (snapshot.hasError) {
                                      AppText(text: snapshot.error.toString());
                                    }
                                    return const SizedBox.shrink();
                                  });
                            },
                          ))
                        ],
                      ),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
