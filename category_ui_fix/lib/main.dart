import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teddy_categories/screens/category_expansion_tile.dart';

import 'Ali/view_entries.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AddEntry());
}

class AddEntry extends StatelessWidget {
  const AddEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Custom Categories",
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





