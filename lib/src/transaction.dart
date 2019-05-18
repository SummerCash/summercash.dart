import 'dart:ffi';
import 'dart:typed_data';

/// A transaction on the SummerCash network.
///
///
/// Used to simplify references to parsed node JSON data.
class Transaction {
  /// Account nonce.
  Uint64 accountNonce;

  /// Hash nonce.
  Uint64 hashNonce;

  /// Transaction sender.
  Uint8List sender;

  /// Transaction recipient.
  Uint8List recipient;

  /// Transaction amount.
  Double amount;

  /// Transaction payload.
  Uint8List payload;

  /// Transaction signature.
  dynamic signature;

  /// Parent transaction hash.
  Uint8List parentTransaction;

  /// Transaction timestmap.
  DateTime timestamp;

  /// Deployed contract instance address (if applicable).
  Uint8List deployedContract;

  /// Does deploy a smart contract.
  bool isContractDeploy;

  /// Is a genesis tx.
  bool isGenesis;

  /// Transaction state.
  dynamic state;

  /// Transaction logs.
  dynamic logs;

  /// Transaction hash.
  Uint8List hash;
}
