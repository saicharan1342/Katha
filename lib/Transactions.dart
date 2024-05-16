class Transactions {
  final double amount;
  final String type;
  final int dateTime;
  final String details;
  late double balance;// Specify the type for the dateTime field

  Transactions( {
    required this.details,
    required this.amount,
    required this.type,
    required this.dateTime,
    required this.balance,
  });

  // Convert transaction object to JSON
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'dateTime': dateTime.toString(),
      'details':details,
      'balance':balance// Serialize dateTime to String
    };
  }

  // Factory method to create transaction object from JSON
  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      amount: json['amount'],
      type: json['type'],
      dateTime: int.parse(json['dateTime']),
      details: json['details'],
      balance: json['balance']// Deserialize dateTime from String
    );
  }
}