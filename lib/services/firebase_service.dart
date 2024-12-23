import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gcjm_collection_app/models/area.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Areas
  Future<void> createArea(Area area) async {
    await _firestore.collection('area').add(area.toMap());
  }

  Stream<List<Area>> getAreas() {
    return _firestore.collection('areas').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Area.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  //Users
  Future<void> createUser({
    required String uid,
    required String refNo,
    required String name,
    required String idNo,
    required String address,
    required String contactNo,
    required String areaId,
    required double subscription,
    required double lastPayment,
    required DateTime lastPaymentDate,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'refNo': refNo,
      'name': name,
      'idNo': idNo,
      'address': address,
      'contactNo': contactNo,
      'areaId': areaId,
      'subscription': subscription,
      'lastPayment': lastPayment,
      'lastPaymentDate': lastPaymentDate,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('areas').doc(areaId).update({
      'totalUsers': FieldValue.increment(1),
    });
  }

  //Payments
  Future<void> recordPayment({
    required String userId,
    required String areaId,
    required double amount,
    required String month,
    required int year,
  }) async {
    final batch = _firestore.batch();

    final paymentRef = _firestore.collection('payments').doc();
    batch.set(paymentRef, {
      'userId': userId,
      'areaId': areaId,
      'amount': amount,
      'month': month,
      'year': year,
      'paidAt': FieldValue.serverTimestamp(),
      'status': 'completed',
    });

    //Update user's lastPayment
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'lastPayment': amount,
      'lastPaymentDate': FieldValue.serverTimestamp()
    });
    await batch.commit();
  }

  //Get users by area
  Stream<List<DocumentSnapshot>> getUsersByArea(String areaId) {
    return _firestore
        .collection('users')
        .where('areaId', isEqualTo: areaId)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  //Get payments by area and month
  Future<QuerySnapshot> getAreaPayments(
      {required String areaId, required String month, required int year}) {
    return _firestore
        .collection('payments')
        .where('areaId', isEqualTo: areaId)
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .get();
  }

  //Get unpaid payments for current month
  Future<QuerySnapshot> getUnpaidPayments(
      String areaId, String month, int year) {
    final monthStart = DateTime(year, DateTime.now().month, 1);
    return _firestore
        .collection('users')
        .where('areaId', isEqualTo: areaId)
        .where('lastPaymentDate', isLessThan: Timestamp.fromDate(monthStart))
        .get();
  }
}
