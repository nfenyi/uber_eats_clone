class ServiceResponse {
  final Result response;
  final dynamic payload;

  ServiceResponse({required this.response, required this.payload});
}

enum Result { success, failure, aborted }
