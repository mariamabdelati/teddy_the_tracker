/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:teddy_the_tracker/constants.dart';

import '../../models/expense_model.dart';

class Piechart extends StatefulWidget {
  const Piechart({Key? key}) : super(key: key);

  @override
  _PiechartState createState() => _PiechartState();
}

class _PiechartState extends State<Piechart> {
  late List<Expense> _getexpense = [];

  Map<String, double> getCategoryData() {
    Map<String, double> catMap = {};
    for (var item in _getexpense) {
      print(item.categoryId);
      if (catMap.containsKey(item.categoryId) == false) {
        catMap[item.categoryId] = 1;
      }
      else {
        catMap.update(item.categoryId, (int) => catMap[item.categoryId]! + 1);
        // test[item.category] = test[item.category]! + 1;
      }
      print(catMap);
    }
    return catMap;
  }



  Widget CategoryPieChart(){
    return PieChart(
      dataMap: getCategoryData(),
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: mainColorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      centerText: "CATEGORIES",
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }

  final Stream<QuerySnapshot> expStream = FirebaseFirestore.instance.collection('/expenses/cFqsqHPIscrC6cY9iPs6/expense').snapshots();

  void getExpfromSanapshot(snapshot) {
    if (snapshot.docs.isNotEmpty) {
      _getexpense = [];
      for (int i = 0; i < snapshot.docs.length; i++) {
        var a = snapshot.docs[i];
        // print(a.data());
        Expense exp = Expense.fromJson(a.data());
        _getexpense.add(exp);
        // print(exp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              StreamBuilder<Object>(
                stream: expStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final data = snapshot.requireData;
                  print("Data: $data");
                  getExpfromSanapshot(data);
                  const Piechart();
                },
              ),
            //Container(height: 80,child: ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
