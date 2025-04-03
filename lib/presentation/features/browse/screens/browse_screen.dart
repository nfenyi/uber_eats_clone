import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/models/browse_video/browse_video_model.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/browse/screens/browse_video_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/send_gifts_intro_screen.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../main.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets.dart';
import '../../box_catering/screens/box_catering_screens.dart';
import '../../grocery_grocery/grocery_grocery_screen.dart';
import '../../home/home_screen.dart';
import '../../home/screens/search_screen.dart';
import '../../main_screen/screens/main_screen.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  final List<FoodCategory> _shopsNearYou = [
    FoodCategory('Grocery', AssetNames.grocery2),
    FoodCategory('Convenience', AssetNames.convenience),
    FoodCategory('Alcohol', AssetNames.alcohol),
    FoodCategory('Gifts', AssetNames.gift),
    FoodCategory('Pharmacy', AssetNames.pharmacy),
    FoodCategory('Baby', AssetNames.babyBottle),
    FoodCategory('Specialty Foods', AssetNames.specialtyFoods),
    FoodCategory('Pet Supplies', AssetNames.petSupplies),
    FoodCategory('Retail', AssetNames.retail),
    //TODO: implement offers
    FoodCategory('Box Catering', AssetNames.boxCatering),
  ];
  // final List<VideoPlayerController> _videoControllers = [];
  // final List<FoodCategory> _foodNearYou = [
  //   FoodCategory('Breakfast and Brunch', AssetNames.breakfastNBrunch),
  //   FoodCategory('Kosher', AssetNames.kosher),
  //   FoodCategory('Deli', AssetNames.deli),
  //   FoodCategory('Pizza', AssetNames.pizzaImage),
  //   //TODO: implement best overall
  //   FoodCategory('Best Overall', AssetNames.bestOverall),
  //   FoodCategory('Fast Food', AssetNames.fastFoodImage),
  //   FoodCategory('Healthy', AssetNames.healthyImage),
  //   FoodCategory('Halal', AssetNames.halal),
  //   FoodCategory('Vegetarian Friendly', AssetNames.vegetarianFriendly),
  //   FoodCategory('Cantonese', AssetNames.cantonese),

  //   FoodCategory('Kids Friendly', AssetNames.kidsFriendly),
  //   FoodCategory('Traditional American', AssetNames.traditionalAmerican),
  //   FoodCategory('Israeli', AssetNames.israeli),
  //   FoodCategory('Eastern European', AssetNames.easternEuropean),
  //   FoodCategory('Arab', AssetNames.arab),
  // ];
  final List<Store> _groceryGroceryStores = [];
  final List<Store> _convenienceStores = [];
  final List<Store> _alcoholStores = [];
  final List<Store> _pharmacyStores = [];
  List<Store> _groceryScreenStores = [];
  final List<Store> _boxCateringStores = [];
  final List<Store> _babyStores = [];
  final List<Store> _specialtyFoodsStores = [];
  final List<Store> _petSuppliesStores = [];
  final List<Store> _retailStores = [];

  @override
  void initState() {
    super.initState();
    for (var store in allStores) {
      if (store.type.contains('Grocery')) {
        _groceryGroceryStores.add(store);
      }
      if (store.type.contains('Convenience')) {
        _convenienceStores.add(store);
      }

      if (store.type.contains('Alcohol')) {
        _alcoholStores.add(store);
      }

      if (store.type.contains('Pharmacy')) {
        _pharmacyStores.add(store);
      }
      if (store.type.contains('Baby')) {
        _babyStores.add(store);
      }
      if (store.type.contains('Specialty Foods')) {
        _specialtyFoodsStores.add(store);
      }
      if (store.type.contains('Pet Supplies')) {
        _petSuppliesStores.add(store);
      }

      if (store.type.contains('Retail')) {
        _retailStores.add(store);
      }
      if (store.type.contains('Box Catering')) {
        _boxCateringStores.add(store);
      }
    }
    _groceryScreenStores = List<Store>.from([
      ..._groceryGroceryStores,
      ..._convenienceStores,
      ..._alcoholStores,
      ..._pharmacyStores,
      ..._babyStores,
      ..._specialtyFoodsStores,
      ..._petSuppliesStores,
      ..._retailStores,
      ..._boxCateringStores
    ]).toSet().toList();
    // _loadVideo(
    //     'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/browse%20videos%2FThis%20how%20we%20make%20a%20bacon%20egg%20and%20cheese%20mcqwidle%20fyp%20viral%20mcdonalds%20fyp%E3%82%B7%20trending%20tiktok%20foryou.mp4?alt=media&token=c185ab55-2fbe-40d8-9f44-63ee847de899');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      titleSpacing: 0,
                      //TODO: change appbar 'surfaceTintColor' at the main screen level
                      surfaceTintColor: Colors.white,
                      pinned: true,
                      floating: true,
                      title: InkWell(
                        onTap: () =>
                            navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => SearchScreen(
                            stores: allStores,
                          ),
                        )),
                        child: Ink(
                          child: const AppTextFormField(
                            enabled: false,
                            hintText: 'Search Uber Eats',
                            constraintWidth: 40,
                            radius: 50,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: InkWell(
                    //     onTap: () =>
                    //         navigatorKey.currentState!.push(MaterialPageRoute(
                    //       builder: (context) => SearchScreen(
                    //         stores: stores,
                    //       ),
                    //     )),
                    //     child: Ink(
                    //       child: const AppTextFormField(
                    //         enabled: false,
                    //         hintText: 'Search Uber Eats',
                    //         constraintWidth: 40,
                    //         radius: 50,
                    //         prefixIcon: Icon(
                    //           Icons.search,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ];
                },
                body: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(10),
                            // AppText(
                            //   text: 'Shops near you',
                            //   size: AppSizes.heading6,
                            //   weight: FontWeight.w600,
                            // ),
                            // Gap(5),
                          ],
                        ),
                      ),
                      SliverGrid.builder(
                        itemCount: _shopsNearYou.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 80,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          final shopNearYou = _shopsNearYou[index];
                          return InkWell(
                            onTap: () {
                              if (shopNearYou.name == 'Grocery') {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => GroceryGroceryScreen(
                                      stores: _groceryGroceryStores),
                                ));
                              } else if (shopNearYou.name == 'Alcohol') {
                                ref
                                    .read(bottomNavIndexProvider.notifier)
                                    .showAlcoholScreen();
                              } else if (shopNearYou.name == 'Pharmacy') {
                                ref
                                    .read(bottomNavIndexProvider.notifier)
                                    .showPharmacyScreen();
                              } else if (shopNearYou.name == 'Gifts') {
                                if (Hive.box(AppBoxes.appState).get(
                                    BoxKeys.firstTimeSendingGift,
                                    defaultValue: true)) {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SendGiftsIntroScreen(),
                                  ));
                                } else {
                                  ref
                                      .read(bottomNavIndexProvider.notifier)
                                      .showGiftScreen();
                                }
                              } else if (shopNearYou.name == 'Box Catering') {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => BoxCateringScreen(
                                    boxCateringStores: _boxCateringStores,
                                  ),
                                ));
                              }
                            },
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                children: [
                                  Image.asset(
                                    shopNearYou.image,
                                    height: 45,
                                  ),
                                  AppText(
                                    text: shopNearYou.name,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(10),
                            // AppText(
                            //   text: 'Food near you',
                            //   size: AppSizes.heading6,
                            //   weight: FontWeight.w600,
                            // ),
                            // Gap(5),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: _getBrowseVideos(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SliverToBoxAdapter(
                                  child: SizedBox.shrink());
                            } else if (snapshot.hasError) {
                              return SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
                                  child:
                                      AppText(text: snapshot.error.toString()),
                                ),
                              );
                            }
                            final browseVideos = snapshot.data!;
                            return SliverStaggeredGrid.countBuilder(
                              itemCount: browseVideos.length,
                              staggeredTileBuilder: (index) =>
                                  const StaggeredTile.fit(1),
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              itemBuilder: (context, index) {
                                return VideoThumbnail(
                                    browseVideos: browseVideos, index: index);
                              },
                            );
                          })
                    ],
                  ),
                )

                //  SingleChildScrollView(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Gap(10),
                //       const AppText(
                //         text: 'Shops near you',
                //         size: AppSizes.heading6,
                //         weight: FontWeight.w600,
                //       ),
                //       const Gap(5),
                //       const Gap(10),
                //       const AppText(
                //         text: 'Food near you',
                //         size: AppSizes.heading6,
                //         weight: FontWeight.w600,
                //       ),
                //       const Gap(5),

                //       // SliverGrid.builder(
                //       //   itemCount: _foodNearYou.length,
                //       //   gridDelegate:
                //       //       const SliverGridDelegateWithFixedCrossAxisCount(
                //       //     mainAxisExtent: 140,
                //       //     crossAxisSpacing: 10,
                //       //     mainAxisSpacing: 0,
                //       //     crossAxisCount: 2,
                //       //   ),
                //       //   itemBuilder: (context, index) {
                //       //     final foodNearYou = _foodNearYou[index];
                //       //     return InkWell(
                //       //       onTap: () {
                //       //         // if (index == 0) {
                //       //         //   navigatorKey.currentState!.push(MaterialPageRoute(
                //       //         //     builder: (context) => GroceryGroceryScreen(
                //       //         //         stores: _groceryGroceryStores),
                //       //         //   ));
                //       //         // } else if (index == 2) {
                //       //         //   navigatorKey.currentState!.push(MaterialPageRoute(
                //       //         //     builder: (context) =>
                //       //         //         AlcoholScreen(alcoholStores: _alcoholStores),
                //       //         //   ));
                //       //         // } else if (index == 4) {
                //       //         //   navigatorKey.currentState!.push(MaterialPageRoute(
                //       //         //     builder: (context) => PharmacyScreen(
                //       //         //         pharmacyStores: _pharmacyStores),
                //       //         //   ));
                //       //         // }
                //       //       },
                //       //       child: Ink(
                //       //         child: SizedBox(
                //       //           width: 60,
                //       //           child: Column(
                //       //             crossAxisAlignment: CrossAxisAlignment.start,
                //       //             children: [
                //       //               Image.asset(
                //       //                 foodNearYou.image,
                //       //                 height: 100,
                //       //               ),
                //       //               AppText(
                //       //                 text: foodNearYou.name,
                //       //                 size: AppSizes.bodySmall,
                //       //                 overflow: TextOverflow.ellipsis,
                //       //               )
                //       //             ],
                //       //           ),
                //       //         ),
                //       //       ),
                //       //     );
                //       //   },
                //       // ),
                //     ],
                //   ),
                // ),

                )));
  }

  Future<List<BrowseVideo>> _getBrowseVideos() async {
    List<BrowseVideo> browseVideos = [];
    final videoSnapshots = await FirebaseFirestore.instance
        .collection(FirestoreCollections.browseVideos)
        .get();
    for (var videoSnapshot in videoSnapshots.docs) {
      browseVideos.add(BrowseVideo.fromJson(videoSnapshot.data()));
    }
    return browseVideos;
  }
}

