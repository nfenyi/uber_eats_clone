import 'package:flutter/material.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/redeem_gift_card_screen.dart';

import '../../../../models/gift_card/gift_card_model.dart';
import '../../../constants/app_sizes.dart';

class GiftCardViewScreen extends StatelessWidget {
  final GiftCard giftCard;
  const GiftCardViewScreen(
    this.giftCard, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [GiftCardWidget(searchedGiftCard: giftCard)],
          ),
        ),
      ),
    );
  }
}
