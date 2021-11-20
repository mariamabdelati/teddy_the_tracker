import 'package:teddy_the_tracker/screens/dashboard/blank.dart';
import '../../screens/entrymanagement/add_entries_page.dart';
import '../../screens/entrymanagement/view_entries_page.dart';
import '../../constants.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'blank.dart';
import 'dashboard_charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
    const pages = [
      Blank(),
      ViewEntriesPage(title: "View All Entries"),
      AddNewEntryPage(title: 'Create New Entry',),
      Blank(),
      Blank(),
    ];
    return Scaffold(
      /*appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 0,
        centerTitle: true,
      ),*/
      body: pages[selected],
      backgroundColor: mainColorList[3],
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: iconsColor), ),
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
    );
  }
}