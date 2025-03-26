import 'dart:async';
import 'dart:typed_data' show Uint8List;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dynamic_staggered_grid_view/flutter_dynamic_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/models/browse_video/browse_video_model.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/send_gifts_screen.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';
import 'package:video_player/video_player.dart';

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
  final List<VideoPlayerController> _videoControllers = [];
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
    for (var store in stores) {
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
  void dispose() {
    for (var videoController in _videoControllers) {
      videoController.dispose();
    }
    super.dispose();
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
                            stores: stores,
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
                body: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(10),
                          AppText(
                            text: 'Shops near you',
                            size: AppSizes.heading6,
                            weight: FontWeight.w600,
                          ),
                          Gap(5),
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
                              navigatorKey.currentState!.push(MaterialPageRoute(
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
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) => const SendGiftsScreen(),
                              ));
                            } else if (shopNearYou.name == 'Box Catering') {
                              navigatorKey.currentState!.push(MaterialPageRoute(
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
                          AppText(
                            text: 'Food near you',
                            size: AppSizes.heading6,
                            weight: FontWeight.w600,
                          ),
                          Gap(5),
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
                                child: AppText(text: snapshot.error.toString()),
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
                              final deviceWidth =
                                  MediaQuery.sizeOf(context).width;
                              final estimatedGridWidth = (deviceWidth -
                                      (AppSizes.horizontalPaddingSmall * 2) -
                                      4) /
                                  2;

                              final browseVideo = browseVideos[index];

                              return FutureBuilder<VideoPlayerController>(
                                future: _loadVideo(browseVideo.videoUrl, index),
                                builder: (context, snapshot) {
                                  // if (snapshot.connectionState ==
                                  //     ConnectionState.waiting)
                                  if (snapshot.hasData) {
                                    final videoController = snapshot.data!;
                                    final videoThumbnailHeight =
                                        estimatedGridWidth /
                                            videoController.value.aspectRatio;
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        // onTap:() {
                                        //   navigatorKey.currentState.push
                                        // },
                                        child: SizedBox(
                                            width: double.infinity,
                                            height: videoThumbnailHeight,
                                            child: VideoPlayer(
                                              videoController,
                                            )),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    logger.d(snapshot.error.toString());
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: AppText(
                                          text: snapshot.error.toString()),
                                    );
                                  } else {
                                    {
                                      return Skeletonizer(
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                color: AppColors.neutral100,
                                                width: double.infinity,
                                                height: estimatedGridWidth +
                                                    (15 * index),
                                              )));
                                    }
                                  }
                                },
                              );
                            },
                          );
                        })
                  ],
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

  Future<VideoPlayerController> _loadVideo(String videoUrl, int index) async {
    if (_videoControllers.elementAtOrNull(index) == null) {
      final videoController =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await videoController.initialize().then(
        (value) async {
          await videoController.setVolume(0).then(
            (value) async {
              await videoController.setLooping(true).then(
                (value) async {
                  await videoController.play();
                },
              );
            },
          );
        },
      );
      _videoControllers.add(videoController);
      return videoController;
    } else {
      return _videoControllers[index];
    }
  }
}
