class PersonModel {
  String? id;
  String name;

  PersonModel({
    this.id,
    required this.name,
  });

  toJson() {
    return {
      "name": name,
    };
  }

  factory PersonModel.fromFirestore(Map<String, dynamic> firestore, String id) {
    return PersonModel(
      id: id,
      name: firestore['name'],
    );
  }
}
