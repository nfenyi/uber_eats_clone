import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_eats_clone/models/user/user_model.dart';
import 'package:uber_eats_clone/services/service_exceptions.dart';
import 'package:uber_eats_clone/utils/firestore_constants.dart';

import '../models/device_info/device_info_model.dart';
import '../utils/result.dart';

class FirestoreServices {
  const FirestoreServices._();
  static Future<Result<Map<String, dynamic>>> _getDocument(
      String collectionName, String docId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docId)
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        return Result.ok(snapshot.data()!);
      } else {
        return Result.error(NoDataFoundException());
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result> storeDeviceInfo(
      String deviceId, Map<String, dynamic> info) async {
    try {
      final userId = info.keys.first;
      final deviceRef = FirebaseFirestore.instance
          .collection(FirestoreCollections.devices)
          .doc(deviceId);
      final deviceSnapshot = await deviceRef.get();
      //true if a user signs in with a foreign phone
      if (!deviceSnapshot.exists) {
        await deviceRef.set(info);
      } else {
        if (deviceSnapshot[userId] == null) {
          await deviceRef.update(info);
        }
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<UserDetails>> getUserDetails(String userId) async {
    final result = await _getDocument(FirestoreCollections.users, userId);
    if (result is RError) {
      return Result.error((result as RError).errorMessage);
    }
    return Result.ok(UserDetails.fromJson((result as Ok).value));
  }

  static Future<Result<Map<String, DeviceUserInfo>>> getDevicesInfo(
      String deviceId) async {
    final result = await _getDocument(FirestoreCollections.devices, deviceId);
    if (result is RError) {
      return Result.error((result as RError).errorMessage);
    }
    result as Ok<Map<String, Map<String, String>>>;
    final devicesUsed = <String, DeviceUserInfo>{};
    for (var i = 0; i < result.value.length; i++) {
      devicesUsed[result.value.keys.elementAt(i)] =
          DeviceUserInfo.fromJson(result.value.values.elementAt(i));
    }

    return Result.ok(devicesUsed);
  }
}
