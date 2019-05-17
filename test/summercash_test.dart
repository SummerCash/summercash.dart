import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:summercash/src/common.dart';

void main() {
  group('common tests', () {
    Common common =
        new Common('https://localhost:8080'); // Initialize common API

    test('encoded test value should match runtime value', () async {
      expect(
          await common.encode(new Uint8List.fromList('test'.codeUnits)),
          equals(new Uint8List.fromList(
              '0x74657374'.codeUnits))); // Test encode functionality
    });

    test('encoded string test value should match runtime value', () async {
      expect(
          await common.encodeString(new Uint8List.fromList('test'.codeUnits)),
          equals('0x74657374')); // Test encode functionality
    });

    test('decoded test value should match runtime value', () async {
      expect(
          await common.decode(new Uint8List.fromList('0x74657374'.codeUnits)),
          equals(new Uint8List.fromList(
              [116, 101, 115, 116]))); // Test encode functionality
    });

    test('decoded string test value should match runtime value', () async {
      expect(
          await common.decodeString('0x74657374'),
          equals(new Uint8List.fromList(
              [116, 101, 115, 116]))); // Test encode functionality

      common.destroy(); // Destroy common
    });
  });
}
