import 'package:flutter/material.dart';
import './transaction.dart';

class TransactionList extends StatelessWidget{

  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context){
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:
        transactions.map((transaction){
          return Card(child: Text(transaction.get_title() + ', ' + transaction.get_amount().toString(),));
        }).toList()
    );


  }
}