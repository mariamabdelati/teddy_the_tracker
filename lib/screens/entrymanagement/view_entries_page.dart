import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ViewEntriesPage extends StatefulWidget {
  final String title;
  const ViewEntriesPage({Key? key, required this.title}) : super(key: key);

  @override
  _ViewEntriesPageState createState() => _ViewEntriesPageState();
}

class _ViewEntriesPageState extends State<ViewEntriesPage> {

  final CollectionReference expenseRef = FirebaseFirestore.instance
      .collection('/expenses/cFqsqHPIscrC6cY9iPs6/expense');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        /*leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),*/
      ),
      //form containing list view of the fields
      body: StreamBuilder(
          stream: expenseRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget("Something went wrong");
            } else
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final data = snapshot.requireData;
            return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index){
                return Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        /*width: 100,*/
                        margin: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15
                        ),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            border: Border.all(
                              color:Color(0xFF5689B9),
                              width: 2,
                            )
                        ),
                        padding: const EdgeInsets.all(7),
                        child: Text('EGP ' + data.docs[index]['amount'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xFF5689B9),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(data.docs[index]['label'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(data.docs[index]['date'],
                            style: const TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}