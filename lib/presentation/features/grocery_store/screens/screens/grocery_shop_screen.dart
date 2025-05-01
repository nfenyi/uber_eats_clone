import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_color_builder/image_color_builder.dart';
import 'package:marquee_list/marquee_list.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/screens/main_screen.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

import '../../../../../app_functions.dart';
import '../../../../../hive_adapters/geopoint/geopoint_adapter.dart';
import '../../../../../main.dart';
import '../../../../../models/favourite/favourite_model.dart';
import '../../../../../models/store/store_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';

import '../../../../core/widgets.dart';
import '../../../../services/google_maps_services.dart';
import '../../../../services/place_detail_model.dart';
import '../../../address/screens/addresses_screen.dart';
import '../../../store/store_details_screen.dart';
import 'grocery_shop_search_screen.dart';
import '../../../home/home_screen.dart';
import 'package:latlong2/latlong.dart' as lt;

class GroceryShopScreen extends StatefulWidget {
  final Store groceryStore;
  const GroceryShopScreen({super.key, required this.groceryStore});

  @override
  State<GroceryShopScreen> createState() => _GroceryShopScreenState();
}

class _GroceryShopScreenState extends State<GroceryShopScreen> {
  final _backgroundColorNotifier = ValueNotifier<Color?>(null);
  late lt.Distance _distance;
  late final double _calculatedDistance;
  late final HiveGeoPoint _selectedGeoPoint;
  late final GeoPoint _storeLatLng;

  @override
  void initState() {
    super.initState();
    _storeLatLng = widget.groceryStore.location.latlng as GeoPoint;
    _distance = const lt.Distance(
      roundResult: true,
    );
    final userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    _selectedGeoPoint = userInfo['selectedAddress']['latlng'];
    _calculatedDistance = _distance.as(
        lt.LengthUnit.Kilometer,
        lt.LatLng(_storeLatLng.latitude, _storeLatLng.longitude),
        lt.LatLng(_selectedGeoPoint.latitude, _selectedGeoPoint.longitude));
  }

