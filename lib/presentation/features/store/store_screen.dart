import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/group_order/group_order_screen.dart';
import 'package:uber_eats_clone/presentation/features/product/product_screen.dart';
import 'package:uber_eats_clone/presentation/features/store/search_menu_screen.dart';
import 'package:uber_eats_clone/presentation/features/store/store_details_screen.dart';
import 'dart:math' as math;

import '../../../main.dart';
import '../../constants/app_sizes.dart';
import '../../constants/asset_names.dart';
import '../home/home_screen.dart';
import '../address/screens/addresses_screen.dart';

class StoreScreen extends StatefulWidget {
  final Store store;
  const StoreScreen(this.store, {super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late final Store _store;
  late final List<GlobalKey> _categoryKeys;
  final _scrollController = ScrollController();

  int? _retrievalFilter = 0;
  late bool _isFavorite;

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

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: null,
    ));
    _store = widget.store;
    _categoryKeys = List.generate(
      _store.productCategories.length,
      (index) => GlobalKey(),
    );

    _scrollController.addListener(_animateToTab);
    _isFavorite = _store.isFavorite;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _store.productCategories.length,
        child: NestedScrollView(
          body: CustomScrollView(
            // controller: _scrollController,
            slivers: [
              const SliverGap(10),
              SliverList(
                  delegate: SliverChildListDelegate([
                SizedBox(
                  height: 145,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                          width: Adaptive.w(80),
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              color: Colors.white,
                                              text:
                                                  '\$0 Delivery Fee + up to 10% off with Uber One',
                                            ),
                                            Gap(10),
                                            AppText(
                                              color: Colors.white,
                                              text: 'Save on your next ride',
                                            ),
                                          ]),
                                      AppButton2(
                                          text: 'Try free for 4 weeks',
                                          callback: () {}),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    child: Image.asset(
                                      height: double.infinity,
                                      AssetNames.hamburger,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                            ],
                          )),
                      const Gap(10),
                      Container(
                          width: Adaptive.w(80),
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 201, 176, 102),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text:
                                                  'Save 20% when you order \$25 or more',
                                            ),
                                            Gap(10),
                                            AppText(
                                              text: 'Use by May 31, 2025 11 PM',
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    child: Image.asset(
                                      height: double.infinity,
                                      AssetNames.greenTag,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                            ],
                          )),
                    ],
                  ),
                ),
                const Gap(10),
              ])),
              (_store.productCategories.isNotEmpty)
                  ? SliverList.separated(
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 3,
                      ),
                      itemCount: _store.productCategories.length,
                      itemBuilder: (context, index) {
                        final productCategory = _store.productCategories[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall,
                                  vertical: 8),
                              child: AppText(
                                key: _categoryKeys[index],
                                text: productCategory.name,
                                size: AppSizes.heading5,
                              ),
                            ),
                            const Gap(10),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              cacheExtent: 300,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: productCategory.products.length,
                              itemBuilder: (context, index) {
                                final product = productCategory.products[index];
                                return InkWell(
                                  onTap: () {
                                    navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) => ProductScreen(
                                        product: product,
                                        store: _store,
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
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                Visibility(
                                                  visible: product.promoPrice !=
                                                      null,
                                                  child: AppText(
                                                      text:
                                                          '\$${product.promoPrice} ',
                                                      color: Colors.green),
                                                ),
                                                AppText(
                                                  text:
                                                      '\$${product.initialPrice}',
                                                  decoration:
                                                      product.promoPrice != null
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                ),
                                                if (product.calories != null)
                                                  AppText(
                                                    text:
                                                        ' • ${product.calories!} Cal.',
                                                    maxLines: 2,
                                                    color: AppColors.neutral500,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                              ],
                                            ),
                                            if (product.description != null)
                                              AppText(
                                                text: product.description!,
                                                maxLines: 2,
                                                color: AppColors.neutral500,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                          ],
                                        ),
                                      ),
                                      const Gap(20),
                                      Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: product.imageUrls.first,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, top: 8.0),
                                            child: InkWell(
                                              onTap: () {},
                                              child: Ink(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          offset: Offset(2, 2),
                                                        )
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
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
              pinned: true,
              snap: true,
              floating: true,
              // automaticallyImplyLeading: false,
              bottom: TabBar(
                padding: EdgeInsets.zero,
                isScrollable: true,
                tabs: _store.productCategories
                    .map(
                      (category) => AppText(
                        text: category.name,
                        size: AppSizes.body,
                      ),
                    )
                    .toList(),
                onTap: (value) => _scrollToIndex,
              ),
              foregroundColor: Colors.white,
              flexibleSpace: LayoutBuilder(
                builder: (context, c) {
                  final settings = context.dependOnInheritedWidgetOfExactType<
                      FlexibleSpaceBarSettings>();
                  final deltaExtent = settings!.maxExtent - settings.minExtent;
                  final t = (1.0 -
                          (settings.currentExtent - settings.minExtent) /
                              deltaExtent)
                      .clamp(0.0, 1.0);
                  final fadeStart =
                      math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
                  const fadeEnd = 1.0;
                  final opacity =
                      1.0 - Interval(fadeStart, fadeEnd).transform(t);

                  return Opacity(
                    opacity: opacity,
                    child: Column(
                      children: [
                        Flexible(
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: _store.cardImage,
                                width: double.infinity,
                                height: 170,
                                fit: BoxFit.fitWidth,
                              ),
                              SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Gap(10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black26,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: const Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                    )),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _isFavorite =
                                                              !_isFavorite;
                                                        });
                                                        if (_isFavorite) {
                                                          showInfoToast(
                                                              'Added to favorites',
                                                              context: context);
                                                        }
                                                      },
                                                      child: Ink(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black26,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Icon(
                                                            _isFavorite
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_outline,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        navigatorKey
                                                            .currentState!
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              SearchMenuScreen(
                                                                  widget.store),
                                                        ));
                                                      },
                                                      child: Ink(
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black26,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: const Icon(
                                                              Icons.search,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () =>
                                                          showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10))),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ListTile(
                                                                  onTap: () {},
                                                                  leading:
                                                                      const Icon(
                                                                          Icons
                                                                              .share),
                                                                  title: const AppText(
                                                                      text:
                                                                          'Share'),
                                                                ),
                                                                ListTile(
                                                                  onTap: () {
                                                                    navigatorKey
                                                                        .currentState!
                                                                        .pop();
                                                                    navigatorKey
                                                                        .currentState!
                                                                        .push(
                                                                            MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          StoreDetailsScreen(
                                                                              widget.store),
                                                                    ));
                                                                  },
                                                                  leading:
                                                                      const Icon(
                                                                          Icons
                                                                              .info_outline),
                                                                  title: const AppText(
                                                                      text:
                                                                          'View store info'),
                                                                  subtitle:
                                                                      const AppText(
                                                                    text:
                                                                        'Hours, address, and more',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      child: Ink(
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black26,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: const Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Gap(50),
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all()),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  imageUrl: _store.logo,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            const Gap(10),
                                            AppText(
                                              text: _store.name,
                                              size: AppSizes.heading5,
                                              weight: FontWeight.w600,
                                            ),
                                            const Gap(5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppText(
                                                  text: '${_store.rating}',
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  size: 10,
                                                ),
                                                AppText(
                                                    text:
                                                        '(${_store.rating.ratings}+) • ${_store.delivery.estimatedDeliveryTime} min'),
                                              ],
                                            ),
                                            const Gap(10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CupertinoSlidingSegmentedControl<
                                                    int>(
                                                  backgroundColor:
                                                      AppColors.neutral200,
                                                  thumbColor: Colors.white,
                                                  children: const {
                                                    0: AppText(
                                                      text: 'Delivery',
                                                    ),
                                                    1: AppText(
                                                      text: 'Pickup',
                                                    )
                                                  },
                                                  groupValue: _retrievalFilter,
                                                  onValueChanged: (value) {
                                                    setState(() {
                                                      _retrievalFilter = value;
                                                      // if (value == 0) {
                                                      //   _retrievalFilter = 'Delivery';
                                                      // } else {
                                                      //   _retrievalFilter = 'Pickup';
                                                      // }
                                                    });
                                                  },
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    navigatorKey.currentState!
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          GroupOrderScreen(
                                                              _store),
                                                    ));
                                                  },
                                                  child: Ink(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .neutral200,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: const Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .person_add_outlined,
                                                            size: 20,
                                                          ),
                                                          Gap(5),
                                                          AppText(
                                                              text:
                                                                  'Group order')
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Gap(10),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: AppColors
                                                          .neutral300)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      AppText(
                                                          text: _store
                                                              .delivery.fee
                                                              .toString()),
                                                      const AppText(
                                                        text: 'Pricing & fees',
                                                        color: AppColors
                                                            .neutral500,
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    color: AppColors.neutral300,
                                                    width: 1,
                                                    height: 30,
                                                  ),
                                                  // const VerticalDivider(
                                                  //     // height: 10,
                                                  //     thickness: 10,
                                                  //     // color: AppColors.neutral300,
                                                  //     color: Colors.red),
                                                  Column(
                                                    children: [
                                                      AppText(
                                                          text:
                                                              '${_store.delivery.estimatedDeliveryTime} min'),
                                                      const AppText(
                                                        text: 'Pickup time',
                                                        color: AppColors
                                                            .neutral500,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              expandedHeight: 400,
              // floating: true,
              // leading: const Icon(
              //   Icons.arrow_back,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
