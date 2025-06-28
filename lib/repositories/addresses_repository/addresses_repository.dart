import 'package:flutter/foundation.dart';
import 'package:location/location.dart' show LocationData;
import 'package:uber_eats_clone/models/user/user_model.dart';

import '../../models/google_location/google_location_model.dart';
import '../../utils/result.dart';

abstract class AddressesRepository {
  Future<Result<List<Prediction>?>> fetchPredictions(
      String query, LocationData? location);

  ValueListenable getUserInfoListenable();
  UserDetails? getHiveUserDetails();
}
