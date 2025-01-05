// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:csv/csv.dart';
// import 'package:gcjm_collection_app/services/firebase_service.dart';

// class CSVImporter {
//   final FirebaseService firebaseService;

//   CSVImporter(this.firebaseService);

//   Future<void> addUIDsToExistingUsers() async {
//     try {
//       final usersCollection = FirebaseFirestore.instance.collection('users');
//       final querySnapshot = await usersCollection.get();

//       for (var doc in querySnapshot.docs) {
//         final data = doc.data();
//         if (data.containsKey('areaCode') && data.containsKey('refNo')) {
//           final String areaCode = data['areaCode'];
//           final String refNo = data['refNo'];
//           final String uid = '${areaCode}_${refNo}'.replaceAll('/', '_');

//           // Update the document with the new UID
//           await doc.reference.update({'uid': uid});
//           print('UID added for document: ${doc.id}');
//         } else {
//           print('Document ${doc.id} is missing areaCode or refNo');
//         }
//       }
//       print('UIDs added successfully for all documents.');
//     } catch (e) {
//       print('Error updating UIDs: $e');
//     }
//   }

//   Future<void> importUsersFromCSVContent(String csvContent) async {
//     try {
//       // Parse CSV content
//       final fields = const CsvToListConverter().convert(csvContent);

//       // Validate header row
//       if (fields.isEmpty || fields[0].length < 7) {
//         print("Invalid CSV format. Ensure it contains the expected columns.");
//         return;
//       }

//       for (int i = 1; i < fields.length; i++) {
//         final row = fields[i];

//         // Validate required fields
//         if (row[0] == null || row[1] == null) {
//           print("Skipping row $i: Missing areaCode or Ref No.");
//           continue;
//         }

//         // Extract fields
//         final String areaCode = row[0]?.toString() ?? '';
//         final String refNo = row[1]?.toString() ?? '';
//         final String uid =
//             '${areaCode}_${refNo}'; // Combine areaCode and Ref No
//         final String name = row[2]?.toString() ?? 'Unknown';
//         final String nic = (row[3]?.toString() ?? '').toLowerCase() != 'null'
//             ? row[3].toString()
//             : '';
//         final String address = row[4]?.toString() ?? 'Unknown';
//         final String contactNo =
//             (row[5]?.toString() ?? '').toLowerCase() != 'nill'
//                 ? row[5].toString()
//                 : '';
//         final double subscription =
//             double.tryParse(row[6]?.toString() ?? '0') ?? 0.0;

//         // Add user to Firebase
//         await firebaseService.createUser(
//           areaCode: areaCode,
//           uid: uid,
//           areaId: areaCode, // Assuming areaCode maps to areaId
//           refNo: refNo,
//           name: name,
//           NIC: nic,
//           address: address,
//           contactNo: contactNo,
//           subscription: subscription,
//           lastPayment: 0.0, // Default value
//           lastPaymentDate: DateTime.now(), // Default value
//         );

//         print("Imported user: $name (UID: $uid)");
//       }

//       print("Users imported successfully!");
//     } catch (e) {
//       print("Error importing users: $e");
//     }
//   }
// }
