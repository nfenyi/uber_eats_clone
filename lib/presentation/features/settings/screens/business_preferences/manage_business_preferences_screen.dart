import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/business_profile/business_profile_model.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/initial_add_business_profile_screen.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

import '../../../../../app_functions.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import 'business_choose_payment_screen.dart';

class ManageBusinessPreferencesScreen extends StatefulWidget {
  const ManageBusinessPreferencesScreen({
    super.key,
  });

  @override
  State<ManageBusinessPreferencesScreen> createState() =>
      _ManageBusinessPreferencesScreenState();
}

class _ManageBusinessPreferencesScreenState
    extends State<ManageBusinessPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppText(
              text: 'Business Preferences',
              weight: FontWeight.bold,
              size: AppSizes.heading4,
            ),
          ),
          ValueListenableBuilder(
              valueListenable: Hive.box(AppBoxes.appState)
                  .listenable(keys: [BoxKeys.userInfo]),
              builder: (context, appStateBox, child) {
                final userInfo = appStateBox.get(BoxKeys.userInfo);

                final List businessProflieIds = userInfo['businessProfileIds'];
                final String selectedProfielId =
                    userInfo['selectedBusinessProfileId'];

                return FutureBuilder<List<BusinessProfile>>(
                    future:
                        AppFunctions.getBusinessProfiles(businessProflieIds),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final businessProfiles = snapshot.data!;
                        return ListView.builder(
                            itemCount: businessProfiles.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final businessProfile = businessProfiles[index];
                              return ListTile(
                                onLongPress: () => navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) =>
                                      BusinessChoosePaymentScreen(
                                    businessId: businessProfile.id,
                                  ),
                                )),
                                onTap: () async {
                                  try {
                                    if (selectedProfielId !=
                                        businessProfile.id) {
                                      await FirebaseFirestore.instance
                                          .collection(
                                              FirestoreCollections.users)
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        'selectedBusinessProfileId':
                                            businessProfile.id
                                      });

                                      await AppFunctions.getOnlineUserInfo();
                                      showInfoToast('Business account switched',
                                          context: navigatorKey.currentContext);
                                    }
                                  } on Exception catch (e) {
                                    await showAppInfoDialog(
                                        navigatorKey.currentContext!,
                                        description: e.toString());
                                  }
                                },
                                tileColor:
                                    selectedProfielId == businessProfile.id
                                        ? AppColors.neutral100
                                        : null,
                                title: const AppText(
                                  text: 'Business',
                                  weight: FontWeight.bold,
                                  size: AppSizes.heading6,
                                ),
                                subtitle: AppText(
                                  text: businessProfile.creditCardNumber ??
                                      'No payment method',
                                  color: AppColors.neutral500,
                                ),
                                // trailing: const Icon(
                                //   Icons.keyboard_arrow_right,
                                //   color: AppColors.neutral500,
                                // ),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blue),
                                  child: const Iconify(
                                    Mdi.briefcase,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return AppText(
                          text: snapshot.error.toString(),
                        );
                      } else {
                        return Skeletonizer(
                          enabled: true,
                          child: ListTile(
                            title: const AppText(
                              text: 'Business',
                              weight: FontWeight.bold,
                              size: AppSizes.heading6,
                            ),
                            subtitle: const AppText(
                              text: 'nalnlaslmsdl',
                              color: AppColors.neutral500,
                            ),
                            leading: Container(
                              width: 60,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColors.neutral100),
                            ),
                          ),
                        );
                      }
                    });
              }),
          ListTile(
            onTap: () async {
              await navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const InitialAddBusinessProfileScreen(),
              ));
              setState(() {});
            },
            leading: const Icon(
              Icons.add,
            ),
            title: const AppText(text: 'Add another business profile'),
          )
        ],
      ),
    );
  }
}
