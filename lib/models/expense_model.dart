class ExpenseModel {
  late final String? id;
  final String title;
  final String category;
  final String personName;
  final String personId;
  final String homeId;
  final double amount;
  final DateTime date;

  ExpenseModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.personName,
    required this.personId,
    required this.homeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "amount": amount,
      "date": date.toIso8601String(),
      "category": category,
      "debtor": personName,
      "debtorId": personId,
      "homeId": homeId,
    };
  }

  factory ExpenseModel.fromFirestore(
      Map<String, dynamic> firestore, String id) {
    return ExpenseModel(
      id: id,
      title: firestore['title'],
      amount: firestore['amount'],
      date: firestore['date'].toDate(),
      category: firestore['category'],
      personName: firestore['personName'],
      personId: firestore['personId'],
      homeId: firestore['homeId'],
    );
  }
}
