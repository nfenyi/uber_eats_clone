import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavIndexNotifier extends StateNotifier<int> {
  BottomNavIndexNotifier() : super(0);

  void updateIndex(int step) {
    state = step;
  }

  void showGiftScreen() {
    state = 6;
  }

  void showGiftCategoryScreen() {
    state = 7;
  }

  void showGenericScreen() {
    state = 8;
  }

  void showBoxCateringScreen() {
    state = 9;
  }
}

final bottomNavIndexProvider =
    StateNotifierProvider<BottomNavIndexNotifier, int>(
  (ref) => BottomNavIndexNotifier(),
);

final categoryProvider = StateProvider<String?>((ref) {
  return null;
});
