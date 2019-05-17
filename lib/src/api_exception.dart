/// An exception that occurs in the scope of the summercash.dart API.
class APIException implements Exception {
  /// Exception cause.
  String cause;

  /// Initialize a new APIException.
  APIException(this.cause);
}
