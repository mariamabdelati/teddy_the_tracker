import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final Function addTransaction;

  var titleController = TextEditingController();
  var amountController = TextEditingController();

  NewTransaction(this.addTransaction);

  @override
  Widget build(BuildContext context){
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
              decoration: InputDecoration(
                hintText: 'Enter the title for your expense',
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
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
                  addTransaction(titleController.text, double.parse(amountController.text));
                }
            ),
          ],
        ),
      ),
    );
  }

}