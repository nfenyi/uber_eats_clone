import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../../../main.dart';
import '../../../../models/order/order_model.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';

class ReceiptScreen extends StatefulWidget {
  final IndividualOrder order;
  const ReceiptScreen({super.key, required this.order});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  late final List<String> _receiptOptions;
  late String _selectedReceipt;
  late Store _store;

  @override
  void initState() {
    super.initState();
    if (widget.order.tip != null) {
      _receiptOptions = ['Receipt including tip', 'Original receipt'];
    } else {
      _receiptOptions = ['Original receipt'];
    }
    _selectedReceipt = _receiptOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = 0;
    return Scaffold(
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    title: AppText(
                      text: 'Receipt',
                      size: AppSizes.heading6,
                      // weight: FontWeight.w600,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverToBoxAdapter(
                    child: ListTile(
                      onTap: _receiptOptions.length == 1
                          ? null
                          : () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _receiptOptions.map(
                                        (option) {
                                          return ListTile(
                                            onTap: () {
                                              setState(() {
                                                _selectedReceipt = option;
                                              });
                                              navigatorKey.currentState!.pop();
                                            },
                                            title: AppText(text: option),
                                            trailing: _selectedReceipt == option
                                                ? const Icon(Icons.check)
                                                : null,
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  );
                                },
                              );
                            },
                      minTileHeight: 50,
                      trailing: const Icon(Icons.keyboard_arrow_down),
                      title: AppText(
                        text: _selectedReceipt,
                        color: _receiptOptions.length == 1
                            ? AppColors.neutral300
                            : null,
                      ),
                      tileColor: AppColors.neutral100,
                    ),
                  ),
                )
              ],
          body: FutureBuilder(
              future: _getData(),
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 500,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        AppText(
                                          text: 'Uber ',
                                          size: AppSizes.heading6,
                                        ),
                                        AppText(
                                          text: 'Eats',
                                          weight: FontWeight.w600,
                                          size: AppSizes.heading6,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            const AppText(text: 'Total '),
                                            AppText(
                                                weight: FontWeight.w600,
                                                text:
                                                    'US\$${widget.order.totalFee.toStringAsFixed(2)}'),
                                          ],
                                        ),
                                        AppText(
                                            text: AppFunctions.formatDate(
                                                widget.order.deliveryDate
                                                    .toString(),
                                                format: 'n F Y'))
                                      ],
                                    )
                                  ],
                                ),
                                const Gap(40),
                                AppText(
                                  text: _selectedReceipt ==
                                          'Receipt including tip'
                                      ? 'Thanks for tipping, Nana'
                                      : 'Thanks for being an Uber One member, Nana',
                                  size: AppSizes.heading2,
                                  // weight: FontWeight.w600,
                                ),
                                const Gap(20),
                                AppText(
                                    size: AppSizes.bodySmall,
                                    text:
                                        "Here's your updated receipt for ${_store.name} (${_store.location.streetAddress.split(', ')[1]})"),
                              ],
                            ),
                            //TODO; Implement receipt background
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const AppText(
                                      text: 'Total',
                                      size: AppSizes.heading4,
                                    ),
                                    AppText(
                                        size: AppSizes.heading4,
                                        text:
                                            'US\$${_selectedReceipt == 'Receipt including tip' ? widget.order.totalFee.toStringAsFixed(2) : _receiptOptions.length == 1 ? widget.order.totalFee : (widget.order.totalFee - widget.order.tip!)}')
                                  ],
                                ),
                                const Gap(10),
                                if (widget.order.promoApplied != null)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        AssetNames.uberOneSmall,
                                        width: 15,
                                        height: 20,
                                      ),
                                      FutureBuilder(
                                          future:
                                              AppFunctions.loadPromoReference(
                                                  widget.order.promoApplied
                                                      as DocumentReference),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final promo = snapshot.data!;
                                              return Flexible(
                                                child: AppText(
                                                    size: AppSizes.bodySmall,
                                                    text:
                                                        ' You saved US\$${(promo.discount / 100) * widget.order.totalFee} on this order with Uber One and promos'),
                                              );
                                            } else if (snapshot.hasError) {
                                              return AppText(
                                                  text: snapshot.error
                                                      .toString());
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          })
                                    ],
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                      // ListView.builder(
                      //   padding: EdgeInsets.zero,
                      //   itemCount: widget.order.productsAndQuantities.length,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   itemBuilder: (context, index) {
                      //     final productNQuantity = widget
                      //         .order.productsAndQuantities.entries
                      //         .elementAt(index);
                      //     subtotal += (productNQuantity.key.promoPrice ??
                      //             productNQuantity.key.initialPrice) *
                      //         productNQuantity.value;
                      //     logger.d(subtotal);
                      //     // logger.d(productNQuantity.key.initialPrice);
                      //     return ListTile(
                      //       // dense: true,
                      //       subtitle: productNQuantity.key.options != null
                      //           ? Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 ListView.builder(
                      //                   padding: EdgeInsets.zero,
                      //                   itemBuilder: (context, index) {
                      //                     final option =
                      //                         productNQuantity.key.options![index];
                      //                     if (option.price != null) {
                      //                       subtotal += option.price!;
                      //                       logger.d(subtotal);
                      //                     }
                      //                     if (option.subOptions?.first.price !=
                      //                         null) {
                      //                       subtotal +=
                      //                           option.subOptions!.first.price!;
                      //                       logger.d(subtotal);
                      //                     }
                      //                     return Column(
                      //                       children: [
                      //                         const AppText(text: 'Select Option'),
                      //                         AppText(
                      //                           text:
                      //                               '${option.name} US\$${option.price ?? 0.00}',
                      //                           color: AppColors.neutral500,
                      //                         ),
                      //                         if (option.subOptions != null)
                      //                           AppText(
                      //                             text: '${option.name} Comes With',
                      //                           ),
                      //                         AppText(
                      //                           text:
                      //                               '${option.subOptions!.first.name} US\$${option.subOptions?.first.price ?? 0.00}',
                      //                           color: AppColors.neutral500,
                      //                         ),
                      //                       ],
                      //                     );
                      //                   },
                      //                   itemCount:
                      //                       productNQuantity.key.options!.length,
                      //                 )
                      //               ],
                      //             )
                      //           : null,
                      //       leading: Container(
                      //         padding: const EdgeInsets.all(5),
                      //         color: AppColors.neutral100,
                      //         child: AppText(text: productNQuantity.value.toString()),
                      //       ),
                      //       title: AppText(
                      //         text: productNQuantity.key.name,
                      //         weight: FontWeight.w600,
                      //         size: AppSizes.bodySmaller,
                      //       ),
                      //       trailing: Column(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           AppText(
                      //               color: AppColors.neutral600,
                      //               text:
                      //                   'US\$${((productNQuantity.key.promoPrice ?? productNQuantity.key.initialPrice) * productNQuantity.value).toStringAsFixed(2)}'),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),

                      const Divider(),
                      const Gap(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  size: AppSizes.bodySmall,
                                  text: 'Subtotal',
                                  weight: FontWeight.w600,
                                ),
                                AppText(
                                  size: AppSizes.bodySmall,
                                  text: 'US\$${subtotal.toStringAsFixed(2)}',
                                  weight: FontWeight.w600,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  size: AppSizes.bodySmall,
                                  text: 'Service Fee',
                                ),
                                AppText(
                                  size: AppSizes.bodySmall,
                                  text:
                                      'US\$${widget.order.serviceFee.toStringAsFixed(2)}',
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  size: AppSizes.bodySmall,
                                  text: 'Tax',
                                ),
                                AppText(
                                  size: AppSizes.bodySmall,
                                  text:
                                      'US\$${(widget.order.tax / 100) * subtotal}',
                                )
                              ],
                            ),
                            if (widget.order.caDriverBenefits != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const AppText(
                                    size: AppSizes.bodySmall,
                                    text: 'CA Driver Benefits',
                                  ),
                                  AppText(
                                    size: AppSizes.bodySmall,
                                    text:
                                        'US\$${widget.order.caDriverBenefits!.toStringAsFixed(2)}',
                                  )
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  size: AppSizes.bodySmall,
                                  text: 'Delivery Fee',
                                ),
                                AppText(
                                  size: AppSizes.bodySmall,
                                  text:
                                      'US\$${widget.order.deliveryFee.toStringAsFixed(2)}',
                                )
                              ],
                            ),
                            if (widget.order.tip != null &&
                                _selectedReceipt == 'Receipt including tip')
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const AppText(
                                    size: AppSizes.bodySmall,
                                    text: 'Tip',
                                  ),
                                  AppText(
                                    size: AppSizes.bodySmall,
                                    text:
                                        'US\$${widget.order.tip!.toStringAsFixed(2)}',
                                  )
                                ],
                              ),
                            if (widget.order.membershipBenefit != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const AppText(
                                    size: AppSizes.bodySmall,
                                    text: 'Membership Benefit',
                                  ),
                                  AppText(
                                    size: AppSizes.bodySmall,
                                    color: Colors.green,
                                    text:
                                        '-US\$${widget.order.membershipBenefit!.toStringAsFixed(2)}',
                                  )
                                ],
                              ),
                            const Gap(10),
                            const Divider(),
                            const Gap(10),
                            const AppText(
                              size: AppSizes.bodySmall,
                              text: 'Payments',
                              weight: FontWeight.w600,
                            ),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: widget.order.payments.length,
                              itemBuilder: (context, index) {
                                final payment = widget.order.payments[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  // leading: Image.asset(
                                  //   payment.paymentMethodId.assetImage,
                                  //   width: 20,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  subtitle: AppText(
                                      text: AppFunctions.formatDate(
                                          payment.datePaid.toString(),
                                          format: 'd/m/Y h:i A')),
                                  trailing: AppText(
                                      weight: FontWeight.w600,
                                      text:
                                          'US\$${payment.amountPaid.toStringAsFixed(2)}'),
                                  // title: AppText(
                                  //     weight: FontWeight.w600,
                                  //     text:
                                  //         '${payment.paymentMethodId.name} ••••${payment.cardNumber.substring(4)}'),
                                );
                              },
                            ),
                            const Divider(),
                            const Gap(20),
                            const AppText(
                                text:
                                    'Uber charges the merchant certain fees and/or costs in connection with the provision of our services.')
                          ],
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        dense: true,
                        onTap: () {},
                        leading: const Iconify(Ph.money),
                        title: const AppText(
                          text: 'Switch payment method',
                          weight: FontWeight.w600,
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      const Divider(
                        indent: 50,
                      ),
                      ListTile(
                        dense: true,
                        onTap: () {},
                        leading: const Icon(Icons.cloud_download_outlined),
                        title: const AppText(
                          text: 'Download PDF',
                          weight: FontWeight.w600,
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      const Divider(
                        indent: 50,
                      ),
                      ListTile(
                        dense: true,
                        onTap: () {},
                        leading: const Iconify(Mdi.briefcase_outline),
                        title: const AppText(
                          text: 'Automate business expensing',
                          weight: FontWeight.w600,
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      const Divider(
                        indent: 50,
                      ),
                      ListTile(
                        dense: true,
                        onTap: () {},
                        leading: const Icon(Icons.mail_outline),
                        title: const AppText(
                          text: 'Resend email',
                          weight: FontWeight.w600,
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      const Divider(
                        indent: 50,
                      ),
                      ListTile(
                        dense: true,
                        onTap: () {},
                        leading: const Icon(Icons.help_outline),
                        title: const AppText(
                          text: 'Get help',
                          weight: FontWeight.w600,
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      const Divider(
                        indent: 50,
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Future<void> _getData() async {}
}
