import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/categorymanagement/subcategory_expansion_tile.dart';
import '../../screens/dashboard/globals.dart';
import '../dashboard/expense_pie_chart.dart';

class Entries {
  Entries(this.date, this.amount, this.label);
  String? date;
  String? amount;
  String? label;
  int? expenseID;
  int? incomeID;
  int? categoryID;
  int? subcategoryID;
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
    expenseID = map["expenseID"];
    incomeID = map["incomeID"];
    categoryID = map["categoryID"];
    subcategoryID = map["subcategoryID"];
    cleanDate();
  }
}
void deleteExpense(int id) async {
  QuerySnapshot categoriesRef = await FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .where("expensesIDs", arrayContains: id)
      .get();

  // deletes it from all the categories
  for (int i = 0; i < categoriesRef.docs.length; i++) {
    var catDoc = categoriesRef.docs[i];
    var existingExpenses = catDoc["expenseIDs"];
    existingExpenses.remove(id);

    FirebaseFirestore.instance
        .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
        .doc(catDoc.id)
        .set({"expenseIDs": existingExpenses}, SetOptions(merge: true));
  }
  // deletes the actual document
  QuerySnapshot expenseRef = await FirebaseFirestore.instance
      .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/expense")
      .where("expenseID", isEqualTo: id)
      .get();

  var exp = expenseRef.docs[0];

  FirebaseFirestore.instance
      .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/expense")
      .doc(exp.id)
      .delete();
}

void deleteIncome(int id) async {
  QuerySnapshot incomeRef = await FirebaseFirestore.instance
      .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/income")
      .where("incomeID", isEqualTo: id)
      .get();

  QuerySnapshot categoriesRef = await FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .where("incomeIDs", arrayContains: id)
      .get();

  // deletes it from all the categories
  for (int i = 0; i < categoriesRef.docs.length; i++) {
    var catDoc = categoriesRef.docs[i];
    var existingIncomes = catDoc["incomeIDs"];
    existingIncomes.remove(id);

    FirebaseFirestore.instance
        .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
        .doc(catDoc.id)
        .set({"incomeIDs": existingIncomes}, SetOptions(merge: true));
  }
  var inc = incomeRef.docs[0];

  FirebaseFirestore.instance
      .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/income")
      .doc(inc.id)
      .delete();
}

// widget responsible for fetching the data from firebase and convert them to List <Entries>
Widget _getExpenses(context) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/expense")
          .where("walletID", isEqualTo: (globals.getWallet()["walletID"]))
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
          .where("walletID", isEqualTo: (globals.getWallet()["walletID"]))
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
              child: _getCategories(context, expenses, incomes)
          );
        }
      });
}

Widget _getCategories(context, List<Entries> expenses, List<Entries> incomes) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
          .where("walletID", isEqualTo: (globals.getWallet()["walletID"])).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("error retreiving categories");
          return const Text("Something went wrong",
              style: TextStyle(color: Colors.white));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          List<Categories> categories = snapshot.data!.docs
              .map((docSnapshot) =>
              Categories.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return Container(
            child: _buildBody(context, expenses, incomes, categories),
          );
        }
      });
}

// Widget responsible for converting List <Entries> to List <FlSpot>
Widget _buildBody(context, List<Entries> expenses, List<Entries> incomes, List<Categories> categories) {
  Map expensesData = {};
  Map incomesData = {};
  Map categoriesData = {};

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

  for (var category in categories.toList()) {
    categoriesData[category.catID] = category.label;
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
        String subcategoryName = "";
        String categoryName = categoriesData[exp.categoryID];
        if (exp.subcategoryID != -1){
          subcategoryName = categoriesData[exp.subcategoryID];
        }
        expansionChildren.add(Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            exp.label.toString().capitalize,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            categoryName.capitalize,
                            style: const TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          if (subcategoryName.isNotEmpty)
                            Text(
                              subcategoryName.capitalize,
                              style: const TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                        var expLabel = exp.label.toString().capitalize;
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Delete Entry',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Are you sure you want to delete '$expLabel' from your entries?",
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                          ),
                                          child: Text('Cancel'),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        const SizedBox(width: 15.0,),
                                        ElevatedButton(
                                          child: Text('Delete'),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))  ,
                                            primary: const Color(0xFFD32F2F),
                                          ),
                                          onPressed: () {
                                            deleteExpense(exp.expenseID!.toInt());
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
        String subcategoryName = "";
        String categoryName = categoriesData[inc.categoryID];
        if (inc.subcategoryID != -1){
          subcategoryName = categoriesData[inc.subcategoryID];
        }
        expansionChildren.add(Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),

          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            inc.label.toString().capitalize,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            categoryName.capitalize,
                            style: const TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          if (subcategoryName.isNotEmpty)
                            Text(
                              subcategoryName.capitalize,
                              style: const TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                        var incLabel = inc.label.toString().capitalize;
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Delete Entry',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Are you sure you want to delete '$incLabel' from your entries?",
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                          ),
                                          child: Text('Cancel'),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        const SizedBox(width: 15.0,),
                                        ElevatedButton(
                                          child: Text('Delete'),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))  ,
                                            primary: const Color(0xFFD32F2F),
                                          ),
                                          onPressed: () {
                                            deleteIncome(inc.incomeID!.toInt());
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
          centerTitle: true,
        ),
        //form containing list view of the fields
        body: SingleChildScrollView(
            controller: widget.controller,
            child: _getExpenses(context))
    );
  }
}
