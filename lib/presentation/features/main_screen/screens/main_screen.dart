import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/favourite/favourite_model.dart';
import 'package:uber_eats_clone/models/store/store_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/account_screen.dart';
import 'package:uber_eats_clone/presentation/features/box_catering/screens/box_catering_screens.dart';
import 'package:uber_eats_clone/presentation/features/explore/screens/explore_screen.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/carts_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_category_screen.dart';
import 'package:uber_eats_clone/presentation/features/grocery/screens/grocery_screen.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';
import 'package:uber_eats_clone/state/shops_state_stream_provider.dart';

import '../../../../hive_adapters/cart_item/cart_item_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import '../../../services/sign_in_view_model.dart';
import '../../alcohol/alcohol_screen.dart';
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
    const ExploreScreen(),
    const CartsScreen(),
    const AccountScreen()
  ];

  @override
  void initState() {
    super.initState();

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
          final uri = Uri.parse(dynamicLinkData.link.toString());
          var giftCardId = uri.queryParameters['id'];
          logger.d(giftCardId);
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
      if (Hive.box(AppBoxes.appState).get(BoxKeys.newGiftCardId) != null) {
        await navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => RedeemGiftCardScreen(
              newGiftCardId:
                  Hive.box(AppBoxes.appState).get(BoxKeys.newGiftCardId)),
        ));

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
                    : bottomNavIndex == 8
                        ? const PharmacyScreen()
                        : bottomNavIndex == 9
                            ? const BoxCateringScreen()
                            : const AlcoholScreen(),
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
            BottomNavigationBarItem(
              activeIcon: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<HiveCartItem>(AppBoxes.carts).listenable(),
                  builder: (context, value, child) {
                    return value.length == 0
                        ? const Iconify(MaterialSymbols.shopping_cart_rounded)
                        : Badge(
                            label: AppText(text: value.length.toString()),
                            child: const Iconify(
                              MaterialSymbols.shopping_cart_rounded,
                            ));
                  }),
              icon: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<HiveCartItem>(AppBoxes.carts).listenable(),
                  builder: (context, value, child) {
                    return value.length == 0
                        ? const Iconify(
                            MaterialSymbols.shopping_cart_outline_rounded,
                            color: AppColors.neutral500,
                          )
                        : Badge(
                            label: AppText(text: value.length.toString()),
                            child: const Iconify(
                              MaterialSymbols.shopping_cart_outline_rounded,
                              color: AppColors.neutral500,
                            ));
                  }),
              label: 'Carts',
              // 'Budgets',
            ),
            BottomNavigationBarItem(
              activeIcon: ValueListenableBuilder(
                  valueListenable: Hive.box(AppBoxes.appState)
                      .listenable(keys: [BoxKeys.userInfo]),
                  builder: (context, appStateBox, child) {
                    final userInfo = appStateBox.get(BoxKeys.userInfo);
                    final accountType = userInfo['type'];
                    final hasUberOne = userInfo['uberOneStatus']['hasUberOne'];

                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        accountType == 'Personal'
                            ? const Icon(
                                Icons.person,
                                // color: AppColors.primary,
                                size: 27,
                              )
                            : const Iconify(
                                Mdi.briefcase,
                                size: 24,
                              ),
                        if (hasUberOne == true)
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
                  builder: (context, appStateBox, child) {
                    final userInfo = appStateBox.get(BoxKeys.userInfo);
                    final accountType = userInfo['type'];
                    final hasUberOne = userInfo['uberOneStatus']['hasUberOne'];
                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        accountType == 'Personal'
                            ? const Icon(
                                Icons.person,
                                size: 27,
                              )
                            : const Iconify(
                                Mdi.briefcase,
                                size: 24,
                                color: AppColors.neutral500,
                              ),
                        if (hasUberOne == true)
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
}
