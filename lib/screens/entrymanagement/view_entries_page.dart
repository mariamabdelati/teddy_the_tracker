import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';
//import 'package:firebase_core/firebase_core.dart';

class ViewEntriesPage extends StatefulWidget {
  final String title;
  final ScrollController controller;

  const ViewEntriesPage({Key? key, required this.title, required this.controller}) : super(key: key);

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
            return const Center(
                child: Text("Something went wrong",
                    style: TextStyle(color: Color(0xFFD32F2F))));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final data = snapshot.requireData;
          return ListView.builder(
            controller: widget.controller,
            itemCount: data.size,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return Card(
                //margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

                //margin: EdgeInsets.symmetric(horizontal: 10),
                elevation: 2,
                color: mainColorList[1],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: <Widget>[
                    Container(
                      /*width: 100,*/
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(
                            color: const Color(0xFF5689B9),
                            width: 2,
                          )),
                      padding: const EdgeInsets.all(7),
                      child: Text(
                        'EGP ' + data.docs[index]['amount'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xFF5689B9),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            data.docs[index]['label'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            data.docs[index]['date'],
                            style: const TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFD32F2F),
                              padding: const EdgeInsets.all(15),
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete Entry'),
                                    content: const Text(
                                        'Are you sure you want to delete this entry?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final expensePath =
                                          expenseRef.doc(ds.id);
                                          await expensePath.delete();
                                          Navigator.pop(context, 'Cancel');
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Color(0xFFD32F2F),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}