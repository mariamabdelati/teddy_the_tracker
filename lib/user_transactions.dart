import 'package:flutter/material.dart';
import './new_transactions.dart';
import './transactions_list.dart';
import './transaction.dart';

class UserTransactions extends StatefulWidget {




  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}
class _UserTransactionsState extends State<UserTransactions>{
  final List<Transaction> _userTransactions = [

    //adding expenses manually

    Transaction('Food', 50),
    Transaction('Rent', 1000),
    Transaction('Shopping', 90),
    Transaction('Games', 60),
    Transaction('Gas', 30),
  ];

  void _addNewTransaction(String title, double amount){
    final newTransaction = Transaction(title, amount);

    setState(() {
      _userTransactions.add(newTransaction);
    });

  }

  Widget build(BuildContext context){
    return Column(
      children: <Widget>[NewTransaction(_addNewTransaction),TransactionList(_userTransactions)],

    );

  }

}