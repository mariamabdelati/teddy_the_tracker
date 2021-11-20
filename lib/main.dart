import 'package:teddy_categories/screens/dashboard/dashoard_screen.dart';

import '../../screens/entrymanagement/view_entries.dart';
import '../../screens/registration/auth_screen.dart';
//import '../../screens/welcome/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Teddy the Tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Nunito",
        appBarTheme: AppBarTheme(color: mainColorList[2]),
        backgroundColor: const Color(0xFFECF4FB),//
        primarySwatch: MaterialColor(0xFF164CC4, color),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //bottomSheetTheme: BottomSheetThemeData(
        //backgroundColor: Colors.black.withOpacity(0)),
        //canvasColor: Colors.transparent,
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: const Color(0xFFF6BAB5),
            textTheme: ButtonTextTheme.primary,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
      home: const DashboardScreen(),/*const ViewEntries()Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: const AuthScreen(true),
        ),
      ),*//*const ViewEntries(),*/
    );
      //home: const WelcomeScreen(),//const ViewEntries(),//const CategoryExpansionTile(),
    //);
  }
}



//FINISHED ADDING AN APP THEME







/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:teddy_categories/screens/category_expansion_tile.dart';

import 'Ali/view_entries.dart';



class AddEntry extends StatelessWidget {
  const AddEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: "Custom Categories",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF0938B6)),
        backgroundColor: const Color(0xFFECF4FB),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //bottomSheetTheme: BottomSheetThemeData(
            //backgroundColor: Colors.black.withOpacity(0)),
        //canvasColor: Colors.transparent,
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: const Color(0xFFF6BAB5),
            textTheme: ButtonTextTheme.primary,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
      home: const ViewEntries(),//const CategoryExpansionTile(),
    );
  }
}

*/
