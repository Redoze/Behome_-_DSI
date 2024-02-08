import 'package:behome/models/expense_model.dart';
import 'package:behome/models/person_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonService {
  final CollectionReference _personsCollection =
      FirebaseFirestore.instance.collection('persons');

  final CollectionReference _expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  Stream<List<PersonModel>> readPersons(String homeId) {
    return _personsCollection
        .where('homeId', isEqualTo: homeId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PersonModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList())
        .handleError((error) {
      return <PersonModel>[];
    });
  }

  Stream<List<ExpenseModel>> readExpensesForPerson(
      String personId, DateTime period) {
    DateTime start = DateTime(period.year, period.month, 1);
    DateTime end = DateTime(period.year, period.month + 1, 1)
        .subtract(const Duration(days: 1));

    return _expensesCollection
        .where('personId', isEqualTo: personId)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList())
        .handleError((error) {
      return <ExpenseModel>[];
    });
  }

  Future<void> createPerson(PersonModel person) async {
    DocumentReference docRef = _personsCollection.doc();
    person.id = docRef.id;
    await docRef.set(person.toJson());
  }

  Future<void> updatePerson(PersonModel person) async {
    await _personsCollection.doc(person.id).update(person.toJson());
  }

  Future<void> deletePerson(String id) async {
    await _personsCollection.doc(id).delete();

    // Delete all expenses of the person
    await _expensesCollection
        .where('personId', isEqualTo: id)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
