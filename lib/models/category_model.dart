class CategoryModel {
  String? id;
  String? name;
  String? icon;
  bool? isActive;

  CategoryModel({
    this.id,
    required this.name,
    required this.icon,
    this.isActive = true,
  });

  toJson() {
    return {
      "name": name,
      "icon": icon,
      "isActive": isActive,
    };
  }

  factory CategoryModel.fromFirestore(
      Map<String, dynamic> firestore, String id) {
    return CategoryModel(
      id: id,
      name: firestore['name'],
      icon: firestore['icon'],
      isActive: firestore['isActive'],
    );
  }
}
