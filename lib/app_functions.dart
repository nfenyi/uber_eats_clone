import 'dart:convert';
import 'dart:typed_data' show Uint8List;

import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uber_eats_clone/models/credit_card_details/credit_card_details_model.dart';
import 'package:uber_eats_clone/models/gift_card_category_model.dart';
import 'package:uber_eats_clone/models/group_order/group_order_model.dart';
import 'package:uber_eats_clone/models/offer/offer_model.dart';
import 'package:uber_eats_clone/models/order/order_model.dart';
import 'package:uber_eats_clone/models/promotion/promotion_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
// import 'package:flutter/material.dart';

import 'hive_adapters/geopoint/geopoint_adapter.dart';
import 'main.dart';
import 'models/advert/advert_model.dart';
import 'models/store/store_model.dart';
import 'presentation/constants/other_constants.dart';
import 'presentation/features/grocery_store/screens/screens/grocery_store_main_screen.dart';
import 'presentation/features/group_order/group_order_screen.dart';
import 'presentation/features/group_order/group_order_settings_screen.dart';
import 'presentation/features/store/store_screen.dart';
import 'presentation/services/sign_in_view_model.dart';

class AppFunctions {
  AppFunctions._();
  // static String formatTime(TimeOfDay time) {
  //   // final formattedHour = time.hourOfPeriod.toString().padLeft(2, '0');
  //   final formattedMinute = time.minute.toString().padLeft(2, '0');
  //   final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  //   return '${time.hourOfPeriod}:$formattedMinute $period';
  // }

  static String formatDate(String date, {String format = 'd/m/Y'}) {
    return date == OtherConstants.na || date == 'null' || date.isEmpty
        ? OtherConstants.na
        : date == '--'
            ? '--'
            : DateTimeFormat.format(DateTime.parse(date), format: format);
  }

  static Future<Map<String, dynamic>> loadDocReference(
      DocumentReference reference) async {
    final snapshot = await reference.get();

    return snapshot.data() as Map<String, dynamic>;
  }

  static Future<LocationData?> getUserCurrentLocation() async {
    final Location location = Location();

    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  // static DateTime? timestampToDateTime(dynamic value) {
  //   if (value is Timestamp) {
  //     return value.toDate();
  //   }
  //   return null;
  //   // // Handle cases where createdAt might already be a DateTime or null
  //   // return value is DateTime
  //   //     ? value
  //   //     : DateTime.now(); // Or handle null as needed
  // }

  static Future<List<Advert>> getGiftAdverts() async {
    final advertsSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.adverts)
        .get();
    final allAdverts = advertsSnapshot.docs.map(
      (snapshot) {
        return Advert.fromJson(snapshot.data());
      },
    );
    final giftAdverts = allAdverts
        .where(
          (element) => element.type.toLowerCase().contains('gift'),
        )
        .toList();
    giftAdverts.shuffle();

    return giftAdverts;
  }

  static Future<void> createGroupOrder(Store store) async {
    List<String> groupOrderIds =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo)['groupOrders'];
    var matchingGroupOrderIds = groupOrderIds.where(
      (element) => element.contains(store.id),
    );

    GroupOrder? orderCreatedByUser;
    for (var matchingOrder in matchingGroupOrderIds) {
      final ref = FirebaseFirestore.instance
          .collection(FirestoreCollections.groupOrders)
          .doc(matchingOrder);
      final groupOrder = await AppFunctions.loadGroupOrderReference(ref);
      if (groupOrder.ownerId == FirebaseAuth.instance.currentUser!.uid) {
        orderCreatedByUser = groupOrder;
        break;
      }
    }

