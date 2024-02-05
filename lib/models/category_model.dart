import 'package:flutter/material.dart';

class CategoryModel {
  String? id;
  final String title;
  final IconData icon;
  bool? isActive;

  CategoryModel({
    this.id,
    required this.title,
    required this.icon,
    this.isActive = true,
  });

  toJson() {
    return {
      "name": title,
      "icon": icon,
      "isActive": isActive,
    };
  }

  factory CategoryModel.fromFirestore(
      Map<String, dynamic> firestore, String id) {
    return CategoryModel(
      id: id,
      title: firestore['name'],
      icon: firestore['icon'],
      isActive: firestore['isActive'],
    );
  }
}
