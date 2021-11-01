//import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final num budget;
  //final num categoryID;
  //final Map<num, List<num>> subcat;
  final String label;
  //final num parentID;

  Category({this.budget, this.label, /*this.categoryID, this.subcat,  this.parentID*/});

}

List<Category> catList = [];

List<String> entryCategories = [
  "Food",
  "Clothing",
  "Transportation",
  "Savings",
  "Medical",
  "Utilities",
  "Subscriptions",
  "Other"
];

/*
  Map<String, IconData> icons = {
  "Food": Icons.fastfood,
  "Clothing": ,
  "Transportation": FontAwesomeIcons.car,
  "Savings" : ,
  "Medical": ,
  "Utilities": ,
  "Subscriptions": ,
  };
 */