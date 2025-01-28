import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_card_category_screen.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import 'customize_gift_screen.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  final List<GiftCardCategory> _giftCardCategories = [
    GiftCardCategory(
        name: "Mother's day",
        cards: [AssetNames.mothersDay1, AssetNames.mothersDay2]),
    GiftCardCategory(
        name: "Graduation",
        cards: [AssetNames.graduation1, AssetNames.graduation2]),
    GiftCardCategory(name: "Community", cards: [
      AssetNames.community1,
      AssetNames.community2,
      AssetNames.community3
    ]),
    GiftCardCategory(
        name: "Office Celebration",
        cards: [AssetNames.officeCelebration1, AssetNames.officeCelebration2]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    right: AppSizes.horizontalPaddingSmall),
                child: GestureDetector(child: const AppText(text: 'My gifts')),
              )
            ],
            flexibleSpace: const FlexibleSpaceBar(
              title: AppText(
                text: 'Gift Cards',
                weight: FontWeight.w600,
                size: AppSizes.heading5,
              ),
            ),
            expandedHeight: 120,
            pinned: true,
            floating: true,
          )
        ];
      },
      body: CustomScrollView(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  callback: () {},
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
                    title: const AppText(text: 'Got a gift card'),
                    trailing: AppButton2(text: 'Redeem', callback: () {}),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                onChanged: (value) {},
                choiceItems: C2Choice.listFrom<String, GiftCardCategory>(
                  source: _giftCardCategories,
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
                  color: AppColors.neutral200,
                ),
              ),
              const Gap(10),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20),
            sliver: SliverList.builder(
                itemCount: _giftCardCategories.length,
                itemBuilder: (context, index) {
                  final giftCardCategory = _giftCardCategories[index];

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: giftCardCategory.name,
                              size: AppSizes.bodySmall,
                            ),
                            // if (giftCategory.cards.length > 2)
                            AppTextButton(
                              text: "See all",
                              callback: () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => GiftCardCategoryScreen(
                                      giftCardCategory: giftCardCategory),
                                ));
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 130,
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final card = giftCardCategory.cards[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () {
                                    navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) => CustomizeGiftScreen(
                                        initiallySelectedCard: card,
                                      ),
                                    ));
                                  },
                                  child: Ink(
                                    child: Image.asset(
                                      card,
                                      width: 200,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Gap(10);
                            },
                            itemCount: giftCardCategory.cards.length < 8
                                ? giftCardCategory.cards.length
                                : 8),
                      )
                    ],
                  );
                }),
          ),
        ],
      ),
    ));
  }
}

class GiftCardCategory {
  final String name;
  final List<String> cards;

  GiftCardCategory({required this.name, required this.cards});
}
