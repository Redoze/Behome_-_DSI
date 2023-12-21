import 'package:behome/models/expense_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  Future<void> createExpense(ExpenseModel expense) async {
    DocumentReference docRef = _expensesCollection.doc();
    expense.id = docRef.id;
    await docRef.set(expense.toJson());
  }

  Stream<List<ExpenseModel>> readExpenses(String homeId) {
    return _expensesCollection
        .where('homeId', isEqualTo: homeId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList())
        .handleError((error) {
      print(error);
      return <ExpenseModel>[];
    });
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await _expensesCollection.doc(expense.id).update(expense.toJson());
  }

  Future<void> deleteExpense(String id) async {
    await _expensesCollection.doc(id).delete();
  }
}
