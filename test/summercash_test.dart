import 'dart:typed_data';

import 'package:summercash/src/chain_api.dart';
import 'package:test/test.dart';
import 'package:summercash/src/common_api.dart';
import 'package:summercash/src/accounts_api.dart';
import 'package:summercash/src/chain.dart';

void main() {
  group('common tests', () {
    CommonAPI common =
        new CommonAPI('https://localhost:8080'); // Initialize common API

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
    AccountsAPI accounts =
        new AccountsAPI('https://localhost:8080'); // Initialize accounts API

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

  group('chain tests', () {
    ChainAPI chain =
        new ChainAPI('https://localhost:8080'); // Initialize chain API
    AccountsAPI accounts =
        new AccountsAPI('https://localhost:8080'); // Initialize accounts API

    test('should calculate the balance of a given chain', () async {
      final account = await accounts.newAccount(); // Initialize new account

      final balance =
          await chain.getBalance(account.address); // Calculate balance

      expect(balance.toInt(), equals(0)); // Ensure has zero balance
    });

    test('should read a given chain', () async {
      final account = await accounts.newAccount(); // Initialize new account

      Chain accountChain =
          await chain.readChainFromMemory(account.address); // Read chain

      expect(accountChain.account,
          equals(account.address)); // Ensure addresses equivalent

      chain.destroy(); // Destroy chain
      accounts.destroy(); // Destroy accounts
    });
  });
}
