import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
//import '../../screens/categorymanagement/subcategory_expansion_tile.dart';
//import 'package:teddy_categories/constants.dart';
//import 'package:teddy_categories/screens/dashboard/pie_chart.dart';

import '../../constants.dart';
import '../categorymanagement/create_new_category.dart';
import '../walletsmanagement/switch_wallet_screen.dart';
import 'balance_progress_bar.dart';
import 'dashboard_charts.dart';
import 'globals.dart';
import 'line_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  bool dashboard = true;

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: dashboard ? const Text('Dashboard') : const Text('Switch Wallet'),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(screenHeight),
          _buildChartsSection(screenHeight),
        ],
      ),
    );
  }

  var x = FirebaseAuth.instance.currentUser!.reload();
  var user_name = FirebaseAuth.instance.currentUser!.displayName;
  var wallet_name = globals.getWallet()["name"] ?? "George";
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
            GestureDetector(
              onTap: () {
                setState(() {
                  dashboard = false;
                });
                showModalBottomSheet(
                  barrierColor: Colors.black.withAlpha(1),
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 40.0,
                  //backgroundColor: mainColorList[1],
                  context: context,
                  builder: (BuildContext context) {
                    return const SwitchWallet();
                  },
                ).whenComplete(() {
                  setState(() {
                    dashboard = true;
                  });
                });
              },
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'HI, $user_name'.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFFFD2CE), //const Color(0xFF1D67A6),
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(
                      Icons.autorenew_rounded,
                      size: 23,
                      color: Color(0xFFFFD2CE),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'VIEWING $wallet_name'.toUpperCase(),
              style: const TextStyle(
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
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: _getExpenses(context),
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
        width: 700,
        child: ChartsPageView(),
      ),
    );
  }
}

Widget _getExpenses(context) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/expense")
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong",
              style: TextStyle(color: Colors.white));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          List<Entries> expenses = snapshot.data!.docs
              .map((docSnapshot) =>
              Entries.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return Container(
            child: _getIncomes(context, expenses),
          );
        }
      });
}

Widget _getIncomes(context, List<Entries> expenses) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/income")
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("error retreiving income");
          return const Text("Something went wrong",
              style: TextStyle(color: Colors.white));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          List<Entries> incomes = snapshot.data!.docs
              .map((docSnapshot) =>
              Entries.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return Container(
            child: _buildBody(context, expenses, incomes),
          );
        }
      });
}

Widget _buildBody(context, List<Entries> expenses, List<Entries> incomes) {
  double expTotal = 0;
  double incTotal = 0;
  for (var entry in expenses.toList()) {
    expTotal += double.parse(entry.amount as String);
  }

  for (var entry in incomes.toList()) {
    incTotal += double.parse(entry.amount as String);
  }

  String balance = "0";
  double percentage = 0;
  if (incTotal < expTotal){
    balance = (incTotal-expTotal).toString();
    percentage = 1;
  } else{
    balance = (incTotal-expTotal).toString();
    print(balance);
    percentage = (incTotal-expTotal)/incTotal;
  }

  return Container(
    child: RadialProgress(balance, percentage),
  );


}