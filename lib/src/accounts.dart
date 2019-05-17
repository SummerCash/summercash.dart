import 'dart:io';
import 'package:http/io_client.dart';

/// API abstractions for the accounts package.
class Accounts {
  /// Base node http API endpoint (does not include package in path).
  String _baseEndpoint;

  /// Node http API endpoint.
  String _endpoint;

  /// API gateway HTTP client.
  IOClient _client;

  /// Initialize an instance of the common API.
  Accounts(String endpoint) {
    var wrapped = new HttpClient(); // Initialize HTTP client
    wrapped.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            true; // Skip verify certificate

    this._client = new IOClient(wrapped); // Set HTTP client
    this._baseEndpoint = endpoint; // Set base endpoint
    this._endpoint = endpoint + '/twirp/accounts.Accounts'; // Set endpoint
  }

  /// Destroy accounts API client.
  void destroy() {
    _client.close(); // Close client
  }

  /// Get base API endpoint.
  String get baseEndpoint => _baseEndpoint;

  /// Get API endpoint.
  String get endpoint => _endpoint;

  /// Get method endpoint.
  String methodEndpoint(String method) {
    return _endpoint +
        '/${method[0].toUpperCase()}${method.substring(1)}'; // Return method endpoint
  }
}
