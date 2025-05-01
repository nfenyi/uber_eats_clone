import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart' show Iconify;
import 'package:iconify_flutter_plus/icons/la.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/constants/weblinks.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../models/promotion/promotion_model.dart';
import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';
import '../address/screens/addresses_screen.dart';
import '../uber_one/join_uber_one_screen.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  final _searchController = TextEditingController();
  List _redeemedPromoIds = [];
  List _usedPromos = [];

  bool _showSearchArea = false;

  Promotion? _searchedPromo;

  bool _isLoading = false;

  String? _searchedPromoId;
  String? _activatedPromoId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Promotions',
          size: AppSizes.heading6,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppTextFormField(
              constraintWidth: 40,
              controller: _searchController,
              radius: 10,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) async {
                final searchedPromoRef = FirebaseFirestore.instance
                    .collection(FirestoreCollections.promotions)
                    .doc(value);
                final promoSnapshot = await searchedPromoRef.get();

                if (!promoSnapshot.exists) {
                  setState(() {
                    _searchedPromo = null;
                  });
                  return;
                }
                if (_redeemedPromoIds.any(
                  (element) => element.contains(value),
                )) {
                  showInfoToast('Promo already claimed',
                      context: navigatorKey.currentContext!);
                  return;
                }
                if (_usedPromos.any(
                  (element) => element.contains(value),
                )) {
                  showInfoToast('Promo already used',
                      context: navigatorKey.currentContext!);
                  return;
                }
                var temp = Promotion.fromJson(promoSnapshot.data()!);
                //TODO: improve this 🙃
                if (temp.applicableLocation != 'Accra') {
                  showInfoToast('This promo is not available in your region',
                      context: navigatorKey.currentContext);
                  return;
                }
                if (temp.expirationDate.isAfter(DateTime.now())) {
                  showInfoToast('This promo is expired',
                      context: navigatorKey.currentContext);
                  return;
                }
                _searchedPromoId = value;
                setState(() {
                  _showSearchArea = true;
                  _searchedPromo = temp;
                });
              },
              prefixIcon: const Iconify(La.tag),
              hintText: 'Enter promo code',
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        if (_searchController.text.isNotEmpty) {
                          _searchController.clear();
                          setState(() {});
                        } else {
                          setState(() {
                            _showSearchArea = false;
                          });
                        }
                      },
                      child: const Icon(
                        Icons.cancel,
                      ),
                    )
                  : null,
            ),
          ),
          Expanded(
              child: _showSearchArea
                  ? (_searchedPromo == null)
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const Gap(30),
                                        // if(_searchedPromo !)
                                        Container(
                                            padding: const EdgeInsets.all(15),
                                            width: Adaptive.w(90),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        AppColors.neutral300)),
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
                                                            text:
                                                                '\$${_searchedPromo!.discount.toInt()} off',
                                                            size: AppSizes
                                                                .heading6,
                                                            weight:
                                                                FontWeight.w600,
                                                          ),
                                                          const Gap(20),
                                                          AppText(
                                                              text:
                                                                  'Use by ${AppFunctions.formatDate(_searchedPromo!.expirationDate.toString(), format: r'M j, Y g A')} \n${_searchedPromo!.description}'),
                                                        ]),
                                                  ),
                                                  Image.asset(
                                                    AssetNames.greenTag,
                                                    width: 40,
                                                  )
                                                ])),
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AppButton(
                                    isLoading: _isLoading,
                                    text: 'Claim promo',
                                    callback: () async {
                                      try {
                                        if (_searchedPromoId != null) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  FirestoreCollections.users)
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            'redeemedPromos':
                                                FieldValue.arrayUnion(
                                                    [_searchedPromoId])
                                          });
                                          await AppFunctions
                                              .getOnlineUserInfo();
                                          showInfoToast('Promo claimed',
                                              context:
                                                  navigatorKey.currentContext);
                                          _searchController.clear();
                                          setState(() {
                                            _isLoading = false;
                                            _showSearchArea = false;
                                          });
                                        }
                                      } on Exception catch (e) {
                                        showInfoToast(e.toString(),
                                            context:
                                                navigatorKey.currentContext);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                                  ),
                                  const Gap(10)
                                ],
                              ),
                            ),
                          ],
                        )
                  : Builder(builder: (context) {
                      _redeemedPromoIds = Hive.box(AppBoxes.appState)
                          .get(BoxKeys.userInfo)['redeemedPromos'];
                      _usedPromos = Hive.box(AppBoxes.appState)
                          .get(BoxKeys.userInfo)['usedPromos'];

                      _activatedPromoId = Hive.box(AppBoxes.appState)
                          .get(BoxKeys.activatedPromoId);
                      return Column(
                        children: [
                          const Gap(40),
                          (_redeemedPromoIds.isNotEmpty)
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: 'Your available promotions',
                                          weight: FontWeight.bold,
                                          size: AppSizes.heading6,
                                        ),
                                        AppText(text: 'Limit one per order'),
                                        Gap(15),
                                      ],
                                    ),
                                  ),
                                )
                              : AppText(
                                  text: _searchController.text.isEmpty
                                      ? 'Your redeemed promotions will show here'
                                      : 'This code does not exist',
                                  color: AppColors.neutral500,
                                ),
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Gap(10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _redeemedPromoIds.length,
                              itemBuilder: (context, index) {
                                final String promoId = _redeemedPromoIds[index];
                                final promoRef = FirebaseFirestore.instance
                                    .collection(FirestoreCollections.promotions)
                                    .doc(promoId);
                                return FutureBuilder(
                                    future: AppFunctions.loadPromotionReference(
                                        promoRef),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Skeletonizer(
                                            enabled: true,
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                width: Adaptive.w(90),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .neutral300)),
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
                                                              const AppText(
                                                                text:
                                                                    'bhkbbkbhjknkllk',
                                                                size: AppSizes
                                                                    .heading6,
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              const Gap(20),
                                                              const AppText(
                                                                  text:
                                                                      'khjkhjkhjhhkjkhjkhkjjk\nhjkhkbnnjknjjkjknkjnknnnnnm,n,n,nnbjkbkjhjkhkhhjlhlhlhubibihhhlj'),
                                                              const Gap(10),
                                                              AppButton2(
                                                                callback: () {},
                                                                text: 'njinjkk',
                                                              )
                                                            ]),
                                                      ),
                                                      Image.asset(
                                                        AssetNames.greenTag,
                                                        width: 40,
                                                      )
                                                    ])));
                                      } else if (snapshot.hasError) {
                                        return AppText(
                                            text: snapshot.error.toString());
                                      }
                                      final promo = snapshot.data!;
                                      return Container(
                                          padding: const EdgeInsets.all(15),
                                          width: Adaptive.w(90),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: _activatedPromoId ==
                                                          promoId
                                                      ? 2
                                                      : 1,
                                                  color: _activatedPromoId ==
                                                          promoId
                                                      ? Colors.black
                                                      : AppColors.neutral300)),
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
                                                          text:
                                                              '\$${promo.discount.toInt()} off',
                                                          size:
                                                              AppSizes.heading6,
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                        const Gap(20),
                                                        AppText(
                                                            text:
                                                                'Use by ${AppFunctions.formatDate(promo.expirationDate.toString(), format: r'M j, Y g A')} \n${promo.description}'),
                                                        const Gap(10),
                                                        Row(
                                                          children: [
                                                            AppButton2(
                                                              callback:
                                                                  () async {
                                                                if (_activatedPromoId ==
                                                                    promoId) {
                                                                  showInfoToast(
                                                                      'Promo already activated',
                                                                      context:
                                                                          navigatorKey
                                                                              .currentContext!);
                                                                  return;
                                                                }
                                                                //holding  former value of activatedPromoPath
                                                                var formerPath =
                                                                    _activatedPromoId;
                                                                await Hive.box(
                                                                        AppBoxes
                                                                            .appState)
                                                                    .put(
                                                                        BoxKeys
                                                                            .activatedPromoId,
                                                                        promoId);
                                                                setState(() {});
                                                                showInfoToast(
                                                                    formerPath !=
                                                                                null &&
                                                                            formerPath ==
                                                                                promoId
                                                                        ? 'Active promo switched'
                                                                        : 'Promo activated',
                                                                    context:
                                                                        navigatorKey
                                                                            .currentContext);
                                                              },
                                                              text: 'Shop now',
                                                            ),
                                                            const Gap(10),
                                                            AppTextButton(
                                                                text: 'Details',
                                                                callback:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      final List<
                                                                              String>
                                                                          splitDetails =
                                                                          promo
                                                                              .description
                                                                              .split('. ');

                                                                      return Container(
                                                                        decoration: const BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              // horizontal:
                                                                              AppSizes.horizontalPaddingSmall),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Center(
                                                                                  child: AppText(
                                                                                text: 'Enjoy \$${promo.discount.toInt()} off',
                                                                                size: AppSizes.body,
                                                                                weight: FontWeight.w600,
                                                                              )),
                                                                              const Gap(5),
                                                                              const Divider(),
                                                                              const Gap(5),
                                                                              const AppText(text: 'Expiration'),
                                                                              AppText(color: AppColors.neutral500, text: '${AppFunctions.formatDate(promo.expirationDate.toString(), format: r'j M')} at ${AppFunctions.formatDate(promo.expirationDate.toString(), format: r'g:i A e')}'),
                                                                              const Gap(5),
                                                                              const Divider(),
                                                                              const Gap(5),
                                                                              const AppText(text: 'Location'),
                                                                              const Gap(5),
                                                                              AppText(
                                                                                text: promo.applicableLocation,
                                                                                color: AppColors.neutral500,
                                                                              ),
                                                                              const Gap(15),
                                                                              const AppText(text: 'Details'),
                                                                              const Gap(5),
                                                                              ListView(
                                                                                  shrinkWrap: true,
                                                                                  children: splitDetails
                                                                                      .map(
                                                                                        (detail) => AppText(
                                                                                          text: '• $detail',
                                                                                          color: AppColors.neutral500,
                                                                                        ),
                                                                                      )
                                                                                      .toList()),
                                                                              const Gap(15),
                                                                              AppText(text: "${promo.title} Terms and fees apply."),
                                                                              const Gap(15),
                                                                              AppButton(
                                                                                text: 'Shop Now',
                                                                                callback: () async {
                                                                                  if (_activatedPromoId == promoId) {
                                                                                    showInfoToast('Promo already activated', context: navigatorKey.currentContext!);
                                                                                    return;
                                                                                  }
                                                                                  //holding former value of activatedPromoPath
                                                                                  var formerId = _activatedPromoId;

                                                                                  await Hive.box(AppBoxes.appState).put(BoxKeys.activatedPromoId, promoId);
                                                                                  navigatorKey.currentState!.pop();
                                                                                  setState(() {});
                                                                                  showInfoToast(formerId != null && formerId == promoId ? 'Active promo switched' : 'Promo activated', context: navigatorKey.currentContext);
                                                                                },
                                                                              ),
                                                                              const Gap(10),
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: AppButton2(
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                      text: 'Got it',
                                                                                      callback: () => navigatorKey.currentState!.pop(),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                })
                                                          ],
                                                        )
                                                      ]),
                                                ),
                                                Image.asset(
                                                  AssetNames.greenTag,
                                                  width: 40,
                                                )
                                              ]));
                                    });
                              },
                            ),
                          ),
                          const BannerCarousel(),
                          const Gap(5),
                        ],
                      );
                    })),
        ],
      ),
    );
  }
}

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> userInfo =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    bool hasUberOne = userInfo['uberOneStatus']['hasUberOne'] ?? false;
    return SizedBox(
      height: 138,
      child: CarouselSlider(
        options: CarouselOptions(
            autoPlayInterval: const Duration(seconds: 8),
            autoPlay: true,
            viewportFraction: 0.84,
            // padEnds: true,
            height: 150,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal),
        items: [
          if (!hasUberOne)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                  width: Adaptive.w(80),
                  // height: 150,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
                width: Adaptive.w(80),
                // height: 150,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    color: Colors.white,
                                    text:
                                        '\$0 Delivery Fee + up to 10% off with Uber One',
                                  ),
                                ]),
                            AppButton2(
                                text: 'Request ride',
                                callback: () async {
                                  await launchUrl(
                                      Uri.parse(Weblinks.googlePlayUberLink));
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
                            AssetNames.whiteCar,
                            fit: BoxFit.cover,
                          ),
                        ))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
