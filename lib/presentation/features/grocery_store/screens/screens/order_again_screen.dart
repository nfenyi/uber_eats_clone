import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/models/order/order_model.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';

import '../../../../../app_functions.dart';
import '../../../../../main.dart';
import '../../../../../models/store/store_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../core/widgets.dart';
import '../../../../services/sign_in_view_model.dart';
import 'grocery_shop_search_screen.dart';

class OrderAgainScreen extends StatefulWidget {
  final Store store;
  const OrderAgainScreen(this.store, {super.key});

  @override
  State<OrderAgainScreen> createState() => _OrderAgainScreenState();
}

class _OrderAgainScreenState extends State<OrderAgainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Ink(
            child: AppTextFormField(
              readOnly: true,
              onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => GroceryShopSearchScreen(
                  store: widget.store,
                ),
              )),
              hintText: 'Search ${widget.store.name}',
              radius: 50,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<IndividualOrder>>(
        future: _getOrdersFromStore(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orders = snapshot.data!;
            if (orders.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: Center(
                        child: AppText(
                            size: AppSizes.bodySmall,
                            textAlign: TextAlign.center,
                            // weight: FontWeight.bold,
                            text:
                                'You have not made any orders from ${widget.store.name} yet')),
                  )
                ],
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => const Gap(20),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: AppText(
                        text: AppFunctions.formatDate(
                          order.deliveryDate.toString(),
                          format: 'M j',
                        ),
                      ),
                    ),
                    const Gap(15),
                    GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 120,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 212,
                              mainAxisSpacing: 10),
                      shrinkWrap: true,
                      itemCount: order.products.length,
                      itemBuilder: (context, index) {
                        final cartProduct = order.products[index];
                        return FutureBuilder(
                            future: AppFunctions.loadProductReference(
                                FirebaseFirestore.instance
                                    .collection(FirestoreCollections.products)
                                    .doc(cartProduct.id)),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final product = snapshot.data!;
                                return ProductGridTilePriceFirst(
                                    product: product, store: widget.store);
                              } else if (snapshot.hasError) {
                                return AppText(text: snapshot.error.toString());
                              } else {
                                return Skeletonizer(
                                  enabled: true,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.neutral100,
                                        ),
                                        width: 70,
                                        height: 70,
                                      ),
                                      const AppText(text: 'noalsfkm'),
                                      const AppText(text: 'noalsfkjkslamklasfm')
                                    ],
                                  ),
                                );
                              }
                            });
                      },
                    )
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return AppText(text: snapshot.error.toString());
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<IndividualOrder>> _getOrdersFromStore() async {
    final List<IndividualOrder> individualOrders = [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.individualOrders)
        .where('userUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('storeId', isEqualTo: widget.store.id)
        .get();
    for (var doc in querySnapshot.docs) {
      individualOrders.add(IndividualOrder.fromJson(doc.data()));
    }
    return individualOrders;
  }
}
