import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gcjm_collection_app/Common_Widgets/bottom_bar.dart';
import 'package:gcjm_collection_app/Screens/dashboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:gcjm_collection_app/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GCJM Collection App',
      home: Scaffold(
        body: HomePage(), // Use PaymentWebView widget here
      ),
    );
  }
}
