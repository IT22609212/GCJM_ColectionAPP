import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcjm_collection_app/color/AppColors.dart';
import 'package:intl/intl.dart';

class CollectionCard extends StatefulWidget {
  final double screenWidth;

  const CollectionCard(this.screenWidth, {Key? key}) : super(key: key);

  @override
  _CollectionCardState createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  int todayCollection = 0;
  int monthCollection = 0;

  @override
  void initState() {
    super.initState();
    fetchTodayCollection();
    fetchMonthCollection();
    // Listen for changes in the payments collection
    FirebaseFirestore.instance
        .collection('payments')
        .snapshots()
        .listen((snapshot) {
      fetchTodayCollection();
      fetchMonthCollection();
      // fetchAllPayments();
    });
  }

  Future<void> fetchTodayCollection() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final snapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('paidAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('paidAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    //print("Today Collection length (documents): ${snapshot.docs.length}");

    double total = 0;

    for (var doc in snapshot.docs) {
      double amount = doc['amount']; // Monthly subscription amount
      List<dynamic> monthsPaid = doc['month'] ?? [];

      if (monthsPaid.isNotEmpty) {
        total += amount *
            monthsPaid.length; // Multiply amount by the number of months paid
      }
    }

    setState(() {
      todayCollection = total.round(); // Round the total to an integer
      print("Today Collection: Rs. $todayCollection");
    });
  }

  Future<void> fetchMonthCollection() async {
    final now = DateTime.now();
    final currentMonth =
        DateFormat('MMM').format(now).toUpperCase(); // e.g., "JAN"
    final currentYear = now.year;

    print("Querying month: $currentMonth, year: $currentYear");

    final snapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('month',
            arrayContains: currentMonth) // Use arrayContains for month
        .where('year', isEqualTo: currentYear) // Filter by year
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += doc['amount']; // Sum the payment amounts
      print("Document data: ${doc.data()}");
    }

    setState(() {
      monthCollection = total.round(); // Round the total to an integer
      print("Total Month Collection: Rs. $monthCollection");
    });
  }

  // Future<void> fetchAllPayments() async {
  //   final snapshot =
  //       await FirebaseFirestore.instance.collection('payments').get();

  //   for (var doc in snapshot.docs) {
  //     print("Document ID: ${doc.id}, Data: ${doc.data()}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Get the current day of the week and month name
    String currentDay =
        DateFormat('EEEE').format(DateTime.now()); // "Monday", "Tuesday", etc.
    String currentMonth = DateFormat('MMMM')
        .format(DateTime.now()); // "January", "February", etc.

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: widget.screenWidth * 0.44,
        width: widget.screenWidth - 40,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('y MMM dd').format(DateTime.now())}',
              style: const TextStyle(
                color: AppColors.defaultWhite,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 50,
                      color: AppColors.defaultWhite,
                    ),
                    Text(
                      "$currentDay Collection", // Display current day instead of "Today Collection"
                      style: const TextStyle(
                        color: AppColors.defaultWhite,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Rs. ${todayCollection.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.defaultWhite,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 50,
                      color: AppColors.defaultWhite,
                    ),
                    Text(
                      "$currentMonth Collection", // Display current month name instead of "Month Collection"
                      style: const TextStyle(
                        color: AppColors.defaultWhite,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Rs. ${monthCollection.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.defaultWhite,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