    if (orderCreatedByUser == null) {
      await showModalBottomSheet(
          isScrollControlled: true,
          useSafeArea: true,
          barrierColor: Colors.transparent,
          context: navigatorKey.currentContext!,
          builder: (context) => ShowCaseWidget(builder: (context) {
                return GroupOrderSettingsScreen(store: store);
              }));
    } else {
      await navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => ShowCaseWidget(builder: (context) {
                return GroupOrderScreen(
                    store: store, groupOrder: orderCreatedByUser!);
              })));
    }
  }

  static Future<void> navigateToStoreScreen(Store store,
      {bool increaseVisitCount = true}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.stores)
        .where('id', isEqualTo: store.id)
        .get();
    if (increaseVisitCount) {
      await querySnapshot.docs.first.reference
          .update({'visits': FieldValue.increment(1)});
    }
    await navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (context) {
        if (store.type.toLowerCase().contains('grocery')) {
          return GroceryStoreMainScreen(store);
        } else {
          return StoreScreen(
            store,
          );
        }
      },
    ));
  }

  static Future<List<GiftCardCategory>> getGiftCardCategories() async {
    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.giftCardCategories)
        .get();
    final giftCategories = categoriesSnapshot.docs.map(
      (snapshot) {
        return GiftCardCategory.fromJson(snapshot.data());
      },
    ).toList();

    return giftCategories;
  }

  static Future<GiftCardImage> getGiftCardImage(
      DocumentReference giftCardRef) async {
    final giftCardJson = await loadDocReference(giftCardRef);

    return GiftCardImage.fromJson(giftCardJson);
  }

  static Future<List<Advert>> getGiftCategoryAdverts(String type) async {
    final advertsSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.adverts)
        .get();
    final allAdverts = advertsSnapshot.docs.map(
      (snapshot) {
        return Advert.fromJson(snapshot.data());
      },
    );
    final giftAdverts = allAdverts
        .where(
          (element) => element.type.toLowerCase().contains(type.toLowerCase()),
        )
        .toList();
    giftAdverts.shuffle();
    // final allStoresSnapshot = await FirebaseFirestore.instance
    //     .collection(FirestoreCollections.stores)
    //     .get();
    // _allStores = allStoresSnapshot.docs.map(
    //   (snapshot) {
    //     return Store.fromJson(snapshot.data());
    //   },
    // ).toList();
    return giftAdverts;
  }

  static Future<List<Product>> fetchDeals(String storeId) async {
    final productsWithDeals = <Product>[];
    final discountedProducts = await FirebaseFirestore.instance
        .collection(FirestoreCollections.products)
        .where('stores', arrayContains: storeId)
        .where('promoPrice', isNotEqualTo: null)
        .get();

    final promoProducts = await FirebaseFirestore.instance
        .collection(FirestoreCollections.deals)
        .where('stores', arrayContains: storeId)
        .where('offer', isNotEqualTo: null)
        .get();
    for (var element in discountedProducts.docs) {
      productsWithDeals.add(Product.fromJson(element.data()));
    }

    for (var element in promoProducts.docs) {
      productsWithDeals.add(Product.fromJson(element.data()));
    }
    return productsWithDeals;
  }

  static Future<Product> loadProductReference(
      DocumentReference reference) async {
    final productJson = await loadDocReference(reference);

    return Product.fromJson(productJson);
  }

  static Future<Offer> loadOfferReference(DocumentReference reference) async {
    final offerJson = await loadDocReference(reference);

    return Offer.fromJson(offerJson);
  }

  static Future<Store> loadStoreReference(DocumentReference reference) async {
    final storeJson = await loadDocReference(reference);

    return Store.fromJson(storeJson);
  }

  static Future<OrderSchedule> loadOrderScheduleReference(
      DocumentReference reference) async {
    final orderScheduleJson = await loadDocReference(reference);

    return OrderSchedule.fromJson(orderScheduleJson);
  }

  static Future<GroupOrder> loadGroupOrderReference(
      DocumentReference reference) async {
    final groupOrderJson = await loadDocReference(reference);

    return GroupOrder.fromJson(groupOrderJson);
  }

  static Future<Promotion> loadPromoReference(
      DocumentReference reference) async {
    final promoJson = await loadDocReference(reference);

    return Promotion.fromJson(promoJson);
  }

  static Widget displayNetworkImage(String image,
      {double? width,
      double? height,
      BoxFit? fit,
      String? placeholderAssetImage}) {
    if (image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: image,
        errorWidget: placeholderAssetImage == null
            ? null
            : (context, url, error) {
                logger.d(error.toString());
                return Image.asset(
                  placeholderAssetImage,
                  width: width,
                  height: height,
                  fit: fit,
                );
              },
        width: width,
        placeholder: placeholderAssetImage == null
            ? null
            : (context, url) => Image.asset(
                  placeholderAssetImage,
                  width: width,
                  height: height,
                  fit: fit,
                ),
        height: height,
        fit: fit,
      );
    } else if (image.startsWith('data:image')) {
      // It's a base64 string
      try {
        String base64String = image.split(',').last;
        Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          width: width,
          height: height,
          errorBuilder: placeholderAssetImage == null
              ? null
              : (context, error, stackTrace) {
                  return Image.asset(
                    placeholderAssetImage,
                    width: width,
                    height: height,
                    fit: fit,
                  );
                },
          fit: fit,
          bytes,
        );
      } catch (e) {
        logger.d('Error decoding base64 image: $e');
        return const AppText(text: 'Error loading image');
      }
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: const AppText(text: 'Invalid image source'),
      );
      // // Handle invalid image source (neither URL nor base64)
    }
  }

  static Future<Promotion> loadPromotionReference(
      DocumentReference reference) async {
    final promoJson = await loadDocReference(reference);

    return Promotion.fromJson(promoJson);
  }

  static Future<Map<dynamic, dynamic>> getOnlineUserInfo() async {
    final userInfoSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic> userInfo = userInfoSnapshot.data()!;

    var userInfoForHiveBox = Map.from(userInfo);
    //changing latlng to a form that can be saved in hive box
    for (var address in userInfoForHiveBox['addresses']) {
      address['latlng'] = HiveGeoPoint(
          latitude: address['latlng'].latitude,
          longitude: address['latlng'].longitude);
    }

    userInfoForHiveBox['selectedAddress']['latlng'] = HiveGeoPoint(
        latitude: userInfo['selectedAddress']['latlng'].latitude,
        longitude: userInfo['selectedAddress']['latlng'].longitude);

    //storing document paths instead of document references
    List<String> groupOrdersPaths = [];
    if (userInfo['groupOrders'] != null) {
      for (String groupOrder in userInfo['groupOrders']) {
        groupOrdersPaths.add(groupOrder);
      }

      userInfoForHiveBox['groupOrders'] = groupOrdersPaths;
    }
    List<String> redeemedPromoIds = [];
    if (userInfo['redeemedPromos'] != null) {
      for (String redeemedPromoId in userInfo['redeemedPromos']) {
        redeemedPromoIds.add(redeemedPromoId);
      }

      userInfoForHiveBox['redeemedPromos'] = redeemedPromoIds;
    }
    //adding display name
    userInfoForHiveBox['displayName'] =
        FirebaseAuth.instance.currentUser!.displayName;
    await Hive.box(AppBoxes.appState).put(BoxKeys.userInfo, userInfoForHiveBox);
    // logger.d(userInfo);
    return userInfo;
  }

  static Future<void> addCreditCard(CreditCardDetails creditCardDetails) async {
    const storage = FlutterSecureStorage();

    Map<String, dynamic> creditCardJson = creditCardDetails.toJson();
    late final List<Map> newListToBeStored;
    String? anyOldExistingList = await storage.read(key: 'creditCard');
    if (anyOldExistingList == null) {
      newListToBeStored = [creditCardJson];
    } else {
      logger.d(json.decode(anyOldExistingList));
      List oldList = json.decode(anyOldExistingList);
      // logger.d(oldList);
      newListToBeStored = [creditCardJson, ...oldList];
    }
    String newEncodedList = json.encode(newListToBeStored);
    await storage.write(key: 'creditCard', value: newEncodedList);
  }

  static String formatPlaceDescription(String description) {
    var strings = description.split(', ');
    if (strings.length > 2) {
      if (strings.length == 3) {
        return '${strings[0]}, ${strings[1]}';
      } else if (strings.length == 4) {
        return '${strings[1]}, ${strings[2]}';
      } else {
        return '${strings[0]}, ${strings[1]}, ${strings[2]}';
      }
    } else {
      return description;
    }
  }

  static Future<List<CreditCardDetails>> getCreditCards() async {
    const storage = FlutterSecureStorage();
    String? encodedList = await storage.read(key: 'creditCard');
    if (encodedList == null) {
      return [];
    }
    List decodedList = json.decode(encodedList);
    final List<CreditCardDetails> storedCreditCards = [];
    for (var card in decodedList) {
      storedCreditCards.add(CreditCardDetails.fromJson(card));
    }
    return storedCreditCards;
  }

  static String getCreditCardName(List<CreditCardType> types) {
    if (types.isEmpty) {
      return 'N/A';
    } else {
      return types.first == CreditCardType.visa()
          ? 'Visa'
          : types.first == CreditCardType.americanExpress()
              ? 'American Express'
              : types.first == CreditCardType.discover()
                  ? 'Discover'
                  : 'Mastercard';
    }
  }

  static Future<List<IndividualOrder>> getAllIndividualOrders() async {
    List<IndividualOrder> individualOrders = [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.individualOrders)
        .where('userUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var element in querySnapshot.docs) {
      individualOrders.add(IndividualOrder.fromJson(element.data()));
    }
    return individualOrders;
  }

  static Future<IndividualOrder> getIndividualOrder(String id) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.individualOrders)
        .where('orderNumber', isEqualTo: id)
        .get();

    final docSnapshot = querySnapshot.docs.first;

    return IndividualOrder.fromJson(docSnapshot.data());
  }
}
