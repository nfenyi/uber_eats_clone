import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:uber_eats_clone/presentation/features/grocery_shop/screens/aisles_screen.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import '../../grocery_shop/screens/grocery_shop_screen.dart';
import '../../grocery_store/state/grocery_store_bottom_nav_index_provider.dart';
import '../../home/home_screen.dart';

class GroceryStoreMainScreen extends ConsumerStatefulWidget {
  final Store groceryStore;
  const GroceryStoreMainScreen(this.groceryStore, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroceryStoreMainScreenState();
}

class _GroceryStoreMainScreenState
    extends ConsumerState<GroceryStoreMainScreen> {
  late final Store _groceryStore;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _groceryStore = widget.groceryStore;
    _screens = [
      GroceryShopScreen(
        groceryStore: _groceryStore,
      ),
      AislesScreen(
        groceryStore: _groceryStore,
      ),
      Container(),
      // OrderAgainScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final int bottomNavIndex = ref.watch(groceryStoreBottomNavIndexProvider);
    return Scaffold(
      body: _screens[bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(groceryStoreBottomNavIndexProvider),
        onTap: (value) {
          final previousIndex = ref.read(groceryStoreBottomNavIndexProvider);

          if (value != previousIndex) {
            ref
                .read(groceryStoreBottomNavIndexProvider.notifier)
                .updateIndex(value);
          }
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
        items: const [
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.store,
                size: 27,
                // color: AppColors.primary,
              ),
              icon: Icon(
                Icons.store_outlined,
                size: 27,
                // color: Colors.transparent,
              ),
              label: 'Shop'
              // 'Home',
              ),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.list,
                size: 27,
                // color: AppColors.primary,
              ),
              icon: Icon(
                Icons.list_outlined,
                size: 27,
                // color: Colors.transparent,
              ),
              label: 'Aisles'
              // 'Home',
              ),
          BottomNavigationBarItem(
              activeIcon: Iconify(Ph.tag_fill),
              icon: Iconify(Ph.tag_light),
              label: 'Deals'
              // 'Home',
              ),
          // BottomNavigationBarItem(
          //     activeIcon: Icon(
          //       Icons.repeat,
          //       size: 27,
          //       // color: AppColors.primary,
          //     ),
          //     icon: Icon(
          //       Icons.repeat_outlined,
          //       size: 27,
          //       // color: Colors.transparent,
          //     ),
          //     label: 'Order Again'
          //     // 'Home',
          //     ),
        ],
      ),
    );
  }
}
