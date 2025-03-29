import 'dart:convert';
import 'dart:typed_data' show Uint8List;

import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/models/credit_card_details/credit_card_details_model.dart';
import 'package:uber_eats_clone/models/offer/offer_model.dart';
import 'package:uber_eats_clone/models/promotion/promotion_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
// import 'package:flutter/material.dart';

import 'hive_adapters/geopoint/geopoint_adapter.dart';
import 'main.dart';
import 'models/store/store_model.dart';
import 'presentation/constants/other_constants.dart';
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

  static Widget displayNetworkImage(String image,
      {double? width,
      double? height,
      BoxFit? fit,
      String placeholderAssetImage = AssetNames.aisleImage}) {
    if (image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: image,
        errorWidget: (context, url, error) {
          logger.d(error.toString());
          return Image.asset(
            placeholderAssetImage,
            width: width,
            height: height,
            fit: fit,
          );
        },
        width: width,
        placeholder: (context, url) => Image.asset(
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
          errorBuilder: (context, error, stackTrace) {
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
      logger.d('Invalid image source');
      return Image.asset(
        placeholderAssetImage,
        width: width,
        height: height,
        fit: fit,
      );
      // // Handle invalid image source (neither URL nor base64)
    }
  }

  static Future<Promotion> loadPromotionReference(
      DocumentReference reference) async {
    final promoJson = await loadDocReference(reference);

    return Promotion.fromJson(promoJson);
  }

  static Future<Map<dynamic, dynamic>> getUserInfo() async {
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
      for (DocumentReference groupOrder in userInfo['groupOrders']) {
        groupOrdersPaths.add(groupOrder.path);
      }

      userInfoForHiveBox['groupOrders'] = groupOrdersPaths;
    }
    List<String> redeemedPromoPaths = [];
    if (userInfo['redeemedPromos'] != null) {
      for (DocumentReference redeemedPromo in userInfo['redeemedPromos']) {
        redeemedPromoPaths.add(redeemedPromo.path);
      }

      userInfoForHiveBox['redeemedPromos'] = redeemedPromoPaths;
    }
    //adding display name
    userInfoForHiveBox['displayName'] =
        FirebaseAuth.instance.currentUser!.displayName;

    await Hive.box(AppBoxes.appState).put(BoxKeys.userInfo, userInfoForHiveBox);
    logger.d(userInfo);
    return userInfo;
  }

  static Future<void> addCreditCard(CreditCardDetails creditCardDetails) async {
    const storage = FlutterSecureStorage();
    Map<String, dynamic> creditCardJson = creditCardDetails.toJson();
    late final List<Map<String, dynamic>> newListToBeStored;
    String? anyOldExistingList = await storage.read(key: 'creditCard');
    if (anyOldExistingList == null) {
      newListToBeStored = [creditCardJson];
    } else {
      List<Map<String, dynamic>> oldList = json.decode(anyOldExistingList);
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
}
