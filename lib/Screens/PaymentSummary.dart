import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcjm_collection_app/color/AppColors.dart';
import 'package:intl/intl.dart';

class PaymentSummary extends StatefulWidget {
  const PaymentSummary({Key? key}) : super(key: key);

  @override
  _PaymentSummaryState createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  Map<String, List<Map<String, dynamic>>> paymentData = {};

  @override
  void initState() {
    super.initState();
    fetchAllPayments();
  }

  Future<void> fetchAllPayments() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('payments').get();

    Map<String, List<Map<String, dynamic>>> groupedPayments = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final timestamp = data['paidAt'] as Timestamp;
      final date = timestamp.toDate();

      // Group by day (e.g., "2025-01-05")
      final formattedDay = DateFormat('yyyy-MM-dd').format(date);
      final months = data['month'] is List
          ? List<String>.from(data['month'])
          : [data['month']]; // Handle single or multiple months

      for (var month in months) {
        if (!groupedPayments.containsKey(formattedDay)) {
          groupedPayments[formattedDay] = [];
        }

        groupedPayments[formattedDay]?.add({
          'amount': data['amount'],
          'userId': data['userId'],
          'paidAt': date,
          'month': month, // Separate by each month
          'year': data['year'],
        });
      }
    }

    // Sort the map by date in descending order
    final sortedKeys = groupedPayments.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

    final sortedPaymentData = {
      for (var key in sortedKeys) key: groupedPayments[key]!
    };

    setState(() {
      paymentData = sortedPaymentData;
    });
  }

  Future<void> _onRefresh() async {
    await fetchAllPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Payment Summary",
          style: TextStyle(color: AppColors.defaultWhite),
        ),
        backgroundColor: AppColors.baseColor,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: paymentData.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  // Show the latest updated date on top
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Last Updated: ${paymentData.keys.first}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.defaultBlack,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: paymentData.length,
                      itemBuilder: (context, index) {
                        final day = paymentData.keys
                            .elementAt(index); // Day key (e.g., "2025-01-05")
                        final payments = paymentData[day]!;

                        // Calculate the total amount for the day
                        final totalAmount = payments.fold<double>(0,
                            (sum, payment) => sum + (payment['amount'] ?? 0));

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: ExpansionTile(
                              collapsedShape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                side: BorderSide.none,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                side: BorderSide.none,
                              ),
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              expandedAlignment: Alignment.centerLeft,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date: $day",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.defaultBlack,
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      'Rs ${totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppColors.defaultWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: AppColors.gold,
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                '${payments.length} payment(s) recorded',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.defaultBlack,
                                ),
                              ),
                              iconColor: AppColors.baseColor,
                              children: [
                                SizedBox(
                                  height: payments.length > 10 ? 300 : null,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: payments.length > 10
                                        ? const ScrollPhysics()
                                        : const NeverScrollableScrollPhysics(),
                                    itemCount: payments.length,
                                    itemBuilder: (context, idx) {
                                      final payment = payments[idx];
                                      print(payment);
                                      final formattedTime =
                                          DateFormat('hh:mm a').format(payment[
                                              'paidAt']); // 12-hour format
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 16),
                                        child: Card(
                                          margin: const EdgeInsets.only(top: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor:
                                                  AppColors.baseColor,
                                              child: Icon(
                                                Icons.person,
                                                color: AppColors.defaultWhite,
                                              ),
                                            ),
                                            title: Text(
                                              'Month: ${payment['month']} - ${payment['year']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.defaultBlack,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Amount: Rs ${payment['amount']}\n'
                                              'User ID: ${payment['userId']}\n'
                                              'Paid Time: $formattedTime',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      AppColors.defaultBlack),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
