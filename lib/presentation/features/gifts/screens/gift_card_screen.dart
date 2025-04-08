import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_card_category_screen.dart';
import '../../../../app_functions.dart';
import '../../../../models/gift_card_category_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import 'customize_gift_screen.dart';
import 'my_gifts_screen.dart';
import 'redeem_gift_card_screen.dart';

class GiftCardScreen extends ConsumerStatefulWidget {
  const GiftCardScreen({super.key});

  @override
  ConsumerState<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends ConsumerState<GiftCardScreen> {
  // final List<GiftCardCategory> _giftCardCategories = [
  //   // GiftCardCategory(
  //   //   name: "Mother's day",
  //   //   giftCardImages: [
  //   //     FirebaseFirestore.instance
  //   //         .collection(FirestoreCollections.giftCards)
  //   //         .doc('3c67dcb9-b933-4b49-a654-edc2d19af51e'),
  //   //     FirebaseFirestore.instance
  //   //         .collection(FirestoreCollections.giftCards)
  //   //         .doc('dd23b292-c231-4eab-9795-d6d7e2c04414'),
  //   //   ],
  //   // ),
  //   // GiftCardCategory(name: "Graduation", giftCardImages: [
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('1ae4bcf8-af4d-4047-8706-c40300e09208'),
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('db952687-31ff-4909-99b6-f54129a1fe55')
  //   // ]),
  //   // GiftCardCategory(name: "Community", giftCardImages: [
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('0f662c2d-3035-46da-9cf6-004c907ea626'),
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('11948544-fc67-4a3b-9f0e-ef8f26bb5168'),
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('bd16f3f9-30a8-4863-b271-3ca349f7cefd'),
  //   // ]),
  //   // GiftCardCategory(name: "Office Celebration", giftCardImages: [
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('69d24947-e64b-4675-ba95-8413a4f8c4fc'),
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('b334299a-d27a-4c36-bdab-1a47b107c2a3'),
  //   // ]),
  //   // GiftCardCategory(name: 'Eats', giftCardImages: [
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('d5b21e54-f7a9-4cad-aabd-153624421263'),
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('dc6ed443-14f4-4366-a3dc-5a3aacf3f3bd'),
  //   // ]),
  //   // GiftCardCategory(name: 'Teacher Appreciation', giftCardImages: [
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('388227a6-6a20-42f5-905a-c3a7bdb965a9'),
  //   //   FirebaseFirestore.instance
  //   //       .collection(FirestoreCollections.giftCards)
  //   //       .doc('58db47c2-30aa-489e-ae02-012046cf10cd'),
  //   // ]),
  // ];

  // final cards = <GiftCardImage>[
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Fmothers_day1.png?alt=media&token=220d25e8-6122-42a5-bf3f-538c0a4b6896',
  //   ),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Fmothers_day2.png?alt=media&token=6ad7b2bb-5829-478a-8bac-22d6f6864f5c',
  //   ),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Fgraduation1.png?alt=media&token=81675c6f-b726-4d07-982b-d22c5ae1a0db',
  //   ),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Fgraduation2.png?alt=media&token=c01a2950-a3f0-41da-8e82-527ba836ed29',
  //   ),
  //   GiftCardImage(
  //       id: const Uuid().v4(),
  //       imageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Fcommunity1.png?alt=media&token=8f1f5679-819e-4400-b015-6c0487f48290'),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Fcommunity2.png?alt=media&token=a18e842f-8345-4ba2-8cdc-2a1927ca61b6',
  //   ),
  //   GiftCardImage(
  //       id: const Uuid().v4(),
  //       imageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Fcommunity3.png?alt=media&token=59eff8bb-d6c3-4d9c-b5b1-acae5a828025'),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Foffice_celebration1.png?alt=media&token=6c653375-93b3-44d7-9cd6-48cf6b12adb4',
  //   ),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Foffice_celebration2.png?alt=media&token=e45875be-f77b-43ce-b341-0a45d89e615b',
  //   ),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Feats1.png?alt=media&token=7c3914d1-5637-4e28-87ba-9dca5d9a16a2',
  //   ),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Feats2.png?alt=media&token=e274c01b-4230-43f2-a7c5-889661f21f3f',
  //   ),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Fteacher_appreciation1.png?alt=media&token=1210be6f-e0a6-4465-bbdf-4420ce6641ac',
  //   ),
  //   GiftCardImage(
  //     id: const Uuid().v4(),
  //     imageUrl:
  //         'https://firebasestorage.googleapis.com/v0/b/uber-eats-clone-d792a.firebasestorage.app/o/gift%20card%20images%2Fteacher_appreciation2.png?alt=media&token=526513b8-71be-4ea3-9804-96c97e94da67',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar.medium(
            title: const AppText(
              text: 'Gift Cards',
              weight: FontWeight.w600,
              size: AppSizes.heading5,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    right: AppSizes.horizontalPaddingSmall),
                child: InkWell(
                    onTap: () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const MyGiftsScreen(),
                      ));
                    },
                    child: Ink(
                      child: const AppText(
                        text: 'My gifts',
                        size: AppSizes.bodySmall,
                      ),
                    )),
              )
            ],

            // expandedHeight: 120,
            pinned: true,
            floating: true,
          )
        ];
      },
      body: FutureBuilder<List<GiftCardCategory>>(
          future: AppFunctions.getGiftCardCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final giftCardCategories = snapshot.data!;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade900,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Adaptive.w(60),
                                          child: const AppText(
                                            text:
                                                "Make someone's day with a special delivery",
                                            color: Colors.white,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        const Gap(10),
                                        AppButton2(
                                          text: 'Shop gifts',
                                          callback: () {
                                            navigatorKey.currentState!.pop();
                                            // ref
                                            //     .read(bottomNavIndexProvider.notifier)
                                            //     .updateIndex(3);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    AssetNames.sendGifts,
                                    height: 120,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                ],
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(top: 15),
                            title: const AppText(
                              text: 'Got a gift card',
                              size: AppSizes.bodySmall,
                            ),
                            trailing: AppButton2(
                                text: 'Redeem',
                                callback: () {
                                  showModalBottomSheet(
                                    useSafeArea: true,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return const RedeemGiftCardScreen();
                                    },
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(
                      thickness: 4,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(10),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: AppText(
                              text: 'Shop gift cards',
                              weight: FontWeight.w600,
                              size: AppSizes.heading5,
                            ),
                          ),
                          const Gap(10),
                          ChipsChoice<String>.single(
                            wrapped: false,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            value: null,
                            onChanged: (value) {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) => GiftCardCategoryScreen(
                                    giftCardCategory:
                                        giftCardCategories.firstWhere(
                                  (category) => category.name == value,
                                )),
                              ));
                            },
                            choiceItems:
                                C2Choice.listFrom<String, GiftCardCategory>(
                              source: giftCardCategories,
                              value: (i, v) => v.name,
                              label: (i, v) => v.name,
                            ),
                            choiceStyle: C2ChipStyle.filled(
                              selectedStyle: const C2ChipStyle(
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.neutral900,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              height: 30,
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.neutral100,
                            ),
                          ),
                          const Gap(10),
                        ]),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 20),
                    sliver: SliverList.separated(
                        separatorBuilder: (context, index) => const Gap(20),
                        itemCount: giftCardCategories.length,
                        itemBuilder: (context, index) {
                          final giftCardCategory = giftCardCategories[index];

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text: giftCardCategory.name,
                                      size: AppSizes.body,
                                    ),
                                    // if (giftCategory.cards.length > 2)
                                    AppTextButton(
                                      text: "See all",
                                      callback: () {
                                        showModalBottomSheet(
                                          context: context,
                                          useSafeArea: true,
                                          isScrollControlled: true,
                                          builder: (context) =>
                                              GiftCardCategoryScreen(
                                                  giftCardCategory:
                                                      giftCardCategory),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 130,
                                child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final cardRef = giftCardCategory
                                          .giftCardImages[index];
                                      return FutureBuilder(
                                          future: AppFunctions.getGiftCardImage(
                                              cardRef as DocumentReference),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final cardUrl =
                                                  snapshot.data!.imageUrl;
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                  onTap: () {
                                                    navigatorKey.currentState!
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          CustomizeGiftScreen(
                                                        initiallySelectedCard:
                                                            cardUrl,
                                                      ),
                                                    ));
                                                  },
                                                  child: Ink(
                                                    child: AppFunctions
                                                        .displayNetworkImage(
                                                            cardUrl,
                                                            placeholderAssetImage:
                                                                AssetNames
                                                                    .giftCardPlaceholder,
                                                            width: 200),
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return SizedBox(
                                                height: 180,
                                                child: AppText(
                                                    text: snapshot.error
                                                        .toString()),
                                              );
                                            } else {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                  color: AppColors.neutral100,
                                                  width: 200,
                                                ),
                                              );
                                            }
                                          });
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Gap(10);
                                    },
                                    itemCount: giftCardCategory
                                                .giftCardImages.length <
                                            8
                                        ? giftCardCategory.giftCardImages.length
                                        : 8),
                              )
                            ],
                          );
                        }),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              logger.d(snapshot.error);
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(100),
                    Image.asset(
                      AssetNames.fallenIceCream,
                      width: 180,
                    ),
                    const Gap(10),
                    const AppText(
                      text: 'Sorry, something went wrong.',
                      weight: FontWeight.bold,
                      size: AppSizes.body,
                    ),
                    AppText(
                      text: snapshot.error.toString(),
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator()],
              );
            }
          }),
    ));
  }
}
