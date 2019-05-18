import 'dart:typed_data';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:summercash/src/account.dart';
import 'package:summercash/src/api_exception.dart';
import 'dart:convert';
import 'package:convert/convert.dart';

import 'package:summercash/summercash.dart';

/// API abstractions for the accoqnts package.
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

  /// Initialize a new account.
  Future<Account> newAccount() async {
    final response = await _client.post(methodEndpoint('NewAccount'),
        body: json.encode({}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded =
        json.decode(response.body.replaceFirst('\n', '')); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    final Account account = new Account(
        Uint8List.fromList(hex.decode(jsonDecoded['message']
            .toString()
            .split('Address: ')[1]
            .split(',')[0]
            .split('0x')[1])),
        Uint8List.fromList(hex.decode(jsonDecoded['message']
            .toString()
            .split(', ')[1]
            .split('0x')[1]
            .toString()))); // Initialize account

    return account; // Return account
  }

  /// Initialize a new contract account.
  Future<Account> newContractAccount(
      String contractPath, Uint8List deployer) async {
    final response = await _client.post(methodEndpoint('NewContractAccount'),
        body: json.encode({
          'address': contractPath,
          'privateKey': '0x' + hex.encode(deployer)
        }),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded =
        json.decode(response.body.replaceFirst('\n', '')); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      print(jsonDecoded['msg']);
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    final Account account = new Account(
        Uint8List.fromList(hex.decode(jsonDecoded['message']
            .toString()
            .split('Address: ')[1]
            .split(',')[0]
            .split('0x')[1])),
        Uint8List.fromList(hex.decode(jsonDecoded['message']
            .toString()
            .split(', ')[1]
            .split('0x')[1]
            .toString()))); // Initialize account

    return account; // Return account
  }

  /// Parse a SummerCash account from a given private key.
  Future<Account> accountFromKey(Uint8List key) async {
    final encodedKey = '0x' + hex.encode(key); // Encode key to hex

    final response = await _client.post(methodEndpoint('AccountFromKey'),
        body: json.encode({'privateKey': encodedKey}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded =
        json.decode(response.body.replaceFirst('\n', '')); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    final Account account = new Account(
        Uint8List.fromList(
            hex.decode(jsonDecoded['message'].toString().split('0x')[1])),
        key); // Initialize account

    return account; // Return account
  }

  /// Walk keystore directory.
  Future<List<Account>> getAllAccounts() async {
    final response = await _client.post(methodEndpoint('GetAllAccounts'),
        body: json.encode({}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded =
        json.decode(response.body.replaceFirst('\n', '')); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    List<Account> accounts = new List<Account>(); // Declare account buffer

    final addresses = jsonDecoded['message']
        .toString()
        .split(', '); // Split into string addresses

    for (String address in addresses) {
      // Iterate through addresses
      accounts.add(await readAccountFromMemory(Uint8List.fromList(hex.decode(
          address.split('0x')[1])))); // Append account to list of accounts
    }

    return accounts; // Return accounts
  }

  /// Walk keystore directory contracts.
  Future<List<Account>> getAllContracts(Uint8List deployingAddress) async {
    final response = await _client.post(methodEndpoint('GetAllContracts'),
        body: json.encode({'address': '0x' + hex.encode(deployingAddress)}),
        headers: {
          'Content-Type': 'application/json'
        }); // Make post request, get response

    final jsonDecoded =
        json.decode(response.body.replaceFirst('\n', '')); // Decode JSON

    if (response.body.contains('"code":"internal"')) {
      // Check for errors
      throw new APIException(jsonDecoded['msg']); // Throw an API Exception
    }

    List<Account> accounts = new List<Account>(); // Declare account buffer

    final addresses = jsonDecoded['message']
        .toString()
        .replaceFirst('\n', '')
        .split(', '); // Split into string addresses

    for (String address in addresses) {
      // Iterate through addresses
      print(address);
      accounts.add(await readAccountFromMemory(Uint8List.fromList(hex.decode(
          address.split('0x')[1])))); // Append account to list of accounts
    }

    return accounts; // Return accounts
  }

  /// Read account from persistent memory.
  Future<Account> readAccountFromMemory(Uint8List address) async {
    final response = await _client.post(methodEndpoint('ReadAccountFromMemory'),
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

    final Account account = new Account(
        Uint8List.fromList(hex.decode(jsonDecoded['message']
            .toString()
            .split('Address: ')[1]
            .split(',')[0]
            .split('0x')[1])),
        Uint8List.fromList(hex.decode(jsonDecoded['message']
            .toString()
            .split(', ')[1]
            .split('0x')[1]
            .toString()))); // Initialize account

    return account; // Return account
  }
}
