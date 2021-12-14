import 'dart:collection';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import '../../data/categories.dart';
//import '../../data/expenses.dart';
//import 'package:pie_chart/pie_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teddy_the_tracker/constants.dart';

//add another class named categories

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
  List<FlSpot> expensesList = [];
  List<FlSpot> incomesList = [];
  List<String> date = [];
  // for (var i; i < data.keys.length; i++) {
  //   data_list.add(FlSpot(i.toDouble(), data[data.keys.elementAt(i)]));
  // }
  int i = 0;
  int index = 0;
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
  if (expensesList[0].x != 0) {
    expensesList = [FlSpot(0, 0), ...expensesList];
  }
  if (expensesList.last.x != date.length - 1)
    expensesList.add(FlSpot(date.length - 1, 0));
  if (incomesList[0].x != 0) incomesList = [FlSpot(0, 0), ...incomesList];
  if (incomesList.last.x != date.length - 1)
    incomesList.add(FlSpot(date.length - 1, 0));

  return Container(
    child: _buildChart(context, expensesList, incomesList, date),
  );
}

// Widget responsible for using List <FlSpots> passed to it and construct the graph
Widget _buildChart(context, List<FlSpot> expenses_list,
    List<FlSpot> incomes_list, List<dynamic> dates) {
  LineTitles lineTitle = LineTitles(dates);
  LineChartBarData expensesLine = LineChartBarData(
      spots: expenses_list,
      isCurved: true,
      colors: [Colors.orange, Colors.red],
      barWidth: 8,
      belowBarData: BarAreaData(
          show: true,
          colors: [Colors.orange, Colors.red]
              .map((color) => color.withOpacity(0.6))
              .toList()));
  LineChartBarData incomesLine = LineChartBarData(
      spots: incomes_list,
      isCurved: true,
      colors: [Colors.blue, Colors.green],
      barWidth: 8,
      belowBarData: BarAreaData(
          show: true,
          colors: [Colors.blue, Colors.green]
              .map((color) => color.withOpacity(0.6))
              .toList()));
  int maxY = 100;
  expenses_list.forEach((spot) {
    maxY = max(maxY, spot.y.ceil());
  });
  incomes_list.forEach((spot) {
    maxY = max(maxY, spot.y.ceil());
  });
  return LineChart(LineChartData(
      minX: 0,
      maxX: dates.length - 1,
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

//   ListView.builder(
//       padding: const EdgeInsets.all(8),
//       itemCount: entries.length,
//       itemBuilder: (BuildContext context, int index) {
//         return Text(entries[index].toString());
//       });
}

class LineTitles {
  List dates;
  LineTitles(this.dates);
  FlTitlesData getTitle() {
    return FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (val) => dates[val.toInt()].replaceAll("-", "\n"),
          margin: 8,
          reservedSize: 60,
          rotateAngle: 30,
        ),
        rightTitles: SideTitles(showTitles: true, getTitles: (val) => ""),
        topTitles: SideTitles(showTitles: true, getTitles: (val) => ""));
  }
}

//------line chart ends here---------
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
        const Text(
          "Expenses vs Income",
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 5, left: 2),
          child: _getExpenses(context),
        )),
        const SizedBox(
          height: 10,
        )
      ])
    ]));
  }
}
//dummy data
/*class PieData {
  final List<Data> data = [];


}

class Data {
  final int catID;

  final double amount;

  Data({required this.catID, required this.amount});
}*/

class PieData {
  static List<Data> data = [
    Data(name: 'Food', percent: 40, color: const Color(0xFFCCEDFF)),
    Data(name: 'Groceries', percent: 30, color: const Color(0xffbdedff)),
    Data(name: 'Shopping', percent: 15, color: const Color(0xffa8e5ff)),
    Data(name: 'Utilities', percent: 15, color: const Color(0xff9bdbff)),
  ];
}

class Data {
  final String name;

  final double percent;

  final Color color;

  Data({required this.name, required this.percent, required this.color});
}

List<PieChartSectionData> getSections(int touchedIndex) {
  return PieData.data
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        final isTouched = index == touchedIndex;
        final double fontSize = isTouched ? 20 : 14;
        final double radius = isTouched ? 80 : 60;

        final value = PieChartSectionData(
          color: data.color,
          value: data.percent,
          title: '${data.percent}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        );

        return MapEntry(index, value);
      })
      .values
      .toList();
}

class PieChartPage extends StatefulWidget {
  PieChartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartPageState();
}

class PieChartPageState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback:
                      (FlTouchEvent event, PieTouchResponse? response) {
                    setState(() {
                      if (event is FlLongPressEnd || event is FlPanEndEvent) {
                        touchedIndex = -1;
                      } else {
                        if (response != null) {
                          touchedIndex = response
                              .touchedSection?.touchedSectionIndex as int;
                        }
                      }
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 35,
                sections: getSections(touchedIndex),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: IndicatorsWidget(),
        ),
      ],
    );
  }
}

class IndicatorsWidget extends StatelessWidget {
  const IndicatorsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PieData.data.map(
        (data) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: buildIndicator(
                color: data.color,
                text: data.name,
                // isSquare: true,
              ));
        },
      ).toList(),
    );
  }

  Widget buildIndicator({
    required Color color,
    required String text,
    bool isSquare = false,
    double size = 16,
    Color textColor = const Color(0xFFFFFFFA),
  }) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
