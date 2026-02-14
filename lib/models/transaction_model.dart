class TransactionModel {
  final int? id;
  final double amount;
  final String merchant;
  final String category;
  final String type;
  final String timestamp;

  TransactionModel({
    this.id,
    required this.amount,
    required this.merchant,
    required this.category,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'merchant': merchant,
      'category': category,
      'type': type,
      'timestamp': timestamp,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount'],
      merchant: map['merchant'],
      category: map['category'],
      type: map['type'],
      timestamp: map['timestamp'],
    );
  }
}
