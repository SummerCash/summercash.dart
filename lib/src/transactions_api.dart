import 'package:summercash/src/api_exception.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:convert/convert.dart';

/// API abstractions for the types:transaction package.
class TransactionsAPI {
  /// Base node http API endpoint (does not include package in path).
  String _baseEndpoint;

  /// Node http API endpoint.
  String _endpoint;

  /// API gateway HTTP client.
  IOClient _client;

  /// Initialize a new TransactionAPI instance.
  TransactionsAPI(String endpoint) {
    var wrapped = new HttpClient(); // Initialize HTTP client
    wrapped.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            true; // Skip verify certificate

    this._client = new IOClient(wrapped); // Set HTTP client
    this._baseEndpoint = endpoint; // Set base endpoint
    this._endpoint =
        endpoint + '/twirp/transaction.Transaction'; // Set endpoint
  }

  /// Destroy transaction API client.
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

  /// Initialize a new transaction with the given nonce, sender, recipient, amount, and payload.
  Future<Uint8List> newTransaction(int nonce, Uint8List sender,
      Uint8List recipient, double amount, Uint8List payload) async {
    final response = await _client.post(methodEndpoint('NewTransaction'),
        body: json.encode({
          'nonce': nonce,
          'address': '0x' + hex.encode(sender),
          'address2': '0x' + hex.encode(recipient),
          'amount': amount,
          'payload': new Base64Codec().encode(payload)
        }),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    return hex.decode(jsonDecoded['message']
        .toString()
        .replaceFirst('\n', '')
        .split('0x')[1]); // Return tx
  }

  /// Publish a given transaction.
  Future publishTransaction(Uint8List transactionHash) async {
    final response = await _client.post(methodEndpoint('Publish'),
        body: json.encode({
          'address': '0x' + hex.encode(transactionHash),
        }),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }
  }

  /// Sign a transaction corresponding to the given transaction has via ECDSA.
  Future signTransaction(Uint8List transactionHash) async {
    final response = await _client.post(methodEndpoint('SignTransaction'),
        body: json.encode({
          'address': '0x' + hex.encode(transactionHash),
        }),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }
  }

  /// Verify the contents of a given transaction's ECDSA hash.
  Future<bool> verifyTransactionSignature(Uint8List transactionHash) async {
    final response = await _client.post(
        methodEndpoint('VerifyTransactionSignature'),
        body: json.encode({
          'address': '0x' + hex.encode(transactionHash),
        }),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded = json.decode(response.body); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    switch (jsonDecoded['message'].toString().replaceAll('\n', '')) {
      // Handle values
      case "true":
        return true; // Valid
      default:
        return false; // Invalid
    }
  }
}
