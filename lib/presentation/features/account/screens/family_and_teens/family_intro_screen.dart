import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/family_and_teens/teen/add_teen_screen.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/family_and_teens/teen/select_a_member_screen.dart';
import 'package:uber_eats_clone/presentation/features/payment_options/payment_options_screen.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../../main.dart';
import '../../../../../models/family_profile/family_profile_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import '../../../settings/screens/uber_account/email_edit_screen.dart';

class FamilyIntroScreen extends StatelessWidget {
  const FamilyIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(
            AssetNames.family,
            width: double.infinity,
          ),
          const Gap(10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            text: 'Take care of your family with Uber',
                            weight: FontWeight.bold,
                            size: AppSizes.heading4),
                        Gap(15),
                        AppText(
                            text:
                                'Want to pay for your loved ones? Invite a family member (ages 18+) to create a Family profile. You can:'),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AppText(
                              text: 'Pay for your family',
                              size: AppSizes.bodySmaller,
                            ),
                            subtitle: AppText(
                              text: 'Use a shared payment method',
                              color: AppColors.neutral500,
                            ),
                            leading: Icon(Icons.favorite)),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AppText(
                              text: 'Get updates',
                              size: AppSizes.bodySmaller,
                            ),
                            subtitle: AppText(
                              text:
                                  'Receive notifications when a member uses the Family profile',
                              color: AppColors.neutral500,
                            ),
                            leading: Icon(Icons.notifications_outlined)),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AppText(
                              text: 'Manage family members',
                              size: AppSizes.bodySmaller,
                            ),
                            subtitle: AppText(
                              text:
                                  'Add up to 10 people that can use the Family profile',
                              color: AppColors.neutral500,
                            ),
                            leading: Icon(Icons.settings)),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                    children: [
                      Consumer(builder: (context, ref, child) {
                        return AppButton(
                          text: 'Invite family',
                          callback: () async {
                            try {
                              if (ref.read(paymentOptionProvider) == null) {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            AppSizes.horizontalPaddingSmall),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Center(
                                                child: AppText(
                                              text: 'Choose a way to pay',
                                              size: AppSizes.bodySmall,
                                              weight: FontWeight.w600,
                                            )),
                                            const Gap(10),
                                            const Divider(),
                                            const Gap(10),
                                            const AppText(
                                                text:
                                                    'Choose a credit card for our family to use. Other ways to pay aren\'t available yet.\n\nBear in mind that everyone in your family profile will share the same payment method.'),
                                            const Gap(10),
                                            AppButton(
                                              text: 'Choose payment method',
                                              callback: () async {
                                                await showModalBottomSheet(
                                                  context: context,
                                                  useSafeArea: true,
                                                  isScrollControlled: true,
                                                  builder: (context) =>
                                                      const PaymentOptionsScreen(
                                                    showOnlyPaymentMethods:
                                                        true,
                                                  ),
                                                );

                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                            const Gap(10),
                                            AppButton(
                                              isSecondary: true,
                                              text: 'Cancel',
                                              callback: () async {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              if (FirebaseAuth.instance.currentUser!.email ==
                                  null) {
                                showInfoToast(
                                    'Set an email in order to receive receipts',
                                    context: navigatorKey.currentContext);
                                await navigatorKey.currentState!.push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EmailEditScreen()));
                              }
                              final userInfo = Hive.box(AppBoxes.appState)
                                  .get(BoxKeys.userInfo);
                              if (FirebaseAuth.instance.currentUser!.email !=
                                      null &&
                                  ref.read(paymentOptionProvider) != null &&
                                  userInfo['familyProfile'] == null) {
                                final selectedPaymentMethod =
                                    ref.read(paymentOptionProvider)!;
                                final newFamilyProfile = FamilyProfile(
                                    id: const Uuid().v4(),
                                    members: [],
                                    organizer: userInfo['displayName'],
                                    paymentMethod:
                                        '${selectedPaymentMethod.creditCardType!}••••${selectedPaymentMethod.cardNumber.substring(8)}',
                                    receiptEmail: FirebaseAuth
                                        .instance.currentUser!.email!);
                                await FirebaseFirestore.instance
                                    .collection(
                                        FirestoreCollections.familyProfiles)
                                    .doc(newFamilyProfile.id)
                                    .set(newFamilyProfile.toJson());
                                final snapshot = await FirebaseFirestore
                                    .instance
                                    .collection(FirestoreCollections.users)
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get();
                                final userInfoFromFirestore = snapshot.data()!;
                                userInfoFromFirestore['familyProfile'] =
                                    newFamilyProfile.id;

                                await FirebaseFirestore.instance
                                    .collection(FirestoreCollections.users)
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set(userInfoFromFirestore);
                                userInfo['familyProfile'] = newFamilyProfile.id;
                                await Hive.box(AppBoxes.appState)
                                    .put(BoxKeys.userInfo, userInfo);
                              }

                              if (userInfo['familyProfile'] != null &&
                                  context.mounted) {
                                final familyProfileSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection(
                                            FirestoreCollections.familyProfiles)
                                        .doc(userInfo['familyProfile'])
                                        .get();
                                final familyProfile = FamilyProfile.fromJson(
                                    familyProfileSnapshot.data()!);
                                await showModalBottomSheet(
                                  isScrollControlled: false,
                                  context: navigatorKey.currentContext!,
                                  builder: (context) {
                                    return AddAdultOrTeenModal(familyProfile);
                                  },
                                );
                              }
                            } on Exception catch (e) {
                              await showAppInfoDialog(
                                  navigatorKey.currentContext!,
                                  description: e.toString());
                            }
                          },
                        );
                      }),
                      const Gap(10)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AddAdultOrTeenModal extends StatefulWidget {
  final FamilyProfile familyProfile;
  const AddAdultOrTeenModal(this.familyProfile, {super.key});

  @override
  State<AddAdultOrTeenModal> createState() => _AddAdultOrTeenModalState();
}

class _AddAdultOrTeenModalState extends State<AddAdultOrTeenModal> {
  String? _selectedOption = 'Teen';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10, horizontal: AppSizes.horizontalPaddingSmall),
            child: AppText(
              text: 'Add an adult or teen?',
              weight: FontWeight.w600,
              size: AppSizes.heading6,
            ),
          ),
          const Divider(),
          RadioListTile.adaptive(
            title: const AppText(
              text: 'Teen',
              size: AppSizes.bodySmall,
            ),
            subtitle: const AppText(
              text: 'Teens are ages 13 to 17',
            ),
            dense: true,
            controlAffinity: ListTileControlAffinity.trailing,
            secondary: const Iconify(Mdi.human_male_child),
            value: 'Teen',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          const Divider(
            indent: 60,
          ),
          RadioListTile.adaptive(
            dense: true,
            title: const AppText(
              text: 'Adult',
              size: AppSizes.bodySmall,
            ),
            subtitle: const AppText(
              text: 'Adults are 18 and older',
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            secondary: const Iconify(Uil.i_18_plus),
            value: 'Adult',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                AppButton(
                  text: 'Continue',
                  callback: () {
                    navigatorKey.currentState!.pop();

                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) {
                        if (_selectedOption == 'Teen') {
                          if (Hive.box(AppBoxes.appState).get(
                              BoxKeys.firstTimeAddingTeen,
                              defaultValue: true)) {
                            return const AddTeenScreen();
                          } else {
                            return const SelectAMemberScreen(
                                memberType: FamilyMemberType.teen);
                          }
                        } else {
                          return const SelectAMemberScreen(
                              memberType: FamilyMemberType.adult);
                        }
                      },
                    ));
                  },
                ),
                const Gap(10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
