import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/group_order/group_order_screen.dart';
import 'package:uber_eats_clone/presentation/features/group_order/group_order_settings_screen.dart';
import 'package:uber_eats_clone/presentation/features/product/product_screen.dart';
import 'package:uber_eats_clone/presentation/features/store/search_menu_screen.dart';
import 'package:uber_eats_clone/presentation/features/store/store_details_screen.dart';
import 'dart:math' as math;

import '../../../main.dart';
import '../../../models/favourite/favourite_model.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../constants/asset_names.dart';
import '../../services/sign_in_view_model.dart';
import '../address/screens/addresses_screen.dart';
import '../home/home_screen.dart';
import '../uber_one/join_uber_one_screen.dart';

class StoreScreen extends StatefulWidget {
  final Store store;

  final GeoPoint userLocation;
  const StoreScreen(this.store, {super.key, required this.userLocation});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late final Store _store;
  late final List<GlobalKey> _categoryKeys;
  // final _scrollController = ScrollController();
  // late final ScrollNotification _scrollNotification;
  late Distance _distance;
  int? _retrievalFilter = 0;
  late bool _isFavorite;

  int _currentCategoryIndex = 0;

  BuildContext? _tabContext;

  void _animateToTab(ScrollNotification scrollNotification) {
    late RenderBox box;
    for (var i = 0; i < _categoryKeys.length; i++) {
      if (_categoryKeys[i].currentContext != null) {
        box = _categoryKeys[i].currentContext!.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        if (scrollNotification.metrics.pixels >= position.dy) {
          _currentCategoryIndex = i;
          DefaultTabController.of(_tabContext!)
              .animateTo(i, duration: const Duration(milliseconds: 100));
        }
      }
    }
  }

  // Future<void> _scrollToIndex(int index) async {
  //   // _scrollController.removeListener(_animateToTab);
  //   if (_categoryKeys[index].currentContext != null) {
  //     final categoryContext = _categoryKeys[index].currentContext!;

  //     await Scrollable.ensureVisible(categoryContext,
  //         duration: const Duration(milliseconds: 100));
  //     _currentCategoryIndex = index;
  //   }

  //   // _scrollController.addListener(_animateToTab);
  // }

  // Future<void> _scrollToIndex(
  //     int index, ScrollController scrollController) async {
  //   if (_categoryKeys[index].currentContext != null) {
  //     final categoryContext = _categoryKeys[index].currentContext!;
  //     RenderBox box = categoryContext.findRenderObject() as RenderBox;
  //     Offset position = box.localToGlobal(Offset.zero);
  //     scrollController.animateTo(position.dy,
  //         duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
  //     _currentCategoryIndex = index;
  //   }
  // }

