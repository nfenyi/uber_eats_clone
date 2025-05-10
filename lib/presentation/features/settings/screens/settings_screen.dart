import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_account_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/sign_in/sign_in_provider.dart';

import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets.dart';
import '../../address/screens/addresses_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    final List<dynamic> savedAddresses = userInfo['addresses'];
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                text: 'Settings',
                size: AppSizes.heading4,
              ),
            ),
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const RadialGradient(stops: [
                            0.6,
                            1.0
                          ], colors: [
                            Colors.white,
                            AppColors.neutral200,
                          ]),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -8),
                        child: Image.asset(
                          AssetNames.noProfilePic,
                          width: 45,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  AppText(
                    text: FirebaseAuth.instance.currentUser!.displayName!,
                    size: AppSizes.bodySmall,
                  ),
                  const Gap(5),
                  InkWell(
                    onTap: () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const UberAccountScreen(),
                      ));
                    },
                    child: Ink(
                      child: const AppText(
                        text: 'EDIT ACCOUNT',
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(40),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppText(
                text: 'Saved places',
                size: AppSizes.bodySmall,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: savedAddresses.length <= 3 ? savedAddresses.length : 3,
              itemBuilder: (context, index) {
                final address = savedAddresses[index];

                return ListTile(
                  leading: address['addressLabel'] == 'Home'
                      ? const Icon(Icons.home_outlined)
                      : (address['addressLabel'] == 'Work' ||
                              address['addressLabel'] == 'Office')
                          ? const Iconify(Mdi.briefcase_outline)
                          : const Icon(
                              Icons.pin_drop_outlined,
                            ),
                  title: AppText(
                    text: address['addressLabel'],
                    size: AppSizes.bodySmall,
                  ),
                  subtitle: AppText(
                    text: AppFunctions.formatPlaceDescription(
                        address['placeDescription']),
                    color: AppColors.neutral500,
                  ),
                );
              },
            ),
            if (!savedAddresses.any(
              (element) =>
                  element['addressLabel'] == 'Home' ||
                  element['addressLabel'] == 'House',
            ))
              ListTile(
                onTap: () async {
                  await navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => const AddressesScreen(
                      newLabel: 'Home',
                    ),
                  ));
                },
                dense: true,
                leading: const Iconify(Mdi.briefcase_outline),
                title: const AppText(text: 'Home'),
                subtitle: const AppText(text: 'Add Home'),
              ),
            if (!savedAddresses.any(
              (element) =>
                  element['addressLabel'] == 'Work' ||
                  element['addressLabel'] == 'Office',
            ))
              ListTile(
                onTap: () async {
                  await navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => const AddressesScreen(
                      newLabel: 'Work',
                    ),
                  ));
                },
                dense: true,
                leading: const Iconify(Mdi.briefcase_outline),
                title: const AppText(text: 'Work'),
                subtitle: const AppText(text: 'Add Work'),
              ),
            const Gap(10),
            if (savedAddresses.length > 3)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: InkWell(
                  onTap: () async {
                    await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const AddressesScreen(),
                    ));
                  },
                  child: Ink(
                    child: const AppText(
                      text: 'View All',
                      // size: AppSizes.bodySmalle,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            const Gap(15),
            const Divider(),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: 'Are you sure you want to sign out?',
                                size: AppSizes.bodySmall,
                                color: AppColors.neutral500,
                              ),
                              const Gap(20),
                              AppButton(
                                text: 'Sign out',
                                callback: () async {
                                  navigatorKey.currentState!.pop();
                                  showInfoToast('Logging out',
                                      icon: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                      context: context);
                                  try {
                                    await ref
                                        .read(signInProvider.notifier)
                                        .logOut();
                                    navigatorKey.currentState!.pop();
                                  } on Exception catch (e) {
                                    showInfoToast(e.toString(),
                                        context: navigatorKey.currentContext);
                                  }
                                },
                              ),
                              const Gap(10),
                              Center(
                                child: AppButton(
                                  isSecondary: true,
                                  text: 'Cancel',
                                  callback: () =>
                                      navigatorKey.currentState!.pop(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Ink(
                  child: AppText(
                    text: 'Sign out',
                    size: AppSizes.bodySmall,
                    color: Colors.red.shade900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
