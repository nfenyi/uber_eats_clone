import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:uber_eats_clone/presentation/features/grocery/screens/grocery_screen.dart';
import 'package:uber_eats_clone/presentation/features/home/home_screen.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import '../state/bottom_nav_index_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const GroceryScreen(),
    Container(),
    Container(),
    Container()
  ];

  @override
  Widget build(BuildContext context) {
    final int bottomNavIndex = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      body: _screens[bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(bottomNavIndexProvider),
        onTap: (value) {
          final previousIndex = ref.read(bottomNavIndexProvider);

          if (value != previousIndex) {
            ref.read(bottomNavIndexProvider.notifier).updateIndex(value);
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
          BottomNavigationBarItem(
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
          BottomNavigationBarItem(
            icon: Iconify(
              MaterialSymbols.manage_search_rounded,
              color: AppColors.neutral500,
              size: 27,
            ),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            activeIcon:
                Badge(child: Iconify(MaterialSymbols.shopping_cart_rounded)),
            icon: Badge(
                child: Iconify(
              MaterialSymbols.shopping_cart_outline_rounded,
              color: AppColors.neutral500,
            )),
            label: 'Carts',
            // 'Budgets',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.person,
              // color: AppColors.primary,
              size: 27,
            ),
            icon: Icon(Icons.person_outline),
            label: 'Account',
            //  'User',
          ),
        ],
      ),
    );
  }
}
