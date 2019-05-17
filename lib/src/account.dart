import 'dart:typed_data';
import 'dart:convert';
import 'package:convert/convert.dart';

/// Abstractions for the standard accounts API response mapping.
class Account {
  /// Account address.
  Uint8List _address;

  /// Account private key.
  Uint8List _privateKey;

  Account(Uint8List address, Uint8List privateKey) {
    this._address = address; // Set address
    this._privateKey = privateKey; // Set private key
  }

  /// Get address.
  Uint8List get address => _address;

  /// Get private key.
  Uint8List get privateKey => _privateKey;

  /// Get address hex value.
  String addressHex() {
    return '0x' + hex.encode(_address); // Return address string value
  }

  /// Get private key hex value.
  String privateKeyHex() {
    return '0x' + hex.encode(_privateKey); // Return privateKey string value
  }

  /// Get account string representation.
  String string() {
    JsonEncoder encoder =
        new JsonEncoder.withIndent('  '); // Initialize encoder

    Map json = {
      'address': addressHex(),
      'privateKey': privateKeyHex(),
    }; // Initialize JSON formatted value

    return encoder.convert(json); // Convert object
  }
}
