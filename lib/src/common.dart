/// API abstractions for the common package.
class Common {
  /// Node https API endpoint.
  String _endpoint;

  /// Initialize an instance of the common API.
  Common(String endpoint) {
    this._endpoint = endpoint; // Set endpoint
  }

  /// Get API endpoint.
  String get endpoint => _endpoint;
}
