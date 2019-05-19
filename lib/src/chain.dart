import 'dart:typed_data';

import 'package:summercash/src/transaction.dart';

/// A chain on the SummerCash network.
class Chain {
  /// Chain account.
  Uint8List _account;

  /// Chain transactions.
  List<Transaction> _transactions;

  /// Genesis transaction.
  Uint8List _genesis;
}
