import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/grocery_store/screens/screens/grocery_shop_search_screen.dart';
import 'package:uber_eats_clone/presentation/features/promotion/promo_screen.dart';

import '../../../../../models/store/store_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets.dart';
import '../../../product/product_screen.dart';

class AislesScreen extends ConsumerStatefulWidget {
  final Store groceryStore;
  const AislesScreen({super.key, required this.groceryStore});

  @override
  ConsumerState<AislesScreen> createState() => _AislesScreenState();
}

class _AislesScreenState extends ConsumerState<AislesScreen> {
  bool _showProdcuctCat = false;
  List<GlobalKey> _categoryKeys = [];
  final _scrollController = ScrollController();
  late Aisle _aisle;

  void _animateToTab() {
    late RenderBox box;
    for (var i = 0; i < _categoryKeys.length; i++) {
      box = _categoryKeys[i].currentContext!.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);
      if (_scrollController.offset >= position.dy) {
        DefaultTabController.of(context)
            .animateTo(i, duration: const Duration(milliseconds: 200));
      }
    }
  }

  Future<void> _scrollToIndex(int index) async {
    _scrollController.removeListener(_animateToTab);
    final categoryContext = _categoryKeys[index].currentContext!;

    await Scrollable.ensureVisible(categoryContext,
        duration: const Duration(milliseconds: 400));

    _scrollController.addListener(_animateToTab);
  }

  // @override
  // void initState() {
  //   super.initState();

  //   _scrollController.addListener(_animateToTab);
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: _showProdcuctCat
            ? DefaultTabController(
                length: _aisle.productCategories.length,
                child: NestedScrollView(
                  body: CustomScrollView(
                    // controller: _scrollController,
                    slivers: [
                      const SliverGap(10),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        const BannerCarousel(),
                        const Gap(10),
                      ])),
                      (_aisle.productCategories.isNotEmpty)
                          ? SliverList.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                thickness: 3,
                              ),
                              itemCount: _aisle.productCategories.length,
                              itemBuilder: (context, index) {
                                final productCategory =
                                    _aisle.productCategories[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizes.horizontalPaddingSmall,
                                          vertical: 8),
                                      child: AppText(
                                        key: _categoryKeys[index],
                                        text: productCategory.name,
                                        size: AppSizes.heading6,
                                      ),
                                    ),
                                    const Gap(10),
                                    ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      cacheExtent: 300,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizes.horizontalPaddingSmall),
                                      separatorBuilder: (context, index) =>
                                          const Divider(),
                                      itemCount: productCategory
                                          .productsAndQuantities.length,
                                      itemBuilder: (context, index) {
                                        final productRef = productCategory
                                            .productsAndQuantities[index]
                                            .product;

                                        return FutureBuilder<Product>(
                                            future: AppFunctions
                                                .loadProductReference(productRef
                                                    as DocumentReference),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Skeletonizer(
                                                    enabled: true,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Container(
                                                        color: Colors.blue,
                                                        width: 100,
                                                        height: 140,
                                                      ),
                                                    ));
                                              } else if (snapshot.hasError) {
                                                return AppText(
                                                    text: snapshot.error
                                                        .toString());
                                              }
                                              final product = snapshot.data!;

                                              return InkWell(
                                                onTap: () {
                                                  navigatorKey.currentState!
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductScreen(
                                                      product: product,
                                                      store:
                                                          widget.groceryStore,
                                                    ),
                                                  ));
                                                },
                                                child: Row(
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AppText(
                                                            text: product.name,
                                                            weight:
                                                                FontWeight.w600,
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Visibility(
                                                                visible: product
                                                                        .promoPrice !=
                                                                    null,
                                                                child: AppText(
                                                                    text:
                                                                        '\$${product.promoPrice} ',
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              AppText(
                                                                text:
                                                                    '\$${product.initialPrice}',
                                                                decoration: product
                                                                            .promoPrice !=
                                                                        null
                                                                    ? TextDecoration
                                                                        .lineThrough
                                                                    : TextDecoration
                                                                        .none,
                                                              ),
                                                              if (product
                                                                      .calories !=
                                                                  null)
                                                                AppText(
                                                                  text:
                                                                      ' • ${product.calories!} Cal.',
                                                                  maxLines: 2,
                                                                  color: AppColors
                                                                      .neutral500,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )
                                                            ],
                                                          ),
                                                          if (product
                                                                  .description !=
                                                              null)
                                                            AppText(
                                                              text: product
                                                                  .description!,
                                                              maxLines: 2,
                                                              color: AppColors
                                                                  .neutral500,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Gap(20),
                                                    Stack(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: product
                                                                .imageUrls
                                                                .first,
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0,
                                                                  top: 8.0),
                                                          child: InkWell(
                                                            onTap: () {},
                                                            child: Ink(
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    boxShadow: const [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black12,
                                                                        offset: Offset(
                                                                            2,
                                                                            2),
                                                                      )
                                                                    ],
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child:
                                                                    const Icon(
                                                                  Icons.add,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                    )
                                  ],
                                );
                              },
                            )
                          : const SliverFillRemaining(
                              child: Center(
                                  child: Column(
                                children: [
                                  Gap(90),
                                  AppText(
                                    text: 'Products not added yet',
                                  ),
                                ],
                              )),
                            )
                    ],
                  ),
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      pinned: true,
                      snap: true,
                      floating: true,
                      title: InkWell(
                        child: Ink(
                          child: AppTextFormField(
                            readOnly: true,
                            onTap: () => navigatorKey.currentState!
                                .push(MaterialPageRoute(
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

                      automaticallyImplyLeading: false,
                      leading: InkWell(
                        onTap: () {
                          setState(() {
                            _showProdcuctCat = false;
                          });
                        },
                        child: Ink(
                          child: const Iconify(
                            Ph.arrow_left,
                            size: 18,
                          ),
                        ),
                      ),
                      bottom: TabBar(
                        padding: EdgeInsets.zero,
                        isScrollable: true,
                        tabs: _aisle.productCategories
                            .map(
                              (category) => AppText(
                                text: category.name,
                                size: AppSizes.bodySmall,
                              ),
                            )
                            .toList(),
                        onTap: (value) => _scrollToIndex,
                      ),
                      // backgroundColor: Colors.white,
                      // foregroundColor: Colors.white,

                      // floating: true,
                      // leading: const Icon(
                      //   Icons.arrow_back,
                      // ),
                    ),
                  ],
                ))
            : Column(
                children: [
                  AppBar(
                    title: AppTextFormField(
                      onTap: () =>
                          navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => GroceryShopSearchScreen(
                          store: widget.groceryStore,
                        ),
                      )),
                      readOnly: true,
                      hintText: 'Search ${widget.groceryStore.name}',
                      radius: 50,
                      constraintWidth: 40,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          final aisle = widget.groceryStore.aisles![index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: AppSizes.horizontalPaddingSmall),
                            onTap: () {
                              _aisle = aisle;
                              _categoryKeys = List.generate(
                                _aisle.productCategories.length,
                                (index) => GlobalKey(),
                              );
                              setState(() {
                                _showProdcuctCat = true;
                              });
                            },
                            leading: Builder(builder: (context) {
                              final firstProductCats = aisle.productCategories;
                              if (firstProductCats.isEmpty) {
                                return Image.asset(
                                  AssetNames.aisleImage,
                                  width: 50,
                                  height: 100,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                final firstProduct = firstProductCats
                                    .first.productsAndQuantities.first.product;

                                return FutureBuilder(
                                    future: AppFunctions.loadProductReference(
                                        firstProduct as DocumentReference),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Image.asset(
                                          AssetNames.aisleImage,
                                          width: 50,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        );
                                      } else if (snapshot.hasError) {
                                        return SizedBox(
                                          width: 50,
                                          height: 100,
                                          child: AppText(
                                              text: snapshot.error.toString()),
                                        );
                                      }

                                      final imageUrl =
                                          snapshot.data!.imageUrls.first;
                                      return AppFunctions.displayNetworkImage(
                                        imageUrl,
                                        width: 50,
                                        height: 100,
                                        placeholderAssetImage:
                                            AssetNames.aisleImage,
                                        fit: BoxFit.cover,
                                      );
                                    });
                              }
                            }),
                            title: AppText(
                              text: aisle.name,
                              color: Colors.black,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            indent: 80,
                          );
                        },
                        itemCount: widget.groceryStore.aisles!.length),
                  )
                ],
              ));
  }
}
