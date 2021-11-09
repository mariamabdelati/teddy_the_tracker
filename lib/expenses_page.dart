import 'package:flutter/material.dart';
class ExpensePage extends StatefulWidget {
  @override
  ExpensePageState createState() => ExpensePageState();
}

class ExpensePageState extends State<ExpensePage> {

  var titleController = TextEditingController();
  var amountController = TextEditingController();
  var initial_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  Text('Choose a date ',
                      style: const TextStyle(fontSize: 20)
                  ),
                  ElevatedButton(
                      child: const Text('Date'),
                      onPressed: () {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2022)
                        );


                      },

                  ),
                ],
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


