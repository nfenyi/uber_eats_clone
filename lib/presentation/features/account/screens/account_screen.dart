import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ep.dart';
import 'package:iconify_flutter/icons/la.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/simple_line_icons.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/communication/communication_screen.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/voice_command_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/send_gifts_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/about/about_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/turn_on_business_preferences_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/favorites_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/help_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/invite_a_friend_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/privacy_center_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/uber_one_account_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/wallet/wallet_screen.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import '../../settings/screens/settings_screen.dart';
import 'family_and_teens/family_and_teens_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _selectedProfile = 'Personal';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: const AppText(
          text: 'Nana Fenyi',
          weight: FontWeight.w600,
          size: AppSizes.heading3,
        ),
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
                              const Divider(),
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
                                groupValue: _selectedProfile,
                                onChanged: (value) {
                                  navigatorKey.currentState!.pop();

                                  setState(() {
                                    _selectedProfile = value;
                                  });

                                  showInfoToast('Switched to $_selectedProfile',
                                      icon: const Icon(
                                        Icons.person,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      context: context);
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
                                  Mdi.briefcase,
                                  size: 18,
                                ),
                                value: 'Business',
                                groupValue: _selectedProfile,
                                onChanged: (value) {
                                  navigatorKey.currentState!.pop();

                                  setState(() {
                                    _selectedProfile = value;
                                  });

                                  showInfoToast('Switched to $_selectedProfile',
                                      icon: const Iconify(
                                        Mdi.briefcase_outline,
                                        size: 19,
                                        color: Colors.white,
                                      ),
                                      context: context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
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
                              text: '$_selectedProfile  ',
                              size: AppSizes.bodySmall,
                            ),
                            _selectedProfile == 'Business'
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
                  ),
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
                    Container(
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
                  ],
                ),
                const Gap(20),
                InkWell(
                  onTap: () {
                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const UberOneAccountScreen(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Uber One',
                              size: AppSizes.bodySmall,
                            ),
                            AppText(text: 'Try free for 4 weeks'),
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
            ),
          ),
          const Gap(15),
          const Divider(),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const FamilyAndTeensScreen(),
              ));
            },
            leading: const Icon(Icons.groups_outlined),
            title: const AppText(text: 'Family and teens'),
            subtitle: const AppText(text: 'Teen and adult accounts'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.directions_car_outlined),
            title: const AppText(text: 'Ride'),
          ),
          ListTile(
            onTap: () {},
            //TODO: may use this icon throughout
            leading: const Iconify(AntDesign.tag_outlined),
            title: const AppText(text: 'Promotions'),
          ),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const SendGiftsScreen(),
              ));
            },
            leading: const Iconify(Ph.gift),
            title: const AppText(text: 'Send a gift'),
          ),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const HelpScreen(),
              ));
            },
            leading: const Iconify(Ep.help),
            title: const AppText(text: 'Help'),
          ),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const TurnOnBusinessPreferencesScreen(),
              ));
            },
            leading: const Iconify(Mdi.briefcase_outline),
            title: const AppText(text: 'Setup your business profile'),
            subtitle:
                const AppText(text: 'Automate work travel & meal expenses'),
          ),
          ListTile(
            onTap: () {},
            leading: const Iconify(Ep.trophy),
            title: const AppText(text: 'Partner Rewards'),
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
            onTap: () {},
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
            onTap: () {},
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
