import 'package:behome/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  Stream<List<CategoryModel>> readCategories(String homeId) {
    return _categoriesCollection
        .where('homeId', isEqualTo: homeId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList())
        .handleError((error) {
      return <CategoryModel>[];
    });
  }

  Future<void> createCategory(CategoryModel category) async {
    DocumentReference docRef = _categoriesCollection.doc();
    category.id = docRef.id;
    await docRef.set(category.toJson());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _categoriesCollection.doc(category.id).update(category.toJson());
  }

  Future<void> deleteCategory(String id) async {
    await _categoriesCollection.doc(id).update({'isActive': false});
  }
}
