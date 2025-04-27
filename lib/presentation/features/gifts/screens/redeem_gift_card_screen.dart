import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/uber_cash/uber_cash_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app_functions.dart';
import '../../../../models/gift_card/gift_card_model.dart';
import '../../../constants/weblinks.dart';
import '../../../core/app_colors.dart';
import '../../../services/sign_in_view_model.dart';
import '../../webview/webview_screen.dart';
import 'recorded_message_player_screen.dart';

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
  void initState() {
    super.initState();
    if (widget.newGiftCardId != null) {
      _textController.text = widget.newGiftCardId!;
    }
  }

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
      body: SingleChildScrollView(
        child: Scrollbar(
          child: Column(
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
              if (_searchedGiftCard != null)
                Padding(
                  padding: const EdgeInsets.all(AppSizes.horizontalPadding),
                  child: GiftCardWidget(
                    searchedGiftCard: _searchedGiftCard,
                  ),
                ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            children: [
              AppButton(
                  text: _searchedGiftCard == null ? 'Search' : 'Apply',
                  callback: _searchedGiftCard == null
                      ? _textController.text.trim().isEmpty
                          ? null
                          : () async {
                              _searchedGiftCardRef = FirebaseFirestore.instance
                                  .collection(
                                      FirestoreCollections.giftCardsAnkasa)
                                  .doc(_textController.text.trim());
                              final giftCardSnapshot =
                                  await _searchedGiftCardRef!.get();

                              if (!giftCardSnapshot.exists) {
                                setState(() {
                                  _searchedGiftCard = null;
                                });
                                showInfoToast('Gift card not found',
                                    context: navigatorKey.currentContext);
                                return;
                              } else {
                                final temp =
                                    GiftCard.fromJson(giftCardSnapshot.data()!);
                                if (temp.used) {
                                  setState(() {
                                    _searchedGiftCard = null;
                                  });
                                  showInfoToast('Gift card already applied',
                                      context: navigatorKey.currentContext);
                                  return;
                                } else {
                                  setState(() {
                                    _searchedGiftCard = GiftCard.fromJson(
                                        giftCardSnapshot.data()!);
                                  });
                                }
                              }
                            }
                      : () async {
                          final usersDetails = await FirebaseFirestore.instance
                              .collection(FirestoreCollections.users)
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get();
                          final UberCash oldDeviceUserDetails =
                              UberCash.fromJson(
                                  usersDetails.data()!['uberCash']);
                          final newDeviceUserDetails =
                              oldDeviceUserDetails.copyWith(
                                  balance: oldDeviceUserDetails.balance +
                                      _searchedGiftCard!.giftAmount,
                                  cashAdded: oldDeviceUserDetails.cashAdded +
                                      _searchedGiftCard!.giftAmount);

                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.users)
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                                  {'uberCash': newDeviceUserDetails.toJson()});
                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.giftCardsAnkasa)
                              .doc(_searchedGiftCard!.id)
                              .update({'used': true});
                        }),
              const Gap(10)
            ],
          ),
        )
      ],
    );
  }
}

class GiftCardWidget extends StatelessWidget {
  const GiftCardWidget({
    super.key,
    required GiftCard? searchedGiftCard,
  }) : _searchedGiftCard = searchedGiftCard;

  final GiftCard? _searchedGiftCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.neutral300,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: AppFunctions.displayNetworkImage(
                  _searchedGiftCard!.imageUrl,
                  placeholderAssetImage: AssetNames.giftCardPlaceholder,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.withAlpha(180))),
              ),
            ],
          ),
          const Gap(20),
          AppText(
            text: '\$${_searchedGiftCard!.giftAmount} USD',
            weight: FontWeight.w600,
            size: AppSizes.heading4,
          ),
          const Gap(30),
          AppText(
              weight: FontWeight.w600,
              size: AppSizes.heading6,
              text:
                  "${_searchedGiftCard!.receiverName}, here's an Uber gift from ${_searchedGiftCard!.senderName}!"),
          const Gap(10),
          if (_searchedGiftCard!.optionalVideoUrl != null)
            InkWell(
              onTap: () async {
                if (context.mounted) {
                  await navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => RecordedMessagePlayerScreen(
                      videoUrl: _searchedGiftCard!.optionalVideoUrl!,
                    ),
                  ));
                }
              },
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.videocam_sharp),
                    const Gap(10),
                    AppText(
                        text:
                            'You got a video from ${_searchedGiftCard!.senderName}!')
                  ],
                ),
              ),
            ),
          if (_searchedGiftCard!.optionalMessage != null)
            AppText(
              text: _searchedGiftCard!.optionalMessage!,
            ),
          const Gap(15),
          GestureDetector(
            onTap: () async {
              await launchUrl(Uri.parse(Weblinks.uberGiftCardTerms));
            },
            child: const AppText(
              text: 'Terms apply',
              decoration: TextDecoration.underline,
              color: AppColors.neutral500,
            ),
          ),
          const Gap(10)
        ],
      ),
    );
  }
}
