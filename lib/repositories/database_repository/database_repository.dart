import '../../utils/repository_result.dart';

abstract class DatabaseRepository {
  Future<RepositoryResult> get userDetails;
}
