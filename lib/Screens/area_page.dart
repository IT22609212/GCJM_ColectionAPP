import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcjm_collection_app/Screens/210Garden.dart';
import 'package:gcjm_collection_app/Screens/importuser.dart';
import 'package:gcjm_collection_app/color/AppColors.dart';
import 'package:gcjm_collection_app/models/area.dart';
import 'package:gcjm_collection_app/models/user.dart';
import 'package:gcjm_collection_app/services/firebase_service.dart';

class AreaPage extends StatefulWidget {
  final Area area;

  const AreaPage({Key? key, required this.area}) : super(key: key);

  @override
  _AreaPageState createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  final FirebaseService _firebaseService = FirebaseService();

  final List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  String? selectedUserId;
  Map<String, dynamic>? selectedUserData;
  bool isImporting = false;
  final TextEditingController refNoController = TextEditingController();
  List<String> paidMonths = [];
  List<String> selected = [];
  List<String> selectedMonths = [];

  bool isAllSelected = false; // Track if "Select All" is checked
  bool isExpanded = false; // Track the expanded state of ExpansionTile
  int selectedYear = DateTime.now().year; // Default to the current year

  Future<void> _fetchPaidMonths() async {
    if (selectedUserData == null) return;

    try {
      // Fetch payments for the selected user
      final paymentsSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('userId', isEqualTo: selectedUserData?['uid'])
          .where('year', isEqualTo: selectedYear) // Filter by selected year
          .get();

      print(
          'Fetched Documents: ${paymentsSnapshot.docs.map((doc) => doc.data()).toList()}');

      if (paymentsSnapshot.docs.isNotEmpty) {
        List<String> monthsPaid = [];

        for (var doc in paymentsSnapshot.docs) {
          var monthData = doc.data()['month'];

          if (monthData is List) {
            monthsPaid.addAll(monthData.cast<String>());
          } else if (monthData is String) {
            monthsPaid.add(monthData);
          }
        }

        print('Raw Months Paid: $monthsPaid');

        const monthOrder = {
          'JAN': 1,
          'FEB': 2,
          'MAR': 3,
          'APR': 4,
          'MAY': 5,
          'JUN': 6,
          'JUL': 7,
          'AUG': 8,
          'SEP': 9,
          'OCT': 10,
          'NOV': 11,
          'DEC': 12,
        };

        monthsPaid = monthsPaid.toSet().toList(); // Remove duplicates
        monthsPaid.sort((a, b) => monthOrder[a]!.compareTo(monthOrder[b]!));

        print('Months Paid (Sorted): $monthsPaid');

        setState(() {
          paidMonths = monthsPaid.cast<String>();
        });
      } else {
        setState(() {
          paidMonths = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching paid months: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Automatically fetch paid months when user data is loaded
    _fetchPaidMonths();
  }

  Future<void> _fetchUserData() async {
    String refNo = refNoController.text;

    if (widget.area.areaCode.isEmpty || refNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter both Area Code and Reference Number')),
      );
      return;
    }

    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('areaCode', isEqualTo: widget.area.areaCode)
          .where('refNo', isEqualTo: refNo)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data();
        setState(() {
          selectedUserData = userData;
        });
        print('User data: $userData');
        await _fetchPaidMonths();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'No user found with the given Area Code and Reference Number')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.area.name,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.baseColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(selectedUserData?[
                'uid']) // You'll need to pass the actual user ID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          // final subscription =
          //     userData['subscription'] as Map<String, dynamic>?;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCard(widget.area.areaCode),
                      // _buildCard(userData['idNo'] ?? ''),

                      Expanded(child: _inputCard()),

                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                'Rs ${selectedUserData?['subscription']?.toString() ?? '0.00'}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _editAmount(context, selectedUserData),
                                icon: const Icon(Icons.edit, size: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _fetchUserData,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        backgroundColor: AppColors.baseColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Fetch User Data',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMonthSelector(),
                  const SizedBox(height: 16),
                  _buildPaidMonthsWidget(),
                  const SizedBox(height: 16),
                  _buildUserDetails(),
                  // Card(
                  //   child: Column(
                  //     children: [
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => Garden210()),
                  //           );
                  //         },
                  //         child: Text(
                  //             'Go to User Import'), // Add a label for the button
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildPaidMonthsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Paid Months',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        paidMonths.isEmpty
            ? const Center(
                child: Text(
                  'No months paid yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paidMonths.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Display 3 cards per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      2.5, // Adjust to have the same width/height ratio as in month selector
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        // You can add any functionality for when a paid month card is tapped
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors
                              .baseColor, // You can adjust this to your preferred color
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            paidMonths[index],
                            style: const TextStyle(
                              fontSize:
                                  14, // Adjusted text size to match your style
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.white, // Text color white for contrast
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key:
              Key(isExpanded.toString()), // Unique key to avoid state conflicts
          title: const Text(
            'Select The Month',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          iconColor: AppColors.baseColor,
          collapsedIconColor: Colors.black,
          initiallyExpanded: isExpanded, // Control expanded state
          onExpansionChanged: (bool expanded) {
            setState(() {
              isExpanded = expanded;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Year:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<int>(
                    value: selectedYear,
                    items: [
                      DateTime.now().year, // Current year
                      DateTime.now().year - 1, // Previous year
                    ].map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text('$year'),
                      );
                    }).toList(),
                    onChanged: (int? year) {
                      setState(() {
                        selectedYear = year ?? DateTime.now().year;
                        _fetchPaidMonths(); // Fetch months for the new year
                      });
                    },
                  ),
                ],
              ),
            ),

            // Checkbox for "Select All Unpaid Months"
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Checkbox(
                    value: isAllSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        isAllSelected = value ?? false;
                        if (isAllSelected) {
                          // Select all unpaid months
                          for (var month in months) {
                            if (!paidMonths.contains(month) &&
                                !selectedMonths.contains(month)) {
                              selectedMonths.add(month);
                            }
                          }
                        } else {
                          // Deselect all months
                          selectedMonths.clear();
                        }
                      });
                    },
                  ),
                  const Text(
                    'Select All Unpaid Months',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Month Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: months.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                bool isPaid = paidMonths.contains(months[index]);
                bool isSelected = selectedMonths.contains(months[index]);
                return GestureDetector(
                  onTap: isPaid
                      ? null // Disable tap for paid months
                      : () {
                          setState(() {
                            if (isSelected) {
                              selectedMonths
                                  .remove(months[index]); // Deselect the month
                            } else {
                              selectedMonths
                                  .add(months[index]); // Select the month
                            }
                          });
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.gold // Highlight selected months
                            : isPaid
                                ? Colors.grey // Disable color for paid months
                                : AppColors.baseColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          months[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isPaid ? Colors.black45 : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetails() {
    if (selectedUserData == null) {
      return const Center(child: Text('No user details available'));
    }

    return Column(
      children: [
        const Center(
          child: Text(
            'User Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.person,
                    'Name: ${selectedUserData?['name'] ?? ''}', 'name'),
                const Divider(),
                _buildDetailRow(
                    Icons.phone,
                    'Phone: ${selectedUserData?['contactNo'] ?? ''}',
                    'contactNo'),
                const Divider(),
                _buildDetailRow(
                    Icons.location_on,
                    'Address: ${selectedUserData?['address'] ?? ''}',
                    'address'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text, String field) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit_square, color: Colors.grey.withOpacity(0.6)),
          onPressed: () => _editUserDetail(
              field), // Call edit function for the respective field
        ),
      ],
    );
  }

  Future<void> _editUserDetail(String field) async {
    final TextEditingController controller = TextEditingController();
    String initialValue = '';

    // Set the initial value based on the selected field
    if (field == 'name') {
      initialValue = selectedUserData?['name'] ?? '';
    } else if (field == 'contactNo') {
      initialValue = selectedUserData?['contactNo'] ?? '';
    } else if (field == 'address') {
      initialValue = selectedUserData?['address'] ?? '';
    }

    controller.text = initialValue;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Enter new $field',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final newValue = controller.text;

                // Update the user data in Firebase based on the field being edited
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(selectedUserData?['uid'])
                    .update({
                  field: newValue,
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$field updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating $field: $e')),
                );
                print('Error updating $field: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String text) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _inputCard() {
    return FractionallySizedBox(
      widthFactor: 0.5, // This reduces the width to 50% of the available space
      child: TextField(
        controller: refNoController,
        decoration: InputDecoration(
          labelText: 'Reference Number',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.baseColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _confirmPayment(),
          child: const Text(
            'Confirm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editAmount(
      BuildContext context, Map<String, dynamic>? selectedUserData) async {
    final TextEditingController amountController = TextEditingController(
        text: selectedUserData?['subscription']?.toString() ?? '0.00');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Amount'),
        content: TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount (Rs)',
            prefixText: 'Rs ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final newAmount = double.parse(amountController.text);

                // Check if the document exists
                final docSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(
                        selectedUserData?['uid']) // Replace with actual user ID
                    .get();

                if (docSnapshot.exists) {
                  // Document exists, proceed with update
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(selectedUserData?['uid'])
                      .update({
                    'subscription': newAmount,
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Amount updated successfully')),
                  );
                } else {
                  // Document doesn't exist, show an error or handle accordingly
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User document not found')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating amount: $e')),
                );
                print('Error updating amount: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmPayment() async {
    if (selectedMonths == null || selectedMonths!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a month')),
      );
      return;
    }

    print("Selected Months--- confirm: $selectedMonths");
    print("Selected User Data: $selectedUserData");
    print("Selected User UID: ${selectedUserData?['uid']}");

    if (selectedUserData?['uid'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
      return;
    }

    try {
      // Record payment in 'payments' collection
      await FirebaseFirestore.instance.collection('payments').add({
        'userId':
            selectedUserData?['uid'], // Ensure 'uid' is the user ID (String)
        'areaId': widget.area.areaCode,
        'amount':
            selectedUserData?['subscription'], // Use 'subscription' for amount
        'month': selectedMonths,
        'year': selectedYear,
        'paidAt': FieldValue.serverTimestamp(),
        'status': 'completed',
      });

      // Update user's 'lastPayment' and 'lastPaymentDate'
      await FirebaseFirestore.instance
          .collection('users')
          .doc(selectedUserData?['uid']) // Use 'uid' for the document ID
          .update({
        'lastPayment':
            selectedUserData?['subscription'], // Update payment amount
        'lastPaymentDate':
            FieldValue.serverTimestamp(), // Set current timestamp
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment recorded successfully')),
      );
      setState(() {
        selectedMonths = []; // Clear selected months
        selectedUserData = null; // Clear selected user
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording payment: $e')),
      );
      print('Error recording payment: $e');
    }
  }
}
