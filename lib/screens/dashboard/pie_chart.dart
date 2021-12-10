import 'dart:ffi';

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
Widget _getData(context) {
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
          List<Entries> entries = snapshot.data!.docs
              .map((docSnapshot) =>
                  Entries.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return Container(
            child: _buildBody(context, entries),
          );
        }
      });
}

// Widget responsible for converting List <Entries> to List <FlSpot>
Widget _buildBody(context, List<Entries> entries) {
  Map data = {};
  List dates = [];

  for (var entry in entries.reversed.toList()) {
    if (data.containsKey(entry.day)) {
      data[entry.date] =
          data[entry.date] + double.parse(entry.amount as String);
    } else {
      data[entry.date] = double.parse(entry.amount as String);
    }
  }
  List<FlSpot> data_list = [];
  // for (var i; i < data.keys.length; i++) {
  //   data_list.add(FlSpot(i.toDouble(), data[data.keys.elementAt(i)]));
  // }
  int i = 0;
  data.forEach((k, v) {
    dates.add(k);
    data_list.add(FlSpot(i.toDouble(), v));
    i++;
  });
  return Container(
    child: _buildChart(context, data_list, dates),
  );
}

// Widget responsible for using List <FlSpots> passed to it and construct the graph
Widget _buildChart(context, List<FlSpot> data_list, List<dynamic> dates) {
  LineTitles lineTitle = LineTitles(dates);
  return LineChart(LineChartData(
      minX: 0,
      maxX: dates.length - 1,
      minY: 0,
      maxY: 1000,
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
      lineBarsData: [
        LineChartBarData(
            spots: data_list,
            isCurved: true,
            colors: [Colors.orange, Colors.red],
            barWidth: 5,
            belowBarData: BarAreaData(
                show: true,
                colors: [Colors.orange, Colors.red]
                    .map((color) => color.withOpacity(0.5))
                    .toList()))
      ]));

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

class TestDashboard extends StatefulWidget {
  const TestDashboard({Key? key}) : super(key: key);

  @override
  TtestDashBoardState createState() => TtestDashBoardState();
}

class TtestDashBoardState extends State<TestDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getData(context),
    );
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
