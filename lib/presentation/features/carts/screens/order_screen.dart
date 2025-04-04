import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/receipt_screen.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/what_delivery_people_see_screen.dart';

import '../../../../main.dart';
import '../../../../models/order/order_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../core/app_text.dart';
import '../../address/screens/addresses_screen.dart';

class OrderScreen extends StatefulWidget {
  final IndividualOrder order;
  const OrderScreen({super.key, required this.order});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
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
            child: AppTextButton(text: 'Help', callback: () {}),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CachedNetworkImage(
                imageUrl: widget.order.store.cardImage,
                width: double.infinity,
                fit: BoxFit.cover,
                height: 120,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 5),
                child: AppButton2(text: 'View store', callback: () {}),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            width: double.infinity,
            color: AppColors.neutral200,
            child: AppText(
                text:
                    'Opens at ${AppFunctions.formatDate(widget.order.store.openingTime.toString(), format: 'h:i A')}'),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: widget.order.store.name,
                  weight: FontWeight.w600,
                  size: AppSizes.heading6,
                ),
                Row(
                  children: [
                    AppText(
                      text: 'Order ${widget.order.status.toLowerCase()}',
                      color: widget.order.status == 'Completed'
                          ? Colors.green
                          : Colors.yellow,
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
                      // height: 40,
                      text: 'Rate and tip',
                      callback: () {},
                      // isSecondary: true,
                      // width: 100,
                      // borderRadius: 30,
                    ),
                  ],
                ),
                const Gap(10),
                ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: widget.order.productsAndQuantities.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = widget.order.productsAndQuantities.entries
                        .elementAt(index);
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          color: AppColors.neutral200,
                          child: AppText(text: item.value.toString()),
                        ),
                        const Gap(5),
                        // AppText(text: item.key.name)
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const Gap(10),
          if (widget.order.tip != null)
            Column(
              children: [
                ListTile(
                  leading: const Iconify(Mdi.hand_coin_outline),
                  title: AppText(
                      text: 'Tip: ${widget.order.tip!.toStringAsFixed(2)}'),
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
            leading: CachedNetworkImage(
              imageUrl:
                  'https://dam.thdstatic.com/content/production/X2d7RXQ3KZQC6EVZ4rz-vQ/qV9oNkYuOPkyeCE-OdZcJA/Original%20file/96_SBE%202023_319614763_D.jpg?im=Resize=(920,575)',
              width: 30,
              fit: BoxFit.cover,
              height: 30,
            ),
            title: AppText(text: 'Your delivery by ${widget.order.courier}'),
            trailing: AppButton2(text: 'View', callback: () {}),
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
                      builder: (context) => ReceiptScreen(order: widget.order),
                    ));
                  },
                ),
                const Gap(10),
                AppButton(
                  text: 'Get help',
                  isSecondary: true,
                  callback: () {},
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
