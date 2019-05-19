import 'dart:typed_data';
import 'package:summercash/src/api_exception.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:convert';

/// API abstractions for the common package.
class CommonAPI {
  /// Base node http API endpoint (does not include package in path).
  String _baseEndpoint;

  /// Node http API endpoint.
  String _endpoint;

  /// API gateway HTTP client.
  IOClient _client;

  /// Initialize an instance of the common API.
  CommonAPI(String endpoint) {
    var wrapped = new HttpClient(); // Initialize HTTP client
    wrapped.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            true; // Skip verify certificate

    this._client = new IOClient(wrapped); // Set HTTP client
    this._baseEndpoint = endpoint; // Set base endpoint
    this._endpoint = endpoint + '/twirp/common.Common'; // Set endpoint
  }

  /// Destroy common API client.
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

  /// Encode given byte array to hex-formatted, MemPrefix-compliant byte array.
  Future<Uint8List> encode(Uint8List b) async {
    final response = await _client.post(methodEndpoint('Encode'),
        body: json.encode({'input': new Base64Codec().encode(b)}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    final stringEncoded =
        jsonDecoded['message'].toString().replaceFirst('\n', ''); // Remove \n

    return new Uint8List.fromList(
        stringEncoded.codeUnits); // Encode to byte array
  }

  /// Encode given byte array to hex-formatted, MemPrefix-compliant string.
  Future<String> encodeString(Uint8List b) async {
    final response = await _client.post(methodEndpoint('EncodeString'),
        body: json.encode({'input': new Base64Codec().encode(b)}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    return jsonDecoded['message']
        .toString()
        .replaceFirst('\n', ''); // Remove \n
  }

  /// Decode given hex-formatted byte array to standard byte array.
  Future<Uint8List> decode(Uint8List b) async {
    final response = await _client.post(methodEndpoint('Decode'),
        body: json.encode({'input': new Base64Codec().encode(b)}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    final stringEncoded =
        jsonDecoded['message'].toString().replaceFirst('\n', ''); // Remove \n

    return new Uint8List.fromList(
        stringEncoded.codeUnits); // Encode to byte array
  }

  Future<Uint8List> decodeString(String s) async {
    final response = await _client.post(methodEndpoint('DecodeString'),
        body: json.encode({'s': s}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    final stringEncoded =
        jsonDecoded['message'].toString().replaceFirst('\n', ''); // Remove \n

    return new Uint8List.fromList(
        stringEncoded.codeUnits); // Encode to byte array
  }
}
