import 'package:uber_eats_clone/services/firebase_auth_services.dart';
import 'package:uber_eats_clone/services/firestore_services.dart';
import 'package:uber_eats_clone/utils/operation_response.dart';

import 'database_repository.dart';

class DatabaseRepositoryRemote extends DatabaseRepository {
  @override
  Future<OperationResponse> get userDetails async {
    return await FirestoreServices.getUserDetails(FirebaseAuthServices.userId!);
  }
}
