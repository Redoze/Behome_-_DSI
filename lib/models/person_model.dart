class PersonModel {
  final String? id;
  final String name;

  PersonModel({
    this.id,
    required this.name,
  });

  toJson() {
    return {
      "name": name,
    };
  }
}
