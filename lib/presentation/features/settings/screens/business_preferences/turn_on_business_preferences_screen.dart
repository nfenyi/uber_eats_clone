import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/business_profile/business_profile_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/business_preferences_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../services/sign_in_view_model.dart';

class TurnOnBusinessPreferencesScreen extends StatefulWidget {
  const TurnOnBusinessPreferencesScreen({super.key});

  @override
  State<TurnOnBusinessPreferencesScreen> createState() =>
      _TurnOnBusinessPreferencesScreenState();
}

class _TurnOnBusinessPreferencesScreenState
    extends State<TurnOnBusinessPreferencesScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Business Preferences',
                  size: AppSizes.heading4,
                ),
                const Gap(15),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color.fromARGB(255, 241, 247, 238),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AssetNames.businessPreferences,
                            width: 60,
                          ),
                          const Gap(20),
                          const Expanded(
                            child: AppText(
                              text: 'Get more with business meals',
                              weight: FontWeight.bold,
                              size: AppSizes.heading6,
                            ),
                          )
                        ],
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.check),
                        title: AppText(
                          text: 'Quicker, easier expensing',
                          weight: FontWeight.bold,
                        ),
                        subtitle: AppText(
                          size: AppSizes.bodySmall,
                          text: 'Automatically sync with expensing apps',
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.check),
                        title: AppText(
                          text: 'Keep work meals separate',
                          weight: FontWeight.bold,
                        ),
                        subtitle: AppText(
                          size: AppSizes.bodySmall,
                          text: 'Get receipts at your work email',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Column(
              children: [
                AppButton(
                  isLoading: _isLoading,
                  text: 'Turn on',
                  callback: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      final firstBusinessProfile = BusinessProfile(
                          id: const Uuid().v4(),
                          email: FirebaseAuth.instance.currentUser!.email);
                      await FirebaseFirestore.instance
                          .collection(FirestoreCollections.businessProfiles)
                          .doc(firstBusinessProfile.id)
                          .set(firstBusinessProfile.toJson());
                      await FirebaseFirestore.instance
                          .collection(FirestoreCollections.users)
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        'selectedBusinessProfileId': firstBusinessProfile.id,
                        'businessProfileIds':
                            FieldValue.arrayUnion([firstBusinessProfile.id])
                      });
                      await AppFunctions.getOnlineUserInfo();
                      await navigatorKey.currentState!
                          .pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            BusinessPreferencesScreen(firstBusinessProfile),
                      ));
                    } on Exception catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      await showAppInfoDialog(navigatorKey.currentContext!,
                          description: e.toString());
                    }
                  },
                ),
                const Gap(10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