  // final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: null,
    ));
    _store = widget.store;
    if (_store.productCategories != null) {
      _categoryKeys = _store.productCategories!
          .map(
            (e) => GlobalKey(),
          )
          .toList();
    }
    _isFavorite = favoriteStores.any((element) => element.id == _store.id);

    // _scrollController.addListener(_animateToTab);

    _distance = const Distance(
      roundResult: true,
    );
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) {
    //     SystemChrome.setSystemUIOverlayStyle(
    //       SystemUiOverlayStyle(
    //         statusBarColor:
    //             AppColors.neutral500, // Replace with your desired color
    //       ),
    //     );
    //   },
    // );
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _store.productCategories!.length,
        child: NestedScrollView(
          // controller: _scrollController,
          body: Builder(builder: (context) {
            _tabContext = context;

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                // _scrollNotification = notification;
                _animateToTab(notification);
                return false;
              },
              child: CustomScrollView(
                // controller: _scrollController,
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 135,
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
                                              ]),
                                          AppButton2(
                                              text: 'Try free for 4 weeks',
                                              callback: () {
                                                navigatorKey.currentState!
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const JoinUberOneScreen(),
                                                ));
                                              }),
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
                                                  text:
                                                      'Use by May 31, 2025 11 PM',
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
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Container(
                                            //   width: double.infinity,
                                            //   color: AppColors.uberOneGold,
                                            // ),
                                            Image.asset(
                                              height: double.infinity,
                                              AssetNames.greenTag,

                                              // fit: BoxFit.cover,
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              )),
                        ],
                      ),
                    ),
                    const Gap(10),
                  ])),
                  (_store.productCategories != null &&
                          _store.productCategories!.isNotEmpty)
                      ? SliverList.separated(
                          separatorBuilder: (context, index) => const Divider(
                            thickness: 2,
                          ),
                          itemCount: _store.productCategories!.length,
                          itemBuilder: (context, index) {
                            final productCategory =
                                _store.productCategories![index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  key: _categoryKeys[index],
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall,
                                      vertical: 8),
                                  child: AppText(
                                    text: productCategory.name,
                                    size: AppSizes.heading5,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(5),
                                (productCategory.name != 'Featured items')
                                    ? ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        // cacheExtent: 50000,
                                        // padding: const EdgeInsets.symmetric(
                                        //     horizontal: AppSizes.horizontalPaddingSmall),
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: productCategory
                                            .productsAndQuantities.length,
                                        itemBuilder: (context, index) {
                                          final productReference =
                                              productCategory
                                                      .productsAndQuantities[
                                                  index]['product'];
                                          return FutureBuilder<Product>(
                                              future: AppFunctions
                                                  .loadProductReference(
                                                      productReference
                                                          as DocumentReference),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Skeletonizer(
                                                    enabled: true,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: AppSizes
                                                              .horizontalPaddingSmall),
                                                      child: Row(
                                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AppText(
                                                                  text:
                                                                      'nklanslldslmasdlms',
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                  maxLines: 3,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    AppText(
                                                                      text:
                                                                          '20.50',
                                                                    ),
                                                                  ],
                                                                ),
                                                                AppText(
                                                                  text:
                                                                      'nanlasndlfmsalmflamflmalfmlewmalfmds,fmasd, mkfadm,fam,maf,mafm,famlmlasmlamlaf;lm',
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
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            child: Container(
                                                              width: 100,
                                                              height: 100,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
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
                                                        store: _store,
                                                      ),
                                                    ));
                                                  },
                                                  child: Ink(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: AppSizes
                                                              .horizontalPaddingSmall),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AppText(
                                                                  text: product
                                                                      .name,
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                  size: AppSizes
                                                                      .bodySmall,
                                                                  maxLines: 3,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Visibility(
                                                                      visible:
                                                                          product.promoPrice !=
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
                                                                      decoration: product.promoPrice !=
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
                                                                            ' • ${product.calories!.toInt()} Cal.',
                                                                        maxLines:
                                                                            2,
                                                                        color: AppColors
                                                                            .neutral500,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      )
                                                                  ],
                                                                ),
                                                                if (product.description !=
                                                                        null ||
                                                                    product.ingredients !=
                                                                        null)
                                                                  AppText(
                                                                    text: product
                                                                            .description ??
                                                                        product
                                                                            .ingredients!,
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
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            children: [
                                                              ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child:
                                                                      Builder(
                                                                    builder:
                                                                        (context) {
                                                                      if (product
                                                                          .imageUrls
                                                                          .first
                                                                          .startsWith(
                                                                              'http')) {
                                                                        return CachedNetworkImage(
                                                                          imageUrl: product
                                                                              .imageUrls
                                                                              .first,
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              100,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        );
                                                                      } else if (product
                                                                          .imageUrls
                                                                          .first
                                                                          .startsWith(
                                                                              'data:image')) {
                                                                        // It's a base64 string
                                                                        try {
                                                                          String base64String = product
                                                                              .imageUrls
                                                                              .first
                                                                              .split(',')
                                                                              .last;
                                                                          Uint8List
                                                                              bytes =
                                                                              base64Decode(base64String);
                                                                          return Image.memory(
                                                                              width: 100,
                                                                              height: 100,
                                                                              fit: BoxFit.fill,
                                                                              bytes);
                                                                        } catch (e) {
                                                                          // logger.d(
                                                                          //     'Error decoding base64 image: $e');
                                                                          return const AppText(
                                                                              text: 'Error loading image');
                                                                        }
                                                                      } else {
                                                                        // Handle invalid image source (neither URL nor base64)
                                                                        return const AppText(
                                                                            text:
                                                                                'Invalid image source');
                                                                      }
                                                                    },
                                                                  )),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8.0,
                                                                        top:
                                                                            8.0),
                                                                child: InkWell(
                                                                  onTap: () {},
                                                                  child: Ink(
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          boxShadow: const [
                                                                            BoxShadow(
                                                                              color: Colors.black12,
                                                                              offset: Offset(2, 2),
                                                                            )
                                                                          ],
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(50)),
                                                                      child:
                                                                          //Implement add button
                                                                          const Icon(
                                                                        Icons
                                                                            .add,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      )
                                    : SizedBox(
                                        height: 191,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final productReference =
                                                  productCategory
                                                          .productsAndQuantities[
                                                      index]['product'];
                                              return FutureBuilder<Product>(
                                                  future: AppFunctions
                                                      .loadProductReference(
                                                          productReference
                                                              as DocumentReference),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Skeletonizer(
                                                          child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              color:
                                                                  Colors.black,
                                                              width: 100,
                                                              height: 100,
                                                            ),
                                                          ),
                                                          const AppText(
                                                              text:
                                                                  'halljaljklas'),
                                                          const AppText(
                                                              text:
                                                                  'kllakasjljalsklaslkalf')
                                                        ],
                                                      ));
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return AppText(
                                                          text: snapshot.error
                                                              .toString());
                                                    }

                                                    final product =
                                                        snapshot.data!;
                                                    return SizedBox(
                                                      width: 140,
                                                      child: InkWell(
                                                        onTap: () {
                                                          navigatorKey
                                                              .currentState!
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductScreen(
                                                              product: product,
                                                              store: _store,
                                                            ),
                                                          ));
                                                        },
                                                        child: Ink(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        AppSizes
                                                                            .horizontalPaddingSmall),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  children: [
                                                                    Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomRight,
                                                                      children: [
                                                                        ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child: Builder(
                                                                              builder: (context) {
                                                                                if (product.imageUrls.first.startsWith('http')) {
                                                                                  return CachedNetworkImage(
                                                                                    imageUrl: product.imageUrls.first,
                                                                                    width: 100,
                                                                                    height: 100,
                                                                                    fit: BoxFit.fill,
                                                                                  );
                                                                                } else if (product.imageUrls.first.startsWith('data:image')) {
                                                                                  // It's a base64 string
                                                                                  try {
                                                                                    String base64String = product.imageUrls.first.split(',').last;
                                                                                    Uint8List bytes = base64Decode(base64String);
                                                                                    return Image.memory(width: 100, height: 100, fit: BoxFit.fill, bytes);
                                                                                  } catch (e) {
                                                                                    // logger.d(
                                                                                    //     'Error decoding base64 image: $e');
                                                                                    return const AppText(text: 'Error loading image');
                                                                                  }
                                                                                } else {
                                                                                  // Handle invalid image source (neither URL nor base64)
                                                                                  return const AppText(text: 'Invalid image source');
                                                                                }
                                                                              },
                                                                            )),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 8.0,
                                                                              top: 8.0),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {},
                                                                            child:
                                                                                Ink(
                                                                              child: Container(
                                                                                padding: const EdgeInsets.all(5),
                                                                                decoration: BoxDecoration(boxShadow: const [
                                                                                  BoxShadow(
                                                                                    color: Colors.black12,
                                                                                    offset: Offset(2, 2),
                                                                                  )
                                                                                ], color: Colors.white, borderRadius: BorderRadius.circular(50)),
                                                                                child:
                                                                                    //Implement add button
                                                                                    const Icon(
                                                                                  Icons.add,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    if (index <
                                                                        3)
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                5,
                                                                            vertical:
                                                                                2),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.green.shade900,
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            AppText(
                                                                          text:
                                                                              '#${index + 1} most liked',
                                                                          size:
                                                                              AppSizes.bodySmallest,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      )
                                                                  ],
                                                                ),
                                                                const Gap(10),
                                                                AppText(
                                                                  text: product
                                                                      .name,
                                                                  size: AppSizes
                                                                      .bodySmall,
                                                                  maxLines: 3,
                                                                  weight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    if (product
                                                                            .promoPrice !=
                                                                        null)
                                                                      AppText(
                                                                        text:
                                                                            '\$${product.promoPrice.toString()}',
                                                                        color: Colors
                                                                            .green
                                                                            .shade900,
                                                                      ),
                                                                    AppText(
                                                                      text:
                                                                          '\$${product.initialPrice}',
                                                                      decoration: product.promoPrice !=
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
                                                                            ' • ${product.calories!.toInt()} Cal',
                                                                        color: AppColors
                                                                            .neutral500,
                                                                      )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Gap(2),
                                            itemCount: productCategory
                                                .productsAndQuantities.length),
                                      ),
                                const Gap(20)
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
            );
          }),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar.medium(
              automaticallyImplyLeading: false,
              expandedHeight: 380,
              toolbarHeight: 115,
              collapsedHeight: 115,
              title: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  navigatorKey.currentState!.pop();
                                },
                                child:
                                    Ink(child: const Icon(Icons.arrow_back))),
                            const Gap(10),
                            AppText(
                              text: _store.name,
                              size: AppSizes.heading6,
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () => navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) =>
                                      SearchMenuScreen(_store),
                                )),
                            child: Ink(child: const Icon(Icons.search)))
                      ],
                    ),
                  ),
                  if (_store.productCategories != null)
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: AppText(
                                        text: 'Menu',
                                        size: AppSizes.heading6,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                    const Divider(),
                                    ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          _store.productCategories!.length,
                                      separatorBuilder: (context, index) =>
                                          const Gap(5),
                                      itemBuilder: (context, index) {
                                        final category =
                                            _store.productCategories![index];
                                        return ListTile(
                                          onTap: () async {
                                            navigatorKey.currentState!.pop();
                                            // return _scrollToIndex(
                                            //     index, _scrollController);
                                          },
                                          title: AppText(
                                            text: category.name,
                                            size: AppSizes.bodySmall,
                                            color:
                                                _currentCategoryIndex == index
                                                    ? Colors.black
                                                    : AppColors.neutral500,
                                          ),
                                        );
                                      },
                                    ),
                                    const Gap(5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizes.horizontalPaddingSmall),
                                      child: AppButton(
                                        text: 'Dismiss',
                                        callback: () =>
                                            navigatorKey.currentState!.pop(),
                                      ),
                                    ),
                                    const Gap(15),
                                  ],
                                );
                              },
                            );
                          },
                          child: Ink(
                            child: const Icon(Icons.list),
                          ),
                        ),
                        Expanded(
                          child: TabBar(
                            onTap: (value) async {
                              _currentCategoryIndex = value;
                              // await _scrollToIndex(value, _scrollController);
                              // _animateToTab(scrollNotification);
                            },
                            tabAlignment: TabAlignment.start,
                            isScrollable: true,
                            tabs: _store.productCategories!
                                .map(
                                  (e) => AppText(text: e.name),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    )
                  // for stores with storeschedule TabBarView(children: [])
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    Stack(
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
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Gap(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: navigatorKey.currentState!.pop,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black26,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          )),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            final userId = FirebaseAuth
                                                .instance.currentUser!.uid;
                                            if (_isFavorite) {
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      FirestoreCollections
                                                          .favoriteStores)
                                                  .doc(userId)
                                                  .update({
                                                widget.store.id:
                                                    FieldValue.delete()
                                              }).then(
                                                (value) {
                                                  favoriteStores.removeWhere(
                                                    (element) =>
                                                        element.id ==
                                                        widget.store.id,
                                                  );
                                                },
                                              );
                                            } else {
                                              var store = FavouriteStore(
                                                  id: widget.store.id,
                                                  dateFavorited:
                                                      DateTime.now());
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      FirestoreCollections
                                                          .favoriteStores)
                                                  .doc(userId)
                                                  .update({
                                                store.id: store.toJson()
                                              }).then(
                                                (value) =>
                                                    favoriteStores.add(store),
                                              );
                                            }
                                            setState(() {
                                              _isFavorite = favoriteStores.any(
                                                  (element) =>
                                                      element.id == _store.id);
                                            });
                                            if (_isFavorite) {
                                              showInfoToast(
                                                  icon: const Icon(
                                                    Icons.favorite,
                                                    color: Colors.white,
                                                  ),
                                                  'Added to favorites',
                                                  context: navigatorKey
                                                      .currentContext!);
                                            }
                                          },
                                          child: Ink(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              padding: const EdgeInsets.all(8),
                                              child: Icon(
                                                _isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Gap(5),
                                        InkWell(
                                          onTap: () {
                                            navigatorKey.currentState!
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchMenuScreen(_store),
                                            ));
                                          },
                                          child: Ink(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: const Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                        const Gap(5),
                                        InkWell(
                                          onTap: () => showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10))),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      onTap: () {},
                                                      leading: const Icon(
                                                          Icons.share),
                                                      title: const AppText(
                                                          text: 'Share'),
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
                                                                  _store),
                                                        ));
                                                      },
                                                      leading: const Icon(
                                                          Icons.info_outline),
                                                      title: const AppText(
                                                          text:
                                                              'View store info'),
                                                      subtitle: const AppText(
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
                                                    color: Colors.black26,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: const Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const Gap(50),
                                Material(
                                  shape: const CircleBorder(),
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: _store.logo,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                AppText(
                                  text: _store.name,
                                  size: AppSizes.heading6,
                                  weight: FontWeight.w600,
                                ),
                                const Gap(5),
                                InkWell(
                                  onTap: () {
                                    navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          StoreDetailsScreen(widget.store),
                                    ));
                                  },
                                  child: Ink(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppText(
                                          text:
                                              '${_store.rating.averageRating}',
                                        ),
                                        const Icon(
                                          Icons.star,
                                          size: 10,
                                        ),
                                        AppText(
                                            text:
                                                '(${_store.rating.ratings}+)'),
                                        if (_store.isUberOneShop)
                                          Row(
                                            children: [
                                              const Gap(5),
                                              Image.asset(
                                                AssetNames.uberOneSmall,
                                                width: 15,
                                                color: AppColors.uberOneGold,
                                              ),
                                              const AppText(
                                                text: ' • Uber One',
                                                color: AppColors.uberOneGold,
                                              ),
                                            ],
                                          ),
                                        AppText(
                                            text:
                                                ' • ${_distance.as(LengthUnit.Kilometer, LatLng(_store.location.latlng.latitude, _store.location.latlng.longitude), LatLng(widget.userLocation.latitude, widget.userLocation.longitude))} km '),
                                        const Icon(Icons.keyboard_arrow_right)
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CupertinoSlidingSegmentedControl<int>(
                                      backgroundColor: AppColors.neutral100,
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
                                        if (_store.doesPickup) {
                                          setState(() {
                                            _retrievalFilter = value;
                                            // if (value == 0) {
                                            //   _retrievalFilter = 'Delivery';
                                            // } else {
                                            //   _retrievalFilter = 'Pickup';
                                            // }
                                          });
                                        }
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // var userInfo =
                                        //     Hive.box(AppBoxes.appState)
                                        //         .get(BoxKeys.userInfo);
                                        // userInfo['groupOrders'] = <String>[];
                                        // Hive.box(AppBoxes.appState)
                                        //     .put(BoxKeys.userInfo, userInfo);

                                        navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                          builder: (context) => ShowCaseWidget(
                                              builder: (context) {
                                            List<String> groupOrders =
                                                Hive.box(AppBoxes.appState)
                                                        .get(BoxKeys.userInfo)[
                                                    'groupOrders'];
                                            var storeGroupOrders =
                                                groupOrders.where(
                                              (element) =>
                                                  element.contains(_store.id),
                                            );
                                            if (storeGroupOrders.isEmpty) {
                                              return GroupOrderSettingsScreen(
                                                  store: _store);
                                            } else {
                                              return GroupOrderScreen(
                                                  store: _store,
                                                  groupOrderPaths:
                                                      storeGroupOrders);
                                            }
                                          }),
                                        ));
                                      },
                                      child: Ink(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: AppColors.neutral100,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.person_add_outlined,
                                                size: 20,
                                              ),
                                              Gap(5),
                                              AppText(text: 'Group order')
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const Gap(10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.neutral300)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          AppText(
                                              text:
                                                  '\$${_store.delivery.fee.toString()} Delivery Fee'),
                                          const AppText(
                                            text: 'Pricing & fees',
                                            color: AppColors.neutral500,
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
                                            text: 'Delivery time',
                                            color: AppColors.neutral500,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//TODO: More to explore horizontal listview at the bottom of the product category menu
