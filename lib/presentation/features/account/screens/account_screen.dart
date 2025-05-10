import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ant_design.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/ep.dart';
import 'package:iconify_flutter_plus/icons/la.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/simple_line_icons.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/models/business_profile/business_profile_model.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/communication/communication_screen.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/voice_command_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/send_gifts_intro_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/about/about_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/turn_on_business_preferences_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/favorites_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/help_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/invite_a_friend_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/privacy_center_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/uber_one_intro_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/wallet/wallet_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../../models/family_profile/family_profile_model.dart';
import '../../../../models/uber_one_status/uber_one_status_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/weblinks.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import '../../../services/sign_in_view_model.dart';
import '../../carts/screens/orders_screen.dart';
import '../../main_screen/state/bottom_nav_index_provider.dart';
import '../../promotion/promo_screen.dart';
import '../../settings/screens/business_preferences/business_preferences_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../settings/screens/uber_account_screen.dart';
import '../../settings/screens/uber_one/uber_one_screen2.dart';
import 'family_and_teens/family_intro_screen.dart';
import 'family_and_teens/family_profile_modal.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final ValueNotifier<String?> _selectedProfile;

  @override
  void initState() {
    super.initState();
    final userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    _selectedProfile = ValueNotifier<String?>(userInfo['type']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: ValueListenableBuilder(
            valueListenable: Hive.box(AppBoxes.appState)
                .listenable(keys: [BoxKeys.userInfo]),
            builder: (context, appStateBox, child) {
              final userInfo = appStateBox.get(BoxKeys.userInfo);
              final String displayName = userInfo['displayName'];

              return AppText(
                text: displayName,
                weight: FontWeight.w600,
                size: AppSizes.heading3,
              );
            }),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: AppSizes.horizontalPaddingSmall),
            child: InkWell(
              onTap: () {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ));
              },
              child: Stack(
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        bool isSwitchingProfiles = false;
                        return StatefulBuilder(builder: (context, setState) {
                          return Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Gap(15),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
                                  child: Center(
                                    child: AppText(
                                      text: 'Switch profile',
                                      size: AppSizes.heading6,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Gap(5),
                                isSwitchingProfiles
                                    ? const LinearProgressIndicator(
                                        color: Colors.blue,
                                      )
                                    : const Divider(),
                                RadioListTile.adaptive(
                                  title: const AppText(
                                    text: 'Personal',
                                    size: AppSizes.bodySmall,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  secondary: const Icon(
                                    Icons.person_outline,
                                    size: 18,
                                  ),
                                  value: 'Personal',
                                  groupValue: _selectedProfile.value,
                                  onChanged: (value) async {
                                    setState(() {
                                      isSwitchingProfiles = true;
                                    });
                                    await FirebaseFirestore.instance
                                        .collection(FirestoreCollections.users)
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      'type': value,
                                    });
                                    await AppFunctions.getOnlineUserInfo();
                                    _selectedProfile.value = value;

                                    showInfoToast(
                                        'Switched to ${_selectedProfile.value}',
                                        icon: const Icon(
                                          Icons.person,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        context: navigatorKey.currentContext);
                                    //     setState(() {
                                    //   isSwitchingProfiles = false;
                                    // });
                                    if (context.mounted) {
                                      navigatorKey.currentState!.pop();
                                    }
                                  },
                                ),
                                RadioListTile.adaptive(
                                  title: const AppText(
                                    text: 'Business',
                                    size: AppSizes.bodySmall,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  secondary: const Iconify(
                                    Mdi.briefcase_outline,
                                    size: 18,
                                  ),
                                  value: 'Business',
                                  groupValue: _selectedProfile.value,
                                  onChanged: (value) async {
                                    setState(() {
                                      isSwitchingProfiles = true;
                                    });
                                    await FirebaseFirestore.instance
                                        .collection(FirestoreCollections.users)
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      'type': value,
                                    });
                                    await AppFunctions.getOnlineUserInfo();
                                    _selectedProfile.value = value;

                                    showInfoToast(
                                        'Switched to ${_selectedProfile.value}',
                                        icon: const Icon(
                                          Icons.person,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        context: navigatorKey.currentContext);
                                    //     setState(() {
                                    //   isSwitchingProfiles = false;
                                    // });
                                    if (context.mounted) {
                                      navigatorKey.currentState!.pop();
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    );
                  },
                  child: ValueListenableBuilder(
                      valueListenable: _selectedProfile,
                      builder: (context, value, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  AppText(
                                    text: '$value  ',
                                    size: AppSizes.bodySmall,
                                  ),
                                  value == 'Business'
                                      ? const Iconify(
                                          Mdi.briefcase_outline,
                                          size: 19,
                                        )
                                      : const Icon(
                                          Icons.person_outline,
                                          size: 19,
                                        ),
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_down)
                            ],
                          ),
                        );
                      }),
                ),
                const Gap(15),
                GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisExtent: 90),
                  children: [
                    InkWell(
                      onTap: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetNames.favorites,
                              width: 30,
                              height: 30,
                            ),
                            const AppText(text: 'Favorites')
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const WalletScreen(),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetNames.wallet,
                              width: 30,
                              height: 30,
                            ),
                            const AppText(text: 'Wallet')
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const OrdersScreen(),
                      )),
                      child: Ink(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AssetNames.orders,
                                width: 30,
                                height: 30,
                              ),
                              const AppText(text: 'Orders'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ValueListenableBuilder(
                    valueListenable: Hive.box(AppBoxes.appState)
                        .listenable(keys: [BoxKeys.userInfo]),
                    builder: (context, appStateBox, child) {
                      final Map<dynamic, dynamic> userInfo =
                          appStateBox.get(BoxKeys.userInfo);
                      Map<String, dynamic> stringObjectMap =
                          userInfo.map((key, value) {
                        return MapEntry(key.toString(), value);
                      });
                      final uberOneStatus =
                          UberOneStatus.fromJson(stringObjectMap);

                      return Column(
                        children: [
                          const Gap(20),
                          InkWell(
                            onTap: () {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) {
                                  if (uberOneStatus.hasUberOne) {
                                    return UberOneScreen2(uberOneStatus);
                                  }
                                  return UberOneIntroScreen(uberOneStatus);
                                },
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              decoration: BoxDecoration(
                                color: AppColors.neutral100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const AppText(
                                        text: 'Uber One',
                                        size: AppSizes.bodySmall,
                                      ),
                                      if (!uberOneStatus.hasUberOne)
                                        const AppText(
                                            text: 'Try free for 4 weeks'),
                                    ],
                                  ),
                                  Image.asset(
                                    AssetNames.uberOneSmall,
                                    width: 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
          const Gap(15),
          const Divider(),
          ListTile(
            onTap: () async {
              final userInfo = Hive.box(AppBoxes.appState).get(
                BoxKeys.userInfo,
              );
              final storedFamilyProfieId = userInfo['familyProfile'];
              if (storedFamilyProfieId == null) {
                await navigatorKey.currentState!
                    .push(MaterialPageRoute(builder: (context) {
                  return const FamilyIntroScreen();
                }));
              } else {
                final snapshot = await FirebaseFirestore.instance
                    .collection(FirestoreCollections.familyProfiles)
                    .doc(storedFamilyProfieId)
                    .get();
                if (snapshot.exists) {
                  final familyProfile =
                      FamilyProfile.fromJson(snapshot.data()!);
                  if (context.mounted) {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: (context) {
                        return FamilyProfileModal(familyProfile);
                      },
                    );
                  }
                } else {
                  logger.d(storedFamilyProfieId);
                }
              }
            },
            leading: const Icon(Icons.groups_outlined),
            title: const AppText(text: 'Family and teens'),
            subtitle: const AppText(text: 'Teen and adult accounts'),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(Uri.parse(Weblinks.googlePlayUberLink));
            },
            leading: const Icon(Icons.directions_car_outlined),
            title: const AppText(text: 'Ride'),
          ),
          ListTile(
            onTap: () => navigatorKey.currentState!.push(
                MaterialPageRoute(builder: (context) => const PromoScreen())),
            leading: const Iconify(AntDesign.tag_outlined),
            title: const AppText(text: 'Promotions'),
          ),
          Consumer(builder: (context, ref, child) {
            return ListTile(
              onTap: () {
                if (Hive.box(AppBoxes.appState)
                    .get(BoxKeys.firstTimeSendingGift, defaultValue: true)) {
                  navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => const SendGiftsIntroScreen(),
                  ));
                } else {
                  ref.read(bottomNavIndexProvider.notifier).showGiftScreen();
                }
              },
              leading: const Iconify(Ph.gift),
              title: const AppText(text: 'Send a gift'),
            );
          }),
          ListTile(
            onTap: () async {
              await navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const HelpScreen(),
              ));
            },
            leading: const Iconify(Ep.help),
            title: const AppText(text: 'Help'),
          ),
          ListTile(
            onTap: () async {
              try {
                final userInfo =
                    Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
                final selectedBusinessProfileId =
                    userInfo['selectedBusinessProfileId'];
                if (selectedBusinessProfileId == null) {
                  await navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) =>
                        const TurnOnBusinessPreferencesScreen(),
                  ));
                } else {
                  final businessProfileSnapshot = await FirebaseFirestore
                      .instance
                      .collection(FirestoreCollections.businessProfiles)
                      .doc(selectedBusinessProfileId)
                      .get();

                  final businessProfileJson = businessProfileSnapshot.data()!;
                  final businessProfile =
                      BusinessProfile.fromJson(businessProfileJson);
                  await navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) =>
                        BusinessPreferencesScreen(businessProfile),
                  ));
                }
              } on Exception catch (e) {
                await showAppInfoDialog(navigatorKey.currentContext!,
                    description: e.toString());
              }
            },
            leading: const Iconify(Mdi.briefcase_outline),
            title: const AppText(text: 'Setup your business profile'),
            subtitle:
                const AppText(text: 'Automate work travel & meal expenses'),
          ),
          const ListTile(
            leading: Iconify(Ep.trophy),
            title: AppText(text: 'Partner Rewards'),
          ),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const InviteAFriendScreen(),
              ));
            },
            leading: const Icon(Icons.person_add_outlined),
            title: const AppText(text: 'Invite friends'),
            subtitle: const AppText(text: 'Get \$15 off your order'),
          ),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const PrivacyCenterScreen(),
              ));
            },
            leading: const Iconify(Mdi.eye_remove_outline),
            title: const AppText(text: 'Privacy'),
          ),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const CommunicationScreen(),
              ));
            },
            leading: const Iconify(Bi.phone_vibrate),
            title: const AppText(text: 'Communication'),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(Uri.parse(Weblinks.uberDeliveryWebPage));
            },
            leading: const Iconify(La.shopping_bag),
            title: const AppText(text: 'Earn by driving or delivering'),
          ),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const VoiceCommandScreen(),
              ));
            },
            leading: const Iconify(SimpleLineIcons.microphone),
            title: const AppText(text: 'Voice command settings'),
          ),
          ListTile(
            onTap: () async {
              await navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const UberAccountScreen(),
              ));
            },
            leading: const Icon(Icons.person_outline),
            title: const AppText(text: 'Manage Uber account'),
          ),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const AboutScreen(),
              ));
            },
            leading: const Icon(Icons.info_outline),
            title: const AppText(text: 'About'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppText(text: 'v1.0'),
          )
        ]),
      ),
    );
  }
}
