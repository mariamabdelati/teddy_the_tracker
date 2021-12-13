import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teddy_the_tracker/screens/walletmanagement/wallet_screen.dart';
//import 'package:teddy_categories/constants.dart';
//import 'package:teddy_categories/screens/dashboard/pie_chart.dart';

import '../categorymanagement/create_new_category.dart';
import 'balance_progress_bar.dart';
import 'dashboard_charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
          elevation: 0,
        ),
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            _buildHeader(screenHeight),
            _buildChartsSection(screenHeight),
          ],
        ));
  }

  var x = FirebaseAuth.instance.currentUser!.reload();
  var user_name = FirebaseAuth.instance.currentUser!.displayName;
  SliverToBoxAdapter _buildHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Color(0xFF0C41CD),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.1, 1.1),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'HI, $user_name',
                  style: TextStyle(
                    color: Color(0xFFFFD2CE), //const Color(0xFF1D67A6),
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEFC7),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  //margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFFFEFC7),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WalletChoosing()));
                      },
                      child: const Center(
                        child: Text(
                          "Switch Wallet",
                          style:
                              TextStyle(color: Color(0xFF1D67A6), fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'VIEWING YOUR WALLET',
              style: TextStyle(
                  fontSize: 12.0, color: Color(0xFFFFBDB8), letterSpacing: 1.5),
            ),
            SizedBox(height: screenHeight * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Your Balance',
                  style: TextStyle(
                    color: Color(0xFFFFEDEC),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: RadialProgress(),
                    )),
                //SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildChartsSection(double screenHeight) {
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: 450,
        width: 400,
        child: ChartsPageView(),
      ),
    );
  }
}
