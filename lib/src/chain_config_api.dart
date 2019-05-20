import 'dart:io';
import 'package:http/io_client.dart';

/// API abstractions for the chain config package.
class ChainConfigAPI {
  /// Base node http API endpoint (does not include package in path).
  String _baseEndpoint;

  /// Node http API endpoint.
  String _endpoint;

  /// API gateway HTTP client.
  IOClient _client;

  /// Initialize an instance of the chain config API.
  ChainConfigAPI(String endpoint) {
    var wrapped = new HttpClient(); // Initialize HTTP client
    wrapped.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            true; // Skip verify certificate

    this._client = new IOClient(wrapped); // Set HTTP client
    this._baseEndpoint = endpoint; // Set base endpoint
    this._endpoint = endpoint + '/twirp/common.Common'; // Set endpoint
  }

  /// Destroy chain config API client.
  void destroy() {
    _client.close(); // Close client
  }

  /// Base API endpoint.
  String get baseEndpoint => _baseEndpoint;

  /// API endpoint.
  String get endpoint => _endpoint;

  /// Get method endpoint.
  String methodEndpoint(String method) {
    return _endpoint +
        '/${method[0].toUpperCase()}${method.substring(1)}'; // Return method endpoint
  }
}
