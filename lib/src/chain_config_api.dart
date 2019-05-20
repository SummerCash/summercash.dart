import 'dart:ffi';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:summercash/src/chain_config.dart';
import 'dart:convert';
import 'package:summercash/src/api_exception.dart';

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
    this._endpoint = endpoint + '/twirp/config.Config'; // Set endpoint
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

  /// Initialize a new chain config from a given genesis file.
  Future<ChainConfig> newChainConfig(String genesisPath) async {
    final response = await _client.post(methodEndpoint('NewChainConfig'),
        body: json.encode({'genesisPath': genesisPath}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded =
        json.decode(response.body.replaceFirst('\n', '')); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    final jsonChainConfig =
        json.decode(jsonDecoded['message']); // Decode message body

    var alloc = new Map<String, double>(); // Initialize alloc

    new Map<String, dynamic>.from(
            new Map<String, dynamic>.from(jsonChainConfig['alloc']))
        .forEach((element, value) =>
            alloc[element] = double.parse(value)); // Parse alloc

    return new ChainConfig(
        alloc,
        double.parse(jsonChainConfig['inflation'].toString()),
        jsonChainConfig['network']); // Return initialize chain config
  }

  /// Get total network supply.
  Future<BigInt> getTotalSupply(String genesisPath) async {
    final response = await _client.post(methodEndpoint('GetTotalSupply'),
        body: json.encode({'genesisPath': genesisPath}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded =
        json.decode(response.body.replaceFirst('\n', '')); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    final stringAmount =
        jsonDecoded['message'].toString().replaceAll('\n', ''); // Remove \n

    return BigInt.parse(stringAmount.split(".")[0]); // Parse amount
  }
}
