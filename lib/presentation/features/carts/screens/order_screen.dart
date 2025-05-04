import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/receipt_screen.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/what_delivery_people_see_screen.dart';

import '../../../../main.dart';
import '../../../../models/order/order_model.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../core/app_text.dart';
import '../../../services/sign_in_view_model.dart';
import '../../address/screens/addresses_screen.dart';
import '../../main_screen/screens/main_screen.dart';

class OrderScreen extends StatefulWidget {
  final IndividualOrder order;

  const OrderScreen({super.key, required this.order});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late final Store _store;
  String doorStepImage =
      'https://thumbs.dreamstime.com/b/package-delivery-residential-house-amazon-order-148343483.jpg';
  @override
  void initState() {
    super.initState();
    _store = allStores.firstWhere(
      (element) => element.id == widget.order.storeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeNow = DateTime.now();
    final bool isClosed = dateTimeNow.isBefore(_store.openingTime) ||
        dateTimeNow.isAfter(_store.closingTime);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          text: 'Order #${widget.order.orderNumber}',
          // weight: FontWeight.w600,
          size: AppSizes.bodySmall,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: AppSizes.horizontalPaddingSmallest),
            child: AppTextButton(
                text: 'Help',
                callback: () {
                  showInfoToast('UI not provided', context: context);
                }),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              AppFunctions.displayNetworkImage(
                _store.cardImage,
                width: double.infinity,
                fit: BoxFit.cover,
                height: 120,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 5),
                child: AppButton2(
                    backgroundColor: Colors.white,
                    text: 'View store',
                    callback: () async {
                      await AppFunctions.navigateToStoreScreen(_store);
                    }),
              )
            ],
          ),
          if (isClosed)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              width: double.infinity,
              color: AppColors.neutral200,
              child: AppText(
                  text:
                      'Opens at ${AppFunctions.formatDate(_store.openingTime.toString(), format: 'h:i A')}'),
            ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: _store.name,
                  weight: FontWeight.w600,
                  size: AppSizes.heading6,
                ),
                Row(
                  children: [
                    AppText(
                      text: 'Order ${widget.order.status.toLowerCase()}',
                      color: widget.order.status == 'Completed'
                          ? Colors.green
                          : Colors.amber.shade400,
                    ),
                    AppText(
                        color: AppColors.neutral500,
                        text:
                            ' • ${AppFunctions.formatDate(widget.order.deliveryDate.toString(), format: r'D, M j')} at ${AppFunctions.formatDate(widget.order.deliveryDate.toString(), format: 'g:i A')}')
                  ],
                ),
                const Gap(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(
                      text: 'Your order',
                      size: AppSizes.heading6,
                      weight: FontWeight.w600,
                    ),
                    AppButton2(
                      text: 'Rate and tip',
                      callback: () {
                        showInfoToast('UI not provided', context: context);
                      },
                    ),
                  ],
                ),
                const Gap(10),
                ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: widget.order.products.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = widget.order.products[index];
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          color: AppColors.neutral200,
                          child: AppText(text: item.quantity.toString()),
                        ),
                        const Gap(5),
                        FutureBuilder<Product>(
                            future: AppFunctions.loadProductReference(
                                FirebaseFirestore.instance
                                    .collection(FirestoreCollections.products)
                                    .doc(item.id)),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final product = snapshot.data!;
                                return AppText(text: product.name);
                              } else if (snapshot.hasError) {
                                return AppText(
                                  text: snapshot.error.toString(),
                                );
                              } else {
                                return const Skeletonizer(
                                  child: AppText(
                                      text: 'nlajajojafsdojklfasjskljasflnkj'),
                                );
                              }
                            })
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const Gap(10),
          if (widget.order.tip != 0)
            Column(
              children: [
                ListTile(
                  leading: const Iconify(Mdi.hand_coin_outline),
                  title: AppText(
                      text: 'Tip: ${widget.order.tip.toStringAsFixed(2)}'),
                ),
                const Divider(
                  indent: 40,
                )
              ],
            ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: AppText(
                text: 'Total: ${widget.order.totalFee.toStringAsFixed(2)}'),
          ),
          const Divider(
            indent: 40,
          ),
          ListTile(
            leading: AppFunctions.displayNetworkImage(
              doorStepImage,
              width: 30,
              fit: BoxFit.cover,
              height: 30,
            ),
            title: AppText(text: 'Your delivery by ${widget.order.courier}'),
            trailing: AppButton2(
                text: 'View',
                callback: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
                          child: Stack(
                            alignment: AlignmentDirectional.topStart,
                            children: [
                              AppFunctions.displayNetworkImage(doorStepImage),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                child: InkWell(
                                  onTap: navigatorKey.currentState!.pop,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
          const Divider(
            indent: 10,
          ),
          const Gap(5),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const AppText(
              text: 'What delivery people see',
              weight: FontWeight.w600,
            ),
            subtitle: const AppText(
              text: 'We limit which info they can view about you',
              color: AppColors.neutral500,
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.neutral500,
            ),
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const WhatDeliveryPeopleSeeScreen(),
              ));
            },
          ),
          const Gap(40),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                AppButton(
                  text: 'View receipt',
                  isSecondary: true,
                  callback: () {
                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => ReceiptScreen(
                        order: widget.order,
                        store: _store,
                      ),
                    ));
                  },
                ),
                const Gap(10),
                AppButton(
                  text: 'Get help',
                  isSecondary: true,
                  callback: () {
                    showInfoToast('UI not provided', context: context);
                  },
                ),
              ],
            ),
          ),
          const Gap(10)
        ],
      ),
    );
  }
}
