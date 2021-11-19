import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class View_Entries_Firebase extends StatefulWidget {
  final String title;
  const View_Entries_Firebase({Key? key, required this.title}) : super(key: key);

  @override
  _View_Entries_FirebaseState createState() => _View_Entries_FirebaseState();
}

class _View_Entries_FirebaseState extends State<View_Entries_Firebase> {

  final CollectionReference expenseRef = FirebaseFirestore.instance
      .collection('/expenses/cFqsqHPIscrC6cY9iPs6/expense');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.title),
    leading: IconButton(
    onPressed: () {
    Navigator.pop(context);
    },
    icon: const Icon(Icons.arrow_back_rounded),
    ),
    ),
    //form containing list view of the fields
    body:StreamBuilder(
      stream: expenseRef.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return ListView(
          children: snapshot.data!.docs.map((exp) {
            /*return Center(
              child: ListTile(
                title: Text(exp['label']),
              ),
            );*/
            return Card(
              child: Row(
                children: <Widget>[
                Container(
                  /*width: 100,*/
                  margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:Color(0xFF5689B9),
                        width: 3,
                      )
                  ),
                  padding: EdgeInsets.all(7),
                  child: Text('EGP '+exp['amount'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF5689B9),

                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                  Text(exp['label'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(exp['date'],
                  style: TextStyle(
                    color: Colors.black45,

                  ),
                  ),
                ],

                ),
              ],),

            );
          }).toList(),
        );
      }),
    );
  }
}
