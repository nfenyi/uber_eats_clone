import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/orders_screen.dart';
import 'package:uber_eats_clone/presentation/features/grocery_store/screens/grocery_store_screens.dart';
import 'package:uber_eats_clone/presentation/features/group_order/group_order_screen.dart';
import 'package:uber_eats_clone/presentation/features/promotion/promo_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/payment_method_screen.dart';
import 'package:uber_eats_clone/presentation/features/store/store_screen.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../home/home_screen.dart';

class CartsScreen extends ConsumerStatefulWidget {
  const CartsScreen({super.key});

  @override
  ConsumerState<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends ConsumerState<CartsScreen> {
  final List<IndividualOrder> _individualOrders = [
    IndividualOrder(
        orderNumber: '372932',
        status: 'Completed',
        totalFee: 58.6,
        store: stores[6],
        productsAndQuantities: {
          stores[6].productCategories.first.products.first: 2,
          stores[6].productCategories.first.products.last: 2,
        },
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        tip: 0.5,
        courier: 'Sally',
        promo: Promotion(
            discount: 3.5,
            description: 'njanndfknald',
            applicableLocation: '1226 University Dr',
            expirationDate: DateTime.now().add(const Duration(days: 2))),
        serviceFee: 2.4,
        tax: 0.4,
        caDriverBenefits: 0.2,
        deliveryFee: 5,
        membershipBenefit: 4.3,
        payments: [
          Payment(
              datePaid: DateTime.now(),
              cardNumber: '383934',
              paymentMethod:
                  PaymentMethod('Mastercard', AssetNames.masterCardLogo),
              amountPaid: 50)
        ])
  ];

  final List<GroupOrder> _groupOrders = [
    GroupOrder(
        repeat: 'Monthly',
        name: 'Havanna unana',
        createdBy: 'Nana',
        location: '1226 University Dr',
        stores: [
          stores[6],
          stores[7]
        ],
        orderSchedules: [
          OrderSchedule(
              orderNumber: '9240230',
              status: 'Ongoing',
              totalFee: 35,
              deliveryDate: DateTime.now().add(const Duration(days: 1)),
              store: stores[6],
              orderItems: [
                OrderItem(
                  person: 'Nana',
                  productsAndQuantities: {
                    stores[6].productCategories.first.products.first: 2,
                    stores[6].productCategories.first.products.last: 2,
                  },
                ),
                OrderItem(
                  person: 'Clement',
                  productsAndQuantities: {
                    stores[6].productCategories.first.products.last: 2,
                  },
                ),
              ],
              courier: 'Courier',
              serviceFee: 0.00,
              tax: 1,
              deliveryFee: 0.00,
              payments: [
                Payment(
                    datePaid: DateTime.now(),
                    cardNumber: '555615616',
                    paymentMethod: PaymentMethod('Venmo', AssetNames.venmoLogo),
                    amountPaid: 69)
              ]),
        ],
        persons: [
          'Kwame',
          'Nana',
          'Mark'
        ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    expandedHeight: 80,
                    pinned: true,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      // titlePadding: const EdgeInsets.only(
                      //     left: AppSizes.horizontalPaddingSmall),
                      centerTitle: true,
                      title: const AppText(
                        text: 'Carts',
                        size: AppSizes.heading6,
                        weight: FontWeight.w600,
                      ),
                      background: Padding(
                        padding: const EdgeInsets.only(
                            right: AppSizes.horizontalPaddingSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => navigatorKey.currentState!
                                  .push(MaterialPageRoute(
                                builder: (context) => const OrdersScreen(),
                              )),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: AppColors.neutral100,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Row(
                                  children: [
                                    Icon(Icons.list),
                                    Gap(5),
                                    AppText(text: 'Orders'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: CustomScrollView(
                slivers: [
                  SliverList.separated(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      final store = stores[index];
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.neutral300)),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                    text: store.name,
                                    weight: FontWeight.w600,
                                    size: AppSizes.bodySmall,
                                  ),
                                  GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.more_horiz,
                                        color: AppColors.neutral500,
                                      ))
                                ],
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CachedNetworkImage(
                                    imageUrl: store.cardImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              subtitle: AppText(
                                  text:
                                      '3 items • \$11.79\n Deliver by ${AppFunctions.formatDate(DateTime.now().toString(), format: r'g:i A')} to 1226 University Dr'),
                            ),
                            const Gap(10),
                            AppButton(
                              text: 'View cart',
                              callback: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: double.infinity,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppBar(
                                            leading: GestureDetector(
                                                onTap: () => navigatorKey
                                                    .currentState!
                                                    .pop(),
                                                child: const Icon(Icons.clear)),
                                            actions: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: AppSizes
                                                        .horizontalPaddingSmall),
                                                child: InkWell(
                                                    child: Ink(
                                                        child: const Icon(Icons
                                                            .person_add_outlined))),
                                              )
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: AppSizes
                                                                .horizontalPaddingSmall),
                                                        child: AppText(
                                                          text: store.name,
                                                          weight:
                                                              FontWeight.w600,
                                                          size: AppSizes.body,
                                                        ),
                                                      ),
                                                      ListView.separated(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final product = store
                                                                .productCategories
                                                                .first
                                                                .products[index];
                                                            return ListTile(
                                                              trailing:
                                                                  Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .neutral100,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    InkWell(
                                                                        child:
                                                                            Ink(
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .delete_outline,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    )),
                                                                    const Gap(
                                                                        10),
                                                                    const AppText(
                                                                        text:
                                                                            '1'),
                                                                    const Gap(
                                                                        10),
                                                                    InkWell(
                                                                        child:
                                                                            Ink(
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                              // contentPadding:
                                                              //     EdgeInsets
                                                              //         .zero,
                                                              leading: SizedBox(
                                                                width: 60,
                                                                height: 60,
                                                                child: CachedNetworkImage(
                                                                    imageUrl: product
                                                                        .imageUrls
                                                                        .first),
                                                              ),
                                                              title: AppText(
                                                                text: product
                                                                    .name,
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                                size: AppSizes
                                                                    .bodySmall,
                                                              ),
                                                              subtitle: Column(
                                                                children: [
                                                                  const Row(
                                                                    children: [
                                                                      AppText(
                                                                        text:
                                                                            'Selected Option: ',
                                                                        weight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                      AppText(
                                                                        text:
                                                                            'njajnasaojoajkaj ',
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Row(
                                                                    children: [
                                                                      AppText(
                                                                        text:
                                                                            'Selected Drink: ',
                                                                        weight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                      AppText(
                                                                        text:
                                                                            'njajnasaojoajkaj ',
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  if (product
                                                                          .options !=
                                                                      null)
                                                                    const Row(
                                                                      children: [
                                                                        AppText(
                                                                          text:
                                                                              'nkanknasjn Comes With ',
                                                                          weight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                        AppText(
                                                                          text:
                                                                              'Ice',
                                                                        ),
                                                                      ],
                                                                    ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (context,
                                                                      index) =>
                                                                  const Gap(10),
                                                          itemCount: store
                                                              .productCategories
                                                              .first
                                                              .products
                                                              .length),
                                                      const Gap(10),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: AppSizes
                                                                .horizontalPaddingSmall),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {},
                                                              child: Ink(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .neutral100,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child:
                                                                    const Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.add,
                                                                      size: 15,
                                                                    ),
                                                                    Gap(10),
                                                                    AppText(
                                                                        text:
                                                                            'Add items'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 2),
                                                        decoration: const BoxDecoration(
                                                            border: Border.symmetric(
                                                                vertical: BorderSide(
                                                                    width: 2,
                                                                    color: AppColors
                                                                        .neutral200))),
                                                        child: ListTile(
                                                          onTap: () {},
                                                          leading:
                                                              const Iconify(
                                                                  Ph.gift),
                                                          title: const AppText(
                                                              text:
                                                                  'Send as a gift'),
                                                          subtitle:
                                                              const AppText(
                                                            text:
                                                                'And customize a digital card',
                                                            color: AppColors
                                                                .neutral500,
                                                          ),
                                                          trailing: const Icon(Icons
                                                              .keyboard_arrow_right),
                                                        ),
                                                      ),
                                                      const ListTile(
                                                        title: AppText(
                                                          text: 'Subtotal',
                                                          weight:
                                                              FontWeight.w600,
                                                          size: AppSizes
                                                              .bodySmall,
                                                        ),
                                                        trailing: AppText(
                                                            size: AppSizes
                                                                .bodySmall,
                                                            weight:
                                                                FontWeight.w600,
                                                            text: 'US\$ 24.13'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .amber.shade100),
                                                      child: ListTile(
                                                        leading: Image.asset(
                                                          AssetNames
                                                              .uberOneSmall,
                                                          width: 20,
                                                          color: Colors.brown,
                                                        ),
                                                        subtitle: AppText(
                                                          color: Colors
                                                              .brown.shade500,
                                                          text:
                                                              'Add \$20.99 to save more with Uber One',
                                                          size: AppSizes
                                                              .bodySmallest,
                                                        ),
                                                        title: AppText(
                                                            color: Colors
                                                                .brown.shade500,
                                                            text:
                                                                'Saving \$0.14 with Uber One'),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.brown),
                                                      child: ListTile(
                                                        leading: Image.asset(
                                                          AssetNames
                                                              .uberOneSmall,
                                                          width: 20,
                                                          color: Colors.white,
                                                        ),
                                                        title: const AppText(
                                                            color: Colors.white,
                                                            text:
                                                                'Saving \$0.14 with Uber One'),
                                                      ),
                                                    ),
                                                    const Gap(10),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: AppSizes
                                                              .horizontalPaddingSmall),
                                                      child: AppButton(
                                                        text: 'Go to checkout',
                                                        callback: () {},
                                                      ),
                                                    ),
                                                    const Gap(10),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const Gap(10),
                            AppButton(
                              callback: () {},
                              text: 'View store',
                              isSecondary: true,
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Gap(15),
                  ),
                  const SliverGap(15),
                  SliverList.separated(
                    itemCount: _groupOrders.length,
                    itemBuilder: (context, index) {
                      final groupOrder = _groupOrders[index];
                      final nextOrder =
                          groupOrder.orderSchedules.firstWhereOrNull(
                        (element) {
                          return !element.deliveryDate
                              .difference(DateTime.now())
                              .isNegative;
                        },
                      );
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.neutral300)),
                        child: Column(
                          children: [
                            ListTile(
                              minLeadingWidth: 45,
                              contentPadding: EdgeInsets.zero,
                              //cart item.stores == 1 ? name of store : $userlocation.name orders
                              title: AppText(
                                text: groupOrder.stores.length == 1
                                    ? groupOrder.stores.first.name
                                    : groupOrder.name,
                                weight: FontWeight.w600,
                                size: AppSizes.bodySmall,
                              ),
                              leading: groupOrder.stores.length > 1
                                  ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: groupOrder
                                                    .stores.first.cardImage,
                                                width: 30,
                                                height: 30,
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                color: Colors.black38,
                                                width: 30,
                                                height: 30,
                                                child: const Icon(
                                                  Icons.group_outlined,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Transform.translate(
                                            offset: const Offset(15, 15),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Colors.white)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: groupOrder
                                                          .stores
                                                          .first
                                                          .cardImage,
                                                      width: 30,
                                                      height: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Container(
                                                      color: Colors.black38,
                                                      width: 30,
                                                      height: 30,
                                                      child: const Icon(
                                                        Icons.group_outlined,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Stack(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: groupOrder
                                                .stores.first.cardImage,
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

                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (groupOrder.repeat != null)
                                    Row(
                                      children: [
                                        Row(children: [
                                          const Icon(
                                            Icons.refresh,
                                            size: 15,
                                          ),
                                          const Gap(5),
                                          AppText(
                                            text: groupOrder.repeat!,
                                          ),
                                          const AppText(
                                            text: ' • ',
                                          ),
                                        ]),
                                        AppText(
                                            text: groupOrder.stores.length == 1
                                                ? groupOrder.name
                                                : 'Created by ${groupOrder.createdBy}')
                                      ],
                                    ),
                                  if (nextOrder != null)
                                    Row(
                                      children: [
                                        const AppText(
                                          text: 'Next order: ',
                                          color: Colors.green,
                                          size: AppSizes.bodySmallest,
                                        ),
                                        AppText(
                                          text: AppFunctions.formatDate(
                                              nextOrder.deliveryDate.toString(),
                                              format: 'M j'),
                                          size: AppSizes.bodySmallest,
                                        ),
                                        const AppText(
                                          text: ' by ',
                                          size: AppSizes.bodySmallest,
                                        ),
                                        AppText(
                                          text: AppFunctions.formatDate(
                                              nextOrder.deliveryDate.toString(),
                                              format: 'g:i A'),
                                          size: AppSizes.bodySmallest,
                                        ),
                                      ],
                                    ),
                                  //deadline == null ?AppText(text: '')
                                ],
                              ),
                            ),
                            const Gap(10),
                            AppButton(
                              text: groupOrder.stores.length == 1
                                  ? 'View order'
                                  : 'View orders',
                              callback: () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) =>
                                      GroupOrderScreen(groupOrder: groupOrder),
                                ));
                              },
                            ),
                            if (groupOrder.stores.length == 1)
                              Column(
                                children: [
                                  const Gap(10),
                                  AppButton(
                                    callback: () {
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return groupOrder.stores.first.type
                                                  .contains('Grocery')
                                              ? GroceryStoreMainScreen(
                                                  groupOrder.stores.first)
                                              : StoreScreen(
                                                  groupOrder.stores.first);
                                        },
                                      ));
                                    },
                                    text: 'View store',
                                    isSecondary: true,
                                  ),
                                ],
                              )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Gap(15),
                  )
                ],
              ),
            )));
  }
}
