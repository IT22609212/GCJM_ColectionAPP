import 'package:flutter/material.dart';
import 'package:gcjm_collection_app/Screens/Dp_page.dart';
import 'package:gcjm_collection_app/color/AppColors.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // List of area names
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
    return Scaffold(
      appBar: customAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 280),
            Padding(
              padding: EdgeInsets.all(16),
              child: AreaGrid(areas: areas),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget customAppBar() {
    return AppBar(
      backgroundColor: AppColors.baseColor,
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/images/logo.jpg'),
                    radius: 20,
                  ),
                ),
              ],
            ),
          ),
          // You can add more widgets on top or below the existing widget inside the Stack
          // add the curvedContainer() here if you want it to be part of the app bar
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: curvedContainer(),
          ),
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: CollectionCard(),
          ),
        ],
      ),
    );
  }

  Widget curvedContainer() {
    return Container(
      height: 150,
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

  const AreaGrid({Key? key, required this.areas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> areaScreens = {
      // Map each area to its corresponding screen
      'DP': DematagodePlace(),
    };

    // Adjust height as needed
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: areas.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Debugging and navigation logic
            final area = areas[index];
            print('Tapped: $area'); // Debug print
            if (areaScreens.containsKey(area)) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => areaScreens[area]!),
              );
            } else {
              print('No screen mapped for $area');
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 217, 220, 221),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                areas[index],
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.baseColor),
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
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 180,
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          children: [
            SizedBox(height: 20),
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
