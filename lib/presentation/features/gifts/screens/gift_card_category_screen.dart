import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/customize_gift_screen.dart';

import '../../../../models/gift_card_category_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

class GiftCardCategoryScreen extends StatelessWidget {
  final GiftCardCategory giftCardCategory;
  const GiftCardCategoryScreen({super.key, required this.giftCardCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar.medium(
                  leading: GestureDetector(
                    onTap: navigatorKey.currentState!.pop,
                    child: const Icon(Icons.close),
                  ),
                  floating: true,
                  pinned: true,
                  title: AppText(
                    text: giftCardCategory.name,
                    weight: FontWeight.w600,
                    size: AppSizes.heading6,
                  ),
                )
              ],
          body: ListView.separated(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            separatorBuilder: (context, index) => const Gap(20),
            itemCount: giftCardCategory.giftCardImages.length,
            itemBuilder: (context, index) {
              final cardRef = giftCardCategory.giftCardImages[index];
              return FutureBuilder<GiftCardImage>(
                  future: AppFunctions.getGiftCardImage(
                      cardRef as DocumentReference),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final cardUrl = snapshot.data!.imageUrl;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () =>
                              navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) => CustomizeGiftScreen(
                              initiallySelectedCard: cardUrl,
                            ),
                          )),
                          child: Ink(
                              child: AppFunctions.displayNetworkImage(
                            cardUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return SizedBox(
                        height: 180,
                        child: AppText(text: snapshot.error.toString()),
                      );
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: AppColors.neutral100,
                          height: 180,
                          width: double.infinity,
                        ),
                      );
                    }
                  });
            },
          )),
    );
  }
}
