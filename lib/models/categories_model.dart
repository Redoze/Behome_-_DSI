import 'package:flutter/material.dart';

class CategoriesModel {
  String? id;
  final String title;
  final IconData icon;

  CategoriesModel({
    this.id,
    required this.title,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "amount": icon,
    };
  }
}
