class CategoryModel {
  String? id;
  final String title;
  final String icon;
  final String homeId;
  bool? isActive;

  CategoryModel({
    this.id,
    required this.title,
    required this.icon,
    required this.homeId,
    this.isActive = true,
  });

  toJson() {
    return {
      "name": title,
      "icon": icon,
      "homeId": homeId,
      "isActive": isActive,
    };
  }

  factory CategoryModel.fromFirestore(
      Map<String, dynamic> firestore, String id) {
    return CategoryModel(
      id: id,
      title: firestore['name'],
      icon: firestore['icon'],
      homeId: firestore['homeId'],
      isActive: firestore['isActive'],
    );
  }
}
