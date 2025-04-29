import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/family_profile/family_profile_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

import '../../../../../app_functions.dart';
import 'family_intro_screen.dart';

class FamilyProfileModal extends StatelessWidget {
  final FamilyProfile familyProfile;
  const FamilyProfileModal(this.familyProfile, {super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    final dateTimeNow = DateTime.now();
    String displayName = userInfo['displayName'];
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => navigatorKey.currentState!.pop(),
            child: const Icon(Icons.close)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Family profile',
                    size: AppSizes.heading4,
                  ),
                  Gap(20),
                  AppText(
                    text: 'Members',
                    weight: FontWeight.bold,
                    size: AppSizes.heading6,
                  ),
                  AppText(
                    size: AppSizes.bodySmallest,
                    text:
                        'Add or remove people that can use your Family profile.',
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final member = familyProfile.members[index];
                return ListTile(
                  dense: true,
                  title: AppText(text: member.name),
                  subtitle: AppText(
                      text: dateTimeNow.difference(member.dob) <
                              const Duration(days: 18 * 365)
                          ? 'Teen'
                          : 'Adult'),
                );
              },
              itemCount: familyProfile.members.length,
            ),
            ListTile(
              onTap: () async => await showModalBottomSheet(
                context: context,
                builder: (context) {
                  return AddAdultOrTeenModal(familyProfile);
                },
              ),
              dense: true,
              leading: const Icon(Icons.add_circle),
              title: const AppText(
                text: 'Add new member',
                size: AppSizes.bodySmall,
              ),
              subtitle: const AppText(
                text: 'Teens or adults',
                color: AppColors.neutral500,
              ),
            ),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.person),
              title: AppText(
                text: displayName,
                size: AppSizes.bodySmall,
              ),
              subtitle: const AppText(
                text: 'Organizer',
                color: AppColors.neutral500,
              ),
            ),
            const Divider(
              color: AppColors.neutral200,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Settings',
                    weight: FontWeight.bold,
                    size: AppSizes.heading6,
                  ),
                  AppText(
                    text:
                        "Choose your family's shared payment method and where you want to get receipts.",
                    // weight: FontWeight.bold,
                    // size: AppSizes.heading6,
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {},
              dense: true,
              leading: const Icon(Icons.email),
              title: const AppText(
                text: 'Email for receipt',
                size: AppSizes.bodySmall,
              ),
              subtitle: AppText(
                text: familyProfile.receiptEmail,
                color: AppColors.neutral500,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
            ),
            ListTile(
              onTap: () {},
              dense: true,
              leading: const Icon(Icons.credit_card),
              title: const AppText(
                text: 'Payment method',
                size: AppSizes.bodySmall,
              ),
              subtitle: AppText(
                text: familyProfile.paymentMethod,
                color: AppColors.neutral500,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.neutral500,
              ),
            ),
            const Divider(
              thickness: 4,
            ),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppButton(
                text: 'Delete Family profile',
                isSecondary: true,
                callback: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      bool isLoading = false;
                      return StatefulBuilder(builder: (context, setState) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isLoading)
                                const LinearProgressIndicator(
                                  color: Colors.blue,
                                ),
                              ListTile(
                                dense: true,
                                onTap: () async {
                                  try {
                                    setState(
                                      () {
                                        isLoading = true;
                                      },
                                    );
                                    await FirebaseFirestore.instance
                                        .collection(
                                            FirestoreCollections.familyProfiles)
                                        .doc(familyProfile.id)
                                        .delete();
                                    final userDetailsSnapshot =
                                        await FirebaseFirestore
                                            .instance
                                            .collection(
                                                FirestoreCollections.users)
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .get();
                                    final userDetails =
                                        userDetailsSnapshot.data()!;
                                    userDetails['familyProfile'] = null;
                                    await FirebaseFirestore.instance
                                        .collection(FirestoreCollections.users)
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .set(userDetails);
                                    await AppFunctions.getOnlineUserInfo();
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                    navigatorKey.currentState!.pop();
                                  } on Exception catch (e) {
                                    setState(
                                      () {
                                        isLoading = false;
                                      },
                                    );
                                    await showAppInfoDialog(
                                        navigatorKey.currentContext!,
                                        description: e.toString());
                                  }
                                },
                                leading: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade900,
                                ),
                                title: const AppText(
                                  text: 'Delete profile',
                                ),
                              ),
                              const Gap(5),
                            ],
                          ),
                        );
                      });
                    },
                  );
                },
                textColor: Colors.red.shade900,
                iconFirst: true,
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red.shade900,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
