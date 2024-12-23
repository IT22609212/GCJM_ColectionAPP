import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  final String id;
  final String shortName;
  final String name;
  final DateTime createdAt;
  final int totalUsers;

  Area({
    required this.id,
    required this.shortName,
    required this.name,
    required this.createdAt,
    this.totalUsers = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'shortName': shortName,
      'name': name,
      'createdAt': createdAt,
      'totalUsers': totalUsers,
    };
  }

  factory Area.fromMap(String id, Map<String, dynamic> map) {
    return Area(
        id: id,
        shortName: map['shortName'] ?? '',
        name: map['name'] ?? '',
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        totalUsers: map['totalUsers'] ?? 0);
  }
}
