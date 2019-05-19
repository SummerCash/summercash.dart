import 'dart:typed_data';

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
}
