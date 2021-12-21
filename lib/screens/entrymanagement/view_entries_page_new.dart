import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './entries_class.dart';
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
          .collection("expenses/cFqsqHPIscrC6cY9iPs6/expense")
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
          .collection("expenses/cFqsqHPIscrC6cY9iPs6/income")
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
  // for (var i; i < data.keys.length; i++) {
  //   data_list.add(FlSpot(i.toDouble(), data[data.keys.elementAt(i)]));
  // }
  //int i = 0;
  //int index = 0;
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
  print(incomes);

  List <String> datesAdded = [];
  List <Widget> expansionChildren = [];

  //print(date.reversed);



  var expansiontiles = <Widget>[];
  for(String d in date.reversed){
    expansionChildren = [];
    for(Entries exp in expenses){
      if (d == exp.date){
        expansionChildren.add(Card(
          //margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

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
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
          //margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

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
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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

    expansiontiles.add(ExpansionTile(title: Text(d),
      initiallyExpanded: true,
      children: expansionChildren,)
    );

  }




  return Container(
    child: SingleChildScrollView(
      child: Column(
        children: expansiontiles,
      ),
    ),
  );
}

class ViewEntriesPage extends StatefulWidget {
  final String title;

  const ViewEntriesPage({Key? key, required this.title}) : super(key: key);

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
      body: Column(
        children: [
          Expanded(flex: 1, child: _getExpenses(context)),
        ],
      )
    );
  }
}

/*
if(datesAdded.contains(d)){
        for(Entries exp in expenses){
          if (d == exp.date){
            expansionChildren.add(Card(
              //margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

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
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
              //margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

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
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
      }
      else{
        datesAdded.add(d);
        expansionChildren = [];

        //expansionChildren.add();
        for(Entries exp in expenses){
          if (d == exp.date){
            expansionChildren.add(Card(
              //margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

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
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
            //margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

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
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
        return ExpansionTile(title: Text(d),
        initiallyExpanded: true,
        children: expansionChildren,);

      };
 */