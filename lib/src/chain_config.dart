/// A SummerCash chain config.
class ChainConfig {
  /// Alloc.
  Map<String, double> _alloc;

  /// Inflation rate.
  double _inflationRate;

  /// Network ID.
  int _networkID;

  /// Initialize a new ChainConfig.
  ChainConfig(
    Map<String, double> alloc,
    double inflationRate,
    int networkID,
  ) {
    this._alloc = alloc; // Set alloc
    this._inflationRate = inflationRate; // Set inflation rate
    this._networkID = networkID; // Set network ID
  }

  /// Alloc.
  Map<String, double> get alloc => _alloc;

  /// Inflation rate.
  double get inflationRate => _inflationRate;

  /// Network ID.
  int get networkID => _networkID;
}
