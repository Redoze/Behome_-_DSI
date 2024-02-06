import 'package:flutter/material.dart';

class EnvironmentModel {
  String? id;
  final String title;
  final String icon;
  final String homeId;
  bool? isActive;

  EnvironmentModel({
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

  factory EnvironmentModel.fromFirestore(
      Map<String, dynamic> firestore, String id) {
    return EnvironmentModel(
      id: id,
      title: firestore['name'],
      icon: firestore['icon'],
      homeId: firestore['homeId'],
      isActive: firestore['isActive'],
    );
  }
}
