import 'package:flutter/material.dart';
import './user_transactions.dart';
import './transaction.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payroll',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget{
  var titleController = TextEditingController();
  var amountController = TextEditingController();
  Transaction t1 = new Transaction('title', 0);

  final List<Transaction> transactions_list = [

  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Teddy The Tracker'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              // not currently working
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  //return NewTransaction();
                  return Container(
                    height: 400,
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            'Add New Transaction',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),
                          ),
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
                                
                              }
                          ),
                          ElevatedButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
              },);
            },
          ),
        ],
      ),
      body:
      Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              UserTransactions()
            ],
          ),
        ),
      )
    );
  }
}