  @override
  void dispose() {
    _backgroundColorNotifier.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              ValueListenableBuilder(
                  valueListenable: _backgroundColorNotifier,
                  builder: (context, value, child) {
                    return SliverAppBar.medium(
                      title: InkWell(
                        onTap: () {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) => GroceryShopSearchScreen(
                              store: widget.groceryStore,
                            ),
                          ));
                        },
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
                      backgroundColor: _backgroundColorNotifier.value,
                      collapsedHeight: 55,
                      toolbarHeight: 55,
                      automaticallyImplyLeading: false,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.horizontalPaddingSmall),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  bool isFavourite =
                                      favoriteStores.firstWhereOrNull(
                                                (store) =>
                                                    store.id ==
                                                    widget.groceryStore.id,
                                              ) !=
                                              null
                                          ? true
                                          : false;

                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            dense: true,
                                            onTap: () async {
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                              await AppFunctions
                                                  .createGroupOrder(
                                                      widget.groceryStore);
                                            },
                                            leading: const Icon(
                                              Icons.person_add_outlined,
                                            ),
                                            title: const AppText(
                                              text: 'Group order',
                                            ),
                                          ),
                                          const Divider(
                                            indent: 40,
                                          ),
                                          ListTile(
                                            dense: true,
                                            onTap: () async {
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                              final userId = FirebaseAuth
                                                  .instance.currentUser!.uid;
                                              if (isFavourite) {
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        FirestoreCollections
                                                            .favoriteStores)
                                                    .doc(userId)
                                                    .update({
                                                  widget.groceryStore.id:
                                                      FieldValue.delete()
                                                }).then(
                                                  (value) {
                                                    favoriteStores.removeWhere(
                                                      (element) =>
                                                          element.id ==
                                                          widget
                                                              .groceryStore.id,
                                                    );
                                                  },
                                                );
                                              } else {
                                                var store = FavouriteStore(
                                                    id: widget.groceryStore.id,
                                                    dateFavorited:
                                                        DateTime.now());
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        FirestoreCollections
                                                            .favoriteStores)
                                                    .doc(userId)
                                                    .update({
                                                  store.id: store.toJson()
                                                });
                                              }
                                              // setState(() {});
                                            },
                                            leading: Icon(
                                              isFavourite
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,
                                            ),
                                            title: AppText(
                                              text: isFavourite
                                                  ? 'Remove from favourites'
                                                  : 'Add to favourites',
                                            ),
                                          ),
                                          const Divider(
                                            indent: 40,
                                          ),
                                          ListTile(
                                            dense: true,
                                            onTap: () async {
                                              final userLocationData =
                                                  await AppFunctions
                                                      .getUserCurrentLocation();
                                              if (userLocationData == null) {
                                                if (context.mounted) {
                                                  await showAppInfoDialog(
                                                      context,
                                                      description:
                                                          'Seems the necessary location permissions have not been accepted yet');
                                                }
                                                return;
                                              }
                                              final result =
                                                  await GoogleMapsServices()
                                                      .fetchDetailsFromLatlng(
                                                          latlng: LatLng(
                                                              userLocationData
                                                                  .latitude!,
                                                              userLocationData
                                                                  .longitude!));
                                              final List<PlaceResult> payload =
                                                  result.payload;
                                              final location = payload
                                                  .first.geometry!.location;
                                              final BitmapDescriptor
                                                  bitmapDescriptor =
                                                  await BitmapDescriptor.asset(
                                                const ImageConfiguration(
                                                    size: Size(15, 15)),
                                                AssetNames.mapMarker2,
                                              );
                                              navigatorKey.currentState!.pop();
                                              await navigatorKey.currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    StoreDetailsScreen(
                                                        distance:
                                                            _calculatedDistance,
                                                        location: location!,
                                                        markerIcon:
                                                            bitmapDescriptor,
                                                        store: widget
                                                            .groceryStore),
                                              ));
                                            },
                                            leading: const Icon(
                                              Icons.info_outline,
                                            ),
                                            title: const AppText(
                                              text: 'View store info',
                                            ),
                                            subtitle: const AppText(
                                              text: 'Hours, address and more',
                                              size: AppSizes.bodySmallest,
                                            ),
                                          ),
                                          const Divider(
                                            indent: 40,
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                            child: Ink(
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        )
                      ],
                      leadingWidth: 60,
                      leading: Padding(
                        padding: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                            bottom: 10,
                            left: AppSizes.horizontalPaddingSmall),
                        child: InkWell(
                          onTap: () {
                            navigatorKey.currentState!.pop();
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(50)),
                            padding: const EdgeInsets.all(1),
                            child: const Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      pinned: true,
                      floating: true,
                      expandedHeight: 290,
                      flexibleSpace: FlexibleSpaceBar(
                        background: ImageColorBuilder(
                            fit: BoxFit.fitHeight,
                            url: widget.groceryStore.logo,
                            placeholder: (contect, url) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.horizontalPaddingSmall,
                                    vertical: 50),
                                color: AppColors.neutral100,
                                child: Column(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.neutral100),
                                    width: 40,
                                    height: 60,
                                    child: Image.asset(
                                      AssetNames.storeBNW,
                                      // color: Colors.black,
                                      height: 40,
                                    ),
                                  ),
                                  const Gap(10),
                                  AppText(
                                    text: widget.groceryStore.name,
                                    color: Colors.white,
                                    size: AppSizes.bodySmall,
                                    weight: FontWeight.w600,
                                  ),
                                  const Gap(10),
                                  InkWell(
                                    onTap: () async {
                                      final userLocationData =
                                          await AppFunctions
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
                                            size: Size(15, 15)),
                                        AssetNames.mapMarker2,
                                      );

                                      await navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            StoreDetailsScreen(
                                                distance: _calculatedDistance,
                                                location: location!,
                                                markerIcon: bitmapDescriptor,
                                                store: widget.groceryStore),
                                      ));
                                    },
                                    child: Ink(
                                      child: MarqueeList(
                                          scrollDuration:
                                              const Duration(seconds: 20),
                                          children: [
                                            AppText(
                                                color: Colors.white,
                                                text:
                                                    '${widget.groceryStore.delivery.estimatedDeliveryTime} min'),
                                            AppText(
                                              color: Colors.white,
                                              text:
                                                  ' • \$${widget.groceryStore.delivery.fee} Delivery Fee',
                                            ),
                                            AppText(
                                              color: Colors.white,
                                              text:
                                                  ' • ${widget.groceryStore.location.streetAddress}',
                                            ),
                                            Visibility(
                                              visible: widget.groceryStore
                                                      .delivery.fee <
                                                  1,
                                              child: Row(children: [
                                                const AppText(
                                                  text: ' • ',
                                                  color: Colors.white,
                                                ),
                                                Image.asset(
                                                  AssetNames.uberOneSmall,
                                                  color: Colors.white,
                                                  height: 10,
                                                )
                                              ]),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  const Gap(10),
                                  InkWell(
                                    onTap: () {
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            GroceryShopSearchScreen(
                                          store: widget.groceryStore,
                                        ),
                                      ));
                                    },
                                    child: Ink(
                                      child: AppTextFormField(
                                        enabled: false,
                                        hintText:
                                            'Search ${widget.groceryStore.name}',
                                        radius: 50,
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(Icons.search),
                                        ),
                                      ),
                                    ),
                                  ),
                                ])),
                            builder: (context, image, imageColor) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                _backgroundColorNotifier.value = imageColor;
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (timeStamp) {
                                    SystemChrome.setSystemUIOverlayStyle(
                                      SystemUiOverlayStyle(
                                        statusBarColor: imageColor,
                                      ),
                                    );
                                  },
                                );
                              });
                              final hsl = HSLColor.fromColor(
                                  imageColor ?? Colors.green);
                              final hslDark = hsl.withLightness(
                                  (hsl.lightness - 0.2).clamp(0.0, 1.0));

                              SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                statusBarIconBrightness: Brightness.light,
                                statusBarColor: hslDark.toColor(),
                              ));
                              return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall,
                                      vertical: 50),
                                  color: imageColor ?? AppColors.neutral100,
                                  child: Column(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: SizedBox(
                                        height: 60,
                                        child: image!,
                                      ),
                                    ),
                                    const Gap(10),
                                    AppText(
                                      text: widget.groceryStore.name,
                                      color: Colors.white,
                                      size: AppSizes.body,
                                      weight: FontWeight.w600,
                                    ),
                                    const Gap(10),
                                    MarqueeList(
                                        scrollDuration:
                                            const Duration(seconds: 20),
                                        children: [
                                          AppText(
                                              color: Colors.white,
                                              text:
                                                  '${widget.groceryStore.delivery.estimatedDeliveryTime} min'),
                                          AppText(
                                            color: Colors.white,
                                            text:
                                                ' • \$${widget.groceryStore.delivery.fee} Delivery Fee',
                                          ),
                                          AppText(
                                            color: Colors.white,
                                            text:
                                                ' • ${widget.groceryStore.location.streetAddress}',
                                          ),
                                          Visibility(
                                            visible: widget
                                                    .groceryStore.delivery.fee <
                                                1,
                                            child: Row(children: [
                                              const AppText(
                                                text: ' • ',
                                                color: Colors.white,
                                              ),
                                              Image.asset(
                                                AssetNames.uberOneSmall,
                                                color: Colors.white,
                                                height: 10,
                                              )
                                            ]),
                                          ),
                                        ]),
                                    const Gap(10),
                                    InkWell(
                                      onTap: () {
                                        navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              GroceryShopSearchScreen(
                                            store: widget.groceryStore,
                                          ),
                                        ));
                                      },
                                      child: Ink(
                                        child: AppTextFormField(
                                          enabled: false,
                                          hintText:
                                              'Search ${widget.groceryStore.name}',
                                          radius: 50,
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Icon(Icons.search),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]));
                            }),
                        centerTitle: true,
                        titlePadding: EdgeInsets.zero,
                      ),
                    );
                  })
            ];
          },
          body: Visibility(
            visible: widget.groceryStore.productCategories != null &&
                widget.groceryStore.productCategories!.isNotEmpty,
            replacement: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  // fit: BoxFit.fitHeight,
                  AssetNames.store,
                  height: 100,
                  color: Colors.black,
                ),
                const Gap(10),
                const AppText(
                  text: 'Stores coming soon',
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(10),
                  CarouselSlider.builder(
                      itemCount: 2,
                      itemBuilder: (context, index, realIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: AppColors.neutral100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const AppText(
                                          size: AppSizes.bodySmallest,
                                          text:
                                              'Make Cinco de Mayo delicious! Get 30% off on DellMax'),
                                      AppButton2(
                                        text: 'Order Now',
                                        backgroundColor: Colors.white,
                                        callback: () {},
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: AppFunctions.displayNetworkImage(
                                      'data:image/jpeg;base64,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',
                                      width: double.infinity,
                                      height: double.infinity),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                          autoPlay: true,
                          viewportFraction: 0.84,
                          // padEnds: true,
                          height: 109,
                          enableInfiniteScroll: false,
                          scrollDirection: Axis.horizontal)),
                  ValueListenableBuilder(
                    valueListenable: Hive.box(AppBoxes.appState)
                        .listenable(keys: [BoxKeys.recentlyViewed]),
                    builder: (context, box, child) {
                      final Map? allrecentlyViewedProducts =
                          box.get(BoxKeys.recentlyViewed);

                      if (allrecentlyViewedProducts == null ||
                          allrecentlyViewedProducts.isEmpty ||
                          allrecentlyViewedProducts[widget.groceryStore.name] ==
                              null) {
                        return const SizedBox.shrink();
                      } else {
                        final Map recentlyViewedProducts =
                            allrecentlyViewedProducts[widget.groceryStore.name];
                        return Column(
                          children: [
                            MainScreenTopic(
                              callback: () {},
                              title: 'Recently viewed',
                            ),
                            const Gap(5),
                            SizedBox(
                              height: 200,
                              child: ListView.separated(
                                  itemCount: recentlyViewedProducts.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      const Gap(10),
                                  itemBuilder: (context, index) {
                                    final product =
                                        recentlyViewedProducts[index];
                                    return ProductGridTile(
                                        product: product,
                                        store: widget.groceryStore);
                                  }),
                            )
                          ],
                        );
                      }
                    },
                  ),
                  if (widget.groceryStore.offers != null &&
                      widget.groceryStore.offers!.isNotEmpty)
                    Column(
                      children: [
                        MainScreenTopic(
                          callback: () =>
                              navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) {
                              return Container();
                            },
                          )),
                          title: 'Deals',
                        ),
                        SizedBox(
                          height: 207,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              itemCount: widget.groceryStore.offers!.length,
                              separatorBuilder: (context, index) =>
                                  const Gap(15),
                              itemBuilder: (context, index) {
                                final offer =
                                    widget.groceryStore.offers![index];
                                return FutureBuilder<Product>(
                                    future: AppFunctions.getOfferProduct(
                                        offer as DocumentReference),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Skeletonizer(
                                          enabled: true,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                color: Colors.blue,
                                                width: 110,
                                                height: 200,
                                              )),
                                        );
                                      } else if (snapshot.hasError) {
                                        return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Container(
                                              color: AppColors.neutral100,
                                              width: 110,
                                              height: 200,
                                              child: AppText(
                                                text: snapshot.error.toString(),
                                                size: AppSizes.bodySmallest,
                                              ),
                                            ));
                                      }
                                      final product = snapshot.data!;
                                      return ProductGridTilePriceFirst(
                                          product: product,
                                          store: widget.groceryStore);

                                      //  InkWell(
                                      //   onTap: () {
                                      //     navigatorKey.currentState!
                                      //         .push(MaterialPageRoute(
                                      //       builder: (context) => ProductScreen(
                                      //         product: product,
                                      //         store: widget.groceryStore,
                                      //       ),
                                      //     ));
                                      //   },
                                      //   child: Ink(
                                      //     child: SizedBox(
                                      //       width: 110,
                                      //       child: Column(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: [
                                      //           ClipRRect(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(12),
                                      //             child: Stack(
                                      //               alignment:
                                      //                   Alignment.bottomRight,
                                      //               children: [
                                      //                 CachedNetworkImage(
                                      //                   imageUrl: product
                                      //                       .imageUrls.first,
                                      //                   width: 110,
                                      //                   height: 120,
                                      //                   fit: BoxFit.fill,
                                      //                 ),
                                      //                 Padding(
                                      //                   padding:
                                      //                       const EdgeInsets
                                      //                           .only(
                                      //                           right: 8.0,
                                      //                           top: 8.0),
                                      //                   child: InkWell(
                                      //                     //TODO: implement add button
                                      //                     onTap: () {},
                                      //                     child: Ink(
                                      //                       child: Container(
                                      //                         padding:
                                      //                             const EdgeInsets
                                      //                                 .all(5),
                                      //                         decoration: BoxDecoration(
                                      //                             boxShadow: const [
                                      //                               BoxShadow(
                                      //                                 color: Colors
                                      //                                     .black12,
                                      //                                 offset:
                                      //                                     Offset(
                                      //                                         2,
                                      //                                         2),
                                      //                               )
                                      //                             ],
                                      //                             color: Colors
                                      //                                 .white,
                                      //                             borderRadius:
                                      //                                 BorderRadius
                                      //                                     .circular(
                                      //                                         50)),
                                      //                         child: const Icon(
                                      //                           Icons.add,
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                 )
                                      //               ],
                                      //             ),
                                      //           ),
                                      //           const Gap(5),
                                      //           Row(
                                      //             children: [
                                      //               Visibility(
                                      //                 visible:
                                      //                     product.promoPrice !=
                                      //                         null,
                                      //                 child: Row(
                                      //                   children: [
                                      //                     AppText(
                                      //                         text:
                                      //                             '\$${product.promoPrice} ',
                                      //                         color:
                                      //                             Colors.green),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               AppText(
                                      //                 text:
                                      //                     "\$${product.initialPrice}",
                                      //                 color:
                                      //                     product.promoPrice ==
                                      //                             null
                                      //                         ? null
                                      //                         : AppColors
                                      //                             .neutral500,
                                      //                 decoration: product
                                      //                             .promoPrice !=
                                      //                         null
                                      //                     ? TextDecoration
                                      //                         .lineThrough
                                      //                     : TextDecoration.none,
                                      //                 weight:
                                      //                     product.promoPrice ==
                                      //                             null
                                      //                         ? FontWeight.bold
                                      //                         : null,
                                      //               )
                                      //             ],
                                      //           ),
                                      //           if (product.quantity != null)
                                      //             AppText(
                                      //                 text: product.quantity!),
                                      //           AppText(
                                      //             text: product.name,
                                      //             maxLines: 3,
                                      //             overflow:
                                      //                 TextOverflow.ellipsis,
                                      //           ),
                                      //           product.promoPrice != null
                                      //               ? Container(
                                      //                   decoration:
                                      //                       BoxDecoration(
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                             .circular(50),
                                      //                     color: Colors.green,
                                      //                   ),
                                      //                   child: AppText(
                                      //                     text: ((product.promoPrice! /
                                      //                                 product
                                      //                                     .initialPrice) *
                                      //                             100)
                                      //                         .toStringAsFixed(
                                      //                             0),
                                      //                   ))
                                      //               : AppTextBadge(
                                      //                   text: offer.title)
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // );
                                    });
                              }),
                        ),
                      ],
                    ),
                  if (widget.groceryStore.aisles != null &&
                      widget.groceryStore.aisles!.isNotEmpty)
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.groceryStore.aisles!.length < 4
                            ? widget.groceryStore.aisles!.length
                            : 4,
                        itemBuilder: (context, index) {
                          final aisle = widget.groceryStore.aisles![index];
                          final category = aisle.productCategories.firstOrNull;
                          if ((category?.productsAndQuantities.length ?? 0) !=
                              0) {
                            return Column(
                              children: [
                                MainScreenTopic(
                                  callback: () {},
                                  // => navigatorKey.currentState!
                                  //     .push(MaterialPageRoute(
                                  //   builder: (context) {
                                  //     return AdvertScreen(
                                  //         store: widget.groceryStore,
                                  //         productRefs: category.productsAndQuantities);
                                  //   },
                                  // )
                                  // ),
                                  title: aisle.name,
                                ),
                                SizedBox(
                                  height: 207,
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizes.horizontalPaddingSmall),
                                      itemCount: category!
                                          .productsAndQuantities.length,
                                      separatorBuilder: (context, index) =>
                                          const Gap(15),
                                      itemBuilder: (context, index) {
                                        final productReference = category
                                                .productsAndQuantities[index]
                                            ['product'] as DocumentReference;

                                        return FutureBuilder<Product>(
                                            future: AppFunctions
                                                .loadProductReference(
                                                    productReference),
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
                                                        color: AppColors
                                                            .neutral100,
                                                        width: 110,
                                                        height: 200,
                                                      )),
                                                );
                                              } else if (snapshot.hasError) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Container(
                                                      color:
                                                          AppColors.neutral100,
                                                      width: 110,
                                                      height: 200,
                                                      child: AppText(
                                                        text: snapshot.error
                                                            .toString(),
                                                        size: AppSizes
                                                            .bodySmallest,
                                                      ),
                                                    ));
                                              }
                                              final product = snapshot.data!;
                                              return ProductGridTilePriceFirst(
                                                  product: product,
                                                  store: widget.groceryStore);
                                              //  InkWell(
                                              //   onTap: () {
                                              //     navigatorKey.currentState!
                                              //         .push(MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           ProductScreen(
                                              //         product: product,
                                              //         store:
                                              //             widget.groceryStore,
                                              //       ),
                                              //     ));
                                              //   },
                                              //   child: Ink(
                                              //     child: SizedBox(
                                              //       width: 110,
                                              //       child: Column(
                                              //         crossAxisAlignment:
                                              //             CrossAxisAlignment
                                              //                 .start,
                                              //         children: [
                                              //           ClipRRect(
                                              //             borderRadius:
                                              //                 BorderRadius
                                              //                     .circular(12),
                                              //             child: Stack(
                                              //               alignment: Alignment
                                              //                   .bottomRight,
                                              //               children: [
                                              //                 CachedNetworkImage(
                                              //                   imageUrl: product
                                              //                       .imageUrls
                                              //                       .first,
                                              //                   width: 110,
                                              //                   height: 120,
                                              //                   fit:
                                              //                       BoxFit.fill,
                                              //                 ),
                                              //                 Padding(
                                              //                   padding:
                                              //                       const EdgeInsets
                                              //                           .only(
                                              //                           right:
                                              //                               8.0,
                                              //                           top:
                                              //                               8.0),
                                              //                   child: InkWell(
                                              //                     onTap: () {},
                                              //                     child: Ink(
                                              //                       child:
                                              //                           Container(
                                              //                         padding:
                                              //                             const EdgeInsets
                                              //                                 .all(
                                              //                                 5),
                                              //                         decoration: BoxDecoration(
                                              //                             boxShadow: const [
                                              //                               BoxShadow(
                                              //                                 color: Colors.black12,
                                              //                                 offset: Offset(2, 2),
                                              //                               )
                                              //                             ],
                                              //                             color: Colors
                                              //                                 .white,
                                              //                             borderRadius:
                                              //                                 BorderRadius.circular(50)),
                                              //                         child:
                                              //                             const Icon(
                                              //                           Icons
                                              //                               .add,
                                              //                         ),
                                              //                       ),
                                              //                     ),
                                              //                   ),
                                              //                 )
                                              //               ],
                                              //             ),
                                              //           ),
                                              //           const Gap(5),
                                              //           Row(
                                              //             children: [
                                              //               Visibility(
                                              //                 visible: product
                                              //                         .promoPrice !=
                                              //                     null,
                                              //                 child: Row(
                                              //                   children: [
                                              //                     AppText(
                                              //                         text:
                                              //                             '\$${product.promoPrice} ',
                                              //                         color: Colors
                                              //                             .green),
                                              //                   ],
                                              //                 ),
                                              //               ),
                                              //               AppText(
                                              //                 text:
                                              //                     "\$${product.initialPrice}",
                                              //                 color: AppColors
                                              //                     .neutral500,
                                              //                 decoration: product
                                              //                             .promoPrice !=
                                              //                         null
                                              //                     ? TextDecoration
                                              //                         .lineThrough
                                              //                     : TextDecoration
                                              //                         .none,
                                              //               )
                                              //             ],
                                              //           ),
                                              //           if (product.quantity !=
                                              //               null)
                                              //             AppText(
                                              //                 text: product
                                              //                     .quantity!),
                                              //           AppText(
                                              //             text: product.name,
                                              //             maxLines: 3,
                                              //             overflow: TextOverflow
                                              //                 .ellipsis,
                                              //           ),
                                              //           product.promoPrice !=
                                              //                   null
                                              //               ? Container(
                                              //                   decoration:
                                              //                       BoxDecoration(
                                              //                     borderRadius:
                                              //                         BorderRadius
                                              //                             .circular(
                                              //                                 50),
                                              //                     color: Colors
                                              //                         .green,
                                              //                   ),
                                              //                   child: AppText(
                                              //                     text: ((product.promoPrice! /
                                              //                                 product
                                              //                                     .initialPrice) *
                                              //                             100)
                                              //                         .toStringAsFixed(
                                              //                             0),
                                              //                   ))
                                              //               : Builder(builder:
                                              //                   (context) {
                                              //                   Offer?
                                              //                       matchingOffer;
                                              //                   return (widget.groceryStore.offers !=
                                              //                               null &&
                                              //                           widget
                                              //                               .groceryStore
                                              //                               .offers!
                                              //                               .isNotEmpty &&
                                              //                           widget
                                              //                               .groceryStore
                                              //                               .offers!
                                              //                               .any(
                                              //                             (offer) {
                                              //                               if (offer.title ==
                                              //                                   product.id) {
                                              //                                 matchingOffer = offer;
                                              //                                 return true;
                                              //                               } else {
                                              //                                 return false;
                                              //                               }
                                              //                             },
                                              //                           ))
                                              //                       ? AppTextBadge(
                                              //                           text: matchingOffer!
                                              //                               .title)
                                              //                       : const SizedBox
                                              //                           .shrink();
                                              //                 })
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ),
                                              // );
                                            });
                                      }),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                ],
              ),
            ),
          )),
    );
  }
}
