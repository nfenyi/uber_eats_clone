import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

// final selectedLocationDescription = StateProvider<String>((ref) {
//   return 'retrieving location...';
// });

// final selectedLocationGeoPoint = StateProvider<GeoPoint?>((ref) {
//   return null;
// });

// final userCurrentLocation = StateProvider<LocationData?>((ref) {
//   return null;
// });

class UserCurrentLocationNotifier extends StateNotifier<LocationData?> {
  UserCurrentLocationNotifier() : super(null);

  Future<void> getCurrentGeoLocation() async {
    final location = Location();
    state = await location.getLocation();
  }
}

final userCurrentGeoLocationProvider =
    StateNotifierProvider<UserCurrentLocationNotifier, LocationData?>((ref) {
  return UserCurrentLocationNotifier();
});
