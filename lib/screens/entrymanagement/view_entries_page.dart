import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import '../../constants.dart';
//import 'package:firebase_core/firebase_core.dart';

class Entries {
  Entries(this.date, this.amount, this.label);
  String? date;
  String? amount;
  String? label;
  DocumentReference? reference;

  int year = 2021;
  int month = 12;
  int day = 10;

  void cleanDate() {
    var data = date!.split("-");
    year = int.parse(data[0]);
    month = int.parse(data[1]);
    day = int.parse(data[2]);
  }

  Entries.fromMap(Map<String, dynamic> map, {this.reference}) {
    date = map["date"];
    amount = map["amount"];
    label = map["label"];
    cleanDate();
  }

/* @override
  String toString() => "Entry<$label : $year,$month,$day : $amount\$";*/
}

// widget responsible for fetching the data from firebase and convert them to List <Entries>
Widget _getExpenses(context) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/expense")
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong",
              style: TextStyle(color: Colors.white));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          List<Entries> expenses = snapshot.data!.docs
              .map((docSnapshot) =>
              Entries.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return Container(
            child: _getIncomes(context, expenses),
          );
        }
      });
}

Widget _getIncomes(context, List<Entries> expenses) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/income")
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("error retreiving income");
          return const Text("Something went wrong",
              style: TextStyle(color: Colors.white));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          List<Entries> incomes = snapshot.data!.docs
              .map((docSnapshot) =>
              Entries.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return Container(
            child: _buildBody(context, expenses, incomes),
          );
        }
      });
}

// Widget responsible for converting List <Entries> to List <FlSpot>
Widget _buildBody(context, List<Entries> expenses, List<Entries> incomes) {
  Map expensesData = {};
  Map incomesData = {};
  List<String> dates = [];

  for (var entry in expenses.reversed.toList()) {
    if (expensesData.containsKey(entry.date)) {
      expensesData[entry.date] =
          expensesData[entry.date] + double.parse(entry.amount as String);
    } else {
      expensesData[entry.date] = double.parse(entry.amount as String);
    }
  }
  for (var entry in incomes.reversed.toList()) {
    if (incomesData.containsKey(entry.date)) {
      incomesData[entry.date] =
          incomesData[entry.date] + double.parse(entry.amount as String);
    } else {
      incomesData[entry.date] = double.parse(entry.amount as String);
    }
  }

  List<String> date = [];
  expensesData.forEach((k, v) {
    if (!date.contains(k)) {
      date.add(k);
    }
  });
  incomesData.forEach((k, v) {
    if (!date.contains(k)) {
      date.add(k);
    }
  });
  date.sort();

  List <Widget> expansionChildren = [];

  var expansiontiles = <Widget>[];
  for(String d in date.reversed){
    expansionChildren = [];
    for(Entries exp in expenses){
      if (d == exp.date){
        expansionChildren.add(Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
          //margin: EdgeInsets.symmetric(horizontal: 10),
          elevation: 2,
          //color: mainColorList[1],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          child:
          Row(
            children: <Widget>[
              Container(
                width: 100,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    )),
                padding: const EdgeInsets.all(7),
                child: Text(
                  'EGP ' + exp.amount.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      exp.label.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      exp.date.toString(),
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
                                  onPressed: ()  {
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
        ),);
      }
    }
    for(Entries inc in incomes){
      if(d == inc.date){
        expansionChildren.add(Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),

          //margin: EdgeInsets.symmetric(horizontal: 10),
          elevation: 2,
          //color: mainColorList[1],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          child:
          Row(
            children: <Widget>[
              Container(
                width: 100,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    )),
                padding: const EdgeInsets.all(7),
                child: Text(
                  'EGP ' + inc.amount.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      inc.label.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      inc.date.toString(),
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
                                  onPressed: ()  {
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
        ),);
      }
    }

    expansiontiles.add(Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(title: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Text(d, style: const TextStyle(fontWeight: FontWeight.w900),),
      ),
        initiallyExpanded: true,
        children: expansionChildren,),
    )
    );
  }

  return Column(
    children: expansiontiles,
  );
}

class ViewEntriesPage extends StatefulWidget {
  final String title;
  final ScrollController controller;

  const ViewEntriesPage({Key? key, required this.title, required this.controller}) : super(key: key);

  @override
  ViewEntriesPageState createState() => ViewEntriesPageState();
}

class ViewEntriesPageState extends State<ViewEntriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Entries'),
        ),
        //form containing list view of the fields
        body: SingleChildScrollView(
            controller: widget.controller,
            child: _getExpenses(context))
    );
  }
}

//old code
/*
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
      .collection('/entries/7sQnsmHSjX5K8Sgz4PoD/expense');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        */
/*leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),*//*

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
                      */
/*width: 100,*//*

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
*/