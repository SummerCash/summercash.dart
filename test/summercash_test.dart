import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:summercash/src/common.dart';

void main() {
  group('common tests', () {
    Common common =
        new Common('https://localhost:8080'); // Initialize common API

    test('encoded test value should match runtime-calculated value', () async {
      expect(
          await common.encode(new Uint8List.fromList('test'.codeUnits)),
          equals(new Uint8List.fromList(
              '0x74657374'.codeUnits))); // Test encode functionality
    });

    test('encoded string test value should match runtime-calculated value',
        () async {
      expect(
          await common.encodeString(new Uint8List.fromList('test'.codeUnits)),
          equals('0x74657374')); // Test encode functionality

      common.destroy(); // Destroy common
    });
  });
}
