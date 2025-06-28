import 'package:flutter/foundation.dart';
import 'package:uber_eats_clone/repositories/user_auth/user_auth_repository_remote.dart';
import 'package:uber_eats_clone/utils/result.dart';

class GetStartedViewModel extends ChangeNotifier {
  bool isLoading = false;
  final authRepo = UserAuthRepositoryRemote();
  Future<Result<void>> getStarted() async {
    isLoading = true;
    notifyListeners();

    final result = await authRepo.getStarted();
    if (result is RError) {
      isLoading = false;
      notifyListeners();
    }
    return result;
  }
}
