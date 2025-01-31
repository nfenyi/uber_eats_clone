import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/order_screen.dart';
import 'package:uber_eats_clone/presentation/features/grocery_store/screens/grocery_store_screens.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';
import 'package:uber_eats_clone/presentation/features/promotion/promo_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/payment_method_screen.dart';
import 'package:uber_eats_clone/presentation/features/store/store_screen.dart';

import '../../../../app_functions.dart';
import '../../../../main.dart';
import '../../../constants/app_sizes.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<IndividualOrder> _allOrders = [
    IndividualOrder(
        productsAndQuantities: {
          stores[6].productCategories.first.products.first: 4,
          stores[6].productCategories.first.products.first: 4
        },
        orderNumber: '15615613',
        deliveryDate: DateTime.now(),
        status: 'Completed',
        store: stores[6],
        tip: 5.2,
        courier: 'Dennis Osei',
        totalFee: 65.0,
        promo: Promotion(
            discount: 3,
            description: 'lajlasklfs',
            applicableLocation: 'Adenta',
            expirationDate: DateTime.now().add(const Duration(days: 3))),
        serviceFee: 2,
        tax: 1,
        deliveryFee: 4,
        payments: [
          Payment(
              datePaid: DateTime.now(),
              cardNumber: '6546516516216',
              paymentMethod: PaymentMethod('Venmo', AssetNames.venmoLogo),
              amountPaid: 99)
        ])
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
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                text: 'Orders',
                size: AppSizes.heading4,
                weight: FontWeight.w600,
              ),
            ),
            const TabBar(
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final ongoingOrder = _ongoingOrders[index];
                                    return ListTile(
                                      title: AppText(
                                        text: ongoingOrder.store.name,
                                        size: AppSizes.bodySmall,
                                        weight: FontWeight.w600,
                                      ),
                                      trailing: AppButton(
                                        isSecondary: true,
                                        borderRadius: 30,
                                        height: 35,
                                        width: 90,
                                        text: 'View store',
                                        callback: () {
                                          navigatorKey.currentState!
                                              .push(MaterialPageRoute(
                                            builder: (context) {
                                              return ongoingOrder.store.type
                                                      .contains('Grocery')
                                                  ? GroceryStoreMainScreen(
                                                      ongoingOrder.store)
                                                  : StoreScreen(
                                                      ongoingOrder.store);
                                            },
                                          ));
                                        },
                                      ),
                                      subtitle: AppText(
                                          text:
                                              '${ongoingOrder.productsAndQuantities.length} items • ${ongoingOrder.totalFee}\n${AppFunctions.formatDate(ongoingOrder.deliveryDate.toString(), format: 'M j')} • ${ongoingOrder.status}'),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          width: 50,
                                          height: 50,
                                          imageUrl:
                                              ongoingOrder.store.cardImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final pastOrder = _pastOrders[index];
                                    return ListTile(
                                      title: AppText(
                                        text: pastOrder.store.name,
                                        size: AppSizes.bodySmall,
                                        weight: FontWeight.w600,
                                      ),
                                      trailing: AppButton(
                                        isSecondary: true,
                                        borderRadius: 30,
                                        height: 35,
                                        width: 90,
                                        text: 'View store',
                                        callback: () {
                                          navigatorKey.currentState!
                                              .push(MaterialPageRoute(
                                            builder: (context) {
                                              return pastOrder.store.type
                                                      .contains('Grocery')
                                                  ? GroceryStoreMainScreen(
                                                      pastOrder.store)
                                                  : StoreScreen(
                                                      pastOrder.store);
                                            },
                                          ));
                                        },
                                      ),
                                      subtitle: AppText(
                                          color: AppColors.neutral500,
                                          text:
                                              '${pastOrder.productsAndQuantities.length} items • ${pastOrder.totalFee}\n${AppFunctions.formatDate(pastOrder.deliveryDate.toString(), format: 'M j')} • ${pastOrder.status}'),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          width: 50,
                                          height: 50,
                                          imageUrl: pastOrder.store.cardImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
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
                            final bool isClosed = timeOfDayNow.hour <
                                    order.store.openingTime.hour ||
                                (timeOfDayNow.hour >=
                                        order.store.closingTime.hour &&
                                    timeOfDayNow.minute >=
                                        order.store.closingTime.minute);
                            return InkWell(
                                onTap: () => navigatorKey.currentState!
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
                                        text: order.store.name,
                                        weight: FontWeight.w600,
                                        size: AppSizes.bodySmall,
                                      ),
                                      subtitle: AppText(
                                        text:
                                            '\$${order.deliveryFee} • ${isClosed ? 'Closed' : 'Open'}',
                                      ),
                                      leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              imageUrl: order.store.cardImage)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizes.horizontalPaddingSmall),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            order.productsAndQuantities.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 120,
                                                mainAxisExtent: 170,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10),
                                        itemBuilder: (context, index) {
                                          final item = order
                                              .productsAndQuantities.entries
                                              .elementAt(index);
                                          return Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    item.key.imageUrls.first,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              ),
                                              const Gap(5),
                                              AppText(
                                                text: item.key.name,
                                                maxLines: 3,
                                              ),
                                              const Gap(5),
                                              Row(
                                                children: [
                                                  AppText(
                                                      color:
                                                          AppColors.neutral500,
                                                      text:
                                                          '\$${(item.key.promoPrice ?? item.key.initialPrice).toStringAsFixed(2)}'),
                                                  if (item.key.calories != null)
                                                    AppText(
                                                        color: AppColors
                                                            .neutral500,
                                                        text:
                                                            ' • ${item.key.calories}')
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                )));
                          },
                        ))
                      ],
                    ),
            ]))
          ],
        ),
      ),
    );
  }
}
