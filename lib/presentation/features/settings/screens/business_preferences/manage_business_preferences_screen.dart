import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/business_profile/business_profile_model.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/initial_add_business_profile_screen.dart';

import '../../../../../app_functions.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';

class ManageBusinessPreferencesScreen extends StatelessWidget {
  const ManageBusinessPreferencesScreen({
    super.key,
  });

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
          FutureBuilder<List<BusinessProfile>>(
              future: AppFunctions.getBusinessProfiles(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final businessProfiles = snapshot.data!;
                  return ListView.builder(
                      itemCount: businessProfiles.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final businessProfile = businessProfiles[index];
                        return ListTile(
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
                          trailing: businessProfile.creditCardNumber == null
                              ? const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: AppColors.neutral500,
                                )
                              : null,
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
                            color: Colors.blue),
                      ),
                    ),
                  );
                }
              }),
          ListTile(
            onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => const InitialAddBusinessProfileScreen(),
            )),
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
