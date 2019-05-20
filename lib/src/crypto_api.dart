import 'package:http/io_client.dart';
import 'dart:io';
import 'package:summercash/src/api_exception.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';

/// API abstractions for the crypto package.
class CryptoAPI {
  /// Base node http API endpoint (does not include package in path).
  String _baseEndpoint;

  /// Node http API endpoint.
  String _endpoint;

  /// API gateway HTTP client.
  IOClient _client;

  /// Initialize a new CryptoAPI instance.
  CryptoAPI(String endpoint) {
    var wrapped = new HttpClient(); // Initialize HTTP client
    wrapped.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            true; // Skip verify certificate

    this._client = new IOClient(wrapped); // Set HTTP client
    this._baseEndpoint = endpoint; // Set base endpoint
    this._endpoint = endpoint + '/twirp/crypto.Crypto'; // Set endpoint
  }

  /// Destroy crypto API client.
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

  /// Hash specified byte array.
  Future<Uint8List> sha3(Uint8List b) async {
    final response = await _client.post(methodEndpoint('Sha3'),
        body: json.encode({'b': new Base64Codec().encode(b)}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    return hex.decode(
        jsonDecoded['message'].toString().replaceAll('\n', '')); // Remove \n
  }

  /// Hash specified byte array to a string.
  Future<String> sha3String(Uint8List b) async {
    final response = await _client.post(methodEndpoint('Sha3String'),
        body: json.encode({'b': new Base64Codec().encode(b)}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    return jsonDecoded['message'].toString().replaceAll('\n', ''); // Remove \n
  }
}
