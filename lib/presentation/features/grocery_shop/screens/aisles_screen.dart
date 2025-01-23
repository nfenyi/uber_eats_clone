import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/grocery_store/state/grocery_store_bottom_nav_index_provider.dart';

import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets.dart';
import '../../home/home_screen.dart';
import '../../product/product_screen.dart';
import 'grocery_shop_search_screen.dart';

class AislesScreen extends ConsumerStatefulWidget {
  final Store groceryStore;
  const AislesScreen({super.key, required this.groceryStore});

  @override
  ConsumerState<AislesScreen> createState() => _AislesScreenState();
}

class _AislesScreenState extends ConsumerState<AislesScreen> {
  bool _showAisleScreen = false;
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
        child: _showAisleScreen
            ? DefaultTabController(
                length: _aisle.productCategories.length,
                child: NestedScrollView(
                  body: CustomScrollView(
                    // controller: _scrollController,
                    slivers: [
                      const SliverGap(10),
                      // SliverList(
                      //     delegate: SliverChildListDelegate([
                      //   SizedBox(
                      //     height: 145,
                      //     child: ListView(
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: AppSizes.horizontalPaddingSmall),
                      //       scrollDirection: Axis.horizontal,
                      //       children: [
                      //         Container(
                      //             width: Adaptive.w(80),
                      //             height: 150,
                      //             decoration: BoxDecoration(
                      //               color: Colors.brown,
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             child: Row(
                      //               children: [
                      //                 Expanded(
                      //                   flex: 2,
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(15.0),
                      //                     child: Column(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         const Column(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             children: [
                      //                               AppText(
                      //                                 color: Colors.white,
                      //                                 text:
                      //                                     '\$0 Delivery Fee + up to 10% off with Uber One',
                      //                               ),
                      //                               Gap(10),
                      //                               AppText(
                      //                                 color: Colors.white,
                      //                                 text:
                      //                                     'Save on your next ride',
                      //                               ),
                      //                             ]),
                      //                         AppButton2(
                      //                             text: 'Try free for 4 weeks',
                      //                             callback: () {}),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Expanded(
                      //                     flex: 1,
                      //                     child: ClipRRect(
                      //                       borderRadius:
                      //                           const BorderRadius.only(
                      //                               topRight:
                      //                                   Radius.circular(10),
                      //                               bottomRight:
                      //                                   Radius.circular(10)),
                      //                       child: Image.asset(
                      //                         height: double.infinity,
                      //                         AssetNames.hamburger,
                      //                         fit: BoxFit.cover,
                      //                       ),
                      //                     ))
                      //               ],
                      //             )),
                      //         const Gap(10),
                      //         Container(
                      //             width: Adaptive.w(80),
                      //             height: 100,
                      //             decoration: BoxDecoration(
                      //               color: const Color.fromARGB(
                      //                   255, 201, 176, 102),
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             child: Row(
                      //               children: [
                      //                 const Expanded(
                      //                   flex: 2,
                      //                   child: Padding(
                      //                     padding: EdgeInsets.all(15.0),
                      //                     child: Column(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Column(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             children: [
                      //                               AppText(
                      //                                 text:
                      //                                     'Save 20% when you order \$25 or more',
                      //                               ),
                      //                               Gap(10),
                      //                               AppText(
                      //                                 text:
                      //                                     'Use by May 31, 2025 11 PM',
                      //                               ),
                      //                             ]),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Expanded(
                      //                     flex: 1,
                      //                     child: ClipRRect(
                      //                       borderRadius:
                      //                           const BorderRadius.only(
                      //                               topRight:
                      //                                   Radius.circular(10),
                      //                               bottomRight:
                      //                                   Radius.circular(10)),
                      //                       child: Image.asset(
                      //                         height: double.infinity,
                      //                         AssetNames.greenTag,
                      //                         fit: BoxFit.cover,
                      //                       ),
                      //                     ))
                      //               ],
                      //             )),
                      //       ],
                      //     ),
                      //   ),
                      //   const Gap(10),
                      // ])),
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
                                        size: AppSizes.heading5,
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
                                      itemCount:
                                          productCategory.products.length,
                                      itemBuilder: (context, index) {
                                        final product =
                                            productCategory.products[index];
                                        return InkWell(
                                          onTap: () {
                                            navigatorKey.currentState!
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductScreen(
                                                product: product,
                                                store: widget.groceryStore,
                                              ),
                                            ));
                                          },
                                          child: Row(
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppText(
                                                      text: product.name,
                                                      weight: FontWeight.w600,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                              color:
                                                                  Colors.green),
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
                                                        if (product.calories !=
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
                                                    if (product.description !=
                                                        null)
                                                      AppText(
                                                        text: product
                                                            .description!,
                                                        maxLines: 2,
                                                        color: AppColors
                                                            .neutral500,
                                                        overflow: TextOverflow
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
                                                        BorderRadius.circular(
                                                            12),
                                                    child: CachedNetworkImage(
                                                      imageUrl: product
                                                          .imageUrls.first,
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                  offset:
                                                                      Offset(
                                                                          2, 2),
                                                                )
                                                              ],
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          child: const Icon(
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
                                  Gap(50),
                                  AppText(
                                    text: 'Products not added yet',
                                    size: AppSizes.heading6,
                                  ),
                                ],
                              )),
                            )
                    ],
                  ),
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      collapsedHeight: 50,
                      pinned: true, toolbarHeight: 50,
                      snap: true,
                      floating: true,
                      title: InkWell(
                        onTap: () =>
                            navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => GroceryShopSearchScreen(
                            store: widget.groceryStore,
                          ),
                        )),
                        child: Ink(
                          child: AppTextFormField(
                            enabled: false,
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
                            _showAisleScreen = false;
                          });
                        },
                        child: Ink(
                          child: const Icon(
                            FontAwesomeIcons.arrowLeft,
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
                                size: AppSizes.body,
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
            : Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  children: [
                    AppBar(
                      leading: GestureDetector(
                          onTap: () => ref
                              .read(groceryStoreBottomNavIndexProvider.notifier)
                              .updateIndex(0),
                          child: const Icon(
                            FontAwesomeIcons.arrowLeft,
                            size: 20,
                          )),
                      title: InkWell(
                        onTap: () =>
                            navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => GroceryShopSearchScreen(
                            store: widget.groceryStore,
                          ),
                        )),
                        child: Ink(
                          child: AppTextFormField(
                            enabled: false,
                            hintText: 'Search ${widget.groceryStore.name}',
                            radius: 50,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final aisle = widget.groceryStore.aisles![index];
                            return ListTile(
                              onTap: () {
                                _aisle = aisle;
                                _categoryKeys = List.generate(
                                  _aisle.productCategories.length,
                                  (index) => GlobalKey(),
                                );
                                setState(() {
                                  _showAisleScreen = true;
                                });
                              },
                              leading: CachedNetworkImage(
                                  width: 50,
                                  height: 100,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                        AssetNames.aisleImage,
                                        height: 100,
                                        width: 50,
                                      ),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset(
                                        AssetNames.aisleImage,
                                        height: 100,
                                        width: 50,
                                      ),
                                  imageUrl: aisle.productCategories.isEmpty
                                      ? 'njanokjns'
                                      : aisle.productCategories.first.products
                                          .first.imageUrls.first),
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
                          itemCount:
                              widget.groceryStore.productCategories.length),
                    )
                  ],
                ),
              ));
  }
}
