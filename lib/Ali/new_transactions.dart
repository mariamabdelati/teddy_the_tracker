import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final Function addTransaction;

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  NewTransaction(this.addTransaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.white,
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter the title for your expense',
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                hintText: 'Enter the amount for your expense',
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
                child: const Text('Confirm'),
                // save data
                onPressed: () {
                  addTransaction(titleController.text,
                      double.parse(amountController.text));
                }),
          ],
        ),
      ),
    );
  }
}
