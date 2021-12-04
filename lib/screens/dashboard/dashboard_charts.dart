import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:fl_chart/fl_chart.dart';

class LineGraph extends StatefulWidget {
  const LineGraph({Key? key}) : super(key: key);

  @override
  _LineGraphState createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  late List<Entries> _chartdata;
  @override
  Widget build(BuildContext context) {
    _chartdata = [Entries("date", "20", "label")];
    return Column(
      children: [
        const SizedBox(
          height: 200,
        ),
        SizedBox(
          width: 400,
          height: 400,
          child: LineChart(
            LineChartData(
              minX: 0, minY: 0, maxX: 10, maxY: 10,
              // lineBarsData: [
              //   LineChartBarData(spots: []
              // ),
            ),
          ),
        ),
      ],
    );
  }

  // List<Entries> getChartData() {
  //   QuerySnapshot data = FirebaseFirestore.instance
  //       .collection("expenses/cFqsqHPIscrC6cY9iPs6/expense")
  //       .orderBy("date", descending: true);
  //   return data;}
}

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

Widget _buildBody(context) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("expenses/cFqsqHPIscrC6cY9iPs6/expense")
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        } else {
          List<Entries> entries = snapshot.data!.docs
              .map((docSnapshot) =>
                  Entries.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(entries[index].toString());
              });
        }
      });
}

class TestDashBoard extends StatefulWidget {
  const TestDashBoard({Key? key}) : super(key: key);

  @override
  TtestDashBoardState createState() => TtestDashBoardState();
}

class TtestDashBoardState extends State<TestDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBody(context),
    );
  }
}
// Widget _buildBody(context) {
//   return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("expenses/cFqsqHPIscrC6cY9iPs6/expense")
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const LinearProgressIndicator();
//         } else {
//           List<Entries> entries = snapshot.data!.docs
//               .map((docSnapshot) =>
//                   Entries.fromMap(docSnapshot.data() as Map<String, dynamic>))
//               .toList();
//         }
//       });
// }
