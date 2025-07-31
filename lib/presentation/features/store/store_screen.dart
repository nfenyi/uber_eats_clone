import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/product/product_screen.dart';
import 'package:uber_eats_clone/presentation/features/promotion/promo_screen.dart';
import 'package:uber_eats_clone/presentation/features/store/search_menu_screen.dart';
import 'package:uber_eats_clone/presentation/features/store/store_details_screen.dart';

import '../../../hive_adapters/geopoint/geopoint_adapter.dart';
import '../../../main.dart';
import '../../../models/favourite/favourite_model.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../constants/asset_names.dart';
import '../../services/google_maps_services.dart';
import '../../services/place_detail_model.dart';
import '../../services/sign_in_view_model.dart';
import '../home/home_screen.dart';
import '../main_screen/screens/main_screen.dart';

class StoreScreen extends ConsumerStatefulWidget {
  final Store store;

  const StoreScreen(this.store, {super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen>
    with SingleTickerProviderStateMixin {
  late final Store _store;
  late final List<GlobalKey> _categoryKeys;
  late final GeoPoint _storeLatLng;

  late lt.Distance _distance;
  late int? _retrievalFilter;
  late bool _isFavorite;
  late final HiveGeoPoint _selectedGeoPoint;

  late final double _calculatedDistance;
  late final TabController _tabController;

  final _showSearchButtonNotifier = ValueNotifier<bool>(false);
  final _nestedScrollViewKey = GlobalKey<NestedScrollViewState>();
  late final double _averageProductCount;
  final estimatedProductHeight =
      107; //the 7 is added to cater for spacing between products and the category name apptext

  void _animateToTab() async {
    late RenderBox box;
    for (var i = 0; i < _categoryKeys.length; i++) {
      if (_categoryKeys[i].currentContext != null) {
        box = _categoryKeys[i].currentContext!.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        if (_nestedScrollViewKey.currentState!.innerController.offset >=
            position.dy) {
          // _currentCategoryIndex = i;
          // DefaultTabController.of(_tabContext!)
          _tabController.animateTo(i,
              duration: const Duration(milliseconds: 100));
        }
      }
    }
  }

  Future<void> _scrollToIndex(int index) async {
    _nestedScrollViewKey.currentState!.innerController
        .removeListener(_animateToTab);
    // logger.d(_categoryKeys[index].currentContext == null);
    // logger.d(_nestedScrollViewKey.currentState!.innerController.offset);
    // logger.d(((index - _tabController.index) *
    //     _averageProductCount *
    //     estimatedProductHeight));
    if (_categoryKeys[index].currentContext == null) {
      await _nestedScrollViewKey.currentState!.innerController.animateTo(
          _nestedScrollViewKey.currentState!.innerController.offset +
              ((index - _tabController.previousIndex) *
                  _averageProductCount *
                  estimatedProductHeight),
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (_categoryKeys[index].currentContext != null) {
      final categoryContext = _categoryKeys[index].currentContext!;
      if (context.mounted) {
        await Scrollable.ensureVisible(categoryContext,
            duration: const Duration(milliseconds: 100));
        _tabController.animateTo(index);
        // setState(() {
        //   _currentCategoryIndex = index;
        // });
      }
    }

    _nestedScrollViewKey.currentState!.innerController
        .addListener(_animateToTab);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: null,
    ));

    _store = widget.store;
    _retrievalFilter = _store.delivery.canDeliver ? 0 : 1;
    _storeLatLng = _store.location.latlng as GeoPoint;
    if (_store.productCategories != null) {
      _categoryKeys = _store.productCategories!
          .map(
            (e) => GlobalKey(),
          )
          .toList();
    }
    _isFavorite = favoriteStores.any((element) => element.id == _store.id);

    // _scrollController.addListener(_animateToTab);

    _distance = const lt.Distance(
      roundResult: true,
    );
    final userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    _selectedGeoPoint = userInfo['selectedAddress']['latlng'];
    _calculatedDistance = _distance.as(
        lt.LengthUnit.Kilometer,
        lt.LatLng(_storeLatLng.latitude, _storeLatLng.longitude),
        lt.LatLng(_selectedGeoPoint.latitude, _selectedGeoPoint.longitude));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nestedScrollViewKey.currentState!.outerController.addListener(() {
        if (_nestedScrollViewKey.currentState!.outerController.offset <= 0) {
          _showSearchButtonNotifier.value = false;
        } else {
          _showSearchButtonNotifier.value = true;
        }
      });
      _nestedScrollViewKey.currentState!.innerController
          .addListener(_animateToTab);
    });
    if (_store.productCategories != null) {
      int noOfProducts = 0;
      for (var category in _store.productCategories!) {
        noOfProducts += category.productsAndQuantities.length;
      }

      _averageProductCount = noOfProducts / noOfProducts;
    }
    _tabController = TabController(
        length: _store.productCategories?.length ?? 0, vsync: this);
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        key: _nestedScrollViewKey,
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              const BannerCarousel(),
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
                      final productCategory = _store.productCategories![index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            key: _categoryKeys[index],
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall,
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  // cacheExtent: 50000,
                                  // padding: const EdgeInsets.symmetric(
                                  //     horizontal: AppSizes.horizontalPaddingSmall),
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: productCategory
                                      .productsAndQuantities.length,
                                  itemBuilder: (context, index) {
                                    final productReference = productCategory
                                        .productsAndQuantities[index].product;
                                    return FutureBuilder<Product>(
                                        future:
                                            AppFunctions.loadProductReference(
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
                                                                FontWeight.w600,
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Row(
                                                            children: [
                                                              AppText(
                                                                text: '20.50',
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
                                                          BorderRadius.circular(
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
                                                text:
                                                    snapshot.error.toString());
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
                                                      CrossAxisAlignment.start,
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
                                                                      ' • ${product.calories!.toInt()} Cal.',
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
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            child: AppFunctions
                                                                .displayNetworkImage(
                                                                    product
                                                                        .imageUrls
                                                                        .first,
                                                                    width: 100,
                                                                    height: 100,
                                                                    fit: BoxFit
                                                                        .fill)),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8.0,
                                                                    top: 8.0),
                                                            child:
                                                                AddToCartButton(
                                                                    product:
                                                                        product,
                                                                    store: widget
                                                                        .store))
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
                                  height: 200,
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final productReference = productCategory
                                            .productsAndQuantities[index]
                                            .product;
                                        return FutureBuilder<Product>(
                                            future: AppFunctions
                                                .loadProductReference(
                                                    productReference
                                                        as DocumentReference),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Skeletonizer(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Container(
                                                        color: Colors.black,
                                                        width: 100,
                                                        height: 100,
                                                      ),
                                                    ),
                                                    const AppText(
                                                        text: 'halljaljklas'),
                                                    const AppText(
                                                        text:
                                                            'kllakasjljalsklaslkalf')
                                                  ],
                                                ));
                                              } else if (snapshot.hasError) {
                                                return SizedBox(
                                                  width: 145,
                                                  child: AppText(
                                                      text: snapshot.error
                                                          .toString()),
                                                );
                                              }

                                              final product = snapshot.data!;
                                              return SizedBox(
                                                width: 145,
                                                child: InkWell(
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
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            children: [
                                                              Stack(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                children: [
                                                                  ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child: AppFunctions.displayNetworkImage(
                                                                          product
                                                                              .imageUrls
                                                                              .first,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              100)),
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              8.0,
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          AddToCartButton(
                                                                        store: widget
                                                                            .store,
                                                                        product:
                                                                            product,
                                                                      )),
                                                                ],
                                                              ),
                                                              if (index < 3)
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .green
                                                                          .shade900,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child:
                                                                      AppText(
                                                                    text:
                                                                        '#${index + 1} most liked',
                                                                    size: AppSizes
                                                                        .bodySmallest,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                            ],
                                                          ),
                                                          const Gap(10),
                                                          AppText(
                                                            text: product.name,
                                                            size: AppSizes
                                                                .bodySmall,
                                                            maxLines: 3,
                                                            weight:
                                                                FontWeight.bold,
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
                                      separatorBuilder: (context, index) =>
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
                              child: Ink(child: const Icon(Icons.arrow_back))),
                          const Gap(10),
                          AppText(
                            text: _store.name,
                            size: AppSizes.heading6,
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                          valueListenable: _showSearchButtonNotifier,
                          builder: (context, value, child) {
                            return Visibility(
                              child: InkWell(
                                  onTap: () => navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            SearchMenuScreen(_store),
                                      )),
                                  child: Ink(child: const Icon(Icons.search))),
                            );
                          })
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
                                    padding: EdgeInsets.symmetric(vertical: 10),
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
                                    itemCount: _store.productCategories!.length,
                                    separatorBuilder: (context, index) =>
                                        const Gap(5),
                                    itemBuilder: (context, index) {
                                      final category =
                                          _store.productCategories![index];
                                      return ListTile(
                                        onTap: () async {
                                          navigatorKey.currentState!.pop();
                                          await _scrollToIndex(
                                            index,
                                          );
                                        },
                                        title: AppText(
                                          text: category.name,
                                          size: AppSizes.bodySmall,
                                          color: _tabController.index == index
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
                          controller: _tabController,
                          onTap: (value) async {
                            await _scrollToIndex(value);
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
                                                .collection(FirestoreCollections
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
                                                dateFavorited: DateTime.now());
                                            await FirebaseFirestore.instance
                                                .collection(FirestoreCollections
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
                                                    BorderRadius.circular(50)),
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
                                              padding: const EdgeInsets.all(8),
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
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    onTap: () {},
                                                    leading:
                                                        const Icon(Icons.share),
                                                    title: const AppText(
                                                        text: 'Share'),
                                                  ),
                                                  ListTile(
                                                    onTap: () async {
                                                      final userLocationData =
                                                          await AppFunctions
                                                              .getUserCurrentLocation();
                                                      if (userLocationData ==
                                                          null) {
                                                        if (context.mounted) {
                                                          await showAppInfoDialog(
                                                              context,
                                                              description:
                                                                  'Seems the necessary location permissions have not been accepted yet');
                                                        }
                                                        return;
                                                      }
                                                      final result = await GoogleMapsServices()
                                                          .fetchDetailsFromLatlng(
                                                              latlng: LatLng(
                                                                  userLocationData
                                                                      .latitude!,
                                                                  userLocationData
                                                                      .longitude!));
                                                      final List<PlaceResult>
                                                          payload =
                                                          result.payload;
                                                      final location = payload
                                                          .first
                                                          .geometry!
                                                          .location;
                                                      final BitmapDescriptor
                                                          bitmapDescriptor =
                                                          await BitmapDescriptor
                                                              .asset(
                                                        const ImageConfiguration(
                                                            size: Size(13, 13)),
                                                        AssetNames.mapMarker2,
                                                      );
                                                      navigatorKey.currentState!
                                                          .pop();
                                                      await navigatorKey
                                                          .currentState!
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            StoreDetailsScreen(
                                                                distance:
                                                                    _calculatedDistance,
                                                                location:
                                                                    location!,
                                                                markerIcon:
                                                                    bitmapDescriptor,
                                                                store: widget
                                                                    .store),
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
                                              padding: const EdgeInsets.all(8),
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
                                onTap: () async {
                                  final userLocationData = await AppFunctions
                                      .getUserCurrentLocation();
                                  if (userLocationData == null) {
                                    if (context.mounted) {
                                      await showAppInfoDialog(context,
                                          description:
                                              'Seems the necessary location permissions have not been accepted yet');
                                    }
                                    return;
                                  }
                                  final result = await GoogleMapsServices()
                                      .fetchDetailsFromLatlng(
                                          latlng: LatLng(
                                              userLocationData.latitude!,
                                              userLocationData.longitude!));
                                  final List<PlaceResult> payload =
                                      result.payload;
                                  final location =
                                      payload.first.geometry!.location;
                                  final BitmapDescriptor bitmapDescriptor =
                                      await BitmapDescriptor.asset(
                                    const ImageConfiguration(
                                        size: Size(13, 13)),
                                    AssetNames.mapMarker2,
                                  );

                                  await navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => StoreDetailsScreen(
                                        distance: _calculatedDistance,
                                        location: location!,
                                        markerIcon: bitmapDescriptor,
                                        store: widget.store),
                                  ));
                                },
                                child: Ink(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppText(
                                        text: '${_store.rating.averageRating}',
                                      ),
                                      const Icon(
                                        Icons.star,
                                        size: 10,
                                      ),
                                      AppText(
                                          text: '(${_store.rating.ratings}+)'),
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
                                          text: ' • $_calculatedDistance km '),
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
                                        });
                                      }
                                    },
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      // var userInfo =
                                      //     Hive.box(AppBoxes.appState)
                                      //         .get(BoxKeys.userInfo);
                                      // userInfo['groupOrders'] = <String>[];
                                      // Hive.box(AppBoxes.appState)
                                      //     .put(BoxKeys.userInfo, userInfo);
                                      await AppFunctions.createGroupOrder(
                                          _store);
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
    );
  }
}

//TODO: More to explore horizontal listview at the bottom of the product category menu
