class ServiceResponse {
  final Result response;
  final dynamic payload;

  ServiceResponse({required this.response, this.payload});
}

enum Result { success, failure, aborted }
