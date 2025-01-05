import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String areaCode;
  final String uid;
  final String areaId;
  final String refNo;
  final String name;
  final String NIC;
  final String address;
  final String contactNo;
  final double subscription;
  final double lastPayment;
  final DateTime lastPaymentDate;

  User({
    required this.areaCode,
    required this.uid,
    required this.areaId,
    required this.refNo,
    required this.name,
    required this.NIC,
    required this.address,
    required this.contactNo,
    required this.subscription,
    required this.lastPayment,
    required this.lastPaymentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'areaCode': areaCode,
      'uid': uid,
      'areaId': areaId,
      'refNo': refNo,
      'name': name,
      'NIC': NIC,
      'address': address,
      'contactNo': contactNo,
      'subscription': subscription,
      'lastPayment': lastPayment,
      'lastPaymentDate': lastPaymentDate.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      areaCode: map['areaCode'] ?? '',
      uid: map['uid'] ?? '',
      areaId: map['areaId'] ?? '',
      refNo: map['refNo'] ?? '',
      name: map['name'] ?? '',
      NIC: map['NIC'] ?? '',
      address: map['address'] ?? '',
      contactNo: map['contactNo'] ?? '',
      subscription: map['subscription'] ?? 0.0,
      lastPayment: map['lastPayment'] ?? 0.0,
      lastPaymentDate: DateTime.parse(map['lastPaymentDate'] ?? ''),
    );
  }
}
