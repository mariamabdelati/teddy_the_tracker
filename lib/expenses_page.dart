import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'mariam/category_expansion_tile.dart';


class ExpensePage extends StatefulWidget {
  @override
  ExpensePageState createState() => ExpensePageState();
}

class ExpensePageState extends State<ExpensePage> {

  var titleController = TextEditingController();
  var amountController = TextEditingController();

  var tite_var = '';
  var amount_var = '';

  var initial_date = DateTime.now();
  bool isChecked = false;
  CollectionReference expenseRef = FirebaseFirestore.instance.collection('/expenses/cFqsqHPIscrC6cY9iPs6/expense');

  var _dateTime = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2023))
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //alignment: Alignment.topCenter,

        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              Container(
                color: Colors.white,
                height: 75,
              ),
              const Text(
                'Add New Expense',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
              ),
              Container(
                height: 10,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter the title for your expense',
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(
                height: 10,
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
              Container(
                height: 10,
              ),
              Row(
                children: [
                  Text('  Choose a date                                     ',
                      style: const TextStyle(fontSize: 20)
                  ),
                  ElevatedButton(
                      child: const Text('Date'),
                      onPressed: () {
                        //get date here
                        _showDatePicker();
                      },

                  ),
                ],
              ),
          Row(
            children: [
              Text('  Recurring?                                             ',
                  style: const TextStyle(fontSize: 20)
              ),
              Checkbox(
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
            ],
          ),
              /*Container(
                height: double.infinity,
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                      child: CategoryExpansionTile())),*/
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: ElevatedButton(
                    child: const Text('Confirm'),
                    onPressed: () async {
                      //save to firebase
                      tite_var = titleController.text.toString();
                      amount_var = amountController.text.toString();


                      await expenseRef.add({
                        'amount':amount_var,
                        'categoryId':1,
                        'date':_dateTime.toString(),
                        'expenseId':2,
                        'label': tite_var.toLowerCase(),
                        'recurring': isChecked,

                      }).then((value) => print ("amount added"));

                      // print ('$titleController');
                      // print ('$amountController');
                      // print (_dateTime.toString());
                      // print (isChecked.toString());

                    }
                ),
              ),

              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ),
            ]
        ),
      ),
    );
  }
}


