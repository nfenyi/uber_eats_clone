import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../hive_adapters/cart_item/cart_item_model.dart';
import '../hive_adapters/country/country_ip_model.dart';
import '../models/user/user_model.dart';

class HiveServices {
  const HiveServices._();

  static final Box<dynamic> _appStateBox = Hive.box(_AppBoxes.appState);

  // static final ValueListenable appStateBoxListener =
  //     _appStateBox.listenable(keys: [BoxKeys.authenticated]);

  static bool get shouldShowGetStarted {
    return _appStateBox.get(_BoxKeys.showGetStarted, defaultValue: true);
  }

  static Future<void> hideGetStarted() async {
    await _appStateBox.put(_BoxKeys.showGetStarted, false);
  }

  static bool get userIsRegisteringWithEmail {
    return _appStateBox.get(_BoxKeys.signedInWithEmail) == true;
  }

  static ValueListenable<Box<dynamic>> get getAuthenticationListenable {
    return _appStateBox.listenable(keys: [_BoxKeys.authenticated]);
  }

  static bool get userAddedEmailToPhoneNumber {
    return _appStateBox.get(_BoxKeys.addedEmailToPhoneNumber) == true;
  }

  static bool get isUserAddressDetailsSaved {
    return _appStateBox.get(_BoxKeys.addressDetailsSaved) == true;
  }

  static bool get isUserAuthenticated {
    return _appStateBox.get(_BoxKeys.authenticated, defaultValue: false);
  }

  static Future<void> setAuthenticated(bool value) async {
    await _appStateBox.put(_BoxKeys.authenticated, value);
  }

  static Future<void> storeEmaiForRegistration(String email) async {
    await _appStateBox.put(_BoxKeys.email, email);
  }

  static HiveCountryResponse? get getCountry {
    return _appStateBox.get(_BoxKeys.country);
  }

  static Future<void> storeCountry(HiveCountryResponse country) async {
    return await _appStateBox.put(_BoxKeys.country, country);
  }

  static ValueListenable get userInfoListenable {
    return _appStateBox.listenable(keys: [_BoxKeys.userInfo]);
  }

  static Future<void> openBoxes() async {
    await Hive.openBox(_AppBoxes.appState);
    await Hive.openBox<String>(_AppBoxes.recentSearches);
    await Hive.openBox<HiveCartItem>(_AppBoxes.carts);
    await Hive.openBox<HiveCartProduct>(_AppBoxes.storedProducts);
  }

  static UserDetails? get getUserDetails {
    final userDetailsJson = _appStateBox.get(_BoxKeys.userInfo);
    if (userDetailsJson == null) return null;
    return UserDetails.fromJson(userDetailsJson);
  }
}

class _AppBoxes {
  static const String appState = 'app_state';
  static const String recentSearches = 'recent_searches';
  static const String carts = 'cart';

  static const String storedProducts = 'stored_products';
  // static const String groupOrder = 'group_orders';

  const _AppBoxes._();
}

class _BoxKeys {
  static const String signedInWithEmail = 'signedInWithEmail';
  static const String addedEmailToPhoneNumber = 'addedEmailToPhoneNumber';
  static const String authenticated = 'authenticated';
  static const String addressDetailsSaved = 'addressDetailsSaved';
  static const String email = 'email';
  static const String showGetStarted = 'showGetStarted';
  static const String onboarded = 'onboarded';
  static const String country = 'country';
  static const String userInfo = 'userInfo';
  static const String activatedPromoId = 'activatedPromoPath';
  static const String recentlyViewed = 'recentlyViewed';
  static const String firstTimeSendingGift = 'firstTimeSendingGift';
  static const String firstTimeAddingTeen = 'firstTimeAddingTeen';

  static const String isOnboardedToUberGifts = 'isOnboardedToUberGifts';
  static const String creditCardInUse = 'creditCardInUse';

  static const String newGiftCardId = 'newGiftCardId';

  const _BoxKeys._();
}