class VideoThumbnail extends StatefulWidget {
  const VideoThumbnail({
    super.key,
    required this.browseVideos,
    required this.index,
  });

  final List<BrowseVideo> browseVideos;

  final int index;

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late final int _index;
  late final BrowseVideo _browseVideo;
  late Store store;
  late Product product;

  VideoPlayerController? _videoController;

  bool _isVideoVisible = false;

  Future<void> _prepareController(BrowseVideo browseVideo, int index) async {
    if (_videoController == null) {
      _videoController = VideoPlayerController.networkUrl(
          Uri.parse(browseVideo.videoUrl),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      await _videoController!.initialize();
      await _videoController!.setVolume(0);
      await _videoController!.setLooping(true);
      store = await AppFunctions.loadStoreReference(
          browseVideo.storeRef as DocumentReference);
      product = await AppFunctions.loadProductReference(
          browseVideo.productRef as DocumentReference);
    }
  }

  @override
  void initState() {
    super.initState();
    _index = widget.index;
    _browseVideo = widget.browseVideos[_index];
  }

  @override
  void dispose() {
    _videoController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.sizeOf(context).width;
    final estimatedGridWidth =
        (deviceWidth - (AppSizes.horizontalPaddingSmall * 2) - 4) / 2;

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder(
            future: _prepareController(_browseVideo, _index),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Skeletonizer(
                    child: Container(
                  color: AppColors.neutral100,
                  width: double.infinity,
                  height: estimatedGridWidth + (15 * _index),
                ));
              } else if (snapshot.hasError) {
                logger.d(snapshot.error.toString());
                logger.d(_index);
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: AppText(text: snapshot.error.toString()),
                );
              } else {
                final videoThumbnailHeight =
                    (estimatedGridWidth / _videoController!.value.aspectRatio) -
                        20;
                return GestureDetector(
                    onTap: () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => BrowseVideoScreen(
                          browseVideos: widget.browseVideos,
                          initialStore: store,
                          initialVideoController: _videoController!,
                          initialBrowseVideoIndex: widget.index,
                          initialProduct: product,
                        ),
                      ));
                    },
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: videoThumbnailHeight,
                          child: VisibilityDetector(
                              key: ValueKey(_index),
                              onVisibilityChanged: (visibilityInfo) async {
                                var visiblePercentage =
                                    visibilityInfo.visibleFraction * 100;
                                if (visiblePercentage > 70 &&
                                    !_isVideoVisible) {
                                  setState(() {
                                    _isVideoVisible = true;
                                    _videoController!.play();
                                  });
                                } else if (visiblePercentage <= 50 &&
                                    _isVideoVisible) {
                                  //this bit seems to run also when i navigate to the gifts screen hence the change of code
                                  //TODO: clean up
                                  if (context.mounted) {
                                    _isVideoVisible = false;
                                    await _videoController!.pause();
                                    setState(() {});
                                  }
                                }
                              },
                              child: VideoPlayer(
                                _videoController!,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text:
                                    '${store.name} (${store.location.streetAddress})',
                                color: Colors.white70,
                                maxLines: 1,
                                size: AppSizes.bodySmallest,
                              ),
                              AppText(
                                text: product.name,
                                color: Colors.white,
                                weight: FontWeight.bold,
                              ),
                              AppText(
                                text:
                                    'US\$${product.promoPrice ?? product.initialPrice}',
                                color: Colors.white,
                                size: AppSizes.bodySmallest,
                              ),
                            ],
                          ),
                        )
                      ],
                    ));
              }
            }));
  }
}
