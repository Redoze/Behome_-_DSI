import 'package:behome/models/environment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnvironmentService {
  final CollectionReference _environmentsCollection =
      FirebaseFirestore.instance.collection('environments');

  Stream<List<EnvironmentModel>> readEnvironments(String homeId) {
    return _environmentsCollection
        .where('homeId', isEqualTo: homeId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EnvironmentModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList())
        .handleError((error) {
      return <EnvironmentModel>[];
    });
  }

  Future<void> createEnvironment(EnvironmentModel environment) async {
    DocumentReference docRef = _environmentsCollection.doc();
    environment.id = docRef.id;
    await docRef.set(environment.toJson());
  }

  Future<void> updateEnvironment(EnvironmentModel environment) async {
    await _environmentsCollection.doc(environment.id).update(environment.toJson());
  }

  Future<void> deleteEnvironment(String id) async {
    await _environmentsCollection.doc(id).update({'isActive': false});
  }
}
