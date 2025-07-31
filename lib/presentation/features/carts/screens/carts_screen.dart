import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/hive_adapters/cart_item/cart_item_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/checkouts/reg_checkout_screen.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/orders_screen.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/screens/main_screen.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';
import 'package:uber_eats_clone/presentation/features/product/product_screen.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

import '../../../../main.dart';
import '../../../../models/group_order/group_order_model.dart';
import '../../../../models/order/order_model.dart';
import '../../../../models/promotion/promotion_model.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/other_constants.dart';
import '../../address/screens/addresses_screen.dart';
import '../../group_order/group_order_screen.dart';
import '../../group_order/group_orders_by_user_screen.dart';

class CartsScreen extends ConsumerStatefulWidget {
  const CartsScreen({super.key});

  @override
  ConsumerState<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends ConsumerState<CartsScreen> {
  // GroupOrder(
  //     repeat: 'Monthly',
  //     name: 'Havanna unana',
  //     ownerId: 'Nana',
  //     location: '1226 University Dr',
  //     storeRefs: [
  //       FirebaseFirestore.instance
  //           .collection(FirestoreCollections.stores)
  //           .doc('NazJMIA9yaUsLRjLxBGa'),
  //       FirebaseFirestore.instance
  //           .collection(FirestoreCollections.stores)
  //           .doc('NazJMIA9yaUsLRjLxBGa'),
  //     ],
  //     orderSchedules: [
  //       // OrderSchedule(
  //       //     orderNumber: '9240230',
  //       //     status: 'Ongoing',
  //       //     totalFee: 35,
  //       //     deliveryDate: DateTime.now().add(const Duration(days: 1)),

  //       //     orderItems: [
  //       //       const OrderItem(
  //       //         person: 'Nana',
  //       //         productsAndQuantities:
  //       //             {},
  //       //       ),
  //       //       OrderItem(
  //       //         person: 'Clement',
  //       //         productsAndQuantities:
  //       //             stores[2].productCategories.first.productsAndQuantities,
  //       //       ),
  //       //     ],
  //       //     courier: 'Courier',
  //       //     serviceFee: 0.00,
  //       //     tax: 1,
  //       //     deliveryFee: 0.00,
  //       //     payments: [
  //       //       Payment(
  //       //           datePaid: DateTime.now(),
  //       //           cardNumber: '555615616',
  //       //           paymentMethod: const PaymentMethod(
  //       //               name: 'Venmo', assetImage: AssetNames.venmoLogo),
  //       //           amountPaid: 69)
  //       //     ]),
  //     ],
  //     persons: [
  //       'Kwame',
  //       'Nana',
  //       'Mark'
  //     ])

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar.medium(
                    scrolledUnderElevation: 0.2,
                    shadowColor: AppColors.neutral500,
                    expandedHeight: 70,
                    pinned: true,
                    centerTitle: true,
                    floating: true,
                    title: const AppText(
                      text: 'Carts',
                      size: AppSizes.heading6,
                      weight: FontWeight.w600,
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const AppText(
                                  text: 'Carts',
                                  size: AppSizes.heading4,
                                  weight: FontWeight.w600,
                                ),
                                InkWell(
                                  onTap: () => navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => const OrdersScreen(),
                                  )),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: AppColors.neutral100,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.receipt_long),
                                        Gap(5),
                                        AppText(text: 'Orders'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(5)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<HiveCartItem>(AppBoxes.carts).listenable(),
                  builder: (context, cartsBox, child) {
                    final cartItems = cartsBox.values;
                    final userInfo =
                        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
                    final groupOrders = userInfo['groupOrders'];

                    return CustomScrollView(
                      slivers: [
                        SliverList.separated(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems.elementAt(index);
                            final store = allStores.firstWhereOrNull(
                              (store) => store.id == cartItem.storeId,
                            );
                            if (store == null) {
                              return const AppText(
                                  text: 'Seems store no longer exists');
                            }
                            if (groupOrders != null && groupOrders.isNotEmpty) {
                              groupOrders as List<String>;
                              if (groupOrders.any(
                                (element) => element.contains(store.id),
                              )) {
                                return const SizedBox.shrink();
                              }
                            }

                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.neutral300)),
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
                                            onTap: () async {
                                              await showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: ListTile(
                                                      onTap: () async {
                                                        navigatorKey
                                                            .currentState!
                                                            .pop();
                                                        for (var product
                                                            in cartItem
                                                                .products) {
                                                          await product
                                                              .delete();
                                                        }
                                                        await cartItem.delete();
                                                      },
                                                      leading: Icon(
                                                        Icons.delete,
                                                        color:
                                                            Colors.red.shade900,
                                                      ),
                                                      title: const AppText(
                                                        text: 'Clear cart',
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
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
                                        child: AppFunctions.displayNetworkImage(
                                          placeholderAssetImage:
                                              AssetNames.storeBNW,
                                          store.cardImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    subtitle: AppText(
                                        color: AppColors.neutral500,
                                        size: AppSizes.bodySmallest,
                                        text: cartItem.deliveryDate != null
                                            ? '${cartItem.products.length} items • \$${cartItem.subtotal.toStringAsFixed(2)}\n Deliver by ${AppFunctions.formatDate(cartItem.deliveryDate.toString(), format: r'g:i A')} to ${AppFunctions.formatPlaceDescription(cartItem.placeDescription)}'
                                            : '${cartItem.products.length} items • \$${cartItem.subtotal.toStringAsFixed(2)}\n Deliver to ${AppFunctions.formatPlaceDescription(cartItem.placeDescription)}'),
                                  ),
                                  const Gap(10),
                                  AppButton(
                                    text: 'View cart',
                                    callback: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        barrierColor: Colors.transparent,
                                        context: context,
                                        builder: (context) {
                                          return CartSheet(
                                            store: store,
                                            cartItem: cartItem,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  const Gap(10),
                                  AppButton(
                                    callback: () async {
                                      await AppFunctions.navigateToStoreScreen(
                                          increaseVisitCount: false, store);
                                    },
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
                        FutureBuilder<Map<String, List<GroupOrder>>>(
                            future: _prepareGroupOrders(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final groupOrdersByUser = snapshot.data!;
                                if (groupOrdersByUser.values.isEmpty &&
                                    cartItems.isEmpty) {
                                  return SliverToBoxAdapter(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Gap(30),
                                      Image.asset(
                                        AssetNames.noCarts,
                                        width: 220,
                                      ),
                                      const Gap(20),
                                      SizedBox(
                                        width: Adaptive.w(80),
                                        child: const AppText(
                                            textAlign: TextAlign.center,
                                            text:
                                                'Once you add items from a restaurant or store, your cart will appear here'),
                                      ),
                                      const Gap(10),
                                      AppButton2(
                                        backgroundColor: Colors.black,
                                        callback: () {
                                          ref
                                              .read(bottomNavIndexProvider
                                                  .notifier)
                                              .updateIndex(0);
                                        },
                                        text: 'Start shopping',
                                        textColor: Colors.white,
                                      )
                                    ],
                                  ));
                                }
                                return SliverList.separated(
                                  itemCount: groupOrdersByUser.length,
                                  itemBuilder: (context, index) {
                                    final groupOrders = groupOrdersByUser.values
                                        .elementAt(index);

                                    return FutureBuilder<List>(
                                        future: _getOrderSchedulesAndStores(
                                            groupOrders),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final futureOrderSchedules =
                                                snapshot.data![0]
                                                    as List<OrderSchedule>;
                                            final stores = snapshot.data![1]
                                                as List<Store>;

                                            return Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: AppColors
                                                          .neutral300)),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    minLeadingWidth: 45,
                                                    title: AppText(
                                                      text: stores.length == 1
                                                          ? stores.first.name
                                                          : '${groupOrders.first.placeDescription} Group Orders',
                                                      weight: FontWeight.w600,
                                                    ),
                                                    leading: stores.length > 1
                                                        ? Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                child: Stack(
                                                                  children: [
                                                                    AppFunctions
                                                                        .displayNetworkImage(
                                                                      stores[1]
                                                                          .cardImage,
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    Container(
                                                                      color: Colors
                                                                          .black38,
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .group_outlined,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Transform
                                                                  .translate(
                                                                      offset:
                                                                          const Offset(
                                                                              15,
                                                                              15),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(50),
                                                                            border: Border.all(width: 4, color: Colors.white)),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(50),
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              AppFunctions.displayNetworkImage(
                                                                                stores[0].cardImage,
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
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            child: Stack(
                                                              children: [
                                                                AppFunctions
                                                                    .displayNetworkImage(
                                                                  stores.first
                                                                      .cardImage,
                                                                  width: 50,
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                Container(
                                                                  color: Colors
                                                                      .black38,
                                                                  width: 50,
                                                                  height: 50,
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .group_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Builder(
                                                            builder: (context) {
                                                          final repeatingGroupOrders =
                                                              groupOrders.where(
                                                            (groupOrder) =>
                                                                groupOrder
                                                                    .frequency !=
                                                                null,
                                                          );

                                                          return Row(
                                                            children: [
                                                              if (repeatingGroupOrders
                                                                  .isNotEmpty)
                                                                Row(children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .refresh,
                                                                    size: 15,
                                                                  ),
                                                                  AppText(
                                                                    text:
                                                                        ' ${repeatingGroupOrders.first.frequency}',
                                                                    size: AppSizes
                                                                        .bodySmallest,
                                                                  ),
                                                                  const AppText(
                                                                    text: ' • ',
                                                                  ),
                                                                ]),
                                                              groupOrders.length ==
                                                                      1
                                                                  ? AppText(
                                                                      text: groupOrders
                                                                          .first
                                                                          .name)
                                                                  : FutureBuilder<
                                                                          String>(
                                                                      future: _getOwnerName(
                                                                          groupOrders
                                                                              .first),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (snapshot
                                                                            .hasData) {
                                                                          return AppText(
                                                                              text: 'Created by ${snapshot.data}');
                                                                        } else {
                                                                          return const AppText(
                                                                              text: '...');
                                                                        }
                                                                      })
                                                            ],
                                                          );
                                                        }),
                                                        if (futureOrderSchedules
                                                            .isNotEmpty)
                                                          futureOrderSchedules
                                                                      .length ==
                                                                  1
                                                              ? Row(
                                                                  children: [
                                                                    const AppText(
                                                                      text:
                                                                          'Next order: ',
                                                                      color: Colors
                                                                          .green,
                                                                      size: AppSizes
                                                                          .bodySmallest,
                                                                    ),
                                                                    AppText(
                                                                      text: AppFunctions.formatDate(
                                                                          futureOrderSchedules
                                                                              .first
                                                                              .orderDate
                                                                              .toString(),
                                                                          format:
                                                                              'M j'),
                                                                      size: AppSizes
                                                                          .bodySmallest,
                                                                    ),
                                                                    const AppText(
                                                                      text:
                                                                          ' by ',
                                                                      size: AppSizes
                                                                          .bodySmallest,
                                                                    ),
                                                                    AppText(
                                                                      text: AppFunctions.formatDate(
                                                                          futureOrderSchedules
                                                                              .first
                                                                              .orderDate
                                                                              .toString(),
                                                                          format:
                                                                              'g:i A'),
                                                                      size: AppSizes
                                                                          .bodySmallest,
                                                                    ),
                                                                  ],
                                                                )
                                                              : AppText(
                                                                  text:
                                                                      '${futureOrderSchedules.length} upcoming orders',
                                                                  color: Colors
                                                                      .green,
                                                                  size: AppSizes
                                                                      .bodySmallest,
                                                                ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Gap(10),
                                                  groupOrders.length == 1
                                                      ? AppButton(
                                                          text: 'View order',
                                                          callback: () {
                                                            navigatorKey
                                                                .currentState!
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GroupOrderScreen(
                                                                      store: stores
                                                                          .first,
                                                                      groupOrder:
                                                                          groupOrders
                                                                              .first),
                                                            ));
                                                          },
                                                        )
                                                      : AppButton(
                                                          text: 'View orders',
                                                          callback: () {
                                                            navigatorKey
                                                                .currentState!
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GroupOrdersByUserScreen(
                                                                      groupOrders:
                                                                          groupOrders),
                                                            ));
                                                          },
                                                        ),
                                                  if (groupOrders.length == 1)
                                                    Column(
                                                      children: [
                                                        const Gap(10),
                                                        AppButton(
                                                          callback: () async {
                                                            await AppFunctions
                                                                .navigateToStoreScreen(
                                                                    stores
                                                                        .first);
                                                          },
                                                          text: 'View store',
                                                          isSecondary: true,
                                                        ),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return AppText(
                                                text:
                                                    snapshot.error.toString());
                                          } else {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: AppColors
                                                          .neutral300)),
                                              child: Skeletonizer(
                                                enabled: true,
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      minLeadingWidth: 45,
                                                      title: const AppText(
                                                          text:
                                                              'njajklasklasl'),
                                                      leading: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              color: Colors
                                                                  .black38,
                                                              width: 50,
                                                              height: 50,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      subtitle: const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AppText(
                                                            text:
                                                                ' njkjnkjnlllnljllkklnlnlnl',
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // const Gap(10),
                                                    // const AppButton(
                                                    //   text:
                                                    //        'njnknknknk',

                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Gap(15),
                                );
                              } else if (snapshot.hasError) {
                                return SliverToBoxAdapter(
                                  child: AppText(
                                    text: snapshot.error.toString(),
                                  ),
                                );
                              } else {
                                return const SliverToBoxAdapter(
                                    child: SizedBox.shrink());
                              }
                            })
                      ],
                    );
                  }),
            )));
  }

  Future<Map<String, List<GroupOrder>>> _prepareGroupOrders() async {
    final sortedGroupOrders = <String, List<GroupOrder>>{};

    List<String> groupOrderIds =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo)['groupOrders'];

    for (var id in groupOrderIds) {
      final groupOrder = await AppFunctions.loadGroupOrderReference(
          FirebaseFirestore.instance
              .collection(FirestoreCollections.groupOrders)
              .doc(id));
      if ((groupOrder.endDate != null &&
              groupOrder.endDate!.isAfter(DateTime.now())) ||
          groupOrder.frequency != null) {
        if (sortedGroupOrders[groupOrder.ownerId] != null) {
          sortedGroupOrders[groupOrder.ownerId]!.add(groupOrder);
        } else {
          sortedGroupOrders[groupOrder.ownerId] = [groupOrder];
        }
      }
    }

    return sortedGroupOrders;
  }

  Future<List> _getOrderSchedulesAndStores(List<GroupOrder> groupOrders) async {
    List<OrderSchedule> futureOrderSchedules = [];
    List<Store> stores = [];
    for (var groupOrder in groupOrders) {
      final scheduleRefs = groupOrder.orderScheduleRefs;
      for (var scheduleRef in scheduleRefs) {
        final orderSchedule = await AppFunctions.loadOrderScheduleReference(
            scheduleRef as DocumentReference);

        if (orderSchedule.orderDate.isAfter(DateTime.now())) {
          futureOrderSchedules.add(orderSchedule);
          break;
        }
      }

      //geting stores
      // logger.d(groupOrder.storeRef);
      stores.add(await AppFunctions.loadStoreReference(
          groupOrder.storeRef as DocumentReference));
    }

    return [futureOrderSchedules, stores];
  }

  Future<String> _getOwnerName(GroupOrder groupOrder) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(groupOrder.ownerId)
        .get();
    return snapshot.data()!['displayName'];
  }
}

class CartSheet extends StatelessWidget {
  const CartSheet({
    super.key,
    required this.store,
    required this.cartItem,
  });

  final Store store;
  final HiveCartItem cartItem;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> userInfo =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    bool hasUberOne = userInfo['uberOneStatus']['hasUberOne'] ?? false;

    return FutureBuilder<Promotion?>(
        future: AppFunctions.getActivatedPromo(),
        builder: (context, snapshot) {
          final promo = snapshot.hasData ? snapshot.data : null;
          return ValueListenableBuilder(
              valueListenable:
                  Hive.box<HiveCartProduct>(AppBoxes.storedProducts)
                      .listenable(),
              builder: (context, productsBox, child) {
                return Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar.medium(
                        leading: GestureDetector(
                            onTap: () => navigatorKey.currentState!.pop(),
                            child: const Icon(Icons.clear)),
                        title: AppText(
                          text: store.name,
                          weight: FontWeight.w600,
                        ),
                        expandedHeight: 110,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppText(
                                  text: store.name,
                                  weight: FontWeight.w600,
                                  size: AppSizes.heading6,
                                ),
                                const Gap(15)
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: AppSizes.horizontalPaddingSmall),
                            child: InkWell(
                                onTap: () async =>
                                    await AppFunctions.createGroupOrder(store),
                                child: Ink(
                                    child:
                                        const Icon(Icons.person_add_outlined))),
                          )
                        ],
                      ),
                    ],
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final cartProduct =
                                        cartItem.products[index];

                                    return FutureBuilder(
                                        future:
                                            AppFunctions.loadProductReference(
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        FirestoreCollections
                                                            .products)
                                                    .doc(cartProduct.id)),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final product = snapshot.data!;

                                            return ListTile(
                                              onTap: () => navigatorKey
                                                  .currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductScreen(
                                                        product: product,
                                                        store: store),
                                              )),
                                              trailing: AddToCartButton(
                                                  removeShadow: true,
                                                  backgroundColor:
                                                      AppColors.neutral100,
                                                  product: product,
                                                  store: store),
                                              leading: SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: AppFunctions
                                                    .displayNetworkImage(product
                                                        .imageUrls.first),
                                              ),
                                              title: AppText(
                                                text: product.name,
                                                weight: FontWeight.w600,
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (cartProduct
                                                      .requiredOptions
                                                      .isNotEmpty)
                                                    Builder(builder: (context) {
                                                      final groupedReqOptions =
                                                          cartProduct
                                                              .requiredOptions
                                                              .groupListsBy(
                                                                  (element) =>
                                                                      element
                                                                          .categoryName);

                                                      return ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              groupedReqOptions
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final reqOption =
                                                                groupedReqOptions
                                                                    .values
                                                                    .elementAt(
                                                                        index);
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AppText(
                                                                  text:
                                                                      '${groupedReqOptions.keys.elementAt(index)}:',
                                                                  weight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children:
                                                                      reqOption
                                                                          .map(
                                                                            (e) =>
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                AppText(
                                                                                  text: e.name,
                                                                                ),
                                                                                if (e.options.isNotEmpty)
                                                                                  Builder(builder: (context) {
                                                                                    final groupedOptions = e.options.groupListsBy(
                                                                                      (element) => element.categoryName,
                                                                                    );

                                                                                    return ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        itemCount: groupedOptions.length,
                                                                                        itemBuilder: (context, index) {
                                                                                          return Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              AppText(text: '${groupedOptions.keys.elementAt(index)}:'),
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: groupedOptions.values
                                                                                                    .elementAt(index)
                                                                                                    .map(
                                                                                                      (e) => Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          AppText(
                                                                                                            text: e.name,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                    .toList(),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        });
                                                                                  }),
                                                                              ],
                                                                            ),
                                                                          )
                                                                          .toList(),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    }),
                                                  if (cartProduct
                                                      .optionalOptions
                                                      .isNotEmpty)
                                                    Builder(builder: (context) {
                                                      final groupedOptOptions =
                                                          cartProduct
                                                              .optionalOptions
                                                              .groupListsBy(
                                                                  (element) =>
                                                                      element
                                                                          .categoryName);

                                                      return ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              groupedOptOptions
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final optOption =
                                                                groupedOptOptions
                                                                    .values
                                                                    .elementAt(
                                                                        index);
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AppText(
                                                                  text:
                                                                      '${groupedOptOptions.keys.elementAt(index)}:',
                                                                  weight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children:
                                                                      optOption
                                                                          .map(
                                                                            (e) =>
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                AppText(
                                                                                  text: e.name,
                                                                                ),
                                                                                if (e.options.isNotEmpty)
                                                                                  Builder(builder: (context) {
                                                                                    final groupedOptions = e.options.groupListsBy(
                                                                                      (element) => element.categoryName,
                                                                                    );

                                                                                    return ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        itemCount: groupedOptions.length,
                                                                                        itemBuilder: (context, index) {
                                                                                          return Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              AppText(text: '${groupedOptions.keys.elementAt(index)}:'),
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: groupedOptions.values
                                                                                                    .elementAt(index)
                                                                                                    .map(
                                                                                                      (e) => Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          AppText(
                                                                                                            text: e.name,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                    .toList(),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        });
                                                                                  }),
                                                                              ],
                                                                            ),
                                                                          )
                                                                          .toList(),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    }),
                                                  if (product.similarProducts
                                                      .isNotEmpty)
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.loop,
                                                          color: AppColors
                                                              .neutral500,
                                                          size: 15,
                                                        ),
                                                        const Gap(5),
                                                        AppText(
                                                            text: cartProduct
                                                                    .backupInstruction ??
                                                                'Best match'),
                                                      ],
                                                    ),
                                                  Row(
                                                    children: [
                                                      AppText(
                                                          text:
                                                              '\$${(product.promoPrice ?? product.initialPrice).toStringAsFixed(2)}',
                                                          color:
                                                              product.promoPrice !=
                                                                      null
                                                                  ? Colors.green
                                                                  : null),
                                                      if (product.promoPrice !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              ' ${product.initialPrice.toStringAsFixed(2)}',
                                                        )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return AppText(
                                              text: snapshot.error.toString(),
                                            );
                                          } else {
                                            return Skeletonizer(
                                                enabled: true,
                                                child: ListTile(
                                                  leading: Container(
                                                      width: 60,
                                                      height: 60,
                                                      color:
                                                          AppColors.neutral100),
                                                  title: const AppText(
                                                    text: 'hdsjnjnadfks',
                                                    weight: FontWeight.w600,
                                                  ),
                                                  subtitle: const AppText(
                                                    text:
                                                        'hdsjnjnadfkdkdkddkkdks',
                                                    weight: FontWeight.w600,
                                                  ),
                                                ));
                                          }
                                        });
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: cartItem.products.length),
                              const Gap(10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.horizontalPadding),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await AppFunctions
                                            .navigateToStoreScreen(store);
                                      },
                                      child: Ink(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: AppColors.neutral100,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              size: 15,
                                            ),
                                            Gap(10),
                                            AppText(text: 'Add items'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (store.offers != null &&
                                  store.offers!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizes.horizontalPaddingSmall),
                                      child: AppText(
                                        text: 'Offers for you',
                                        weight: FontWeight.bold,
                                        size: AppSizes.body,
                                      ),
                                    ),
                                    const Gap(10),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes
                                                .horizontalPaddingSmall),
                                        itemBuilder: (context, index) {
                                          final offer = store.offers![index];
                                          return FutureBuilder(
                                              future:
                                                  AppFunctions.getOfferProduct(
                                                      offer
                                                          as DocumentReference),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return ProductGridTilePriceFirst(
                                                      product: snapshot.data!,
                                                      store: store);
                                                } else if (snapshot.hasError) {
                                                  return AppText(
                                                    text: snapshot.error
                                                        .toString(),
                                                  );
                                                } else {
                                                  return Skeletonizer(
                                                      enabled: true,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            color: AppColors
                                                                .neutral100,
                                                          ),
                                                          const AppText(
                                                              text: 'lkajlskj'),
                                                          const AppText(
                                                              text:
                                                                  'nlanjsklaf')
                                                        ],
                                                      ));
                                                }
                                              });
                                        },
                                        itemCount: store.offers!.length,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    )
                                  ],
                                ),
                              const Divider(),
                              ListTile(
                                onTap: () {
                                  // navigatorKey.currentState!.push(MaterialPageRoute(
                                  //   builder: (context) => const CustomizeGiftScreen(),
                                  // ));
                                },
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                leading: const Iconify(Ph.gift),
                                title: const AppText(text: 'Send as a gift'),
                                subtitle: const AppText(
                                  text: 'And customize a digital card',
                                  color: AppColors.neutral500,
                                ),
                                trailing:
                                    const Icon(Icons.keyboard_arrow_right),
                              ),
                              const Divider(),
                              ListTile(
                                title: const AppText(
                                  text: 'Subtotal',
                                  weight: FontWeight.w600,
                                  size: AppSizes.bodySmall,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                        size: AppSizes.bodySmall,
                                        decoration: promo != null || hasUberOne
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        text:
                                            '\$${cartItem.subtotal.toStringAsFixed(2)}'),
                                    if (promo != null || hasUberOne)
                                      AppText(
                                          size: AppSizes.bodySmall,
                                          weight: FontWeight.w600,
                                          text:
                                              ' \$${(cartItem.subtotal - (promo != null ? promo.discount : 0) - (hasUberOne ? OtherConstants.uberOneDiscount : 0)).toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (promo != null &&
                                (promo.minimumOrder == null ||
                                    promo.minimumOrder! <= cartItem.subtotal))
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.amberAccent.shade100),
                                child: ListTile(
                                  dense: true,
                                  leading: cartItem.subtotal < 30 && hasUberOne
                                      ? Image.asset(
                                          AssetNames.uberOneSmall,
                                          width: 20,
                                          color: Colors.brown,
                                        )
                                      : null,
                                  subtitle: cartItem.subtotal < 30 && hasUberOne
                                      ? AppText(
                                          color: Colors.brown.shade500,
                                          text:
                                              'Add \$${30 - cartItem.subtotal} to save more with Uber One',
                                          size: AppSizes.bodySmallest,
                                        )
                                      : null,
                                  title: AppText(
                                      color: Colors.brown.shade500,
                                      size: AppSizes.bodySmallest,
                                      text:
                                          'Saving \$${(promo.discount).toStringAsFixed(2)} with promotions'),
                                ),
                              ),
                            if (hasUberOne && cartItem.subtotal >= 30)
                              Container(
                                width: double.infinity,
                                decoration:
                                    const BoxDecoration(color: Colors.brown),
                                child: ListTile(
                                  leading: Image.asset(
                                    AssetNames.uberOneSmall,
                                    width: 20,
                                    color: Colors.white,
                                  ),
                                  title: const AppText(
                                      color: Colors.white,
                                      text: 'Saving \$0.14 with Uber One'),
                                ),
                              ),
                            const Gap(10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              child: AppButton(
                                text: 'Go to checkout',
                                callback: () async {
                                  final BitmapDescriptor bitmapDescriptor =
                                      await BitmapDescriptor.asset(
                                    const ImageConfiguration(
                                        size: Size(13, 13)),
                                    AssetNames.mapMarker2,
                                  );

                                  await navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                        promotion: promo,
                                        markerIcon: bitmapDescriptor,
                                        store: store),
                                  ));
                                },
                              ),
                            ),
                            const Gap(10),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
