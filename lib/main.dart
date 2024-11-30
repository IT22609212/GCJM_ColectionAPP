import 'package:flutter/material.dart';
import 'package:gcjm_collection_app/Common_Widgets/bottom_bar.dart';
import 'package:gcjm_collection_app/Screens/dashboard.dart';

void main() {
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
