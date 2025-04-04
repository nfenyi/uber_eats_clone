import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/favourite/favourite_model.dart';
import 'package:uber_eats_clone/models/store/store_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/account_screen.dart';
import 'package:uber_eats_clone/presentation/features/browse/screens/browse_screen.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/carts_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_category_screen.dart';
import 'package:uber_eats_clone/presentation/features/grocery/screens/grocery_screen.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';
import 'package:uber_eats_clone/state/shops_state_stream_provider.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import '../../../services/sign_in_view_model.dart';
import '../../gifts/screens/gift_screen.dart';
import '../../gifts/screens/redeem_gift_card_screen.dart';
import '../../pharmacy/screens/pharmacy_screen.dart';
import '../state/bottom_nav_index_provider.dart';

late List<Store> allStores;
late List<FavouriteStore> favoriteStores;

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late int _currentScreen;
  final List<Widget> _screens = [
    const HomeScreen(),
    const GroceryScreen(),
    const BrowseScreen(),
    const CartsScreen(),
    const AccountScreen()
  ];

  bool _hasUberOne = false;

  String _accountType = 'Personal';

  @override
  void initState() {
    super.initState();
    _getAccountStatus();
    _currentScreen = ref.read(bottomNavIndexProvider);
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      try {
        final user = FirebaseAuth.instance.currentUser!;

        if (dynamicLinkData.link.toString().contains('group-order')) {
          var groupOrderId = dynamicLinkData.link.toString().split('%').last;
          DocumentReference groupOrderRef = FirebaseFirestore.instance
              .collection(FirestoreCollections.groupOrders)
              .doc(groupOrderId);
          await groupOrderRef.update({
            'persons': FieldValue.arrayUnion([user.uid])
          });
          await FirebaseFirestore.instance
              .collection(FirestoreCollections.users)
              .doc(user.uid)
              .update({
            'groupOrders': FieldValue.arrayUnion([groupOrderRef])
          });
          showInfoToast('Group order added!',
              context: navigatorKey.currentContext);
        } else if (dynamicLinkData.link.toString().contains('gift-card')) {
          var giftCardId = dynamicLinkData.link.toString().split('%').last;
          DocumentReference giftCardRef = FirebaseFirestore.instance
              .collection(FirestoreCollections.giftCardsAnkasa)
              .doc(giftCardId);

          await FirebaseFirestore.instance
              .collection(FirestoreCollections.users)
              .doc(user.uid)
              .update({
            'giftCards': FieldValue.arrayUnion([giftCardRef])
          });
          await navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) =>
                RedeemGiftCardScreen(newGiftCardId: giftCardId),
          ));
        }
      } catch (e) {
        await showAppInfoDialog(navigatorKey.currentContext!,
            description: e.toString());
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Hive.box(AppBoxes.appState)
          .get(BoxKeys.hasGiftCard, defaultValue: false)) {
        await navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => RedeemGiftCardScreen(
              newGiftCardId:
                  Hive.box(AppBoxes.appState).get(BoxKeys.newGiftCardId)),
        ));
        await Hive.box(AppBoxes.appState).put(BoxKeys.hasGiftCard, false);
        await Hive.box(AppBoxes.appState).delete(BoxKeys.newGiftCardId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int bottomNavIndex = ref.watch(bottomNavIndexProvider);
    allStores = ref.watch(storesProvider).value ?? [];
    favoriteStores = ref.watch(favoriteStoresProvider).value ?? [];
    if (bottomNavIndex < 6) {
      _currentScreen = bottomNavIndex;
    }
    return PopScope(
      canPop: bottomNavIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (bottomNavIndex != 0) {
          ref.read(bottomNavIndexProvider.notifier).updateIndex(0);
        }
      },
      child: Scaffold(
        body: bottomNavIndex < 6
            ? _screens[_currentScreen]
            : bottomNavIndex == 6
                ? const GiftScreen()
                : bottomNavIndex == 7
                    ? const GiftCategoryScreen()
                    : const PharmacyScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentScreen,
          onTap: (value) {
            ref.read(bottomNavIndexProvider.notifier).updateIndex(value);
          },
          backgroundColor: Colors.white,
          // elevation: 5,
          enableFeedback: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: AppSizes.bodySmallest,
          unselectedFontSize: AppSizes.bodySmallest,
          // selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.neutral500,
          selectedLabelStyle: const TextStyle(
            fontSize: AppSizes.bodySmallest,
            fontWeight: FontWeight.w500,
            // color: AppColors.primary,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: AppSizes.bodySmallest,
            fontWeight: FontWeight.w500,
            color: AppColors.neutral500,
          ),
          items: [
            const BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.home_filled,
                  size: 27,
                  // color: AppColors.primary,
                ),
                icon: Icon(
                  Icons.home_outlined,
                  size: 27,
                  // color: Colors.transparent,
                ),
                label: 'Home'
                // 'Home',
                ),
            const BottomNavigationBarItem(
              activeIcon: Iconify(
                Mdi.food_apple,
              ),
              icon: Iconify(
                Mdi.food_apple_outline,
                color: AppColors.neutral500,
                size: 27,
              ),
              label: 'Grocery',
            ),
            const BottomNavigationBarItem(
              activeIcon: Iconify(
                MaterialSymbols.manage_search_rounded,
                size: 27,
              ),
              icon: Iconify(
                MaterialSymbols.manage_search_rounded,
                color: AppColors.neutral500,
                size: 27,
              ),
              label: 'Explore',
            ),
            const BottomNavigationBarItem(
              activeIcon: Badge(
                  label: AppText(text: '4'),
                  child: Iconify(MaterialSymbols.shopping_cart_rounded)),
              icon: Badge(
                  label: AppText(text: '4'),
                  child: Iconify(
                    MaterialSymbols.shopping_cart_outline_rounded,
                    color: AppColors.neutral500,
                  )),
              label: 'Carts',
              // 'Budgets',
            ),
            BottomNavigationBarItem(
              activeIcon: ValueListenableBuilder(
                  valueListenable: Hive.box(AppBoxes.appState)
                      .listenable(keys: [BoxKeys.userInfo]),
                  builder: (context, box, child) {
                    // if(box.get(BoxKeys.userInfo) == nul)

                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _accountType == 'Personal'
                            ? const Icon(
                                Icons.person,
                                // color: AppColors.primary,
                                size: 27,
                              )
                            : const Iconify(
                                Mdi.briefcase,
                                size: 26,
                              ),
                        if (_hasUberOne == true)
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: Image.asset(
                              AssetNames.uberOneSmall,
                              width: 17,
                            ),
                          ),
                      ],
                    );
                  }),

              icon: ValueListenableBuilder(
                  valueListenable: Hive.box(AppBoxes.appState)
                      .listenable(keys: [BoxKeys.userInfo]),
                  builder: (context, box, child) {
                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _accountType == 'Personal'
                            ? const Icon(
                                Icons.person,
                                size: 27,
                              )
                            : const Iconify(
                                Mdi.briefcase,
                                size: 26,
                              ),
                        if (_hasUberOne == true)
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: Image.asset(
                              AssetNames.uberOneSmall,
                              width: 17,
                            ),
                          ),
                      ],
                    );
                  }),

              label: 'Account',
              //  'User',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getAccountStatus() async {
    Map<dynamic, dynamic>? userInfo =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    userInfo ??= await AppFunctions.getUserInfo();

    _hasUberOne = userInfo['hasUberOne'];
    _accountType = userInfo['type'];
  }
}
