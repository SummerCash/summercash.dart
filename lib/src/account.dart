import 'dart:typed_data';

/// Abstractions for the standard accounts API response mapping.
class Account {
  /// Account address.
  Uint8List _address;

  /// Account private key.
  Uint8List _privateKey;

  Account(Uint8List address, Uint8List, privateKey) {
    this._address = address; // Set address
    this._privateKey = privateKey; // Set private key
  }

  /// Get address.
  Uint8List get address => _address;

  /// Get private key.
  Uint8List get privateKey => _privateKey;
}
