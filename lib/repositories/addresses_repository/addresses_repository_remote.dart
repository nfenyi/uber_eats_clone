import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:location/location.dart' show LocationData;
import 'package:uber_eats_clone/models/user/user_model.dart';
import 'package:uber_eats_clone/services/hive_services.dart';
import 'package:uber_eats_clone/utils/result.dart';

import '../../models/google_location/google_location_model.dart';
import '../../services/google_maps_services.dart';
import 'addresses_repository.dart';

class AddressesRepositoryRemote implements AddressesRepository {
  @override
  Future<Result<List<Prediction>?>> fetchPredictions(
      String query, LocationData? location) {
    return GoogleMapsServices.fetchPredictions(
        query: query, location: location);
  }

  @override
  ValueListenable getUserInfoListenable() {
    return HiveServices.userInfoListenable;
  }

  @override
  UserDetails? getHiveUserDetails() {
    return HiveServices.getUserDetails();
  }
}
