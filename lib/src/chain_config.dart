import 'dart:typed_data';

/// A SummerCash chain config.
class ChainConfig {
  /// Alloc.
  Map<String, double> _alloc;

  /// Alloc members.
  List<Uint8List> _allocAddresses;

  /// Inflation rate.
  double _inflationRate;

  /// Network ID.
  int _networkID;

  /// Chain ID.
  Uint8List _chainID;

  /// Chain version.
  String _chainVersion;

  /// Initialize a new ChainConfig.
  ChainConfig(
      Map<String, double> alloc,
      List<Uint8List> allocAddresses,
      double inflationRate,
      int networkID,
      Uint8List chainID,
      String chainVersion) {
    this._alloc = alloc; // Set alloc
    this._allocAddresses = allocAddresses; // Set alloc members
    this._inflationRate = inflationRate; // Set inflation rate
    this._networkID = networkID; // Set network ID
    this._chainID = chainID; // Set chain ID
    this._chainVersion = chainVersion; // Set chain version
  }

  /// Alloc.
  Map<String, double> get alloc => _alloc;

  /// Alloc members.
  List<Uint8List> get allocAddresses => _allocAddresses;

  /// Inflation rate.
  double get inflationRate => _inflationRate;

  /// Network ID.
  int get networkID => _networkID;

  /// Chain ID.
  Uint8List get chainID => _chainID;

  /// Chain version.
  String get chainVersion => _chainVersion;
}
