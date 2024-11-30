import 'package:flutter/material.dart';
import 'package:gcjm_collection_app/Screens/dashboard.dart';
import 'package:gcjm_collection_app/color/AppColors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _widget = Container(); // default

  @override
  Widget build(BuildContext context) {
    Widget widget = _widget;

    switch (_selectedIndex) {
      case 0:
        widget = Dashboard();
        _widget = widget;
        break;
      case 1:
        //widget = const SupportMainPage();
        _widget = widget;
        break;
      case 2:
        // widget = MainPaymentScreen();
        _widget = widget;
        break;
        // case 3:
        //   _openDrawer();

        break;
    }
    return Scaffold(
      key: _scaffoldKey,

      // drawer: DrawerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_rounded),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_rounded),
            label: 'Menu',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.baseColor,
        unselectedItemColor: const Color.fromARGB(255, 178, 180, 180),
        onTap: _onItemTapped,
      ),
      body: widget,
    );
  }
}
