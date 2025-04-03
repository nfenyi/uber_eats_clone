import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_eats_clone/models/favourite/favourite_model.dart';
import 'package:uber_eats_clone/models/store/store_model.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

// class ShopsNotifier extends StreamNotifier<List<Store>> {
//   @override
//   Stream<List<Store>> build() {
//     return FirebaseFirestore.instance
//         .collection(FirestoreCollections.stores)
//         .snapshots()
//         .map(
//           (event) => event.docs
//               .map(
//                 (docSnapshot) => Store.fromJson(docSnapshot.data()),
//               )
//               .toList(),
//         );
//   }
// }

final storesProvider = StreamProvider<List<Store>>((ref) {
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.stores)
      .snapshots()
      .map(
    (event) {
      return event.docs
          .map(
            (docSnapshot) => Store.fromJson(docSnapshot.data()),
          )
          .toList();
    },
  );
});

final favoriteStoresProvider = StreamProvider<List<FavouriteStore>>((ref) {
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.favoriteStores)
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((docSnapshot) => docSnapshot
          .data()!
          .entries
          .map(
            (mapEntry) => FavouriteStore.fromJson(mapEntry.value),
          )
          .toList());
});
