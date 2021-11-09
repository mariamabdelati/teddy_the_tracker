import 'package:flutter/material.dart';
import 'package:teddy_the_tracker/expenses_page.dart';
import './user_transactions.dart';

class main_body extends StatefulWidget {
  const main_body({Key? key}) : super(key: key);

  @override
  mainbodyState createState() => mainbodyState();
}

class mainbodyState extends State<main_body> {


  @override
  Widget build(BuildContext context) {
    return  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
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
    ),
   Container(
       alignment: Alignment.bottomRight,
     padding: const EdgeInsets.all(8.0),
     child: ElevatedButton(
         child: const Text('Add Expense'),
         onPressed: () {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => ExpensePage()),
           );
         }
     ),
   )
    ]
    );
  }
}
