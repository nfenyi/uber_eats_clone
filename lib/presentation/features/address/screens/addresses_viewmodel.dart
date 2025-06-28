import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:uber_eats_clone/models/user/user_model.dart';

import '../../../../models/google_location/google_location_model.dart';
import '../../../../repositories/addresses_repository/addresses_repository_remote.dart';
import '../../../../utils/result.dart';

class AddressesViewmodel extends StateNotifier<_AddressesViewmodelState> {
  AddressesViewmodel() : super(_AddressesViewmodelState());

  final _addressRepository = AddressesRepositoryRemote();

  Future<Result<List<Prediction>?>> fetchPredictions(
      String query, LocationData? location) async {
    return await _addressRepository.fetchPredictions(query, location);
  }

  ValueListenable getUserInfoListenable() {
    return _addressRepository.getUserInfoListenable();
  }

  UserDetails? getUserInfo() {
    return _addressRepository.getHiveUserDetails();
  }
}

final addressesViewmodel =
    StateNotifierProvider<AddressesViewmodel, _AddressesViewmodelState>((ref) {
  return AddressesViewmodel();
});

class _AddressesViewmodelState {}
