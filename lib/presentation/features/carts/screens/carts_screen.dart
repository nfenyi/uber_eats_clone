import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/hive_adapters/geopoint/geopoint_adapter.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/orders_screen.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

import '../../../../main.dart';
import '../../../../models/group_order/group_order_model.dart';
import '../../../../models/order/order_model.dart';
import '../../../../models/payment/payment_model.dart';
import '../../../../models/payment_method_model.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../group_order/group_order_screen.dart';
import '../../group_order/group_orders_by_user_screen.dart';

class CartsScreen extends ConsumerStatefulWidget {
  const CartsScreen({super.key});

  @override
  ConsumerState<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends ConsumerState<CartsScreen> {
  late final GeoPoint _storedUserLocation;
  final List<IndividualOrder> _individualOrders = [
    IndividualOrder(
        placeDescription: 'Adenta',
        orderNumber: '372932',
        status: 'Completed',
        totalFee: 58.6,
        storeRef: FirebaseFirestore.instance
            .collection(FirestoreCollections.stores)
            .doc('NazJMIA9yaUsLRjLxBGa'),
        productsAndQuantities: {},
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        tip: 0.5,
        courier: 'Sally',
        promoApplied: FirebaseFirestore.instance
            .collection(FirestoreCollections.promotions)
            .doc('01959946-9bb6-750c-ab40-906312145b51'),
        serviceFee: 2.4,
        tax: 0.4,
        caDriverBenefits: 0.2,
        deliveryFee: 5,
        membershipBenefit: 4.3,
        payments: [
          Payment(
              datePaid: DateTime.now(),
              cardNumber: '383934',
              paymentMethodId: const PaymentMethod(
                  name: 'Mastercard', assetImage: AssetNames.masterCardLogo),
              amountPaid: 50)
        ])
  ];

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
  void initState() {
    super.initState();
    HiveGeoPoint temp = Hive.box(AppBoxes.appState)
        .get(BoxKeys.userInfo)['selectedAddress']['latlng'];
    _storedUserLocation = GeoPoint(temp.latitude, temp.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar.medium(
                    scrolledUnderElevation: 1,
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
                                    builder: (context) => OrdersScreen(
                                      storedUserLocation: _storedUserLocation,
                                    ),
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
              child: CustomScrollView(
                slivers: [
                  FutureBuilder<List>(
                      future: _getIndividualOrders(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final individualOrders =
                              snapshot.data!.first as List<IndividualOrder>;
                          final stores = snapshot.data!.last as List<Store>;
                          return SliverList.separated(
                            itemCount: individualOrders.length,
                            itemBuilder: (context, index) {
                              final order = individualOrders[index];
                              final store = stores[index];
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.neutral300)),
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
                                          color: AppColors.neutral500,
                                          size: AppSizes.bodySmallest,
                                          text:
                                              '${order.productsAndQuantities.length} items • \$${order.totalFee}\n Deliver by ${AppFunctions.formatDate(order.deliveryDate.toString(), format: r'g:i A')} to ${order.placeDescription}'),
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppBar(
                                                    leading: GestureDetector(
                                                        onTap: () =>
                                                            navigatorKey
                                                                .currentState!
                                                                .pop(),
                                                        child: const Icon(
                                                            Icons.clear)),
                                                    actions: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right: AppSizes
                                                                .horizontalPaddingSmall),
                                                        child: InkWell(
                                                            child: Ink(
                                                                child: const Icon(
                                                                    Icons
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
                                                                    horizontal:
                                                                        AppSizes
                                                                            .horizontalPaddingSmall),
                                                                child: AppText(
                                                                  text: store
                                                                      .name,
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                  size: AppSizes
                                                                      .bodySmall,
                                                                ),
                                                              ),
                                                              ListView
                                                                  .separated(
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        final product = store
                                                                            .productCategories!
                                                                            .first
                                                                            .productsAndQuantities[index];
                                                                        return ListTile(
                                                                          trailing:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(5),
                                                                            decoration:
                                                                                BoxDecoration(color: AppColors.neutral100, borderRadius: BorderRadius.circular(50)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                InkWell(
                                                                                    child: Ink(
                                                                                  child: const Icon(
                                                                                    Icons.delete_outline,
                                                                                    size: 15,
                                                                                  ),
                                                                                )),
                                                                                const Gap(10),
                                                                                const AppText(text: '1'),
                                                                                const Gap(10),
                                                                                InkWell(
                                                                                    child: Ink(
                                                                                  child: const Icon(
                                                                                    Icons.add,
                                                                                    size: 15,
                                                                                  ),
                                                                                )),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          contentPadding:
                                                                              EdgeInsets.zero,
                                                                          leading:
                                                                              SizedBox(
                                                                            width:
                                                                                60,
                                                                            height:
                                                                                60,
                                                                            child:
                                                                                CachedNetworkImage(imageUrl: product['imageUrls'].imageUrls.first),
                                                                          ),
                                                                          // title: AppText(
                                                                          //   text: product
                                                                          //       .name,
                                                                          //   weight:
                                                                          //       FontWeight
                                                                          //           .w600,
                                                                          //   size: AppSizes
                                                                          //       .bodySmall,
                                                                          // ),
                                                                          subtitle:
                                                                              const Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  AppText(
                                                                                    text: 'Selected Option: ',
                                                                                    weight: FontWeight.w600,
                                                                                  ),
                                                                                  AppText(
                                                                                    text: 'njajnasaojoajkaj ',
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  AppText(
                                                                                    text: 'Selected Drink: ',
                                                                                    weight: FontWeight.w600,
                                                                                  ),
                                                                                  AppText(
                                                                                    text: 'njajnasaojoajkaj ',
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              // if (product
                                                                              //         .options !=
                                                                              //     null)
                                                                              //   const Row(
                                                                              //     children: [
                                                                              //       AppText(
                                                                              //         text:
                                                                              //             'nkanknasjn Comes With ',
                                                                              //         weight:
                                                                              //             FontWeight.w600,
                                                                              //       ),
                                                                              //       AppText(
                                                                              //         text:
                                                                              //             'Ice',
                                                                              //       ),
                                                                              //     ],
                                                                              //   ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                      separatorBuilder: (context,
                                                                              index) =>
                                                                          const Gap(
                                                                              10),
                                                                      itemCount: store
                                                                          .productCategories!
                                                                          .first
                                                                          .productsAndQuantities
                                                                          .length),
                                                              const Gap(10),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        AppSizes
                                                                            .horizontalPaddingSmall),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Ink(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                AppColors.neutral100,
                                                                            borderRadius: BorderRadius.circular(50)),
                                                                        child:
                                                                            const Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
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
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            2),
                                                                decoration: const BoxDecoration(
                                                                    border: Border.symmetric(
                                                                        vertical: BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                AppColors.neutral200))),
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
                                                                  trailing:
                                                                      const Icon(
                                                                          Icons
                                                                              .keyboard_arrow_right),
                                                                ),
                                                              ),
                                                              const ListTile(
                                                                title: AppText(
                                                                  text:
                                                                      'Subtotal',
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                  size: AppSizes
                                                                      .bodySmall,
                                                                ),
                                                                trailing: AppText(
                                                                    size: AppSizes
                                                                        .bodySmall,
                                                                    weight:
                                                                        FontWeight
                                                                            .w600,
                                                                    text:
                                                                        'US\$ 24.13'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .amber
                                                                          .shade100),
                                                              child: ListTile(
                                                                leading:
                                                                    Image.asset(
                                                                  AssetNames
                                                                      .uberOneSmall,
                                                                  width: 20,
                                                                  color: Colors
                                                                      .brown,
                                                                ),
                                                                subtitle:
                                                                    AppText(
                                                                  color: Colors
                                                                      .brown
                                                                      .shade500,
                                                                  text:
                                                                      'Add \$20.99 to save more with Uber One',
                                                                  size: AppSizes
                                                                      .bodySmallest,
                                                                ),
                                                                title: AppText(
                                                                    color: Colors
                                                                        .brown
                                                                        .shade500,
                                                                    text:
                                                                        'Saving \$0.14 with Uber One'),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      color: Colors
                                                                          .brown),
                                                              child: ListTile(
                                                                leading:
                                                                    Image.asset(
                                                                  AssetNames
                                                                      .uberOneSmall,
                                                                  width: 20,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                title: const AppText(
                                                                    color: Colors
                                                                        .white,
                                                                    text:
                                                                        'Saving \$0.14 with Uber One'),
                                                              ),
                                                            ),
                                                            const Gap(10),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      AppSizes
                                                                          .horizontalPaddingSmall),
                                                              child: AppButton(
                                                                text:
                                                                    'Go to checkout',
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
                                      callback: () async {
                                        await AppFunctions
                                            .navigateToStoreScreen(
                                                increaseVisitCount: false,
                                                store);
                                      },
                                      text: 'View store',
                                      isSecondary: true,
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const Gap(15),
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
                      }),
                  const SliverGap(15),
                  FutureBuilder<Map<String, List<GroupOrder>>>(
                      future: _prepareGroupOrders(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final groupOrdersByUser = snapshot.data!;
                          return SliverList.separated(
                            itemCount: groupOrdersByUser.length,
                            itemBuilder: (context, index) {
                              final groupOrders =
                                  groupOrdersByUser.values.elementAt(index);

                              return FutureBuilder<List>(
                                  future:
                                      _getOrderSchedulesAndStores(groupOrders),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final futureOrderSchedules = snapshot
                                          .data![0] as List<OrderSchedule>;
                                      final stores =
                                          snapshot.data![1] as List<Store>;

                                      return Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: AppColors.neutral300)),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              minLeadingWidth: 45,
                                              contentPadding: EdgeInsets.zero,
                                              title: AppText(
                                                text: stores.length == 1
                                                    ? stores.first.name
                                                    : groupOrders
                                                        .first.placeDescription,
                                                weight: FontWeight.w600,
                                                size: AppSizes.bodySmall,
                                              ),
                                              leading: stores.length > 1
                                                  ? Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Stack(
                                                            children: [
                                                              AppFunctions
                                                                  .displayNetworkImage(
                                                                stores[1]
                                                                    .cardImage,
                                                                width: 30,
                                                                height: 30,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              Container(
                                                                color: Colors
                                                                    .black38,
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .group_outlined,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Transform.translate(
                                                            offset:
                                                                const Offset(
                                                                    15, 15),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  border: Border.all(
                                                                      width: 4,
                                                                      color: Colors
                                                                          .white)),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                child: Stack(
                                                                  children: [
                                                                    AppFunctions
                                                                        .displayNetworkImage(
                                                                      stores[0]
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
                                                            )),
                                                      ],
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Stack(
                                                        children: [
                                                          AppFunctions
                                                              .displayNetworkImage(
                                                            stores.first
                                                                .cardImage,
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          Container(
                                                            color:
                                                                Colors.black38,
                                                            width: 50,
                                                            height: 50,
                                                            child: const Icon(
                                                              Icons
                                                                  .group_outlined,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Builder(builder: (context) {
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
                                                              Icons.refresh,
                                                              size: 15,
                                                            ),
                                                            AppText(
                                                              text:
                                                                  ' ${repeatingGroupOrders.first.frequency}',
                                                            ),
                                                            const AppText(
                                                              text: ' • ',
                                                            ),
                                                          ]),
                                                        stores.length == 1
                                                            ? AppText(
                                                                text:
                                                                    groupOrders
                                                                        .first
                                                                        .name)
                                                            : FutureBuilder<
                                                                    String>(
                                                                future: _getOwnerName(
                                                                    groupOrders
                                                                        .first),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    return AppText(
                                                                        text:
                                                                            'Created by ${snapshot.data}');
                                                                  } else {
                                                                    return const AppText(
                                                                        text:
                                                                            '...');
                                                                  }
                                                                })
                                                      ],
                                                    );
                                                  }),
                                                  if (futureOrderSchedules
                                                      .isNotEmpty)
                                                    Row(
                                                      children: [
                                                        const AppText(
                                                          text: 'Next order: ',
                                                          color: Colors.green,
                                                          size: AppSizes
                                                              .bodySmallest,
                                                        ),
                                                        AppText(
                                                          text: AppFunctions.formatDate(
                                                              futureOrderSchedules
                                                                  .first
                                                                  .deliveryDate
                                                                  .toString(),
                                                              format: 'M j'),
                                                          size: AppSizes
                                                              .bodySmallest,
                                                        ),
                                                        const AppText(
                                                          text: ' by ',
                                                          size: AppSizes
                                                              .bodySmallest,
                                                        ),
                                                        AppText(
                                                          text: AppFunctions.formatDate(
                                                              futureOrderSchedules
                                                                  .first
                                                                  .deliveryDate
                                                                  .toString(),
                                                              format: 'g:i A'),
                                                          size: AppSizes
                                                              .bodySmallest,
                                                        ),
                                                      ],
                                                    ),

                                                  //deadline == null ?AppText(text: '')
                                                ],
                                              ),
                                            ),
                                            const Gap(10),
                                            groupOrders.length == 1
                                                ? AppButton(
                                                    text: 'View order',
                                                    callback: () {
                                                      navigatorKey.currentState!
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
                                                      navigatorKey.currentState!
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
                                                              stores.first);
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
                                          text: snapshot.error.toString());
                                    } else {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: AppColors.neutral300)),
                                        child: Skeletonizer(
                                          enabled: true,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                minLeadingWidth: 45,
                                                contentPadding: EdgeInsets.zero,
                                                title: const AppText(
                                                    text: 'njajklasklasl'),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        color: Colors.black38,
                                                        width: 50,
                                                        height: 50,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                subtitle: const Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                            separatorBuilder: (context, index) => const Gap(15),
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
              ),
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
      if (sortedGroupOrders[groupOrder.ownerId] != null) {
        sortedGroupOrders[groupOrder.ownerId]!.add(groupOrder);
      } else {
        sortedGroupOrders[groupOrder.ownerId] = [groupOrder];
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
        if (orderSchedule.deliveryDate.isAfter(DateTime.now())) {
          futureOrderSchedules.add(orderSchedule);
          break;
        }
      }

      //geting stores
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

  Future<List> _getIndividualOrders() async {
    List<IndividualOrder> individualOrders = [];
    List<Store> stores = [];
    final individualOrderSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.individualOrders)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (individualOrderSnapshot.exists) {
      final allIndividualOrders = individualOrderSnapshot.data()!;
      for (var individualOrderJson in allIndividualOrders.values) {
        final individualOrder = IndividualOrder.fromJson(individualOrderJson);
        individualOrders.add(individualOrder);

        final store = await AppFunctions.loadStoreReference(
            individualOrder.storeRef as DocumentReference);
        stores.add(store);
      }
    }
    return [individualOrders, stores];
  }
}
