import 'package:teddy_the_tracker/components/rounded_button.dart';
import 'package:teddy_the_tracker/constants.dart';
import 'package:teddy_the_tracker/screens/blank_screen.dart';
import 'package:teddy_the_tracker/screens/chat_screen.dart';
import 'package:teddy_the_tracker/screens/welcome_screen.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teddy_the_tracker/components/rounded_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
      Icon(Icons.home, size: 30),
      Icon(Icons.view_agenda_outlined, size: 30),
      Icon(Icons.add_rounded, size: 30),
      Icon(Icons.analytics_outlined, size: 30),
      Icon(Icons.person, size: 30),
    ];
    const pages = [
      Blank(),
      Blank(),
      Blank(),
      Blank(),
      Blank(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 0,
        centerTitle: true,
      ),
      body: pages[selected],
      backgroundColor: mainColorList[3],
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: mainColorList[2])),
        child: CurvedNavigationBar(
          items: items,
          height: MediaQuery.of(context).size.height * 0.06,
          backgroundColor: Colors.transparent,
          index: selected,
          animationDuration: const Duration(milliseconds: 350),
          onTap: (index) => setState(() => this.selected = index),
        ),
      ),
    );
  }
}
