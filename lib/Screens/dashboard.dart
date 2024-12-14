import 'package:flutter/material.dart';
import 'package:gcjm_collection_app/Screens/210Garden.dart';
import 'package:gcjm_collection_app/Screens/213Garden.dart';
import 'package:gcjm_collection_app/Screens/225Dispensary.dart';
import 'package:gcjm_collection_app/Screens/261Garden.dart';
import 'package:gcjm_collection_app/Screens/AlbionRoad.dart';
import 'package:gcjm_collection_app/Screens/BaslineGarden.dart';
import 'package:gcjm_collection_app/Screens/BaslineRoad.dart';
import 'package:gcjm_collection_app/Screens/DematagodaRoad.dart';
import 'package:gcjm_collection_app/Screens/Dp_page.dart';
import 'package:gcjm_collection_app/Screens/General.dart';
import 'package:gcjm_collection_app/Screens/HawanaGarden.dart';
import 'package:gcjm_collection_app/Screens/KentRoad.dart';
import 'package:gcjm_collection_app/Screens/Mallikarama_Dflat.dart';
import 'package:gcjm_collection_app/Screens/Mallikarama_Gflats.dart';
import 'package:gcjm_collection_app/Screens/Mallikarama_Road.dart';
import 'package:gcjm_collection_app/Screens/Patty.dart';
import 'package:gcjm_collection_app/Screens/PerthRoad.dart';
import 'package:gcjm_collection_app/color/AppColors.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> areas = [
    '210',
    '225',
    '213',
    '261',
    'DR',
    'DP',
    'MR',
    'MDF',
    'MGF',
    'HG',
    'BR',
    'BG',
    'PR',
    'KR',
    'P',
    'AR',
    'General',
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(screenWidth),
      body: Column(
        children: [
          Container(
            color: Colors.transparent,
            height: screenHeight * 0.36, // Responsive height
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: AreaGrid(areas: areas, screenWidth: screenWidth),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget customAppBar(double screenWidth) {
    return AppBar(
      backgroundColor: AppColors.baseColor,
      elevation: 0,
      toolbarHeight: screenWidth * 0.18, // Responsive toolbar height
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.05, top: 30),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/images/logo.jpg'),
                    radius: screenWidth * 0.05, // Responsive radius
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: screenWidth * 0.22,
            left: 0,
            right: 0,
            child: curvedContainer(screenWidth),
          ),
          Positioned(
            top: screenWidth * 0.42,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: CollectionCard(screenWidth),
          ),
          Container(
            height: screenWidth * 0.5,
          ),
        ],
      ),
    );
  }

  Widget curvedContainer(double screenWidth) {
    return Container(
      height: screenWidth * 0.3,
      decoration: const BoxDecoration(
        color: AppColors.baseColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Ghaneemathul Casimiya\n Jumma Masjid',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.baseColorForG,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class AreaGrid extends StatelessWidget {
  final List<String> areas;
  final double screenWidth;

  const AreaGrid({Key? key, required this.areas, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> areaScreens = {
      'DP': DematagodePlace(),
      '210': Garden210(),
      '225': Garden225(),
      '213': Garden213(),
      '261': Garden261(),
      'DR': Dematagodaroad(),
      'MR': MallikaramaRoad(),
      'MDF': MallikaramaDflat(),
      'MGF': MallikaramaGflats(),
      'HG': HawanaGarden(),
      'BR': Baslineroad(),
      'BG': BaslineGarden(),
      'P': Patty(),
      'PR': PerthRoad(),
      'KR': KentRoad(),
      'AR': AlbionRoad(),
      'General': General(),
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 4 : 3, // Adjust based on width
        crossAxisSpacing: screenWidth * 0.02,
        mainAxisSpacing: screenWidth * 0.02,
        childAspectRatio: 1,
      ),
      itemCount: areas.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            final area = areas[index];
            if (areaScreens.containsKey(area)) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => areaScreens[area]!),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                areas[index],
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: AppColors.baseColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CollectionCard extends StatelessWidget {
  final double screenWidth;

  const CollectionCard(this.screenWidth, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: screenWidth * 0.44,
        width: screenWidth - 40,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          children: [
            SizedBox(height: 8),
            Text(
              'Date: 2024 DEC 15',
              style: TextStyle(
                color: AppColors.defaultWhite,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 50,
                      color: AppColors.defaultWhite,
                    ),
                    Text(
                      'Today Collection',
                      style: TextStyle(
                        color: AppColors.defaultWhite,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Rs 15000.00',
                      style: TextStyle(
                        color: AppColors.defaultWhite,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 50,
                      color: AppColors.defaultWhite,
                    ),
                    Text(
                      'Month Collection',
                      style: TextStyle(
                        color: AppColors.defaultWhite,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Rs 150000.00',
                      style: TextStyle(
                        color: AppColors.defaultWhite,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
