import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../models/gift_card/gift_card_model.dart';
import '../../../services/sign_in_view_model.dart';

class RedeemGiftCardScreen extends StatefulWidget {
  final String? newGiftCardId;
  const RedeemGiftCardScreen({super.key, this.newGiftCardId});

  @override
  State<RedeemGiftCardScreen> createState() => _RedeemGiftCardScreenState();
}

class _RedeemGiftCardScreenState extends State<RedeemGiftCardScreen> {
  final _textController = TextEditingController();
  Timer? _debounce;

  DocumentReference<Map<String, Object?>>? _searchedGiftCardRef;

  GiftCard? _searchedGiftCard;

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: navigatorKey.currentState!.pop,
            child: const Icon(Icons.close)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AssetNames.addGiftCard,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      text: 'Add Gift Card',
                      weight: FontWeight.bold,
                      size: AppSizes.heading4,
                    ),
                    const Gap(15),
                    AppTextFormField(
                      controller: _textController,
                      hintText: 'Enter your code...',
                      onChanged: (value) {
                        if (value != null) {
                          if (_debounce?.isActive ?? false) {
                            _debounce?.cancel();
                          }
                          _debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            setState(() {});
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                AppButton(
                  text: 'Apply',
                  callback: _textController.text.trim().isEmpty
                      ? null
                      : () async {
                          _searchedGiftCardRef = FirebaseFirestore.instance
                              .collection(FirestoreCollections.giftCards)
                              .doc(_textController.text.trim());
                          final giftCardSnapshot =
                              await _searchedGiftCardRef!.get();
                          // logger.d(promoSnapshot.exists);
                          if (!giftCardSnapshot.exists) {
                            setState(() {
                              _searchedGiftCard = null;
                            });
                            return;
                          }
                        },
                ),
                const Gap(10)
              ],
            ),
          )
        ],
      ),
    );
  }
}
