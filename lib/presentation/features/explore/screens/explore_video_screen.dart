import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/explore_video/explore_video_model.dart';
import 'package:uber_eats_clone/models/store/store_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';
import 'package:uber_eats_clone/presentation/features/product/product_screen.dart';
import 'package:video_player/video_player.dart';

import '../../../../app_functions.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_text.dart';

class ExploreVideoScreen extends StatefulWidget {
  final List<ExploreVideo> exploreVideos;
  final int initialExploreVideoIndex;
  final Store initialStore;
  final Product initialProduct;
  final VideoPlayerController initialVideoController;
  const ExploreVideoScreen(
      {super.key,
      required this.exploreVideos,
      required this.initialExploreVideoIndex,
      required this.initialStore,
      required this.initialProduct,
      required this.initialVideoController});

  @override
  State<ExploreVideoScreen> createState() => _ExploreVideoScreenState();
}

class _ExploreVideoScreenState extends State<ExploreVideoScreen> {
  late List<ExploreVideo> _exploreVideos;
  final List<VideoPlayerController> _videoPlayerControllers = [];
  final List<Store> _stores = [];
  final List<Product> _products = [];

  // List<bool> justCreated = [];

  Future<VideoPlayerController> _prepareController(int index) async {
    if (_videoPlayerControllers.elementAtOrNull(index) == null) {
      final videoController = VideoPlayerController.networkUrl(
          Uri.parse(_exploreVideos[index].videoUrl),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      await videoController.initialize();
      await videoController.setVolume(0);
      await videoController.setLooping(true);
      _videoPlayerControllers.add(videoController);
      // Future.delayed(const Duration(seconds: 4), () {
      await videoController.play();
      // });

      // justCreated.add(true);
    }

    return _videoPlayerControllers[index];
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black38,
    ));
    _exploreVideos = widget.exploreVideos;
    _videoPlayerControllers.add(widget.initialVideoController);
    _stores.add(widget.initialStore);
    _products.add(widget.initialProduct);
    Future.delayed(const Duration(seconds: 2), () {
      widget.initialVideoController.play();
    });
    // justCreated.add(true);
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: CarouselSlider.builder(
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            height: double.infinity,
            scrollDirection: Axis.vertical,
            enableInfiniteScroll: false,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              if (index != 0 &&
                  _videoPlayerControllers[index - 1].value.isPlaying) {
                _videoPlayerControllers[index - 1].pause();
              } else if (_videoPlayerControllers[index + 1].value.isPlaying) {
                _videoPlayerControllers[index + 1].pause();
              }
              setState(() {
                _videoPlayerControllers[index].play();
              });
            },
          ),
          itemCount: _exploreVideos.length,
          itemBuilder: (context, index, realIndex) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      StatefulBuilder(builder: (context, setState) {
                        return Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                  onTap: _videoPlayerControllers
                                              .elementAtOrNull(index) ==
                                          null
                                      ? null
                                      : () {
                                          setState(() {
                                            final controller =
                                                _videoPlayerControllers[index];
                                            controller.value.isPlaying
                                                ? controller.pause()
                                                : controller.play();
                                          });
                                        },
                                  child: FutureBuilder<VideoPlayerController>(
                                      future: _prepareController(index),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final controller = snapshot.data!;

                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              VideoPlayer(controller),
                                              if (!controller.value.isPlaying)
                                                const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white54,
                                                  size: 120,
                                                ),
                                            ],
                                          );
                                        } else if (snapshot.hasError) {
                                          return AppText(
                                              text: snapshot.error.toString());
                                        }
                                        return Container(
                                          width: double.infinity,
                                          height: Adaptive.h(80),
                                          color: Colors.black,
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              LinearProgressIndicator(
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                            const Gap(50),
                          ],
                        );
                      }),
                      SafeArea(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(
                              AppSizes.horizontalPaddingSmall,
                            ),
                            child: GestureDetector(
                              onTap: () => navigatorKey.currentState!.pop(),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.black45,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              left: AppSizes.horizontalPaddingSmall,
                              right: AppSizes.horizontalPaddingSmall,
                              bottom: 5,
                            ),
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.transparent,
                                  Colors.black87
                                ],
                                    stops: [
                                  0.1,
                                  1.0
                                ])),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(30),
                                FutureBuilder(
                                    future: _getStoreAndProduct(index),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Skeletonizer(
                                          enabled: true,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Container(
                                                        color: Colors.white,
                                                        width: 30,
                                                        height: 30),
                                                  ),
                                                  const Gap(10),
                                                  const Expanded(
                                                    child: AppText(
                                                        maxLines: 1,
                                                        color: Colors.white,
                                                        text:
                                                            'ajkfljakljafljaskljklasklafkljkaljklajfkl'),
                                                  ),
                                                ],
                                              ),
                                              const ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: AppText(
                                                  text: 'lkjajksjslkaa',
                                                  weight: FontWeight.bold,
                                                  size: AppSizes.heading6,
                                                  color: Colors.white,
                                                ),
                                                subtitle: AppText(
                                                    size: AppSizes.body,
                                                    color: Colors.white,
                                                    text: 'jklajklasjklas'),
                                              ),
                                              const AppText(
                                                text:
                                                    'pakpkaklslka;;lsak;lkala;;al;s;',
                                                color: Colors.white,
                                              ),
                                              const SingleChildScrollView(
                                                child: Row(
                                                  children: [
                                                    AppText(
                                                        color: Colors.white,
                                                        text: 'jnanlakjajflk'),
                                                    Gap(5),
                                                    AppText(
                                                        color: Colors.white,
                                                        text:
                                                            'jkajkaklaklska;a')
                                                  ],
                                                ),
                                              ),
                                              const Gap(20),
                                              const AppText(
                                                  color: Colors.white,
                                                  weight: FontWeight.bold,
                                                  text: 'You might also like'),
                                            ],
                                          ),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        AppText(
                                            text: snapshot.error.toString());
                                      }
                                      final product = _products[index];
                                      final store = _stores[index];
                                      bool isContainerTapped = false;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await AppFunctions
                                                  .navigateToStoreScreen(store);
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: AppFunctions
                                                      .displayNetworkImage(
                                                          _stores[index].logo,
                                                          width: 30,
                                                          height: 30),
                                                ),
                                                const Gap(10),
                                                Expanded(
                                                  child: AppText(
                                                      maxLines: 1,
                                                      color: Colors.white,
                                                      text:
                                                          '${_stores[index].name} (${_stores[index].location.streetAddress})'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: AppText(
                                              text: product.name,
                                              weight: FontWeight.bold,
                                              size: AppSizes.heading6,
                                              color: Colors.white,
                                            ),
                                            trailing: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const Icon(
                                                Icons.arrow_forward,
                                              ),
                                            ),
                                            onTap: () => navigatorKey
                                                .currentState!
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductScreen(
                                                      product: product,
                                                      store: store),
                                            )),
                                            subtitle: AppText(
                                                size: AppSizes.body,
                                                color: Colors.white,
                                                text:
                                                    'US\$${(product.promoPrice ?? product.initialPrice).toStringAsFixed(2)}'),
                                          ),
                                          if (product.description != null)
                                            StatefulBuilder(
                                                builder: (context, setState) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      isContainerTapped =
                                                          !isContainerTapped;
                                                    },
                                                  );
                                                },
                                                child: AnimatedContainer(
                                                    duration: const Duration(
                                                        seconds: 500),
                                                    child: AppText(
                                                      text:
                                                          product.description!,
                                                      color: Colors.white,
                                                      maxLines:
                                                          isContainerTapped
                                                              ? null
                                                              : 1,
                                                    )),
                                              );
                                            }),
                                          SingleChildScrollView(
                                            child: Row(
                                              children: [
                                                if (product.offer != null)
                                                  FutureBuilder(
                                                      future: AppFunctions
                                                          .loadOfferReference(
                                                              product.offer
                                                                  as DocumentReference),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Row(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Row(
                                                                  children: [
                                                                    AppText(
                                                                        color: Colors
                                                                            .white,
                                                                        text: snapshot
                                                                            .data!
                                                                            .title)
                                                                  ],
                                                                ),
                                                              ),
                                                              const Gap(10),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          logger.d(snapshot
                                                              .error
                                                              .toString());
                                                          return const SizedBox
                                                              .shrink();
                                                        } else {
                                                          return const SizedBox
                                                              .shrink();
                                                        }
                                                      }),
                                                if (store.isUberOneShop)
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.black45,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              AssetNames
                                                                  .uberOneSmall,
                                                              color:
                                                                  Colors.white,
                                                              width: 17,
                                                            ),
                                                            AppText(
                                                                color: Colors
                                                                    .white,
                                                                text:
                                                                    ' \$${store.delivery.fee.toStringAsFixed(2)} Delivery Fee')
                                                          ],
                                                        ),
                                                      ),
                                                      const Gap(10),
                                                    ],
                                                  ),
                                                Builder(builder: (context) {
                                                  final timeOfDayNow =
                                                      TimeOfDay.now();
                                                  final isClosed = timeOfDayNow
                                                          .isBefore(store
                                                              .openingTime) ||
                                                      timeOfDayNow.isAfter(
                                                          store.closingTime);
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black45,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          size: 17,
                                                          Icons
                                                              .shopping_bag_outlined,
                                                          color: Colors.white,
                                                        ),
                                                        AppText(
                                                            color: Colors.white,
                                                            text: isClosed
                                                                ? 'Closed • Available at ${AppFunctions.formatTimeOFDay(store.openingTime)}'
                                                                : " ${store.delivery.estimatedDeliveryTime} min")
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                          const Gap(20),
                                          Builder(builder: (context) {
                                            final similarProducts = <Product>{};
                                            final subStrings =
                                                product.name.split(' ');
                                            for (var i = 0;
                                                i < subStrings.length;
                                                i++) {
                                              if (i == 4) {
                                                break;
                                              }
                                              similarProducts
                                                  .addAll(products.values.where(
                                                (element) =>
                                                    element.id != product.id &&
                                                    element.name.contains(
                                                        subStrings[i]),
                                              ));
                                            }

                                            final hasSimilarProducts =
                                                similarProducts.isNotEmpty;
                                            // logger.d(similarProducts);
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                  dividerColor:
                                                      Colors.transparent),
                                              child: ExpansionTile(
                                                collapsedIconColor:
                                                    Colors.white,
                                                iconColor: Colors.white,
                                                tilePadding: EdgeInsets.zero,
                                                childrenPadding:
                                                    EdgeInsets.zero,
                                                title: AppText(
                                                    color: Colors.white,
                                                    weight: FontWeight.bold,
                                                    text: hasSimilarProducts
                                                        ? 'You might also like'
                                                        : 'Similar products unavailable'),
                                                enabled: hasSimilarProducts,
                                                children: [
                                                  SizedBox(
                                                    height: Adaptive.h(12),
                                                    child: ListView.separated(
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const Gap(10),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: similarProducts
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final product =
                                                            similarProducts
                                                                .elementAt(
                                                                    index);
                                                        return FutureBuilder<
                                                                Store>(
                                                            future: AppFunctions
                                                                .loadStoreReference(product
                                                                        .stores!
                                                                        .first
                                                                    as DocumentReference),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                final similarProductStore =
                                                                    snapshot
                                                                        .data!;
                                                                final similarProduct =
                                                                    similarProducts
                                                                        .elementAt(
                                                                            index);
                                                                return GestureDetector(
                                                                  onTap: () =>
                                                                      navigatorKey
                                                                          .currentState!
                                                                          .push(
                                                                              MaterialPageRoute(
                                                                    builder: (context) => ProductScreen(
                                                                        product:
                                                                            similarProduct,
                                                                        store:
                                                                            similarProductStore),
                                                                  )),
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        Adaptive.w(
                                                                            75),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade900,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.grey.shade600)),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              AppText(
                                                                                text: similarProduct.name,
                                                                                maxLines: 1,
                                                                                color: Colors.white,
                                                                              ),
                                                                              AppText(
                                                                                text: 'US\$${similarProduct.promoPrice ?? similarProduct.initialPrice}',
                                                                                color: Colors.white,
                                                                              ),
                                                                              AppText(
                                                                                text: '${similarProductStore.name} (${similarProductStore.location.streetAddress})',
                                                                                maxLines: 1,
                                                                                color: Colors.white,
                                                                              ),
                                                                              AppText(
                                                                                text: '\$${similarProductStore.delivery.fee} DeliveryFee • ${similarProductStore.delivery.estimatedDeliveryTime} min',
                                                                                color: Colors.white,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const Gap(
                                                                            15),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            child: AppFunctions.displayNetworkImage(similarProduct.imageUrls.first,
                                                                                width: double.infinity,
                                                                                height: double.infinity,
                                                                                fit: BoxFit.cover),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              } else if (snapshot
                                                                  .hasError) {
                                                                SizedBox(
                                                                  width:
                                                                      Adaptive.w(
                                                                          70),
                                                                  child:
                                                                      AppText(
                                                                    text: snapshot
                                                                        .error
                                                                        .toString(),
                                                                  ),
                                                                );
                                                              }
                                                              return Skeletonizer(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8),
                                                                  width:
                                                                      Adaptive.w(
                                                                          70),
                                                                  height:
                                                                      Adaptive.h(
                                                                          20),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade900,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600)),
                                                                  child: Row(
                                                                    children: [
                                                                      const Expanded(
                                                                        flex: 3,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            AppText(text: 'nlnaljlkasmls,sm,s'),
                                                                            AppText(text: 'nlnaljlkas'),
                                                                            AppText(text: 'nlnaljlkaslslalalkalk')
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              Container(
                                                                            color:
                                                                                Colors.white,
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                double.infinity,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          })
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }

  Future<void> _getStoreAndProduct(int index) async {
    if (_videoPlayerControllers.elementAtOrNull(index) == null) {
      _stores.add(await AppFunctions.loadStoreReference(
          _exploreVideos[index].storeRef as DocumentReference));
      _products.add(await AppFunctions.loadProductReference(
          _exploreVideos[index].productRef as DocumentReference));
    }
  }
}
