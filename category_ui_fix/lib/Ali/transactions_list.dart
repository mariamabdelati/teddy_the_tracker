import 'package:flutter/material.dart';
import './transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList(this.transactions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: transactions.map((transaction) {
          return Card(
              child: Text(
            transaction.getTitle() +
                ', ' +
                transaction.getAmount().toString(),
          ));
        }).toList());
  }
}
