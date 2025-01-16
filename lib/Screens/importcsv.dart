// import 'dart:html' as html; // Web-specific
// import 'package:flutter/material.dart';
// import 'package:gcjm_collection_app/services/firebase_service.dart';
// import 'package:gcjm_collection_app/Screens/importuser.dart';

// class Garden210 extends StatelessWidget {
//   final FirebaseService firebaseService = FirebaseService();
//   final CSVImporter csvImporter;

//   Garden210({Key? key})
//       : csvImporter = CSVImporter(FirebaseService()),
//         super(key: key);

//   Future<void> importCSV(BuildContext context) async {
//     final html.FileUploadInputElement uploadInput =
//         html.FileUploadInputElement();
//     uploadInput.accept = ".csv";
//     uploadInput.click();

//     uploadInput.onChange.listen((e) async {
//       final files = uploadInput.files;
//       if (files != null && files.isNotEmpty) {
//         final reader = html.FileReader();
//         reader.readAsText(files[0]);

//         reader.onLoadEnd.listen((event) async {
//           final csvContent = reader.result as String;
//           await csvImporter.importUsersFromCSVContent(csvContent);

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('CSV Imported Successfully!')),
//           );
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Panel')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => importCSV(context),
//           child: const Text('Import User Data'),
//         ),
//       ),
//     );
//   }


// --------------
// // import 'package:flutter/material.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:gcjm_collection_app/Screens/importuser.dart';
// // import 'dart:io';
// // import 'package:gcjm_collection_app/services/firebase_service.dart';

// // class ImportCSVScreen extends StatefulWidget {
// //   @override
// //   _ImportCSVScreenState createState() => _ImportCSVScreenState();
// // }

// // class _ImportCSVScreenState extends State<ImportCSVScreen> {
// //   final FirebaseService firebaseService = FirebaseService();
// //   late final CSVImporter csvImporter;

// //   @override
// //   void initState() {
// //     super.initState();
// //     csvImporter = CSVImporter(firebaseService);
// //   }

// //   Future<void> _importCSV() async {
// //     try {
// //       // Allow user to pick a CSV file
// //       FilePickerResult? result = await FilePicker.platform.pickFiles(
// //         type: FileType.custom,
// //         allowedExtensions: ['csv'],
// //       );

// //       if (result != null && result.files.single.path != null) {
// //         File file = File(result.files.single.path!);

// //         // Read file content
// //         String csvContent = await file.readAsString();

// //         // Call the import function
// //         await csvImporter.importUsersFromCSVContent(csvContent);

// //         // Show success message
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("CSV imported successfully!")),
// //         );
// //       } else {
// //         // User canceled the picker
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("No file selected.")),
// //         );
// //       }
// //     } catch (e) {
// //       // Handle errors
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error importing CSV: $e")),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Import CSV"),
// //       ),
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: _importCSV,
// //           child: Text("Import Users from CSV"),
// //         ),
// //       ),
// //     );
// //   }
// // }
