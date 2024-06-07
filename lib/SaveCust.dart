import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kt/Transactions.dart';
import 'package:kt/customers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerStorage {
  static const String _keyPrefix = 'customer_';

  static Future<void> saveCustomerDetails(Customers customer) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String key = _keyPrefix + customer.name;

      final List<String> serializedTrans =
      customer.trans.map((trans) => jsonEncode(trans.toJson())).toList();

      prefs.setStringList(
        key,
        [
          customer.name,
          customer.phone,
          customer.town,
          customer.balance.toString(),
          ...serializedTrans,
          customer.credit.toString(),
          customer.debit.toString(),
        ],
      );
    } catch (e) {
      print('Error saving customer details: $e');
    }
  }

  static Future<List<Customers>> getSavedCustomers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> keys = prefs.getKeys().where((key) => key.startsWith(_keyPrefix)).toList();

      final List<Customers> customers = [];
      for (String key in keys) {
        final List<String>? customerData = prefs.getStringList(key);
        if (customerData != null && customerData.length >= 3) {
          final List<Transactions> transactions = [];
          for (int i = 4; i < customerData.length - 2; i++) {
            final Map<String, dynamic> transactionData = jsonDecode(customerData[i]) as Map<String, dynamic>;
            transactions.add(Transactions.fromJson(transactionData));
          }
          final credit = double.tryParse(customerData[customerData.length - 2]) ?? 0.0;
          final debit = double.tryParse(customerData[customerData.length - 1]) ?? 0.0;
          final balance = double.tryParse(customerData[3]) ?? 0.0;
          customers.add(Customers.withTransaction(
            name: customerData[0],
            phone: customerData[1],
            town: customerData[2],
            balance: balance,
            trans: transactions,
            credit: credit.toString(),
            debit: debit.toString(),
            edited: DateTime.now().microsecondsSinceEpoch,
          ));
        }
      }
      return customers;
    } catch (e) {
      print('Error retrieving customer details: $e');
      return [];
    }
  }

  static Future<void> clearCustomerDetails(String customerName) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String key = _keyPrefix + customerName;

      // Remove the key associated with the customer
      await prefs.remove(key);
    } catch (e) {
      print('Error clearing customer details: $e');
    }
  }
  static Future<void> clearAllCustomers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> keys = prefs.getKeys().where((key) => key.startsWith(_keyPrefix)).toList();

      for (String key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      print('Error clearing all customer details: $e');
    }
  }
}
