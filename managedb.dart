//import 'package:flutter/material.dart';
import './category.dart';

class FireStoreManager {

  mapCategoryToList(Map map) {
    for(int i = 0; i < map.length; i++){
      Category category = Category(
        budget: map[i]['budget'],
        label: map[i]['label'],
      );
      catList.add(category);
    }
  }

  //write  data to firestore
  //Future addExpense;

}