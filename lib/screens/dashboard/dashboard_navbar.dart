import 'package:teddy_the_tracker/screens/dashboard/hide_navbar.dart';
import 'package:teddy_the_tracker/screens/walletmanagement/wallet_screen.dart';

import '../../screens/entrymanagement/add_entries_page.dart';
import '../../screens/entrymanagement/view_entries_page.dart';
import '../../screens/profilemanagement/profile.dart';
import '../../constants.dart';
import "package:flutter/material.dart";
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'blank.dart';
import 'dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int selected = 0;
  @override
  Widget build(BuildContext context) {
    const items = <Widget>[
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(EvaIcons.homeOutline, size: 25),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(Icons.receipt_long_rounded, size: 27),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(Icons.add_rounded, size: 27),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(Icons.assessment_outlined, size: 27),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(Icons.person_outline_rounded, size: 27),
      ),
    ];
    List<Widget> pages = [
      const DashboardPage(),
      const ViewEntriesPage(title: "View All Entries"),
      AddNewEntryPage(
        controller: controller,
        title: 'Create New Entry',
      ),
      const WalletChoosing(),
      const Profile(),
    ];
    return Scaffold(
      body: pages[selected],
      bottomNavigationBar: HideWidget(
        controller: controller,
        child: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: iconsColor),
          ),
          child: CurvedNavigationBar(
            items: items,
            height: MediaQuery.of(context).size.height * 0.08,
            color: mainColorList[1],
            backgroundColor: Colors.transparent,
            index: selected,
            animationDuration: const Duration(milliseconds: 350),
            onTap: (index) => setState(() => selected = index),
          ),
        ),
      ),
    );
  }
}
