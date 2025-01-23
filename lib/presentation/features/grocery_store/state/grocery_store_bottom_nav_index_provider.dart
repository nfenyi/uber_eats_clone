import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroceryStoreBottomNavIndexNotifier extends StateNotifier<int> {
  GroceryStoreBottomNavIndexNotifier() : super(0);

  void updateIndex(int step) {
    state = step;
  }
}

final groceryStoreBottomNavIndexProvider =
    StateNotifierProvider<GroceryStoreBottomNavIndexNotifier, int>(
  (ref) => GroceryStoreBottomNavIndexNotifier(),
);
