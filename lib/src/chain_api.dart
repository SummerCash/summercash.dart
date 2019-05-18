import 'dart:ffi';
import 'dart:typed_data';
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:convert';
import 'package:summercash/src/api_exception.dart';
import 'package:convert/convert.dart';
import 'dart:core';

/// API abstractions for the chain package.
class Chain {
  /// Base node http API endpoint (does not include package in path).
  String _baseEndpoint;

  /// Node http API endpoint.
  String _endpoint;

  /// API gateway HTTP client.
  IOClient _client;

  /// Initialize an instance of the chain API.
  Chain(String endpoint) {
    var wrapped = new HttpClient(); // Initialize HTTP client
    wrapped.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            true; // Skip verify certificate

    this._client = new IOClient(wrapped); // Set HTTP client
    this._baseEndpoint = endpoint; // Set base endpoint
    this._endpoint = endpoint + '/twirp/chain.Chain'; // Set endpoint
  }

  /// Destroy chain API client.
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

  /// Calculate account chain balance.
  Future<double> getBalance(Uint8List address) async {
    final response = await _client.post(methodEndpoint('GetBalance'),
        body: json.encode({'address': '0x' + hex.encode(address)}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded =
        json.decode(response.body.replaceFirst('\n', '')); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    final parsed = double.parse(jsonDecoded['message']
        .toString()
        .replaceAll('\n', '')
        .split('balance: ')[1]); // Parse balance

    return parsed; // Return balance
  }
}
