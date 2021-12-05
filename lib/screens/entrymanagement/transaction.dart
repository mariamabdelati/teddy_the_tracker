// import 'package:flutter/material.dart';

class Transaction {
  String title = '_';
  double amount = 0;

  //constructor
  Transaction(this.title, this.amount);

  //setters
  void setTitle(String title) {
    this.title = title;
  }

  void setAmount(double amount) {
    this.amount = amount;
  }

  //getters
  String getTitle() {
    return title;
  }

  double getAmount() {
    return amount;
  }
}
