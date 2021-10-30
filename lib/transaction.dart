// import 'package:flutter/material.dart';

class Transaction
{
  String title = '_';
  double amount = 0;

  //constructor
  Transaction(String title, double amount)
  {
    this.title = title;
    this.amount = amount;
  }

  //setters
  void set_title(String title){
    this.title = title;
  }
  void set_amount(double amount){
    this.amount = amount;
  }

  //getters
  String get_title(){
    return title;
  }

  double get_amount(){
    return amount;
  }
}