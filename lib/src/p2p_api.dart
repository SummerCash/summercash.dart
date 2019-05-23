import 'dart:io';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'package:summercash/src/api_exception.dart';

/// API abstractions for the p2p package.
class P2PAPI {
  /// Base node http API endpoint (does not include package in path).
  String _baseEndpoint;

  /// Node http API endpoint.
  String _endpoint;

  /// API gateway HTTP client.
  IOClient _client;

  /// Initialize a new P2PAPI instance.
  P2PAPI(String endpoint) {
    var wrapped = new HttpClient(); // Initialize HTTP client
    wrapped.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            true; // Skip verify certificate

    this._client = new IOClient(wrapped); // Set HTTP client
    this._baseEndpoint = endpoint; // Set base endpoint
    this._endpoint = endpoint + '/twirp/p2p.P2P'; // Set endpoint
  }

  /// Destroy p2p API client.
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

  /// Request the number of connected peers from a local node.
  Future<int> numConnectedPeers() async {
    final response = await _client.post(methodEndpoint('NumConnectedPeers'),
        body: json.encode({}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    return int.parse(
        jsonDecoded['message'].toString().replaceAll('\n', '')); // Return num
  }

  /// Request a list of peers connected to the local node.
  Future<List<String>> connectedPeers() async {
    final response = await _client.post(methodEndpoint('ConnectedPeers'),
        body: json.encode({}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    return List<String>.from(jsonDecoded['message']
        .toString()
        .replaceFirst('\n', '')
        .split(', ')); // Return peers
  }

  /// Sync the working network.
  Future syncNetwork(String network) async {
    final response = await _client.post(methodEndpoint('SyncNetwork'),
        body: json.encode({'network': network}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }
  }
}
