import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';

import '../../../../../main.dart';
import '../../../../../models/store/store_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../core/app_text.dart';
import '../../../../core/widgets.dart';
import 'grocery_shop_search_screen.dart';

class DealsScreen extends StatefulWidget {
  final Store groceryStore;
  const DealsScreen({super.key, required this.groceryStore});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  final List<GlobalKey> _categoryKeys = [];
  final _scrollController = ScrollController();
  final Map<String, Set<Product>> _aislesAndProducts = {};
  //  void _animateToTab() {
  //   late RenderBox box;
  //   for (var i = 0; i < _categoryKeys.length; i++) {
  //     box = _categoryKeys[i].currentContext!.findRenderObject() as RenderBox;
  //     Offset position = box.localToGlobal(Offset.zero);
  //     if (_scrollController.offset >= position.dy) {
  //       DefaultTabController.of(context)
  //           .animateTo(i, duration: const Duration(milliseconds: 200));
  //     }
  //   }
  // }

  // Future<void> _scrollToIndex(int index) async {
  //   _scrollController.removeListener(_animateToTab);
  //   final categoryContext = _categoryKeys[index].currentContext!;

  //   await Scrollable.ensureVisible(categoryContext,
  //       duration: const Duration(milliseconds: 400));

  //   _scrollController.addListener(_animateToTab);
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppFunctions.fetchDeals(widget.groceryStore.id);
    return FutureBuilder(
        future: AppFunctions.fetchDeals(widget.groceryStore.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator()),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -100),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(100),
                            Image.asset(
                              AssetNames.fallenIceCream,
                              width: 180,
                            ),
                            const Gap(10),
                            const AppText(
                              text: 'Sorry, something went wrong.',
                              weight: FontWeight.bold,
                              size: AppSizes.body,
                            ),
                            AppText(text: snapshot.error.toString()),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          final products = snapshot.data!;

          for (var aisle in widget.groceryStore.aisles!) {
            for (var productCategory in aisle.productCategories) {
              for (var prodAndQuant in productCategory.productsAndQuantities) {
                final castedProductRef =
                    prodAndQuant.product as DocumentReference;
                for (var product in products) {
                  if (castedProductRef.path.contains(product.id)) {
                    if (_aislesAndProducts[aisle.name] == null) {
                      _aislesAndProducts[aisle.name] = {product};
                    } else {
                      _aislesAndProducts[aisle.name] = {
                        product,
                        ..._aislesAndProducts[aisle.name]!
                      };
                    }
                  }
                }
              }
            }
          }

          if (_aislesAndProducts.isEmpty) {
            return Scaffold(
              body: Column(
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
                                'No deals from ${widget.groceryStore.name} yet')),
                  )
                ],
              ),
            );
          }

          return DefaultTabController(
            length: _aislesAndProducts.length,
            child: Scaffold(
              appBar: AppBar(
                title: InkWell(
                  child: Ink(
                    child: AppTextFormField(
                      readOnly: true,
                      onTap: () =>
                          navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => GroceryShopSearchScreen(
                          store: widget.groceryStore,
                        ),
                      )),
                      hintText: 'Search ${widget.groceryStore.name}',
                      radius: 50,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                bottom: TabBar(
                  padding: EdgeInsets.zero,
                  isScrollable: true,
                  tabs: _aislesAndProducts.keys
                      .map(
                        (aisle) => AppText(
                          text: aisle,
                          size: AppSizes.bodySmall,
                        ),
                      )
                      .toList(),
                  // onTap: (value) => _scrollToIndex,
                ),
              ),
              body: TabBarView(
                  children: _aislesAndProducts.entries
                      .map(
                        (aisleAndProducts) => SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: aisleAndProducts.key,
                                  size: AppSizes.heading6,
                                  weight: FontWeight.w600,
                                ),
                                const Gap(10),
                                GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 200,
                                          crossAxisCount: 2),
                                  itemCount: aisleAndProducts.value.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        aisleAndProducts.value.elementAt(index);
                                    return ProductGridTilePriceFirst(
                                            product: product,
                                            store: widget.groceryStore)
                                        // GrocerySearchProductGridTile(
                                        //     store: widget.groceryStore,
                                        //     product: product)
                                        ;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ),
          );
        });
  }
}
