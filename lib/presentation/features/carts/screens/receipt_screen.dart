import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/cib.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
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
  final Store store;
  const ReceiptScreen({
    super.key,
    required this.order,
    required this.store,
  });

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  late final List<String> _receiptOptions;
  late String _selectedReceipt;

  late final String displayName;

  @override
  void initState() {
    super.initState();
    if (widget.order.tip != 0) {
      _receiptOptions = ['Receipt including tip', 'Original receipt'];
    } else {
      _receiptOptions = ['Original receipt'];
    }
    _selectedReceipt = _receiptOptions.first;
    final userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    displayName = userInfo['displayName'].split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = 0;
    return Scaffold(
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverAppBar.medium(
                  pinned: true,
                  floating: true,
                  title: AppText(
                    text: 'Receipt',
                    size: AppSizes.heading6,
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
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        color: _receiptOptions.length == 1
                            ? AppColors.neutral500
                            : null,
                      ),
                      title: AppText(
                        text: _selectedReceipt,
                        color: _receiptOptions.length == 1
                            ? AppColors.neutral500
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
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AssetNames.receiptBackground),
                            fit: BoxFit.cover,
                          ),
                        ),
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
                                      ? 'Thanks for tipping, $displayName'
                                      : '${widget.order.membershipBenefit != null ? 'Thanks for being an Uber One member' : 'Thanks for ordering'}, $displayName',
                                  size: AppSizes.heading2,
                                  // weight: FontWeight.w600,
                                ),
                                const Gap(20),
                                AppText(
                                    size: AppSizes.bodySmall,
                                    text:
                                        "Here's your updated receipt for ${widget.store.name} (${widget.store.location.streetAddress.split(', ')[1]})"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(40),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  text: 'Total',
                                  size: AppSizes.heading4,
                                ),
                                AppText(
                                    size: AppSizes.heading4,
                                    text:
                                        'US\$${_selectedReceipt == 'Receipt including tip' ? widget.order.totalFee.toStringAsFixed(2) : _receiptOptions.length == 1 ? widget.order.totalFee : (widget.order.totalFee - widget.order.tip)}')
                              ],
                            ),
                            const Gap(10),
                            if (widget.order.promoApplied != null ||
                                widget.order.membershipBenefit != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.order.membershipBenefit != null)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          AssetNames.uberOneSmall,
                                          width: 15,
                                          height: 20,
                                        ),
                                        const Gap(3),
                                      ],
                                    ),
                                  if (widget.order.promoApplied != null)
                                    FutureBuilder(
                                        future: AppFunctions.loadPromoReference(
                                            widget.order.promoApplied
                                                as DocumentReference),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final promo = snapshot.data!;

                                            double discountAmount =
                                                promo.discount;
                                            if (widget
                                                    .order.membershipBenefit !=
                                                null) {
                                              discountAmount = widget.order
                                                      .membershipBenefit! +
                                                  discountAmount;
                                            }
                                            return AppText(
                                                size: AppSizes.bodySmall,
                                                text:
                                                    'You saved US\$${discountAmount.toStringAsFixed(2)} on this order with${widget.order.membershipBenefit != null ? ' Uber One and' : ''} promos');
                                          } else if (snapshot.hasError) {
                                            return AppText(
                                                text:
                                                    snapshot.error.toString());
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        }),
                                  if (widget.order.promoApplied == null &&
                                      widget.order.membershipBenefit != null)
                                    Builder(builder: (context) {
                                      final double discountAmount =
                                          widget.order.membershipBenefit!;
                                      return AppText(
                                          size: AppSizes.bodySmall,
                                          text:
                                              'You saved US\$${discountAmount.toStringAsFixed(2)} on this order with Uber One');
                                    }),
                                ],
                              )
                          ],
                        ),
                      ),
                      const Gap(30),
                      const Divider(),
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: widget.order.products.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final cartProduct = widget.order.products[index];
                          subtotal += (cartProduct.purchasePrice) *
                              cartProduct.quantity;

                          return ListTile(
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                    color: AppColors.neutral600,
                                    text:
                                        'US\$${((cartProduct.purchasePrice) * cartProduct.quantity).toStringAsFixed(2)}'),
                              ],
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(5),
                              color: AppColors.neutral100,
                              child: AppText(
                                  text: cartProduct.quantity.toString()),
                            ),
                            title: AppText(
                              text: cartProduct.name,
                              weight: FontWeight.w600,
                            ),
                            subtitle: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: cartProduct.requiredOptions
                                      .map(
                                        (e) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                AppText(
                                                  text: '${e.name}:',
                                                  weight: FontWeight.w600,
                                                ),
                                                if (e.options.isNotEmpty)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: e.options
                                                        .map(
                                                          (e) => Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppText(
                                                                text: e.name,
                                                              ),
                                                              Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: e
                                                                      .options
                                                                      .map(
                                                                        (e) =>
                                                                            AppText(
                                                                          text:
                                                                              e.name,
                                                                        ),
                                                                      )
                                                                      .toList()),
                                                            ],
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: cartProduct.optionalOptions
                                      .map(
                                        (e) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                AppText(
                                                  text: '${e.name}:',
                                                  weight: FontWeight.w600,
                                                ),
                                                if (e.options.isNotEmpty)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: e.options
                                                        .map(
                                                          (e) => Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppText(
                                                                text: e.name,
                                                              ),
                                                              Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: e
                                                                      .options
                                                                      .map(
                                                                        (e) =>
                                                                            AppText(
                                                                          text:
                                                                              e.name,
                                                                        ),
                                                                      )
                                                                      .toList()),
                                                            ],
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                                // if (cartProduct
                                //     .ba.isNotEmpty)
                                //   Row(
                                //     children: [
                                //       const Icon(
                                //         Icons.loop,
                                //         color: AppColors.neutral500,
                                //         size: 15,
                                //       ),
                                //       const Gap(5),
                                //       AppText(
                                //           text: cartProduct
                                //                   .backupInstruction ??
                                //               'Best match'),
                                //     ],
                                //   ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
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
                            const Gap(8),
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
                            const Gap(8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  size: AppSizes.bodySmall,
                                  text: 'Tax',
                                ),
                                AppText(
                                  size: AppSizes.bodySmall,
                                  text: 'US\$${widget.order.tax}',
                                )
                              ],
                            ),
                            if (widget.order.caDriverBenefits != 0)
                              Column(
                                children: [
                                  const Gap(8),
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
                                            'US\$${widget.order.caDriverBenefits.toStringAsFixed(2)}',
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            const Gap(8),
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
                            if (_selectedReceipt == 'Receipt including tip')
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
                                        'US\$${widget.order.tip.toStringAsFixed(2)}',
                                  )
                                ],
                              ),
                            if (widget.order.promoDiscount != null)
                              Column(
                                children: [
                                  const Gap(8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const AppText(
                                        size: AppSizes.bodySmall,
                                        text: 'Promo Discount',
                                      ),
                                      AppText(
                                        size: AppSizes.bodySmall,
                                        color: Colors.green,
                                        text:
                                            '-US\$${widget.order.promoDiscount!.toStringAsFixed(2)}',
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            if (widget.order.membershipBenefit != null)
                              Column(
                                children: [
                                  const Gap(8),
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
                                ],
                              ),
                            const Gap(10),
                            const Divider(),
                            const Gap(20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      AppSizes.horizontalPaddingSmallest),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      final payment =
                                          widget.order.payments[index];
                                      return ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        leading: ReceiptCreditCardLogo(
                                            type: payment.creditCardType),
                                        subtitle: AppText(
                                            text: AppFunctions.formatDate(
                                                payment.datePaid.toString(),
                                                format: 'd/m/Y h:i A')),
                                        trailing: AppText(
                                            weight: FontWeight.w600,
                                            text:
                                                'US\$${payment.amountPaid.toStringAsFixed(2)}'),
                                        title: AppText(
                                            weight: FontWeight.w600,
                                            text:
                                                '${payment.creditCardType}${payment.cardNumber}'),
                                      );
                                    },
                                  ),
                                  const Divider(),
                                  const Gap(20),
                                  const AppText(
                                      size: AppSizes.bodySmallest,
                                      text:
                                          'Uber charges the merchant certain fees and/or costs in connection with the provision of our services.'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: AppColors.neutral100,
                      ),
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

class ReceiptCreditCardLogo extends StatelessWidget {
  const ReceiptCreditCardLogo({
    super.key,
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    if (type.isEmpty) {
      return Image.asset(
        AssetNames.creditCard, // Assuming AssetNames is defined elsewhere
        width: 30,
        height: 20,
        fit: BoxFit.fitWidth,
      );
    }

    switch (type) {
      case 'Visa':
        return const Iconify(Logos.visa, size: 12);
      case 'American Express':
        return const Iconify(Cib.american_express, size: 12);
      case 'Discover':
        return const Iconify(Logos.discover, size: 12);
      default:
        return const Iconify(Logos.mastercard, size: 12);
    }
  }
}
