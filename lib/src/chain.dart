import 'dart:typed_data';
import 'package:convert/convert.dart';

/// A chain on the SummerCash network.
class Chain {
  /// Chain account.
  Uint8List _account;

  /// Chain transactions.
  List<dynamic> _transactions;

  /// Genesis transaction.
  Uint8List _genesis;

  /// Contract source.
  Uint8List _contractSource;

  /// Network ID (mainnet: 0, testnet: 1, etc...).
  int _networkID;

  /// Chain ID.
  Uint8List _id;

  Chain(Uint8List account, List<dynamic> transactions, Uint8List genesis,
      Uint8List contractSource, int networkID, Uint8List id) {
    this._account = account; // Set account
    this._transactions = transactions; // Set transaction
    this._genesis = genesis; // Set genesis
    this._contractSource = contractSource; // Set contract source
    this._networkID = networkID; // Set network ID
    this._id = id; // Set chain ID
  }

  /// Chain account (address).
  Uint8List get account => _account;

  /// Chain transactions.
  List<dynamic> get transactions => _transactions;

  /// Chain genesis.
  Uint8List get genesis => _genesis;

  /// Contract source.
  Uint8List get contractSource => _contractSource;

  /// Network ID (mainnet: 0, testnet: 1, etc...).
  int get networkID => _networkID;

  /// Chain ID.
  Uint8List get id => _id;

  /// Number of transactions in chain.
  int get numTransactions => _transactions.length;

  /// Search the working chain for a given hash.
  dynamic queryTransaction(Uint8List hash) {
    for (dynamic transaction in _transactions) {
      // Iterate through transactions
      if (hex.encode(new List<int>.from(transaction['hash'])) ==
          hex.encode(hash)) {
        // Check matching hash
        return transaction; // Return tx
      }
    }

    return null; // No tx found
  }
}
