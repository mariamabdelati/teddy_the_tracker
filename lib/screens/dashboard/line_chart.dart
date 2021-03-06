import 'dart:collection';
import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'globals.dart';

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

  @override
  String toString() => "Entry<$label : $year,$month,$day : $amount\$";
}

// widget responsible for fetching the data from firebase and convert them to List <Entries>
Widget _getExpenses(context) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/expense")
          .where("walletID", isEqualTo: globals.getWallet()["walletID"])
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
          .where("walletID", isEqualTo: globals.getWallet()["walletID"])
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
  if (expenses.isEmpty) {
    expenses.add(Entries(" ", "0", ""));
  }
  if (incomes.isEmpty) {
    incomes.add(Entries(" ", "0", ""));
  }

  for (var entry in expenses.toList()) {
    if (expensesData.containsKey(entry.date)) {
      expensesData[entry.date] =
          expensesData[entry.date] + double.parse(entry.amount as String);
    } else {
      expensesData[entry.date] = double.parse(entry.amount as String);
    }
  }
  for (var entry in incomes.toList()) {
    if (incomesData.containsKey(entry.date)) {
      incomesData[entry.date] =
          incomesData[entry.date] + double.parse(entry.amount as String);
    } else {
      incomesData[entry.date] = double.parse(entry.amount as String);
    }
  }
  List<FlSpot> expensesList = [];
  List<FlSpot> incomesList = [];
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
  expensesData.forEach((k, v) {
    expensesList
        .add(FlSpot(date.indexWhere((element) => element == k).toDouble(), v));
  });
  incomesData.forEach((k, v) {
    incomesList
        .add(FlSpot(date.indexWhere((element) => element == k).toDouble(), v));
  });

  expensesList.sort((a, b) {
    double ax = a.x;
    double bx = b.x;
    if (ax > bx) {
      return 1;
    } else if (ax == bx) {
      return 0;
    } else {
      return -1;
    }
  });
  incomesList.sort((a, b) {
    double ax = a.x;
    double bx = b.x;
    if (ax > bx) {
      return 1;
    } else if (ax == bx) {
      return 0;
    } else {
      return -1;
    }
  });

  if (expensesList[0].x != 0) {
    expensesList = [FlSpot(0, 0), ...expensesList];
  }
  if (expensesList.last.x != date.length - 1) {
    expensesList.add(FlSpot(date.length - 1, 0));
  }
  if (incomesList[0].x != 0) {
    incomesList = [const FlSpot(0, 0), ...incomesList];
    print("added the zero to incomes");
  }
  if (incomesList.last.x != date.length - 1) {
    incomesList.add(FlSpot(date.length - 1, 0));
  }

  return Container(
    child: _buildChart(context, expensesList, incomesList, date),
  );
}

// Widget responsible for using List <FlSpots> passed to it and construct the graph
Widget _buildChart(context, List<FlSpot> expensesList, List<FlSpot> incomesList, List<dynamic> dates) {
  int maxY = 100;
  for (var spot in expensesList) {
    maxY = max(maxY, spot.y.ceil());
  }
  for (var spot in incomesList) {
    maxY = max(maxY, spot.y.ceil());
  }
  LineTitles lineTitle = LineTitles(dates, maxY);
  LineChartBarData expensesLine = LineChartBarData(
    spots: expensesList,
    isCurved: true,
    colors: [Colors.orange, Colors.red],
    barWidth: 5,
  );
  LineChartBarData incomesLine = LineChartBarData(
    spots: incomesList,
    isCurved: true,
    colors: [Colors.green, Colors.greenAccent],
    barWidth: 5,
  );

  return LineChart(LineChartData(
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white, tooltipRoundedRadius: 20)),
      minX: 0,
      maxX: dates.length ==1 ? dates.length.toDouble() :(dates.length - 1),
      minY: 0,
      maxY: maxY.toDouble(),
      titlesData: lineTitle.getTitle(),
      gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: const Color(0x99CCEDFF), strokeWidth: 1);
          },
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) {
            return FlLine(color: const Color(0x99CCEDFF), strokeWidth: 1);
          }),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xAACCEDFF), width: 1),
      ),
      lineBarsData: <LineChartBarData>[expensesLine, incomesLine]));

}

class LineTitles {
  List dates;
  int maxY;
  LineTitles(this.dates, this.maxY);
  FlTitlesData getTitle() {
    List<int> visited_titles = [];
    return FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          getTitles: (val) {
            var diff = val - val.toInt().toDouble();
            if (diff <=0.099){
              print("the label for point $val is ${dates[val.toInt()]}");
              return dates[val.toInt()].replaceAll("-", "\n");}
            else if (diff >=0.9){
              print("the label for point $val is ${dates[val.ceil()]}");
              return dates[val.ceil()].replaceAll("-", "\n");}
            else {
              return "";
            }
          },
          margin: 8,
          reservedSize: 60,
          rotateAngle: 30,
        ),
        leftTitles: SideTitles(
          reservedSize: 40,
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          interval: maxY / 10,
        ),
        rightTitles: SideTitles(showTitles: true, getTitles: (val) => ""),
        topTitles: SideTitles(showTitles: true, getTitles: (val) => ""));
  }
}

class TestDashboard extends StatefulWidget {
  const TestDashboard({Key? key}) : super(key: key);

  @override
  TtestDashBoardState createState() => TtestDashBoardState();
}

class TtestDashBoardState extends State<TestDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
            const SizedBox(
              height: 37,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Expenses",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.orangeAccent.shade400,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "  vs  ",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Incomes",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5CD561),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, left: 2, bottom: 40),
                  child: _getExpenses(context),
                )),
            const SizedBox(
              height: 10,
            )
          ])
        ]));
  }
}
