import 'package:kt/Transactions.dart';

class Customers {
  late  String name;
  late  String phone;
  late  String town;
  late double balance;
  late List<Transactions> trans; // Make sure to initialize this properly
  late var credit;
  late var debit;

  Customers({
    required this.name,
    required this.phone,
    required this.town,
    this.balance=0,
    List<Transactions> trans = const [],
    this.credit=0,
    this.debit=0// Initialize trans as an empty list
  }) : trans = trans;

  Customers.withTransaction({
    required this.name,
    required this.phone,
    required this.town,
    required this.balance,
    required this.trans,
    required this.credit,
    required this.debit,
  });
}
