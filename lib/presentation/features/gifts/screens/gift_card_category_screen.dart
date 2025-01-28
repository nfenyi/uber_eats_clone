import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/customize_gift_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_card_screen.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_text.dart';

class GiftCardCategoryScreen extends StatelessWidget {
  final GiftCardCategory giftCardCategory;
  const GiftCardCategoryScreen({super.key, required this.giftCardCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    title: AppText(
                      text: giftCardCategory.name,
                      weight: FontWeight.w600,
                      size: AppSizes.heading6,
                    ),
                  ),
                )
              ],
          body: ListView.separated(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            separatorBuilder: (context, index) => const Gap(20),
            itemCount: giftCardCategory.cards.length,
            itemBuilder: (context, index) {
              final card = giftCardCategory.cards[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: () =>
                      navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => CustomizeGiftScreen(
                      initiallySelectedCard: card,
                    ),
                  )),
                  child: Ink(
                    child: Image.asset(
                      card,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
