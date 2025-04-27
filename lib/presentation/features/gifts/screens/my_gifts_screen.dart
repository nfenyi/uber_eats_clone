import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/gift_card/gift_card_model.dart';

import '../../../../app_functions.dart';
import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import '../../../services/sign_in_view_model.dart';
import 'gift_card_view_screen.dart';

class MyGiftsScreen extends StatefulWidget {
  const MyGiftsScreen({super.key});

  @override
  State<MyGiftsScreen> createState() => _MyGiftsScreenState();
}

class _MyGiftsScreenState extends State<MyGiftsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'My Gifts',
          size: AppSizes.heading6,
        ),
      ),
      body: FutureBuilder<List<GiftCard>>(
          future: _getMyGifts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final giftCards = snapshot.data!;
              return ListView.separated(
                itemBuilder: (context, index) {
                  final giftCard = giftCards[index];
                  logger.d(giftCard.dateCreated);
                  return Dismissible(
                    key: ValueKey(giftCard.id),
                    direction: DismissDirection.endToStart,
                    secondaryBackground: Container(
                      color: Colors.red.shade900,
                      child: const Padding(
                        padding: EdgeInsets.only(
                            right: AppSizes.horizontalPaddingSmall),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    background: const SizedBox.shrink(),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        final ref = FirebaseFirestore.instance
                            .collection(FirestoreCollections.giftCardsAnkasa)
                            .doc(giftCard.id);
                        giftCards.removeAt(index);
                        await ref.delete().then(
                          (value) {
                            setState(() {});
                          },
                        );
                      }
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      dense: true,
                      onTap: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => GiftCardViewScreen(giftCard),
                        ));
                      },
                      title: Row(
                        children: [
                          const AppText(
                            text: 'To: ',
                            color: AppColors.neutral500,
                          ),
                          AppText(text: giftCard.receiverName)
                        ],
                      ),
                      trailing: AppText(
                          color: AppColors.neutral500,
                          size: AppSizes.bodySmallest,
                          text:
                              //  giftCard.dateCreated == null
                              //     ? 'N/A'
                              //     :
                              AppFunctions.formatDate(
                                  giftCard.dateCreated.toString(),
                                  format: 'j M')),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                itemCount: giftCards.length,
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: snapshot.hasError
                          ? AppText(text: snapshot.error.toString())
                          : const CircularProgressIndicator(),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<List<GiftCard>> _getMyGifts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.giftCardsAnkasa)
        .where('senderUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    Iterable<GiftCard> myGiftCards = snapshot.docs.map(
      (snapshot) {
        return GiftCard.fromJson(snapshot.data());
      },
    );

    return myGiftCards.sorted(
      (a, b) => b.dateCreated.compareTo(a.dateCreated),
    );
  }
}
