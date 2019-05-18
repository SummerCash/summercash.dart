import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:summercash/src/common.dart';
import 'package:summercash/src/accounts.dart';

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

  group('account tests', () {
    Accounts accounts =
        new Accounts('https://localhost:8080'); // Initialize accounts API

    test('should create a new account', () async {
      await accounts.newAccount(); // Test encode functionality
    });

    test('should create a new contract account', () async {
      final deployer = await accounts.newAccount(); // Create deploying account

      await accounts.newContractAccount(
          'examples/fib.wasm', deployer.address); // Test encode functionality
    });

    test('should decode an account from a given private key', () async {
      final account = await accounts.newAccount(); // Initialize account

      final decoded = await accounts
          .accountFromKey(account.privateKey); // Decode account private key

      expect(decoded.string(),
          equals(account.string())); // Ensure accounts are equivalent
    });

    test('should get a list of working accounts', () async {
      await accounts
          .newAccount(); // Initialize account just to make sure getAllAccounts() isn't nil

      final localAccounts = await accounts.getAllAccounts(); // Get all accounts

      expect(localAccounts.length, greaterThan(0)); // Ensure has accounts
    });

    test('should get a list of working contracts', () async {
      final deployer = await accounts.newAccount(); // Create deploying account

      await accounts.newContractAccount(
          'examples/fib.wasm', deployer.address); // Initialize contract account
      await accounts.newContractAccount('examples/main.wasm',
          deployer.address); // Initialize contract account

      final localContracts =
          await accounts.getAllContracts(deployer.address); // Get all contracts

      expect(localContracts.length, greaterThan(0)); // Ensure has accounts
    });

    test('should read an account from persistent memory', () async {
      final account = await accounts.newAccount(); // Initialize account

      final readAccount = await accounts.readAccountFromMemory(
          account.address); // Read account from persistent memory

      expect(account.string(),
          equals(readAccount.string())); // Ensure accounts are equivalent

      accounts.destroy(); // Destroy accounts
    });
  });
}
